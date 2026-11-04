/// Ilova qo'llab-quvvatlaydigan tillar.
enum AppLanguage {
  cs('cs', 'CS', 'Čeština'),
  en('en', 'EN', 'English'),
  ru('ru', 'RU', 'Русский'),
  uk('uk', 'UK', 'Українська'),
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
