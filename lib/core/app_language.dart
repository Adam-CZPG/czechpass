/// Ilova qo'llab-quvvatlaydigan tillar.
enum AppLanguage {
  // Tartib: chex tili (standart), so'ng Chexiyadagi eng katta jamoalar tillari.
  cs('cs', 'CS', 'Čeština'),
  uk('uk', 'UK', 'Українська'),
  vi('vi', 'VI', 'Tiếng Việt'),
  ru('ru', 'RU', 'Русский'),
  en('en', 'EN', 'English'),
  uz('uz', 'UZ', "O'zbekcha");

  const AppLanguage(this.code, this.badge, this.nativeName);

  /// ISO kod, saqlash uchun ishlatiladi.
  final String code;

  /// Ro'yxatdagi kichik belgi.
  final String badge;

  /// Tilning o'z nomi.
  final String nativeName;

  static AppLanguage? fromCode(String? code) {
    for (final language in values) {
      if (language.code == code) return language;
    }
    return null;
  }
}
