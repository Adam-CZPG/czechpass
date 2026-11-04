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
}
