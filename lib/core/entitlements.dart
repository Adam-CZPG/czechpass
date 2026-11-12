import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:czech_pass/core/tariff.dart';

/// Bepul versiyadagi cheklovlar. O'zgartirish uchun shu yerni tahrirlang.
class FreeLimits {
  /// A2: har bir ko'nikmadan (o'qish, tinglash, yozish, gapirish) bepul topshiriqlar soni.
  static const a2TasksPerSkill = 2;

  /// České reálie: har bir mavzudan bepul savollar soni.
  static const realiePerTopic = 3;

  /// Har bir sinov imtihonidan bepul urinishlar soni.
  static const freeMocks = 1;
}

/// Sinov imtihonlari (bepul urinishlar shu kalitlar bo'yicha hisoblanadi).
class Mocks {
  static const realie = 'realie_mock';
  static const a2 = 'a2_mock';
}

/// Foydalanuvchi sotib olgan tariflar va bepul urinishlar hisobi.
/// To'lov Google Play Billing orqali (billing.dart): xarid [grant] bilan ochiladi,
/// har ochilishda Play'dagi holat [replaceOwned] bilan tekshiriladi.
///
/// Sinov APK'sida hamma narsa ochiq bo'lishi uchun `--dart-define=DEV_UNLOCK=true`.
class Entitlements {
  Entitlements({
    SharedPreferences? preferences,
    Set<Tariff>? owned,
    Map<String, int>? mocksUsed,
    this.devUnlock = const bool.fromEnvironment('DEV_UNLOCK'),
  })  : _prefs = preferences,
        _owned = owned ?? <Tariff>{},
        _mocksUsed = mocksUsed ?? <String, int>{};

  static const _ownedKey = 'owned_tariffs';
  static const _mocksKey = 'mocks_used';

  final SharedPreferences? _prefs;
  final Set<Tariff> _owned;
  final Map<String, int> _mocksUsed;

  /// Ishlab chiquvchi yig'masi: barcha bo'limlar ochiq.
  final bool devUnlock;

  static Future<Entitlements> load() async {
    final prefs = await SharedPreferences.getInstance();
    final owned = <Tariff>{
      for (final name in prefs.getStringList(_ownedKey) ?? const <String>[])
        for (final t in Tariff.values)
          if (t.name == name) t,
    };
    final raw = prefs.getString(_mocksKey);
    final mocks = raw == null ? <String, int>{} : Map<String, int>.from(jsonDecode(raw) as Map);
    return Entitlements(preferences: prefs, owned: owned, mocksUsed: mocks);
  }

  bool get residence => devUnlock || _owned.contains(Tariff.residence) || _owned.contains(Tariff.both);

  bool get citizenship => devUnlock || _owned.contains(Tariff.citizenship) || _owned.contains(Tariff.both);

  bool unlocked(Tariff tariff) => switch (tariff) {
        Tariff.residence => residence,
        Tariff.citizenship => citizenship,
        Tariff.both => residence && citizenship,
      };

  /// Bepul versiyada ro'yxatning faqat boshidagi [free] tasi ochiq.
  List<T> limit<T>(List<T> items, Tariff tariff, int free) =>
      unlocked(tariff) || items.length <= free ? items : items.take(free).toList();

  int mocksUsed(String mock) => _mocksUsed[mock] ?? 0;

  bool canStartMock(String mock, Tariff tariff) => unlocked(tariff) || mocksUsed(mock) < FreeLimits.freeMocks;

  /// Bepul urinish ishlatildi (tarif ochiq bo'lsa hisoblanmaydi).
  Future<void> useMock(String mock, Tariff tariff) async {
    if (unlocked(tariff)) return;
    _mocksUsed[mock] = mocksUsed(mock) + 1;
    await _prefs?.setString(_mocksKey, jsonEncode(_mocksUsed));
  }

  Future<void> grant(Tariff tariff) async {
    _owned.add(tariff);
    await _prefs?.setStringList(_ownedKey, [for (final t in _owned) t.name]);
  }

  /// Google Play'dan olingan haqiqiy holat: ro'yxat to'liq almashtiriladi
  /// (qaytarilgan yoki boshqa akkauntga tegishli xarid yopiladi).
  Future<void> replaceOwned(Set<Tariff> tariffs) async {
    _owned
      ..clear()
      ..addAll(tariffs);
    await _prefs?.setStringList(_ownedKey, [for (final t in _owned) t.name]);
  }
}
