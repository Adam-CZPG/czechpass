# Google Play'ga chiqarish ro'yxati

Belgilar: ✅ tayyor · 🟡 qisman · ⬜ qilinmagan.

## Kod va yig'ish

- ✅ Doimiy imzo kaliti (GitHub Secrets), har yig'ishda o'suvchi `versionCode`.
- ✅ AAB: CI `czechpass.aab` faylini yig'adi (artifact `czechpass-apk` ichida).
- ✅ Kod kichraytirish (R8): Flutter release yig'ishda standart holatda yoqilgan.
- ✅ Ilova ichida maxfiylik siyosati ekrani (`assets/legal/`).
- 🟡 **Play Billing**: kod ulangan (`lib/core/billing.dart`), haqiqiy telefonda hali sinalmagan. Qolgani:
  1. Play Console → Monetize → In-app products: `czechpass_residence`, `czechpass_citizenship`,
     `czechpass_both` (bir martalik, narxlar 199 / 299 / 399 Kč). ID'lar koddagi bilan bir xil bo'lishi shart.
  2. AAB'ni Internal testing'ga yuklash va o'zingizni License tester qilib qo'shish.
  3. Sinov: xarid, bekor qilish, "Xaridni tiklash", ilovani o'chirib qayta o'rnatish, pulni qaytarish.
  Xarid har ochilishda Play'dan tekshiriladi, shuning uchun ulashilgan APK'da xarid o'tmaydi.
- ⬜ Reklama (AdMob) va rozilik oynasi (UMP) — AdMob akkaunti ochilgach.
- ⬜ Crash hisobotlari (Crashlytics yoki Sentry) — akkaunt kerak; qo'shilsa maxfiylik siyosati yangilanadi.
- 🟡 Versiya: `pubspec.yaml`da `1.0.0`, sozlamalar ekranida `0.1.0` qo'lda yozilgan — bittasini tanlash kerak.

## Maxfiylik siyosati

- 🟡 Matn tayyor (chexcha — asosiy, inglizcha — qolgan tillar uchun). To'ldirish kerak:
  `[DOPLNIT ...]` / `[FILL IN ...]` joylari (operator nomi, IČO, manzil, e-mail, sana).
- ⬜ Matnni huquqshunos ko'rib chiqishi.
- ⬜ Ochiq URL'da joylash (Play Console talab qiladi). Repo yopiq bo'lsa GitHub Pages bepul tarifda ishlamaydi.

## Play Console: Data safety formasi

Ilovaning hozirgi holatiga ko'ra javoblar (reklama, AI yoki crash hisobotlari qo'shilsa o'zgaradi):

| Savol | Javob |
|---|---|
| Ilova foydalanuvchi ma'lumotlarini yig'adimi yoki ulashadimi? | Yo'q — progress va sozlamalar faqat telefonda |
| Mikrofon | Ruxsat so'raladi; ovozni telefonning nutqni aniqlash xizmati qayta ishlaydi, ilova yozib olmaydi va yubormaydi |
| Ma'lumotlar shifrlangan holda uzatiladimi? | Ilova o'zi ma'lumot uzatmaydi; shifrlanmagan HTTP taqiqlangan |
| Foydalanuvchi ma'lumotni o'chira oladimi? | Ha — Sozlamalar → Progressni tozalash yoki ilovani o'chirish |

Eslatma: Android zaxirasi yoqilgan bo'lsa, progress foydalanuvchining Google akkauntidagi zaxiraga tushadi
(yangi telefonda tiklanadi). Bu siyosat matnida aytilgan.

## Do'kon sahifasi

- ⬜ Ilova nomi, qisqa va to'liq tavsif (6 tilda), skrinshotlar, 512×512 belgi, 1024×500 banner.
- ⬜ Kontent reytingi so'rovnomasi, maqsadli auditoriya (kattalar), reklama bor/yo'qligi.
- ⬜ Rasmiy emasligi haqida izoh: ilova NPI ČR / MŠMT bilan bog'liq emas, savollar o'zimizniki.
- ⬜ Yopiq test (yangi shaxsiy akkauntlar uchun Play 12 ta sinovchi / 14 kun talab qiladi; biznes akkauntga tegishli emas).

## Kontent

- ⬜ B1 (fuqarolik tarifi B1 + reálie deb sotiladi, hozir B1 yo'q).
- 🟡 Reálie: 126 savol. Yangilarini qo'shishdan oldin `tool/similarity_check.py` rasmiy ma'lumotnoma
  fayli bilan ishga tushiriladi (fayl repoda saqlanmaydi).
- ⬜ Chex tili mutaxassisi tekshiruvi (yozish va gapirish namunalari).
