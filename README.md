# CzechPass

Android (Flutter) ilova: Chexiyadagi chet elliklar uchun imtihonlarga tayyorlov.

- **Doimiy yashash** — chex tili A2 (o'qish, tinglash, yozish, gapirish, to'liq sinov imtihoni)
- **Fuqarolik** — chex tili B1 (tez orada) va České reálie

Tillar: chex (standart), ukrain, vyetnam, rus, ingliz, o'zbek.

## Tuzilma

| Papka | Nima bor |
|---|---|
| `lib/core` | Ma'lumotlar, progress, takrorlash, tariflar, imtihon qoidalari, ovoz |
| `lib/features` | Ekranlar (bosh sahifa, A2, reálie, sinov imtihonlari, progress, sozlamalar) |
| `lib/l10n/strings.dart` | Barcha interfeys matnlari 6 tilda |
| `assets/questions` | Savollar (JSON) |
| `assets/audio/listening` | Tinglash dialoglari (Azure TTS, avtomatik yaratiladi) |
| `assets/info/exams.json` | Rasmiy imtihonlar haqida ma'lumot |
| `tool/` | Audio generatori, xavfsizlik tekshiruvi |
| `e2e/` | Playwright testlari |

## CI/CD (GitHub Actions)

- **CI**: `flutter analyze` + unit testlar → xavfsizlik (gitleaks, OSV, `tool/security_check.sh`) →
  Playwright (Flutter web) → APK (`czechpass-full` — hamma bo'lim ochiq, sinov uchun; `czechpass-free`).
- **Audio**: `a2_listening.json` o'zgarganda MP3 yaratiladi (Vlasta — ayol, Antonín — erkak).

GitHub Secrets: `AZURE_SPEECH_KEY`, `AZURE_SPEECH_REGION`, `ANDROID_KEYSTORE_BASE64`,
`ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`. Kalitlar kodga yozilmaydi.

## Lokal ishga tushirish

```powershell
flutter pub get
flutter test
flutter run
```
