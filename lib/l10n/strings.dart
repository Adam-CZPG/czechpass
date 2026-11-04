import 'package:flutter/widgets.dart';

import 'package:czech_pass/app/app_scope.dart';

/// Ilova interfeysi matnlari, 5 tilda.
/// Foydalanish: `final s = S.of(context); Text(s.welcome)`.
class S {
  const S(this.lang);

  final String lang;

  static S of(BuildContext context) => S(AppScope.of(context).language.code);

  String _t(Map<String, String> m) => m[lang] ?? m['cs']!;

  // ── Til tanlash ──────────────────────────────────────────────
  String get chooseLanguage => _t(const {
        'uz': 'Tilni tanlang',
        'cs': 'Vyberte jazyk',
        'en': 'Choose your language',
        'vi': 'Chọn ngôn ngữ',
        'ru': 'Выберите язык',
        'uk': 'Оберіть мову',
      });
  String get languageNote => _t(const {
        'uz': "Savollar doim chex tilida ko'rsatiladi. Tanlangan til tarjima va izohlar uchun ishlatiladi.",
        'cs': 'Otázky jsou vždy v češtině. Zvolený jazyk slouží pro překlad a vysvětlení.',
        'en': 'Questions are always shown in Czech. The language you choose is used for translations and explanations.',
        'vi': 'Câu hỏi luôn được hiển thị bằng tiếng Séc. Ngôn ngữ bạn chọn được dùng cho bản dịch và giải thích.',
        'ru': 'Вопросы всегда показываются на чешском. Выбранный язык используется для перевода и пояснений.',
        'uk': 'Питання завжди показуються чеською. Обрана мова використовується для перекладу та пояснень.',
      });
  String get continueBtn => _t(const {
        'uz': 'Davom etish',
        'cs': 'Pokračovat',
        'en': 'Continue',
        'vi': 'Tiếp tục',
        'ru': 'Продолжить',
        'uk': 'Продовжити',
      });

  // ── Bosh sahifa ──────────────────────────────────────────────
  String get welcome => _t(const {
        'uz': 'Xush kelibsiz',
        'cs': 'Vítejte',
        'en': 'Welcome',
        'vi': 'Xin chào',
        'ru': 'Добро пожаловать',
        'uk': 'Ласкаво просимо',
      });
  String get homeTitle => _t(const {
        'uz': 'Qaysi imtihonga tayyorlanamiz?',
        'cs': 'Na jakou zkoušku se připravujeme?',
        'en': 'Which exam are we preparing for?',
        'vi': 'Bạn đang ôn thi kỳ thi nào?',
        'ru': 'К какому экзамену готовимся?',
        'uk': 'До якого іспиту готуємося?',
      });
  String get forCitizenship => _t(const {
        'uz': 'FUQAROLIK UCHUN',
        'cs': 'PRO OBČANSTVÍ',
        'en': 'FOR CITIZENSHIP',
        'vi': 'ĐỂ XIN QUỐC TỊCH',
        'ru': 'ДЛЯ ГРАЖДАНСТВА',
        'uk': 'ДЛЯ ГРОМАДЯНСТВА',
      });
  String get realieSubtitle => _t(const {
        'uz': 'Tarix, geografiya, davlat tuzilishi, madaniyat',
        'cs': 'Dějiny, zeměpis, stát a politika, kultura',
        'en': 'History, geography, state and politics, culture',
        'vi': 'Lịch sử, địa lý, nhà nước và chính trị, văn hóa',
        'ru': 'История, география, государство, культура',
        'uk': 'Історія, географія, держава, культура',
      });
  String mastered(int percent) => _t(const {
        'uz': "{p}% o'zlashtirildi",
        'cs': 'Zvládnuto {p} %',
        'en': '{p}% mastered',
        'vi': 'Đã nắm vững {p}%',
        'ru': 'Освоено {p}%',
        'uk': 'Опановано {p}%',
      }).replaceAll('{p}', '$percent');
  String get startPractice => _t(const {
        'uz': 'Mashqni boshlash',
        'cs': 'Začít procvičovat',
        'en': 'Start practising',
        'vi': 'Bắt đầu luyện tập',
        'ru': 'Начать практику',
        'uk': 'Почати практику',
      });
  String get continuePractice => _t(const {
        'uz': 'Mashqni davom ettirish',
        'cs': 'Pokračovat v procvičování',
        'en': 'Continue practising',
        'vi': 'Tiếp tục luyện tập',
        'ru': 'Продолжить практику',
        'uk': 'Продовжити практику',
      });
  String get forResidence => _t(const {
        'uz': 'DOIMIY YASHASH UCHUN',
        'cs': 'PRO TRVALÝ POBYT',
        'en': 'FOR PERMANENT RESIDENCE',
        'vi': 'ĐỂ XIN THƯỜNG TRÚ',
        'ru': 'ДЛЯ ПМЖ',
        'uk': 'ДЛЯ ПОСТІЙНОГО ПРОЖИВАННЯ',
      });
  String get a2Title => _t(const {
        'uz': 'Chex tili A2',
        'cs': 'Čeština A2',
        'en': 'Czech A2',
        'vi': 'Tiếng Séc A2',
        'ru': 'Чешский язык A2',
        'uk': 'Чеська мова A2',
      });
  String get a2Subtitle => _t(const {
        'uz': "To'rt ko'nikma bo'yicha mashq",
        'cs': 'Procvičování čtyř dovedností',
        'en': 'Practise all four skills',
        'vi': 'Luyện cả bốn kỹ năng',
        'ru': 'Практика четырёх навыков',
        'uk': 'Практика чотирьох навичок',
      });
  String get newFormat => _t(const {
        'uz': 'Yangi format',
        'cs': 'Nový formát',
        'en': 'New format',
        'vi': 'Định dạng mới',
        'ru': 'Новый формат',
        'uk': 'Новий формат',
      });
  String get reading => _t(const {
        'uz': "O'qish",
        'cs': 'Čtení',
        'en': 'Reading',
        'vi': 'Đọc',
        'ru': 'Чтение',
        'uk': 'Читання',
      });
  String get listening => _t(const {
        'uz': 'Tinglash',
        'cs': 'Poslech',
        'en': 'Listening',
        'vi': 'Nghe',
        'ru': 'Аудирование',
        'uk': 'Аудіювання',
      });
  String get writing => _t(const {
        'uz': 'Yozish',
        'cs': 'Psaní',
        'en': 'Writing',
        'vi': 'Viết',
        'ru': 'Письмо',
        'uk': 'Письмо',
      });
  String get speaking => _t(const {
        'uz': 'Gapirish',
        'cs': 'Mluvení',
        'en': 'Speaking',
        'vi': 'Nói',
        'ru': 'Говорение',
        'uk': 'Говоріння',
      });
  String get mockExam => _t(const {
        'uz': 'Sinov imtihoni',
        'cs': 'Zkouška nanečisto',
        'en': 'Mock exam',
        'vi': 'Thi thử',
        'ru': 'Пробный экзамен',
        'uk': 'Пробний іспит',
      });
  String get mockExamSub => _t(const {
        'uz': 'Haqiqiy test kabi',
        'cs': 'Jako u skutečné zkoušky',
        'en': 'Just like the real test',
        'vi': 'Giống như bài thi thật',
        'ru': 'Как на настоящем экзамене',
        'uk': 'Як на справжньому іспиті',
      });
  String get myMistakes => _t(const {
        'uz': 'Xatolarim',
        'cs': 'Moje chyby',
        'en': 'My mistakes',
        'vi': 'Lỗi của tôi',
        'ru': 'Мои ошибки',
        'uk': 'Мої помилки',
      });
  String toReview(int n) => _t(const {
        'uz': 'Takrorlash uchun: {n}',
        'cs': 'K opakování: {n}',
        'en': 'To review: {n}',
        'vi': 'Cần ôn lại: {n}',
        'ru': 'Для повторения: {n}',
        'uk': 'Для повторення: {n}',
      }).replaceAll('{n}', '$n');
  String get unlockFull => _t(const {
        'uz': "To'liq versiyani oching",
        'cs': 'Odemkněte plnou verzi',
        'en': 'Unlock the full version',
        'vi': 'Mở khóa phiên bản đầy đủ',
        'ru': 'Откройте полную версию',
        'uk': 'Відкрийте повну версію',
      });
  String get oneTimePayment => _t(const {
        'uz': "Bir martalik to'lov, obuna emas",
        'cs': 'Jednorázová platba, žádné předplatné',
        'en': 'One-time payment, no subscription',
        'vi': 'Thanh toán một lần, không đăng ký định kỳ',
        'ru': 'Разовый платёж, без подписки',
        'uk': 'Разовий платіж, без підписки',
      });
  String get disclaimer => _t(const {
        'uz': 'Mustaqil tayyorlov ilovasi. NPI ČR ning rasmiy mahsuloti emas.',
        'cs': 'Nezávislá přípravná aplikace. Nejde o oficiální produkt NPI ČR.',
        'en': 'An independent prep app. Not an official NPI ČR product.',
        'vi': 'Ứng dụng ôn thi độc lập. Không phải sản phẩm chính thức của NPI ČR.',
        'ru': 'Независимое приложение для подготовки. Не является официальным продуктом NPI ČR.',
        'uk': 'Незалежний застосунок для підготовки. Не є офіційним продуктом NPI ČR.',
      });
  String get comingSoon => _t(const {
        'uz': 'Tez orada',
        'cs': 'Již brzy',
        'en': 'Coming soon',
        'vi': 'Sắp ra mắt',
        'ru': 'Скоро',
        'uk': 'Незабаром',
      });

  // ── Pastki menyu ─────────────────────────────────────────────
  String get navHome => _t(const {
        'uz': 'Bosh sahifa',
        'cs': 'Domů',
        'en': 'Home',
        'vi': 'Trang chủ',
        'ru': 'Главная',
        'uk': 'Головна',
      });
  String get navPractice => _t(const {
        'uz': 'Mashq',
        'cs': 'Procvičování',
        'en': 'Practice',
        'vi': 'Luyện tập',
        'ru': 'Практика',
        'uk': 'Практика',
      });
  String get navProgress => _t(const {
        'uz': 'Progress',
        'cs': 'Pokrok',
        'en': 'Progress',
        'vi': 'Tiến độ',
        'ru': 'Прогресс',
        'uk': 'Прогрес',
      });
  String get navSettings => _t(const {
        'uz': 'Sozlamalar',
        'cs': 'Nastavení',
        'en': 'Settings',
        'vi': 'Cài đặt',
        'ru': 'Настройки',
        'uk': 'Налаштування',
      });

  // ── Test ─────────────────────────────────────────────────────
  String get modeMistakes => _t(const {
        'uz': 'Xatolar ustida ishlash',
        'cs': 'Opakování chyb',
        'en': 'Reviewing mistakes',
        'vi': 'Ôn lại lỗi sai',
        'ru': 'Работа над ошибками',
        'uk': 'Робота над помилками',
      });
  String get showTranslation => _t(const {
        'uz': "Tarjimani ko'rsatish",
        'cs': 'Zobrazit překlad',
        'en': 'Show translation',
        'vi': 'Hiện bản dịch',
        'ru': 'Показать перевод',
        'uk': 'Показати переклад',
      });
  String get hideTranslation => _t(const {
        'uz': 'Tarjimani yashirish',
        'cs': 'Skrýt překlad',
        'en': 'Hide translation',
        'vi': 'Ẩn bản dịch',
        'ru': 'Скрыть перевод',
        'uk': 'Сховати переклад',
      });
  String get check => _t(const {
        'uz': 'Tekshirish',
        'cs': 'Zkontrolovat',
        'en': 'Check',
        'vi': 'Kiểm tra',
        'ru': 'Проверить',
        'uk': 'Перевірити',
      });
  String get nextQuestion => _t(const {
        'uz': 'Keyingi savol',
        'cs': 'Další otázka',
        'en': 'Next question',
        'vi': 'Câu tiếp theo',
        'ru': 'Следующий вопрос',
        'uk': 'Наступне питання',
      });
  String get seeResult => _t(const {
        'uz': "Natijani ko'rish",
        'cs': 'Zobrazit výsledek',
        'en': 'See result',
        'vi': 'Xem kết quả',
        'ru': 'Посмотреть результат',
        'uk': 'Переглянути результат',
      });
  String get correct => _t(const {
        'uz': "To'g'ri!",
        'cs': 'Správně!',
        'en': 'Correct!',
        'vi': 'Đúng rồi!',
        'ru': 'Правильно!',
        'uk': 'Правильно!',
      });
  String wrongAnswer(String letter) => _t(const {
        'uz': "Noto'g'ri. To'g'ri javob: {l}",
        'cs': 'Špatně. Správná odpověď: {l}',
        'en': 'Incorrect. The right answer: {l}',
        'vi': 'Chưa đúng. Đáp án đúng: {l}',
        'ru': 'Неправильно. Верный ответ: {l}',
        'uk': 'Неправильно. Правильна відповідь: {l}',
      }).replaceAll('{l}', letter);
  String get loadError => _t(const {
        'uz': "Savollarni yuklab bo'lmadi.",
        'cs': 'Otázky se nepodařilo načíst.',
        'en': 'Could not load the questions.',
        'vi': 'Không thể tải câu hỏi.',
        'ru': 'Не удалось загрузить вопросы.',
        'uk': 'Не вдалося завантажити питання.',
      });
  String get back => _t(const {
        'uz': 'Orqaga',
        'cs': 'Zpět',
        'en': 'Back',
        'vi': 'Quay lại',
        'ru': 'Назад',
        'uk': 'Назад',
      });
  String get close => _t(const {
        'uz': 'Yopish',
        'cs': 'Zavřít',
        'en': 'Close',
        'vi': 'Đóng',
        'ru': 'Закрыть',
        'uk': 'Закрити',
      });
  String get noMistakesTitle => _t(const {
        'uz': "Xatolar yo'q",
        'cs': 'Žádné chyby',
        'en': 'No mistakes',
        'vi': 'Không có lỗi',
        'ru': 'Ошибок нет',
        'uk': 'Помилок немає',
      });
  String get noMistakesText => _t(const {
        'uz': "Hozircha takrorlash uchun savol yo'q. Avval mashq qiling.",
        'cs': 'Zatím nemáte co opakovat. Nejdřív si procvičte otázky.',
        'en': 'Nothing to review yet. Practise some questions first.',
        'vi': 'Chưa có gì để ôn lại. Hãy luyện tập một số câu hỏi trước.',
        'ru': 'Пока нечего повторять. Сначала потренируйтесь.',
        'uk': 'Поки нічого повторювати. Спочатку потренуйтеся.',
      });

  // ── Natija ───────────────────────────────────────────────────
  String get result => _t(const {
        'uz': 'Natija',
        'cs': 'Výsledek',
        'en': 'Result',
        'vi': 'Kết quả',
        'ru': 'Результат',
        'uk': 'Результат',
      });
  String get resultGreat => _t(const {
        'uz': 'Yaxshi natija!',
        'cs': 'Výborný výsledek!',
        'en': 'Great result!',
        'vi': 'Kết quả rất tốt!',
        'ru': 'Отличный результат!',
        'uk': 'Чудовий результат!',
      });
  String get resultGood => _t(const {
        'uz': 'Yomon emas!',
        'cs': 'Není to špatné!',
        'en': 'Not bad!',
        'vi': 'Khá tốt!',
        'ru': 'Неплохо!',
        'uk': 'Непогано!',
      });
  String get resultLow => _t(const {
        'uz': 'Yana mashq qilamiz',
        'cs': 'Ještě potrénujeme',
        'en': "Let's practise more",
        'vi': 'Hãy luyện tập thêm',
        'ru': 'Потренируемся ещё',
        'uk': 'Потренуємося ще',
      });
  String get adviceAll => _t(const {
        'uz': "Barcha mavzular bo'yicha a'lo natija.",
        'cs': 'Výborně ve všech tématech.',
        'en': 'Excellent in every topic.',
        'vi': 'Xuất sắc ở mọi chủ đề.',
        'ru': 'Отлично по всем темам.',
        'uk': 'Відмінно з усіх тем.',
      });
  String adviceTopic(String topic) => _t(const {
        'uz': "{t} bo'limini yana takrorlashni tavsiya qilamiz.",
        'cs': 'Doporučujeme zopakovat téma {t}.',
        'en': 'We recommend reviewing {t} again.',
        'vi': 'Bạn nên ôn lại chủ đề «{t}».',
        'ru': 'Рекомендуем повторить тему «{t}».',
        'uk': 'Радимо повторити тему «{t}».',
      }).replaceAll('{t}', topic);
  String get byTopic => _t(const {
        'uz': "Mavzular bo'yicha",
        'cs': 'Podle témat',
        'en': 'By topic',
        'vi': 'Theo chủ đề',
        'ru': 'По темам',
        'uk': 'За темами',
      });
  String get retry => _t(const {
        'uz': 'Qayta urinish',
        'cs': 'Zkusit znovu',
        'en': 'Try again',
        'vi': 'Thử lại',
        'ru': 'Попробовать снова',
        'uk': 'Спробувати ще',
      });
  String reviewMistakes(int n) => _t(const {
        'uz': "Xatolarni ko'rib chiqish ({n})",
        'cs': 'Projít chyby ({n})',
        'en': 'Review mistakes ({n})',
        'vi': 'Xem lại lỗi sai ({n})',
        'ru': 'Разобрать ошибки ({n})',
        'uk': 'Розібрати помилки ({n})',
      }).replaceAll('{n}', '$n');
  String scoreLabel(int right, int total, int percent) => _t(const {
        'uz': "{t} savoldan {r} tasi to'g'ri, {p} foiz",
        'cs': '{r} z {t} správně, {p} procent',
        'en': '{r} of {t} correct, {p} percent',
        'vi': 'Đúng {r} trên {t}, {p} phần trăm',
        'ru': '{r} из {t} правильно, {p} процентов',
        'uk': '{r} з {t} правильно, {p} відсотків',
      }).replaceAll('{r}', '$right').replaceAll('{t}', '$total').replaceAll('{p}', '$percent');

  // ── To'liq versiya ───────────────────────────────────────────
  String get premiumTitle => _t(const {
        'uz': "Imtihonga to'liq tayyorlaning",
        'cs': 'Připravte se na zkoušku naplno',
        'en': 'Prepare fully for your exam',
        'vi': 'Chuẩn bị đầy đủ cho kỳ thi',
        'ru': 'Подготовьтесь к экзамену полностью',
        'uk': 'Підготуйтеся до іспиту повністю',
      });
  String get premiumSubtitle => _t(const {
        'uz': "Bir marta to'laysiz va hamma narsa doim siz bilan qoladi. Obuna yo'q.",
        'cs': 'Zaplatíte jednou a vše vám zůstane. Žádné předplatné.',
        'en': 'Pay once and keep everything. No subscription.',
        'vi': 'Thanh toán một lần và dùng mãi. Không đăng ký định kỳ.',
        'ru': 'Платите один раз — всё остаётся у вас. Без подписки.',
        'uk': 'Платите один раз — усе залишається з вами. Без підписки.',
      });
  List<(String, String)> get premiumFeatures => [
        (
          _t(const {'uz': 'Barcha mashq savollari', 'cs': 'Všechny cvičné otázky', 'en': 'All practice questions', 'vi': 'Tất cả câu hỏi luyện tập', 'ru': 'Все тренировочные вопросы', 'uk': 'Усі тренувальні питання'}),
          _t(const {'uz': "České reálie va A2 bo'yicha to'liq to'plam", 'cs': 'Kompletní sada pro české reálie i A2', 'en': 'The complete set for české reálie and A2', 'vi': 'Bộ đầy đủ cho české reálie và A2', 'ru': 'Полный набор для české reálie и A2', 'uk': 'Повний набір для české reálie та A2'}),
        ),
        (
          _t(const {'uz': 'Cheksiz sinov testlari', 'cs': 'Neomezené zkoušky nanečisto', 'en': 'Unlimited mock exams', 'vi': 'Thi thử không giới hạn', 'ru': 'Неограниченные пробные экзамены', 'uk': 'Необмежені пробні іспити'}),
          _t(const {'uz': 'Haqiqiy imtihon formatida', 'cs': 'Ve formátu skutečné zkoušky', 'en': 'In the real exam format', 'vi': 'Theo định dạng bài thi thật', 'ru': 'В формате настоящего экзамена', 'uk': 'У форматі справжнього іспиту'}),
        ),
        (
          _t(const {'uz': '6 tilda tarjima va izohlar', 'cs': 'Překlady a vysvětlení v 6 jazycích', 'en': 'Translations and explanations in 6 languages', 'vi': 'Bản dịch và giải thích bằng 6 ngôn ngữ', 'ru': 'Переводы и пояснения на 6 языках', 'uk': 'Переклади та пояснення 6 мовами'}),
          _t(const {'uz': "Chex, ukrain, vyetnam, rus, ingliz, o'zbek", 'cs': 'Čeština, ukrajinština, vietnamština, ruština, angličtina, uzbečtina', 'en': 'Czech, Ukrainian, Vietnamese, Russian, English, Uzbek', 'vi': 'Tiếng Séc, Ukraina, Việt, Nga, Anh, Uzbek', 'ru': 'Чешский, украинский, вьетнамский, русский, английский, узбекский', 'uk': 'Чеська, українська, в\'єтнамська, російська, англійська, узбецька'}),
        ),
        (
          _t(const {'uz': 'Oflayn rejim', 'cs': 'Offline režim', 'en': 'Offline mode', 'vi': 'Chế độ ngoại tuyến', 'ru': 'Офлайн-режим', 'uk': 'Офлайн-режим'}),
          _t(const {'uz': 'Internetsiz ham mashq qiling', 'cs': 'Procvičujte i bez internetu', 'en': 'Practise without internet', 'vi': 'Luyện tập không cần internet', 'ru': 'Занимайтесь без интернета', 'uk': 'Займайтеся без інтернету'}),
        ),
        (
          _t(const {'uz': 'Reklamasiz', 'cs': 'Bez reklam', 'en': 'No ads', 'vi': 'Không quảng cáo', 'ru': 'Без рекламы', 'uk': 'Без реклами'}),
          _t(const {'uz': "Hech narsa chalg'itmaydi", 'cs': 'Nic vás neruší', 'en': 'Nothing to distract you', 'vi': 'Không có gì làm bạn phân tâm', 'ru': 'Ничто не отвлекает', 'uk': 'Ніщо не відволікає'}),
        ),
      ];
  String get fullVersion => _t(const {
        'uz': "To'liq versiya",
        'cs': 'Plná verze',
        'en': 'Full version',
        'vi': 'Phiên bản đầy đủ',
        'ru': 'Полная версия',
        'uk': 'Повна версія',
      });
  String get viaPlay => _t(const {
        'uz': "Bir martalik to'lov · Google Play orqali",
        'cs': 'Jednorázová platba · přes Google Play',
        'en': 'One-time payment · via Google Play',
        'vi': 'Thanh toán một lần · qua Google Play',
        'ru': 'Разовый платёж · через Google Play',
        'uk': 'Разовий платіж · через Google Play',
      });
  String buyFor(String price) => _t(const {
        'uz': '{p} ga sotib olish',
        'cs': 'Koupit za {p}',
        'en': 'Buy for {p}',
        'vi': 'Mua với giá {p}',
        'ru': 'Купить за {p}',
        'uk': 'Купити за {p}',
      }).replaceAll('{p}', price);
  String get restore => _t(const {
        'uz': 'Xaridni tiklash',
        'cs': 'Obnovit nákup',
        'en': 'Restore purchase',
        'vi': 'Khôi phục giao dịch mua',
        'ru': 'Восстановить покупку',
        'uk': 'Відновити покупку',
      });
  String get billingSoon => _t(const {
        'uz': "To'lov Google Play ulangandan keyin ishlaydi.",
        'cs': 'Platba bude fungovat po napojení Google Play.',
        'en': 'Payments will work once Google Play billing is connected.',
        'vi': 'Thanh toán sẽ hoạt động sau khi kết nối Google Play.',
        'ru': 'Оплата заработает после подключения Google Play.',
        'uk': 'Оплата запрацює після підключення Google Play.',
      });

  // ── Sozlamalar ───────────────────────────────────────────────
  String get appLanguage => _t(const {
        'uz': 'Ilova tili',
        'cs': 'Jazyk aplikace',
        'en': 'App language',
        'vi': 'Ngôn ngữ ứng dụng',
        'ru': 'Язык приложения',
        'uk': 'Мова застосунку',
      });
  String get about => _t(const {
        'uz': 'Ilova haqida',
        'cs': 'O aplikaci',
        'en': 'About the app',
        'vi': 'Giới thiệu ứng dụng',
        'ru': 'О приложении',
        'uk': 'Про застосунок',
      });
  String get aboutText => _t(const {
        'uz': "CzechPass — Chexiyadagi chet elliklar uchun mustaqil tayyorlov ilovasi. Savollar ilova mualliflari tomonidan ochiq manbalar asosida tuzilgan. Ilova NPI ČR yoki boshqa davlat idoralari bilan bog'liq emas.",
        'cs': 'CzechPass je nezávislá přípravná aplikace pro cizince v Česku. Otázky sestavili autoři aplikace z veřejných zdrojů. Aplikace není spojena s NPI ČR ani jinými státními institucemi.',
        'en': "CzechPass is an independent prep app for foreigners in Czechia. The questions were written by the app's authors from public sources. The app is not affiliated with NPI ČR or any other state institution.",
        'vi': 'CzechPass là ứng dụng ôn thi độc lập dành cho người nước ngoài tại Séc. Câu hỏi do tác giả ứng dụng biên soạn dựa trên các nguồn công khai. Ứng dụng không liên quan đến NPI ČR hay bất kỳ cơ quan nhà nước nào.',
        'ru': 'CzechPass — независимое приложение для подготовки иностранцев в Чехии. Вопросы составлены авторами приложения на основе открытых источников. Приложение не связано с NPI ČR или другими государственными учреждениями.',
        'uk': "CzechPass — незалежний застосунок для підготовки іноземців у Чехії. Питання склали автори застосунку на основі відкритих джерел. Застосунок не пов'язаний з NPI ČR чи іншими державними установами.",
      });
  String get privacyPolicy => _t(const {
        'uz': 'Maxfiylik siyosati',
        'cs': 'Zásady ochrany osobních údajů',
        'en': 'Privacy policy',
        'vi': 'Chính sách quyền riêng tư',
        'ru': 'Политика конфиденциальности',
        'uk': 'Політика конфіденційності',
      });
  String get resetProgress => _t(const {
        'uz': 'Progressni tozalash',
        'cs': 'Smazat pokrok',
        'en': 'Reset progress',
        'vi': 'Xóa tiến độ',
        'ru': 'Сбросить прогресс',
        'uk': 'Скинути прогрес',
      });
  String get resetConfirm => _t(const {
        'uz': "Barcha javoblar va natijalar o'chiriladi. Davom etasizmi?",
        'cs': 'Všechny odpovědi a výsledky budou smazány. Pokračovat?',
        'en': 'All answers and results will be deleted. Continue?',
        'vi': 'Tất cả câu trả lời và kết quả sẽ bị xóa. Bạn có muốn tiếp tục?',
        'ru': 'Все ответы и результаты будут удалены. Продолжить?',
        'uk': 'Усі відповіді та результати буде видалено. Продовжити?',
      });
  String get cancel => _t(const {
        'uz': 'Bekor qilish',
        'cs': 'Zrušit',
        'en': 'Cancel',
        'vi': 'Hủy',
        'ru': 'Отмена',
        'uk': 'Скасувати',
      });
  String get reset => _t(const {
        'uz': 'Tozalash',
        'cs': 'Smazat',
        'en': 'Reset',
        'vi': 'Xóa',
        'ru': 'Сбросить',
        'uk': 'Скинути',
      });
  String get progressCleared => _t(const {
        'uz': 'Progress tozalandi',
        'cs': 'Pokrok byl smazán',
        'en': 'Progress reset',
        'vi': 'Đã xóa tiến độ',
        'ru': 'Прогресс сброшен',
        'uk': 'Прогрес скинуто',
      });
  String get version => _t(const {
        'uz': 'Versiya',
        'cs': 'Verze',
        'en': 'Version',
        'vi': 'Phiên bản',
        'ru': 'Версия',
        'uk': 'Версія',
      });

  // ── Progress ─────────────────────────────────────────────────
  String answeredOf(int answered, int total) => _t(const {
        'uz': '{t} savoldan {a} tasiga javob berilgan',
        'cs': 'Zodpovězeno {a} z {t} otázek',
        'en': '{a} of {t} questions answered',
        'vi': 'Đã trả lời {a} trên {t} câu',
        'ru': 'Отвечено {a} из {t} вопросов',
        'uk': 'Надано відповідь на {a} з {t} питань',
      }).replaceAll('{a}', '$answered').replaceAll('{t}', '$total');
  String get noProgress => _t(const {
        'uz': "Hali natija yo'q. Birinchi mashqni boshlang!",
        'cs': 'Zatím žádné výsledky. Začněte první procvičování!',
        'en': 'No results yet. Start your first practice!',
        'vi': 'Chưa có kết quả. Hãy bắt đầu bài luyện tập đầu tiên!',
        'ru': 'Пока нет результатов. Начните первую практику!',
        'uk': 'Поки немає результатів. Почніть першу практику!',
      });

  // ── A2 o'qish ────────────────────────────────────────────────
  String taskN(int n) => _t(const {
        'uz': '{n}-topshiriq',
        'cs': 'Úloha {n}',
        'en': 'Task {n}',
        'vi': 'Bài {n}',
        'ru': 'Задание {n}',
        'uk': 'Завдання {n}',
      }).replaceAll('{n}', '$n');
  String get readingInstruction => _t(const {
        'uz': "Matnni o'qing va savollarga javob bering.",
        'cs': 'Přečtěte si text a odpovězte na otázky.',
        'en': 'Read the text and answer the questions.',
        'vi': 'Hãy đọc văn bản và trả lời câu hỏi.',
        'ru': 'Прочитайте текст и ответьте на вопросы.',
        'uk': 'Прочитайте текст і дайте відповіді на питання.',
      });
  String get checkAnswers => _t(const {
        'uz': 'Javoblarni tekshirish',
        'cs': 'Zkontrolovat odpovědi',
        'en': 'Check answers',
        'vi': 'Kiểm tra đáp án',
        'ru': 'Проверить ответы',
        'uk': 'Перевірити відповіді',
      });
  String scoreShort(int right, int total) => _t(const {
        'uz': "{r} / {t} to'g'ri",
        'cs': 'Správně {r} / {t}',
        'en': '{r} / {t} correct',
        'vi': 'Đúng {r} / {t}',
        'ru': 'Правильно {r} / {t}',
        'uk': 'Правильно {r} / {t}',
      }).replaceAll('{r}', '$right').replaceAll('{t}', '$total');
  String get nextTask => _t(const {
        'uz': 'Keyingi topshiriq',
        'cs': 'Další úloha',
        'en': 'Next task',
        'vi': 'Bài tiếp theo',
        'ru': 'Следующее задание',
        'uk': 'Наступне завдання',
      });
  String get finish => _t(const {
        'uz': 'Tugatish',
        'cs': 'Dokončit',
        'en': 'Finish',
        'vi': 'Hoàn thành',
        'ru': 'Завершить',
        'uk': 'Завершити',
      });

  // ── Tariflar va bloklar ──────────────────────────────────────
  String get trackResidence => _t(const {
        'uz': 'Doimiy yashash (A2)',
        'cs': 'Trvalý pobyt (A2)',
        'en': 'Permanent residence (A2)',
        'ru': 'ПМЖ (A2)',
        'uk': 'Постійне проживання (A2)',
        'vi': 'Thường trú (A2)',
      });
  String get trackCitizenship => _t(const {
        'uz': 'Fuqarolik (B1 + reálie)',
        'cs': 'Občanství (B1 + reálie)',
        'en': 'Citizenship (B1 + reálie)',
        'ru': 'Гражданство (B1 + reálie)',
        'uk': 'Громадянство (B1 + reálie)',
        'vi': 'Quốc tịch (B1 + reálie)',
      });
  String get trackBoth => _t(const {
        'uz': 'Ikkalasi birga',
        'cs': 'Obojí dohromady',
        'en': 'Both together',
        'ru': 'Оба вместе',
        'uk': 'Обидва разом',
        'vi': 'Cả hai',
      });
  String get residenceNote => _t(const {
        'uz': 'Doimiy yashash uchun faqat A2 darajasidagi chex tili imtihoni kerak.',
        'cs': 'Pro trvalý pobyt stačí zkouška z češtiny na úrovni A2.',
        'en': 'For permanent residence you only need the Czech exam at level A2.',
        'ru': 'Для ПМЖ нужен только экзамен по чешскому языку уровня A2.',
        'uk': 'Для постійного проживання потрібен лише іспит з чеської мови рівня A2.',
        'vi': 'Để xin thường trú, bạn chỉ cần thi tiếng Séc trình độ A2.',
      });
  String get citizenshipNote => _t(const {
        'uz': 'Fuqarolik uchun B1 darajasidagi chex tili imtihoni va České reálie testi kerak.',
        'cs': 'Pro občanství potřebujete zkoušku z češtiny na úrovni B1 a test z českých reálií.',
        'en': 'For citizenship you need the Czech exam at level B1 and the české reálie test.',
        'ru': 'Для гражданства нужны экзамен по чешскому языку уровня B1 и тест по české reálie.',
        'uk': 'Для громадянства потрібні іспит з чеської мови рівня B1 і тест з české reálie.',
        'vi': 'Để xin quốc tịch, bạn cần thi tiếng Séc trình độ B1 và bài kiểm tra české reálie.',
      });
  String get czechB1 => _t(const {
        'uz': 'Chex tili B1',
        'cs': 'Čeština B1',
        'en': 'Czech B1',
        'ru': 'Чешский язык B1',
        'uk': 'Чеська мова B1',
        'vi': 'Tiếng Séc B1',
      });
  String get b1Subtitle => _t(const {
        'uz': 'Fuqarolik uchun til imtihoni',
        'cs': 'Jazyková zkouška pro občanství',
        'en': 'Language exam for citizenship',
        'ru': 'Языковой экзамен для гражданства',
        'uk': 'Мовний іспит для громадянства',
        'vi': 'Kỳ thi ngôn ngữ để xin quốc tịch',
      });
  String get includesA2 => _t(const {
        'uz': "A2 bo'yicha barcha topshiriqlar: o'qish, tinglash, yozish, gapirish",
        'cs': 'Všechny úlohy A2: čtení, poslech, psaní, mluvení',
        'en': 'All A2 tasks: reading, listening, writing, speaking',
        'ru': 'Все задания A2: чтение, аудирование, письмо, говорение',
        'uk': 'Усі завдання A2: читання, аудіювання, письмо, говоріння',
        'vi': 'Tất cả bài tập A2: đọc, nghe, viết, nói',
      });
  String get includesCitizenship => _t(const {
        'uz': "Barcha České reálie savollari va cheksiz sinov imtihonlari; B1 tayyorlovi qo'shilganda u ham ichida bo'ladi",
        'cs': 'Všechny otázky z českých reálií a neomezené zkoušky nanečisto; až přidáme přípravu na B1, bude také součástí',
        'en': 'All české reálie questions and unlimited mock exams; B1 preparation will be included once it is added',
        'ru': 'Все вопросы по české reálie и неограниченные пробные экзамены; подготовка к B1 войдёт сюда, когда появится',
        'uk': "Усі питання з české reálie та необмежені пробні іспити; підготовка до B1 увійде сюди, коли з'явиться",
        'vi': 'Tất cả câu hỏi české reálie và thi thử không giới hạn; phần ôn B1 cũng sẽ có khi được bổ sung',
      });
  String get includesBoth => _t(const {
        'uz': 'Ikkala tarif: A2 va fuqarolik',
        'cs': 'Oba tarify: A2 i občanství',
        'en': 'Both plans: A2 and citizenship',
        'ru': 'Оба тарифа: A2 и гражданство',
        'uk': 'Обидва тарифи: A2 і громадянство',
        'vi': 'Cả hai gói: A2 và quốc tịch',
      });
  String savePrice(String price) => _t(const {
        'uz': 'Tejash: {p}',
        'cs': 'Ušetříte {p}',
        'en': 'Save {p}',
        'ru': 'Экономия {p}',
        'uk': 'Економія {p}',
        'vi': 'Tiết kiệm {p}',
      }).replaceAll('{p}', price);
  String get chooseTariff => _t(const {
        'uz': 'Tarifni tanlang',
        'cs': 'Vyberte tarif',
        'en': 'Choose a plan',
        'ru': 'Выберите тариф',
        'uk': 'Оберіть тариф',
        'vi': 'Chọn gói',
      });
  String unlockFrom(String price) => _t(const {
        'uz': '{p} dan boshlab',
        'cs': 'od {p}',
        'en': 'from {p}',
        'ru': 'от {p}',
        'uk': 'від {p}',
        'vi': 'từ {p}',
      }).replaceAll('{p}', price);

  // ── Bo'lim va kurs natijasi ──────────────────────────────────
  String sectionScore(int percent) => _t(const {
        'uz': "Bo'lim natijasi: {p}%",
        'cs': 'Výsledek oddílu: {p} %',
        'en': 'Section result: {p}%',
        'vi': 'Kết quả phần thi: {p}%',
        'ru': 'Результат раздела: {p}%',
        'uk': 'Результат розділу: {p}%',
      }).replaceAll('{p}', '$percent');
  String get courseTotal => _t(const {
        'uz': 'Umumiy kurs natijasi',
        'cs': 'Celkový výsledek kurzu',
        'en': 'Overall course result',
        'vi': 'Kết quả toàn khóa học',
        'ru': 'Общий результат курса',
        'uk': 'Загальний результат курсу',
      });
  String courseCompleted(int percent) => _t(const {
        'uz': 'Kurs {p}% muvaffaqiyatli bajarildi',
        'cs': 'Kurz úspěšně splněn na {p} %',
        'en': 'Course {p}% successfully completed',
        'vi': 'Đã hoàn thành {p}% khóa học',
        'ru': 'Курс успешно пройден на {p}%',
        'uk': 'Курс успішно пройдено на {p}%',
      }).replaceAll('{p}', '$percent');

  // ── A2 tinglash ──────────────────────────────────────────────
  String get listeningInstruction => _t(const {
        'uz': 'Yozuvni tinglang va savollarga javob bering. Uni 2 marta eshitishingiz mumkin.',
        'cs': 'Poslechněte si nahrávku a odpovězte na otázky. Můžete ji slyšet dvakrát.',
        'en': 'Listen to the recording and answer the questions. You can hear it twice.',
        'vi': 'Hãy nghe đoạn ghi âm và trả lời câu hỏi. Bạn có thể nghe hai lần.',
        'ru': 'Прослушайте запись и ответьте на вопросы. Её можно прослушать два раза.',
        'uk': 'Прослухайте запис і дайте відповіді на питання. Його можна прослухати двічі.',
      });
  String playRecording(int left) => _t(const {
        'uz': 'Yozuvni tinglash ({n} marta qoldi)',
        'cs': 'Pustit nahrávku (zbývá {n}×)',
        'en': 'Play recording ({n} left)',
        'vi': 'Phát ghi âm (còn {n} lần)',
        'ru': 'Включить запись (осталось {n})',
        'uk': 'Увімкнути запис (залишилось {n})',
      }).replaceAll('{n}', '$left');
  String get playing => _t(const {
        'uz': 'Eshittirilmoqda… To\'xtatish uchun bosing',
        'cs': 'Přehrávání… Klepnutím zastavíte',
        'en': 'Playing… Tap to stop',
        'vi': 'Đang phát… Chạm để dừng',
        'ru': 'Воспроизведение… Нажмите, чтобы остановить',
        'uk': 'Відтворення… Натисніть, щоб зупинити',
      });
  String get listenAgain => _t(const {
        'uz': 'Yana tinglash',
        'cs': 'Poslechnout znovu',
        'en': 'Listen again',
        'vi': 'Nghe lại',
        'ru': 'Прослушать ещё раз',
        'uk': 'Прослухати ще раз',
      });
  String get transcript => _t(const {
        'uz': 'Yozuv matni',
        'cs': 'Přepis nahrávky',
        'en': 'Transcript',
        'vi': 'Lời ghi âm',
        'ru': 'Текст записи',
        'uk': 'Текст запису',
      });
  String get ttsMissing => _t(const {
        'uz': "Telefoningizda chex tili ovozi topilmadi. Telefon sozlamalaridagi «Matnni nutqqa aylantirish» bo'limidan chex tilini o'rnating.",
        'cs': 'V telefonu chybí český hlas. Nainstalujte ho v nastavení telefonu v části Převod textu na řeč.',
        'en': 'No Czech voice was found on your phone. Install it in your phone settings under Text-to-speech.',
        'vi': 'Không tìm thấy giọng đọc tiếng Séc trên điện thoại. Hãy cài đặt trong phần Chuyển văn bản thành giọng nói của điện thoại.',
        'ru': 'На телефоне нет чешского голоса. Установите его в настройках телефона в разделе «Синтез речи».',
        'uk': 'На телефоні немає чеського голосу. Встановіть його в налаштуваннях телефона в розділі «Синтез мовлення».',
      });

  String get ttsMissingPc => _t(const {
        'uz': "Kompyuteringizda chex tili ovozi yo'q. Ilovani Microsoft Edge'da oching yoki Windows sozlamalarida (Vaqt va til → Nutq → Ovoz qo'shish) chex tilini o'rnating.",
        'cs': 'Ve vašem počítači chybí český hlas. Otevřete aplikaci v Microsoft Edge, nebo přidejte češtinu v nastavení Windows (Čas a jazyk → Řeč → Přidat hlasy).',
        'en': 'Your computer has no Czech voice. Open the app in Microsoft Edge, or add Czech in Windows settings (Time & language → Speech → Add voices).',
        'vi': 'Máy tính không có giọng đọc tiếng Séc. Hãy mở ứng dụng bằng Microsoft Edge hoặc thêm tiếng Séc trong cài đặt Windows (Thời gian và ngôn ngữ → Giọng nói → Thêm giọng nói).',
        'ru': 'На компьютере нет чешского голоса. Откройте приложение в Microsoft Edge или добавьте чешский в настройках Windows (Время и язык → Речь → Добавить голоса).',
        'uk': "На комп'ютері немає чеського голосу. Відкрийте застосунок у Microsoft Edge або додайте чеську в налаштуваннях Windows (Час і мова → Мовлення → Додати голоси).",
      });

  // ── A2 gapirish ──────────────────────────────────────────────
  String get speakingInstruction => _t(const {
        'uz': 'Topshiriqni o\'qing, mikrofonni bosing va chex tilida gapiring.',
        'cs': 'Přečtěte si úkol, klepněte na mikrofon a mluvte česky.',
        'en': 'Read the task, tap the microphone and speak Czech.',
        'vi': 'Hãy đọc đề bài, chạm vào micrô và nói tiếng Séc.',
        'ru': 'Прочитайте задание, нажмите на микрофон и говорите по-чешски.',
        'uk': 'Прочитайте завдання, натисніть мікрофон і говоріть чеською.',
      });
  String get tapToSpeak => _t(const {
        'uz': 'Gapirish uchun bosing',
        'cs': 'Klepněte a mluvte',
        'en': 'Tap to speak',
        'vi': 'Chạm để nói',
        'ru': 'Нажмите и говорите',
        'uk': 'Натисніть і говоріть',
      });
  String get listeningNow => _t(const {
        'uz': 'Tinglayapman… Tugatish uchun bosing',
        'cs': 'Poslouchám… Klepnutím ukončíte',
        'en': 'Listening… Tap to finish',
        'vi': 'Đang nghe… Chạm để kết thúc',
        'ru': 'Слушаю… Нажмите, чтобы закончить',
        'uk': 'Слухаю… Натисніть, щоб завершити',
      });
  String get yourAnswer => _t(const {
        'uz': 'Sizning javobingiz',
        'cs': 'Vaše odpověď',
        'en': 'Your answer',
        'vi': 'Câu trả lời của bạn',
        'ru': 'Ваш ответ',
        'uk': 'Ваша відповідь',
      });
  String get keyPhrases => _t(const {
        'uz': 'Kerakli iboralar',
        'cs': 'Důležité fráze',
        'en': 'Key phrases',
        'vi': 'Cụm từ quan trọng',
        'ru': 'Ключевые фразы',
        'uk': 'Ключові фрази',
      });
  String get modelAnswer => _t(const {
        'uz': 'Namunaviy javob',
        'cs': 'Vzorová odpověď',
        'en': 'Model answer',
        'vi': 'Câu trả lời mẫu',
        'ru': 'Образец ответа',
        'uk': 'Зразок відповіді',
      });
  String get listenModel => _t(const {
        'uz': 'Namunani tinglash',
        'cs': 'Poslechnout vzor',
        'en': 'Listen to the model',
        'vi': 'Nghe câu mẫu',
        'ru': 'Прослушать образец',
        'uk': 'Прослухати зразок',
      });
  String get sttMissing => _t(const {
        'uz': "Nutqni aniqlash bu qurilmada ishlamayapti. Javobingizni yozib kiriting.",
        'cs': 'Rozpoznávání řeči na tomto zařízení nefunguje. Napište odpověď.',
        'en': "Speech recognition isn't available on this device. Type your answer instead.",
        'vi': 'Thiết bị này không hỗ trợ nhận dạng giọng nói. Hãy nhập câu trả lời.',
        'ru': 'Распознавание речи на этом устройстве недоступно. Напишите ответ.',
        'uk': 'Розпізнавання мовлення на цьому пристрої недоступне. Напишіть відповідь.',
      });
  String get speakingPrivacy => _t(const {
        'uz': 'Ovozingiz telefoningizning nutqni aniqlash xizmati orqali matnga aylantiriladi. Ilova ovoz yozuvini saqlamaydi.',
        'cs': 'Hlas převádí na text služba rozpoznávání řeči ve vašem telefonu. Aplikace nahrávky neukládá.',
        'en': "Your voice is turned into text by your phone's speech recognition service. The app does not store recordings.",
        'vi': 'Giọng nói của bạn được dịch vụ nhận dạng giọng nói của điện thoại chuyển thành văn bản. Ứng dụng không lưu bản ghi âm.',
        'ru': 'Голос преобразуется в текст службой распознавания речи вашего телефона. Приложение не сохраняет записи.',
        'uk': 'Голос перетворюється на текст службою розпізнавання мовлення вашого телефона. Застосунок не зберігає записи.',
      });

  // ── A2 yozish ────────────────────────────────────────────────
  String get mustInclude => _t(const {
        'uz': "Matnda bo'lishi kerak",
        'cs': 'Text musí obsahovat',
        'en': 'Your text must include',
        'vi': 'Bài viết cần có',
        'ru': 'В тексте должно быть',
        'uk': 'У тексті має бути',
      });
  String wordCount(int n, int min) => _t(const {
        'uz': "{n} / {m} so'z",
        'cs': '{n} / {m} slov',
        'en': '{n} / {m} words',
        'vi': '{n} / {m} từ',
        'ru': '{n} / {m} слов',
        'uk': '{n} / {m} слів',
      }).replaceAll('{n}', '$n').replaceAll('{m}', '$min');
  String get writeHere => _t(const {
        'uz': 'Shu yerga chex tilida yozing…',
        'cs': 'Pište sem česky…',
        'en': 'Write in Czech here…',
        'vi': 'Hãy viết bằng tiếng Séc ở đây…',
        'ru': 'Пишите здесь по-чешски…',
        'uk': 'Пишіть тут чеською…',
      });
  String tooShort(int min) => _t(const {
        'uz': "Matn juda qisqa: kamida {m} so'z kerak.",
        'cs': 'Text je příliš krátký: potřebujete alespoň {m} slov.',
        'en': 'The text is too short: at least {m} words are needed.',
        'vi': 'Bài viết quá ngắn: cần ít nhất {m} từ.',
        'ru': 'Текст слишком короткий: нужно минимум {m} слов.',
        'uk': 'Текст закороткий: потрібно щонайменше {m} слів.',
      }).replaceAll('{m}', '$min');
  String get lengthOk => _t(const {
        'uz': 'Uzunlik yetarli.',
        'cs': 'Délka je v pořádku.',
        'en': 'The length is fine.',
        'vi': 'Độ dài đạt yêu cầu.',
        'ru': 'Длина достаточная.',
        'uk': 'Довжина достатня.',
      });
  String get greetingOk => _t(const {
        'uz': 'Salomlashuv bor.',
        'cs': 'Pozdrav na začátku je v pořádku.',
        'en': 'There is a greeting.',
        'vi': 'Có lời chào.',
        'ru': 'Приветствие есть.',
        'uk': 'Привітання є.',
      });
  String get greetingMissing => _t(const {
        'uz': "Salomlashuv yo'q (masalan: Ahoj, Dobrý den, Milá…).",
        'cs': 'Chybí pozdrav (např. Ahoj, Dobrý den, Milá…).',
        'en': 'The greeting is missing (e.g. Ahoj, Dobrý den, Milá…).',
        'vi': 'Thiếu lời chào (ví dụ: Ahoj, Dobrý den, Milá…).',
        'ru': 'Нет приветствия (например: Ahoj, Dobrý den, Milá…).',
        'uk': 'Немає привітання (наприклад: Ahoj, Dobrý den, Milá…).',
      });
  String get closingOk => _t(const {
        'uz': 'Xayrlashuv bor.',
        'cs': 'Rozloučení na konci je v pořádku.',
        'en': 'There is a closing.',
        'vi': 'Có lời kết.',
        'ru': 'Прощание есть.',
        'uk': 'Прощання є.',
      });
  String get closingMissing => _t(const {
        'uz': "Xayrlashuv yo'q (masalan: S pozdravem, Měj se, Ahoj…).",
        'cs': 'Chybí rozloučení (např. S pozdravem, Měj se, Ahoj…).',
        'en': 'The closing is missing (e.g. S pozdravem, Měj se, Ahoj…).',
        'vi': 'Thiếu lời kết (ví dụ: S pozdravem, Měj se, Ahoj…).',
        'ru': 'Нет прощания (например: S pozdravem, Měj se, Ahoj…).',
        'uk': 'Немає прощання (наприклад: S pozdravem, Měj se, Ahoj…).',
      });
  String get fewDiacritics => _t(const {
        'uz': "Chex harflari (á, č, ě, ř, š, ž…) deyarli ishlatilmagan. Imtihonda ular muhim.",
        'cs': 'Skoro nepoužíváte diakritiku (á, č, ě, ř, š, ž…). U zkoušky je důležitá.',
        'en': 'You hardly use Czech diacritics (á, č, ě, ř, š, ž…). They matter in the exam.',
        'vi': 'Bạn hầu như không dùng dấu tiếng Séc (á, č, ě, ř, š, ž…). Trong kỳ thi, dấu rất quan trọng.',
        'ru': 'Почти нет диакритики (á, č, ě, ř, š, ž…). На экзамене она важна.',
        'uk': 'Майже немає діакритики (á, č, ě, ř, š, ž…). На іспиті вона важлива.',
      });
  String get pasteBlocked => _t(const {
        'uz': "Bu yerda matnni nusxa qilib qo'yib bo'lmaydi. Uni o'zingiz yozing, imtihonda ham qo'lda yoziladi.",
        'cs': 'Vkládání textu tu není možné. Napište text sami, stejně jako u zkoušky.',
        'en': "Pasting isn't allowed here. Type the text yourself, just like in the exam.",
        'vi': 'Không thể dán văn bản ở đây. Hãy tự gõ, giống như trong kỳ thi.',
        'ru': 'Вставлять текст здесь нельзя. Напишите текст сами, как на экзамене.',
        'uk': 'Вставляти текст тут не можна. Напишіть текст самі, як на іспиті.',
      });
  String get selfCheckPoints => _t(const {
        'uz': "Har bir bandni o'zingiz tekshiring:",
        'cs': 'Zkontrolujte sami každý bod:',
        'en': 'Check each point yourself:',
        'vi': 'Hãy tự kiểm tra từng ý:',
        'ru': 'Проверьте каждый пункт сами:',
        'uk': 'Перевірте кожен пункт самі:',
      });
  String get showModel => _t(const {
        'uz': "Namunaviy javobni ko'rsatish",
        'cs': 'Zobrazit vzorovou odpověď',
        'en': 'Show model answer',
        'vi': 'Hiện câu trả lời mẫu',
        'ru': 'Показать образец ответа',
        'uk': 'Показати зразок відповіді',
      });
  String get aiCheck => _t(const {
        'uz': 'AI tekshiruvi',
        'cs': 'Kontrola pomocí AI',
        'en': 'AI check',
        'vi': 'Kiểm tra bằng AI',
        'ru': 'Проверка ИИ',
        'uk': 'Перевірка ШІ',
      });
  String get aiSoon => _t(const {
        'uz': "Grammatik xatolarni AI bilan tuzatish keyingi versiyada qo'shiladi.",
        'cs': 'Opravy gramatiky pomocí AI přidáme v příští verzi.',
        'en': 'AI grammar correction is coming in the next version.',
        'vi': 'Tính năng sửa ngữ pháp bằng AI sẽ có trong phiên bản tiếp theo.',
        'ru': 'Исправление грамматики с помощью ИИ появится в следующей версии.',
        'uk': 'Виправлення граматики за допомогою ШІ з\'явиться в наступній версії.',
      });

  // ── 1-bosqich: qulflar, takrorlash, reja, sinov imtihonlari ──
  String freeVersionNote(int shown, int total) => _t(const {
        'uz': 'Bepul versiya: {t} tadan {n} tasi. Qolganini to\'liq versiyada ochasiz.',
        'cs': 'Bezplatná verze: {n} z {t}. Zbytek odemknete v plné verzi.',
        'en': 'Free version: {n} of {t}. Unlock the rest in the full version.',
        'vi': 'Bản miễn phí: {n}/{t}. Mở khóa phần còn lại trong bản đầy đủ.',
        'ru': 'Бесплатная версия: {n} из {t}. Остальное откроете в полной версии.',
        'uk': 'Безкоштовна версія: {n} з {t}. Решту відкриєте в повній версії.',
      }).replaceAll('{n}', '$shown').replaceAll('{t}', '$total');
  String get unlockButton => _t(const {
        'uz': 'To\'liq versiyani ochish',
        'cs': 'Odemknout plnou verzi',
        'en': 'Unlock the full version',
        'vi': 'Mở khóa bản đầy đủ',
        'ru': 'Открыть полную версию',
        'uk': 'Відкрити повну версію',
      });
  String get freeEndTitle => _t(const {
        'uz': 'Bepul qism tugadi',
        'cs': 'Bezplatná část je hotová',
        'en': 'You have finished the free part',
        'vi': 'Bạn đã hoàn thành phần miễn phí',
        'ru': 'Бесплатная часть пройдена',
        'uk': 'Безкоштовну частину завершено',
      });
  String get mockLockedTitle => _t(const {
        'uz': 'Bepul sinov imtihonidan foydalanildi',
        'cs': 'Bezplatná zkouška nanečisto je vyčerpána',
        'en': 'Your free mock exam has been used',
        'vi': 'Bạn đã dùng lượt thi thử miễn phí',
        'ru': 'Бесплатный пробный экзамен использован',
        'uk': 'Безкоштовний пробний іспит використано',
      });
  String get mockLockedText => _t(const {
        'uz': 'To\'liq versiyada sinov imtihonlarini cheksiz topshirishingiz mumkin.',
        'cs': 'V plné verzi můžete skládat zkoušky nanečisto bez omezení.',
        'en': 'With the full version you can take unlimited mock exams.',
        'vi': 'Với bản đầy đủ, bạn có thể thi thử không giới hạn.',
        'ru': 'В полной версии вы можете сдавать пробные экзамены без ограничений.',
        'uk': 'У повній версії ви можете складати пробні іспити без обмежень.',
      });
  String get freeMockNote => _t(const {
        'uz': 'Bepul versiyada 1 ta sinov imtihoni bor.',
        'cs': 'Bezplatná verze obsahuje 1 zkoušku nanečisto.',
        'en': 'The free version includes 1 mock exam.',
        'vi': 'Bản miễn phí có 1 lượt thi thử.',
        'ru': 'Бесплатная версия включает 1 пробный экзамен.',
        'uk': 'Безкоштовна версія містить 1 пробний іспит.',
      });
  String get reviewTitle => _t(const {
        'uz': 'Takrorlash',
        'cs': 'Opakování',
        'en': 'Review',
        'vi': 'Ôn tập',
        'ru': 'Повторение',
        'uk': 'Повторення',
      });
  String get noReviewTitle => _t(const {
        'uz': 'Bugun takrorlash uchun savol qolmadi',
        'cs': 'Pro dnešek je vše zopakováno',
        'en': 'Nothing left to review today',
        'vi': 'Hôm nay không còn gì để ôn',
        'ru': 'На сегодня всё повторено',
        'uk': 'На сьогодні все повторено',
      });
  String get noReviewText => _t(const {
        'uz': 'Xato qilgan savollaringiz va takrorlash vaqti kelgan savollar shu yerda o\'zi paydo bo\'ladi.',
        'cs': 'Otázky, ve kterých jste chybovali, a otázky, které je čas zopakovat, se zde objeví samy.',
        'en': 'Questions you got wrong, and those due for repetition, will appear here automatically.',
        'vi': 'Các câu bạn trả lời sai và các câu đến lúc ôn lại sẽ tự động xuất hiện ở đây.',
        'ru': 'Вопросы, в которых вы ошиблись, и те, которые пора повторить, появятся здесь автоматически.',
        'uk': 'Питання, у яких ви помилилися, і ті, які час повторити, з’являться тут автоматично.',
      });
  String get examInfoTitle => _t(const {
        'uz': 'Imtihonlar haqida',
        'cs': 'O zkouškách',
        'en': 'About the exams',
        'vi': 'Thông tin kỳ thi',
        'ru': 'Об экзаменах',
        'uk': 'Про іспити',
      });
  String get examInfoSubtitle => _t(const {
        'uz': 'To\'lov, vaqt, ballar va ro\'yxatdan o\'tish',
        'cs': 'Poplatky, časy, body a registrace',
        'en': 'Fees, timing, points and registration',
        'vi': 'Lệ phí, thời gian, điểm và đăng ký',
        'ru': 'Стоимость, время, баллы и регистрация',
        'uk': 'Оплата, час, бали та реєстрація',
      });
  String get officialSite => _t(const {
        'uz': 'Rasmiy sayt',
        'cs': 'Oficiální stránky',
        'en': 'Official website',
        'vi': 'Trang web chính thức',
        'ru': 'Официальный сайт',
        'uk': 'Офіційний сайт',
      });
  String get dataAsOf => _t(const {
        'uz': 'Ma\'lumotlar 2026-yil noyabr holatiga. Ro\'yxatdan o\'tishdan oldin rasmiy saytda tekshiring.',
        'cs': 'Údaje platí k listopadu 2026. Před registrací je ověřte na oficiálních stránkách.',
        'en': 'Information as of November 2026. Please check the official website before registering.',
        'vi': 'Thông tin tính đến tháng 11/2026. Vui lòng kiểm tra trên trang web chính thức trước khi đăng ký.',
        'ru': 'Данные по состоянию на ноябрь 2026 года. Перед регистрацией проверьте их на официальном сайте.',
        'uk': 'Дані станом на листопад 2026 року. Перед реєстрацією перевірте їх на офіційному сайті.',
      });
  String get linkError => _t(const {
        'uz': 'Havolani ochib bo\'lmadi',
        'cs': 'Odkaz se nepodařilo otevřít',
        'en': 'Could not open the link',
        'vi': 'Không mở được liên kết',
        'ru': 'Не удалось открыть ссылку',
        'uk': 'Не вдалося відкрити посилання',
      });
  String get examDate => _t(const {
        'uz': 'Imtihon sanasi',
        'cs': 'Datum zkoušky',
        'en': 'Exam date',
        'vi': 'Ngày thi',
        'ru': 'Дата экзамена',
        'uk': 'Дата іспиту',
      });
  String get setExamDate => _t(const {
        'uz': 'Imtihon sanasini belgilang',
        'cs': 'Nastavte datum zkoušky',
        'en': 'Set your exam date',
        'vi': 'Đặt ngày thi của bạn',
        'ru': 'Укажите дату экзамена',
        'uk': 'Вкажіть дату іспиту',
      });
  String get examToday => _t(const {
        'uz': 'Imtihon bugun. Omad tilaymiz!',
        'cs': 'Zkouška je dnes. Hodně štěstí!',
        'en': 'Your exam is today. Good luck!',
        'vi': 'Hôm nay là ngày thi. Chúc bạn may mắn!',
        'ru': 'Экзамен сегодня. Удачи!',
        'uk': 'Іспит сьогодні. Успіхів!',
      });
  String get examDatePassed => _t(const {
        'uz': 'Imtihon sanasi o\'tib ketdi. Yangisini belgilang.',
        'cs': 'Datum zkoušky již uplynulo. Nastavte nové.',
        'en': 'Your exam date has passed. Set a new one.',
        'vi': 'Ngày thi đã qua. Hãy đặt ngày mới.',
        'ru': 'Дата экзамена уже прошла. Укажите новую.',
        'uk': 'Дата іспиту вже минула. Вкажіть нову.',
      });
  String get dailyGoal => _t(const {
        'uz': 'Kunlik maqsad',
        'cs': 'Denní cíl',
        'en': 'Daily goal',
        'vi': 'Mục tiêu hằng ngày',
        'ru': 'Дневная цель',
        'uk': 'Щоденна мета',
      });
  String todayProgress(int done, int goal) => _t(const {
        'uz': 'Bugun: {d} / {g} javob',
        'cs': 'Dnes: {d} / {g} odpovědí',
        'en': 'Today: {d} / {g} answers',
        'vi': 'Hôm nay: {d} / {g} câu trả lời',
        'ru': 'Сегодня: {d} / {g} ответов',
        'uk': 'Сьогодні: {d} / {g} відповідей',
      }).replaceAll('{d}', '$done').replaceAll('{g}', '$goal');
  String get goalReached => _t(const {
        'uz': 'Bugungi maqsad bajarildi!',
        'cs': 'Dnešní cíl splněn!',
        'en': 'Today’s goal reached!',
        'vi': 'Đã đạt mục tiêu hôm nay!',
        'ru': 'Цель на сегодня выполнена!',
        'uk': 'Сьогоднішню мету виконано!',
      });
  String streakDays(int n) => _t(const {
        'uz': 'Ketma-ket kunlar: {n}',
        'cs': 'Dny v řadě: {n}',
        'en': 'Day streak: {n}',
        'vi': 'Chuỗi ngày: {n}',
        'ru': 'Дней подряд: {n}',
        'uk': 'Днів поспіль: {n}',
      }).replaceAll('{n}', '$n');
  String answersPerDay(int n) => _t(const {
        'uz': 'Kuniga {n} ta javob',
        'cs': '{n} odpovědí denně',
        'en': '{n} answers a day',
        'vi': '{n} câu mỗi ngày',
        'ru': '{n} ответов в день',
        'uk': '{n} відповідей на день',
      }).replaceAll('{n}', '$n');
  String get save => _t(const {
        'uz': 'Saqlash',
        'cs': 'Uložit',
        'en': 'Save',
        'vi': 'Lưu',
        'ru': 'Сохранить',
        'uk': 'Зберегти',
      });
  String get clearDate => _t(const {
        'uz': 'Sanani o\'chirish',
        'cs': 'Smazat datum',
        'en': 'Remove date',
        'vi': 'Xóa ngày',
        'ru': 'Удалить дату',
        'uk': 'Видалити дату',
      });
  String get planTitle => _t(const {
        'uz': 'Mening rejam',
        'cs': 'Můj plán',
        'en': 'My plan',
        'vi': 'Kế hoạch của tôi',
        'ru': 'Мой план',
        'uk': 'Мій план',
      });
  String get timeUp => _t(const {
        'uz': 'Vaqt tugadi',
        'cs': 'Čas vypršel',
        'en': 'Time is up',
        'vi': 'Hết giờ',
        'ru': 'Время вышло',
        'uk': 'Час вичерпано',
      });
  String timeLeft(String time) => _t(const {
        'uz': 'Qolgan vaqt: {t}',
        'cs': 'Zbývající čas: {t}',
        'en': 'Time left: {t}',
        'vi': 'Thời gian còn lại: {t}',
        'ru': 'Осталось времени: {t}',
        'uk': 'Залишилося часу: {t}',
      }).replaceAll('{t}', time);
  String get mockA2Title => _t(const {
        'uz': 'A2 sinov imtihoni',
        'cs': 'Zkouška A2 nanečisto',
        'en': 'A2 mock exam',
        'vi': 'Thi thử A2',
        'ru': 'Пробный экзамен A2',
        'uk': 'Пробний іспит A2',
      });
  String get mockA2Sub => _t(const {
        'uz': 'To\'liq imtihon: vaqt bilan 4 qism',
        'cs': 'Celá zkouška: 4 části s časovým limitem',
        'en': 'Full exam: 4 timed parts',
        'vi': 'Bài thi đầy đủ: 4 phần có giới hạn thời gian',
        'ru': 'Полный экзамен: 4 части с ограничением времени',
        'uk': 'Повний іспит: 4 частини з обмеженням часу',
      });
  String minutesShort(int n) => _t(const {
        'uz': '{n} daq',
        'cs': '{n} min',
        'en': '{n} min',
        'vi': '{n} phút',
        'ru': '{n} мин',
        'uk': '{n} хв',
      }).replaceAll('{n}', '$n');
  String pointsOf(int got, int max) => _t(const {
        'uz': '{p} / {m} ball',
        'cs': '{p} / {m} b.',
        'en': '{p} / {m} pts',
        'vi': '{p} / {m} điểm',
        'ru': '{p} / {m} б.',
        'uk': '{p} / {m} б.',
      }).replaceAll('{p}', '$got').replaceAll('{m}', '$max');
  String maxPoints(int n) => _t(const {
        'uz': '{n} ball',
        'cs': '{n} b.',
        'en': '{n} pts',
        'vi': '{n} điểm',
        'ru': '{n} б.',
        'uk': '{n} б.',
      }).replaceAll('{n}', '$n');
  String get startExam => _t(const {
        'uz': 'Imtihonni boshlash',
        'cs': 'Začít zkoušku',
        'en': 'Start the exam',
        'vi': 'Bắt đầu thi',
        'ru': 'Начать экзамен',
        'uk': 'Почати іспит',
      });
  String get nextPart => _t(const {
        'uz': 'Keyingi qism',
        'cs': 'Další část',
        'en': 'Next part',
        'vi': 'Phần tiếp theo',
        'ru': 'Следующая часть',
        'uk': 'Наступна частина',
      });
  String get finishExam => _t(const {
        'uz': 'Imtihonni yakunlash',
        'cs': 'Ukončit zkoušku',
        'en': 'Finish the exam',
        'vi': 'Kết thúc bài thi',
        'ru': 'Завершить экзамен',
        'uk': 'Завершити іспит',
      });
  String get writtenPart => _t(const {
        'uz': 'Yozma qism (o\'qish, yozish, tinglash)',
        'cs': 'Písemná část (čtení, psaní, poslech)',
        'en': 'Written part (reading, writing, listening)',
        'vi': 'Phần viết (đọc, viết, nghe)',
        'ru': 'Письменная часть (чтение, письмо, аудирование)',
        'uk': 'Письмова частина (читання, письмо, аудіювання)',
      });
  String get oralPart => _t(const {
        'uz': 'Og\'zaki qism',
        'cs': 'Ústní část',
        'en': 'Oral part',
        'vi': 'Phần nói',
        'ru': 'Устная часть',
        'uk': 'Усна частина',
      });
  String passNeed(int n) => _t(const {
        'uz': 'O\'tish uchun kamida {n} ball kerak',
        'cs': 'K úspěchu je třeba alespoň {n} b.',
        'en': 'You need at least {n} pts to pass',
        'vi': 'Cần ít nhất {n} điểm để đạt',
        'ru': 'Для успеха нужно не менее {n} б.',
        'uk': 'Для успіху потрібно щонайменше {n} б.',
      }).replaceAll('{n}', '$n');
  String get mockPassed => _t(const {
        'uz': 'Ehtimol, imtihondan o\'tgan bo\'lardingiz',
        'cs': 'Zkoušku byste pravděpodobně složili',
        'en': 'You would probably pass',
        'vi': 'Có thể bạn sẽ đạt',
        'ru': 'Вероятно, вы сдали бы экзамен',
        'uk': 'Імовірно, ви склали б іспит',
      });
  String get mockFailed => _t(const {
        'uz': 'Hozircha imtihondan o\'tolmas edingiz',
        'cs': 'Zatím byste zkoušku nesložili',
        'en': 'You would not pass yet',
        'vi': 'Hiện tại bạn chưa đạt',
        'ru': 'Пока вы бы не сдали экзамен',
        'uk': 'Поки що ви б не склали іспит',
      });
  String get estimateNote => _t(const {
        'uz': 'Bu taxminiy natija. Haqiqiy imtihonda yozish va gapirishni imtihonchilar baholaydi.',
        'cs': 'Jde o orientační výsledek. Psaní a mluvení u skutečné zkoušky hodnotí zkoušející.',
        'en': 'This is an estimate. In the real exam, writing and speaking are marked by examiners.',
        'vi': 'Đây là kết quả ước tính. Trong kỳ thi thật, phần viết và nói do giám khảo chấm.',
        'ru': 'Это ориентировочный результат. На настоящем экзамене письмо и устную часть оценивают экзаменаторы.',
        'uk': 'Це орієнтовний результат. На справжньому іспиті письмо й усне мовлення оцінюють екзаменатори.',
      });
  String get failRule => _t(const {
        'uz': 'O\'tolmasangiz, butun imtihon qayta topshiriladi.',
        'cs': 'Při neúspěchu se opakuje celá zkouška.',
        'en': 'If you fail, the whole exam must be retaken.',
        'vi': 'Nếu không đạt, bạn phải thi lại toàn bộ.',
        'ru': 'При неудаче весь экзамен сдаётся заново.',
        'uk': 'У разі невдачі іспит складають повністю знову.',
      });
  String realiePassRule(int pass, int total) => _t(const {
        'uz': 'O\'tish uchun {t} tadan kamida {p} ta to\'g\'ri javob kerak.',
        'cs': 'K úspěchu je třeba alespoň {p} správných odpovědí z {t}.',
        'en': 'You need at least {p} correct answers out of {t} to pass.',
        'vi': 'Cần ít nhất {p}/{t} câu đúng để đạt.',
        'ru': 'Для успеха нужно не менее {p} правильных ответов из {t}.',
        'uk': 'Для успіху потрібно щонайменше {p} правильних відповідей із {t}.',
      }).replaceAll('{p}', '$pass').replaceAll('{t}', '$total');
  String get realiePassed => _t(const {
        'uz': 'Testdan o\'tgan bo\'lardingiz',
        'cs': 'Test byste složili',
        'en': 'You would pass the test',
        'vi': 'Bạn sẽ đạt bài thi',
        'ru': 'Вы сдали бы тест',
        'uk': 'Ви склали б тест',
      });
  String get realieFailed => _t(const {
        'uz': 'Hozircha testdan o\'tolmas edingiz',
        'cs': 'Test byste zatím nesložili',
        'en': 'You would not pass the test yet',
        'vi': 'Bạn chưa đạt bài thi',
        'ru': 'Пока вы бы не сдали тест',
        'uk': 'Поки що ви не склали б тест',
      });
  String get mockIntro => _t(const {
        'uz': 'Imtihon haqiqiysidek o\'tadi: izohsiz va vaqt bilan. Natijani oxirida ko\'rasiz.',
        'cs': 'Zkouška probíhá jako skutečná: bez nápovědy a s časovým limitem. Výsledek uvidíte na konci.',
        'en': 'The exam runs like the real one: no hints and a time limit. You will see your result at the end.',
        'vi': 'Bài thi diễn ra như thật: không gợi ý, có giới hạn thời gian. Bạn sẽ thấy kết quả ở cuối.',
        'ru': 'Экзамен проходит как настоящий: без подсказок и с ограничением времени. Результат вы увидите в конце.',
        'uk': 'Іспит проходить як справжній: без підказок і з обмеженням часу. Результат побачите в кінці.',
      });
  String get realieMockSub => _t(const {
        'uz': '30 savol · 30 daqiqa',
        'cs': '30 otázek · 30 minut',
        'en': '30 questions · 30 minutes',
        'vi': '30 câu hỏi · 30 phút',
        'ru': '30 вопросов · 30 минут',
        'uk': '30 питань · 30 хвилин',
      });

  /// Imtihongacha qolgan kunlar (chex, rus va ukrain tillarida ko'plik shakllari bilan).
  String daysLeft(int n) {
    final mod10 = n % 10;
    final mod100 = n % 100;
    final few = mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14);
    final one = mod10 == 1 && mod100 != 11;
    switch (lang) {
      case 'cs':
        return 'Do zkoušky: $n ${n == 1 ? 'den' : (n >= 2 && n <= 4) ? 'dny' : 'dní'}';
      case 'en':
        return '$n ${n == 1 ? 'day' : 'days'} until your exam';
      case 'uz':
        return 'Imtihongacha $n kun qoldi';
      case 'vi':
        return 'Còn $n ngày đến kỳ thi';
      case 'ru':
        return 'До экзамена: $n ${one ? 'день' : few ? 'дня' : 'дней'}';
      case 'uk':
        return 'До іспиту: $n ${one ? 'день' : few ? 'дні' : 'днів'}';
      default:
        return 'Do zkoušky: $n ${n == 1 ? 'den' : (n >= 2 && n <= 4) ? 'dny' : 'dní'}';
    }
  }
}
