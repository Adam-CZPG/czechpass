/// Pullik tariflar. Doimiy yashash va fuqarolik — alohida imtihonlar, shuning uchun alohida tariflar.
enum Tariff { residence, citizenship, both }

/// Narxlar (Kč). Haqiqiy narxlar Google Play Console'dagi mahsulotlardan olinadi;
/// to'lov ulangunicha shu qiymatlar ko'rsatiladi. Narxni o'zgartirish uchun shu yerni tahrirlang.
class Prices {
  static const czk = {
    Tariff.residence: 199,
    Tariff.citizenship: 299,
    Tariff.both: 399,
  };

  static String of(Tariff tariff) => format(czk[tariff]!);

  static String format(int value) => '$value Kč';

  /// "Ikkalasi birga" olinganda tejaladigan summa.
  static int get bundleSaving =>
      czk[Tariff.residence]! + czk[Tariff.citizenship]! - czk[Tariff.both]!;
}
