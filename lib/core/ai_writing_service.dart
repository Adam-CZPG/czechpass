/// AI orqali yozilgan matndagi xatolarni tuzatish — KEYINGI VERSIYA UCHUN.
///
/// Ulashdan oldin hal qilinadigan narsalar:
/// 1. Advokat maslahati va maxfiylik siyosatiga AI bo'limini qo'shish
///    (foydalanuvchi matni uchinchi tomonga yuboriladi).
/// 2. Foydalanuvchidan aniq rozilik olish (sozlamalarda yoqiladigan tugma).
/// 3. Provayder tanlash. Diqqat: Gemini API'ning bepul tarifi EEA (shu jumladan
///    Chexiya) foydalanuvchilariga xizmat ko'rsatadigan ilovalarda ishlatilmaydi —
///    pullik tarif kerak (shartlarni ai.google.dev/terms dan tekshiring).
/// 4. API kalitini ilova ichida emas, server tomonda saqlash
///    (masalan, Supabase Edge Function ilova bilan AI o'rtasida turadi).
abstract class AiWritingService {
  /// [text] — foydalanuvchi chexcha matni, [lang] — izohlar tili.
  /// Natija: tuzatilgan matn va xatolar izohi.
  Future<AiWritingFeedback> correct(String text, {required String lang});
}

class AiWritingFeedback {
  const AiWritingFeedback({required this.corrected, required this.notes});

  final String corrected;
  final List<String> notes;
}
