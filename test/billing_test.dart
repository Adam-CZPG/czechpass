import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:czech_pass/core/billing.dart';
import 'package:czech_pass/core/entitlements.dart';
import 'package:czech_pass/core/tariff.dart';

void main() {
  test('har bir tarifning Play mahsulot ID\'si bor va ular takrorlanmaydi', () {
    expect(BillingProducts.ids.keys.toSet(), Tariff.values.toSet());
    expect(BillingProducts.ids.values.toSet().length, Tariff.values.length);
    for (final tariff in Tariff.values) {
      expect(BillingProducts.tariffOf(BillingProducts.ids[tariff]!), tariff);
    }
    expect(BillingProducts.tariffOf('boshqa_mahsulot'), isNull);
  });

  test("Play'dagi xaridlar tariflarga aylantiriladi, notanish ID'lar tashlab ketiladi", () {
    expect(BillingProducts.ownedFrom(['czechpass_residence', 'x', 'czechpass_residence']), {Tariff.residence});
    expect(BillingProducts.ownedFrom(const []), isEmpty);
  });

  test("Play'dagi holat telefondagi ro'yxatni to'liq almashtiradi", () async {
    SharedPreferences.setMockInitialValues({});
    final e = await Entitlements.load();
    await e.grant(Tariff.both);
    expect(e.residence && e.citizenship, isTrue);

    // Xarid qaytarilgan yoki APK boshqa akkauntli telefonga ko'chirilgan: Play bo'sh ro'yxat qaytaradi.
    await e.replaceOwned({});
    expect(e.residence || e.citizenship, isFalse);
    expect((await Entitlements.load()).residence, isFalse);

    await e.replaceOwned({Tariff.citizenship});
    final reloaded = await Entitlements.load();
    expect(reloaded.citizenship, isTrue);
    expect(reloaded.residence, isFalse);
  });
}
