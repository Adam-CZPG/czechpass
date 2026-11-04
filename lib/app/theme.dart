import 'package:flutter/material.dart';

/// Bitta mavzu (yorug' yoki qorong'i) uchun ranglar to'plami.
class AppPalette {
  const AppPalette({
    required this.ink,
    required this.muted,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.border,
    required this.surface,
    required this.background,
    required this.card,
    required this.banner,
    required this.onBanner,
    required this.onBannerMuted,
    required this.bannerTrack,
    required this.success,
    required this.successSoft,
    required this.error,
    required this.errorSoft,
    required this.warning,
  });

  final Color ink; // asosiy matn
  final Color muted; // ikkinchi darajali matn
  final Color accent; // tugmalar, belgilar
  final Color onAccent; // accent / success / error ustidagi matn va belgilar
  final Color accentSoft;
  final Color border;
  final Color surface; // kulrang bloklar
  final Color background; // ekran foni
  final Color card; // kartalar va kiritish maydonlari
  final Color banner; // to'q banner (to'liq versiya, umumiy natija)
  final Color onBanner;
  final Color onBannerMuted;
  final Color bannerTrack;
  final Color success;
  final Color successSoft;
  final Color error;
  final Color errorSoft;
  final Color warning;
}

/// Yorug' mavzu (canvas'dagi MVP dizayni).
const lightPalette = AppPalette(
  ink: Color(0xFF13233A),
  muted: Color(0xFF5A6678),
  accent: Color(0xFF2F5BEA),
  onAccent: Color(0xFFFFFFFF),
  accentSoft: Color(0xFFEEF2FD),
  border: Color(0xFFE3E7EE),
  surface: Color(0xFFF2F4F7),
  background: Color(0xFFF5F7FA),
  card: Color(0xFFFFFFFF),
  banner: Color(0xFF13233A),
  onBanner: Color(0xFFFFFFFF),
  onBannerMuted: Color(0xFFC9D2E0),
  bannerTrack: Color(0xFF2E3F58),
  success: Color(0xFF1F7A4D),
  successSoft: Color(0xFFE6F4EC),
  error: Color(0xFFC2362B),
  errorSoft: Color(0xFFFBEAE8),
  warning: Color(0xFFD9822B),
);

/// Qorong'i mavzu. Matn va fon kontrasti WCAG AA (4.5:1) dan yuqori.
const darkPalette = AppPalette(
  ink: Color(0xFFE6ECF5),
  muted: Color(0xFF9DA9BB),
  accent: Color(0xFF7B9BFF),
  onAccent: Color(0xFF0B1220),
  accentSoft: Color(0xFF1D2A4D),
  border: Color(0xFF2A3546),
  surface: Color(0xFF1E2836),
  background: Color(0xFF0E1520),
  card: Color(0xFF161F2C),
  banner: Color(0xFF1D2A4D),
  onBanner: Color(0xFFFFFFFF),
  onBannerMuted: Color(0xFFC9D2E0),
  bannerTrack: Color(0xFF34466E),
  success: Color(0xFF4CC38A),
  successSoft: Color(0xFF12301F),
  error: Color(0xFFF2766B),
  errorSoft: Color(0xFF3A1A18),
  warning: Color(0xFFF0A04B),
);

/// Ekranlar ranglarni shu yerdan oladi. [dark] telefon mavzusiga qarab
/// ilova ishga tushganda va mavzu o'zgarganda yangilanadi (main.dart).
class AppColors {
  static bool dark = false;
  static AppPalette get _p => dark ? darkPalette : lightPalette;

  static Color get ink => _p.ink;
  static Color get muted => _p.muted;
  static Color get accent => _p.accent;
  static Color get onAccent => _p.onAccent;
  static Color get accentSoft => _p.accentSoft;
  static Color get border => _p.border;
  static Color get surface => _p.surface;
  static Color get background => _p.background;
  static Color get card => _p.card;
  static Color get banner => _p.banner;
  static Color get onBanner => _p.onBanner;
  static Color get onBannerMuted => _p.onBannerMuted;
  static Color get bannerTrack => _p.bannerTrack;
  static Color get success => _p.success;
  static Color get successSoft => _p.successSoft;
  static Color get error => _p.error;
  static Color get errorSoft => _p.errorSoft;
  static Color get warning => _p.warning;
}

ThemeData buildTheme(Brightness brightness) {
  final p = brightness == Brightness.dark ? darkPalette : lightPalette;
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPalette.accent,
      brightness: brightness,
      primary: p.accent,
      onPrimary: p.onAccent,
      surface: p.card,
      onSurface: p.ink,
      error: p.error,
    ),
    scaffoldBackgroundColor: p.card,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: p.ink, displayColor: p.ink),
    iconTheme: IconThemeData(color: p.ink),
    dividerColor: p.border,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        disabledBackgroundColor: p.border,
        disabledForegroundColor: p.muted,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: p.muted),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.banner,
      contentTextStyle: TextStyle(color: p.onBanner),
    ),
  );
}
