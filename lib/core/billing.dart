import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/tariff.dart';

/// Google Play Console'dagi bir martalik mahsulotlar (in-app products).
/// Play Console'da aynan shu ID'lar bilan yaratiladi; ID keyin o'zgartirilmaydi.
class BillingProducts {
  static const ids = {
    Tariff.residence: 'czechpass_residence',
    Tariff.citizenship: 'czechpass_citizenship',
    Tariff.both: 'czechpass_both',
  };

  static Tariff? tariffOf(String productId) {
    for (final entry in ids.entries) {
      if (entry.value == productId) return entry.key;
    }
    return null;
  }

  /// Play qaytargan mahsulot ID'laridan tariflar to'plami (notanish ID'lar tashlab ketiladi).
  static Set<Tariff> ownedFrom(Iterable<String> productIds) => {
        for (final id in productIds)
          if (tariffOf(id) != null) tariffOf(id)!,
      };
}

/// To'lov jarayonidagi hodisalar (ekranda xabar ko'rsatish uchun).
enum BillingEvent { purchased, pending, failed }

/// Xaridlarni tiklash natijasi.
enum RestoreResult { restored, nothing, unavailable }

/// Google Play Billing. Xaridlar Google akkauntiga bog'langan: ilova har ochilganda
/// Play'dan so'raladi, shuning uchun APK boshqa telefonga ko'chirilsa xarid o'tmaydi,
/// telefon almashtirilganda esa o'zi tiklanadi.
class BillingService {
  BillingService({required this.entitlements, required this.onChanged});

  final Entitlements entitlements;

  /// Tariflar o'zgarganda chaqiriladi (ekranlarni yangilash uchun).
  final VoidCallback onChanged;

  /// To'lov faqat Android'da (Google Play) ishlaydi; veb va testlarda o'chiq.
  static bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  final _products = <Tariff, ProductDetails>{};
  final _events = StreamController<BillingEvent>.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _available = false;

  Stream<BillingEvent> get events => _events.stream;

  /// Play'dagi narx (foydalanuvchi valyutasida); hali yuklanmagan bo'lsa — null.
  String? priceOf(Tariff tariff) => _products[tariff]?.price;

  bool canBuy(Tariff tariff) => _available && _products.containsKey(tariff);

  Future<void> start() async {
    if (!supported) return;
    try {
      _subscription = InAppPurchase.instance.purchaseStream.listen(_onPurchases, onError: (Object _) {});
      _available = await InAppPurchase.instance.isAvailable();
      if (!_available) return;
      await _loadProducts();
      await _syncOwned();
    } catch (_) {
      // Play xizmati ishlamasa, ilova oxirgi ma'lum holat bilan ishlashda davom etadi.
    }
  }

  Future<void> _loadProducts() async {
    final response = await InAppPurchase.instance.queryProductDetails(BillingProducts.ids.values.toSet());
    for (final product in response.productDetails) {
      final tariff = BillingProducts.tariffOf(product.id);
      if (tariff != null) _products[tariff] = product;
    }
    onChanged();
  }

  /// Play'dan egalik qilinayotgan mahsulotlarni so'raydi va tariflarni shunga moslaydi.
  /// Play aniq javob bermasa (internet yo'q va h.k.) — null, tariflar o'zgarmaydi.
  Future<Set<Tariff>?> _syncOwned() async {
    final addition = InAppPurchase.instance.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final response = await addition.queryPastPurchases();
    if (response.error != null) return null;
    final ids = <String>[];
    for (final purchase in response.pastPurchases) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
        ids.add(purchase.productID);
        if (purchase.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(purchase);
      }
    }
    final owned = BillingProducts.ownedFrom(ids);
    await entitlements.replaceOwned(owned);
    onChanged();
    return owned;
  }

  /// Xarid oynasini ochadi. Natija [events] orqali keladi. Oyna ochilmasa — false.
  Future<bool> buy(Tariff tariff) async {
    final product = _products[tariff];
    if (!_available || product == null) return false;
    try {
      return await InAppPurchase.instance.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
    } catch (_) {
      return false;
    }
  }

  Future<RestoreResult> restore() async {
    if (!supported) return RestoreResult.unavailable;
    try {
      if (!_available) {
        _available = await InAppPurchase.instance.isAvailable();
        if (!_available) return RestoreResult.unavailable;
      }
      if (_products.isEmpty) await _loadProducts();
      final owned = await _syncOwned();
      if (owned == null) return RestoreResult.unavailable;
      return owned.isEmpty ? RestoreResult.nothing : RestoreResult.restored;
    } catch (_) {
      return RestoreResult.unavailable;
    }
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final tariff = BillingProducts.tariffOf(purchase.productID);
          if (tariff != null) {
            await entitlements.grant(tariff);
            onChanged();
            _events.add(BillingEvent.purchased);
          }
        case PurchaseStatus.pending:
          _events.add(BillingEvent.pending);
        case PurchaseStatus.error:
          _events.add(BillingEvent.failed);
        case PurchaseStatus.canceled:
          break;
      }
      if (purchase.pendingCompletePurchase) {
        try {
          await InAppPurchase.instance.completePurchase(purchase);
        } catch (_) {
          // Tasdiqlash keyingi ochilishda (_syncOwned) qayta uriniladi.
        }
      }
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _events.close();
  }
}
