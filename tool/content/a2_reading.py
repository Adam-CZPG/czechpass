# A2 o'qish — yangi topshiriqlar (o'zimiz yozgan matnlar).
# Rasmiy model testlardagi vaziyatlar (do'kon reklamalari, zoopark, salyut, sayohat agentligi va h.k.)
# ataylab ishlatilmagan.

def T(id, title, text, questions):
    return {'id': id, 'title': title, 'text': text, 'questions': questions}


def q(id, question, options):
    return {'id': id, 'question': question, 'options': options, 'correct': 0}


def L(cs, uz, en, ru, uk, vi):
    return {'cs': cs, 'uz': uz, 'en': en, 'ru': ru, 'uk': uk, 'vi': vi}


TASKS = [
    T('own-a2r-013', L('Blokové čištění ulice', "Ko'chani tozalash", 'Street cleaning', 'Уборка улицы', 'Прибирання вулиці', 'Làm sạch đường phố'),
      'UPOZORNĚNÍ – BLOKOVÉ ČIŠTĚNÍ\n\nV úterý 12. května od 7:00 do 16:00 se bude čistit ulice Polní.\n'
      'Prosíme, nenechávejte v tento den auta na ulici. Auta, která tu budou stát, odtáhne odtahová služba.\n'
      'Parkovat můžete zdarma na parkovišti u sportovní haly.\n\nTechnické služby města',
      [q('q1', L('Kdy se bude čistit ulice Polní?', "Polní ko'chasi qachon tozalanadi?", 'When will Polní Street be cleaned?',
                 'Когда будут убирать улицу Полни?', 'Коли прибиратимуть вулицю Полні?', 'Khi nào phố Polní được làm sạch?'),
         ['V úterý 12. května', 'Každé úterý', 'V sobotu 12. května', 'Celý květen']),
       q('q2', L('Co se stane s auty, která zůstanou na ulici?', "Ko'chada qolgan mashinalar bilan nima bo'ladi?", 'What will happen to cars left in the street?',
                 'Что будет с машинами, оставленными на улице?', 'Що буде з автомобілями, залишеними на вулиці?', 'Xe để lại trên đường sẽ bị làm sao?'),
         ['Odtáhne je odtahová služba', 'Umyjí je', 'Dostanou slevu', 'Nic se nestane']),
       q('q3', L('Kde se dá parkovat zdarma?', "Qayerda bepul to'xtash mumkin?", 'Where can you park for free?',
                 'Где можно парковаться бесплатно?', 'Де можна паркуватися безкоштовно?', 'Có thể đỗ xe miễn phí ở đâu?'),
         ['U sportovní haly', 'Na ulici Polní', 'U nádraží', 'V centru města'])]),

    T('own-a2r-014', L('Nový svoz odpadu', 'Chiqindilarni olib ketishning yangi tartibi', 'New waste collection', 'Новый вывоз мусора', 'Новий вивіз сміття', 'Lịch thu gom rác mới'),
      'Vážení obyvatelé,\n\nod 1. března se mění svoz odpadu. Směsný odpad budeme odvážet každou středu, ne ve čtvrtek.\n'
      'Bioodpad (zbytky jídla, tráva) budeme odvážet jednou za dva týdny v pondělí.\n'
      'Velké věci, například starý nábytek, můžete zdarma odvézt do sběrného dvora v Jasmínové ulici.\n\nObecní úřad',
      [q('q1', L('Kdy se bude nově odvážet směsný odpad?', "Aralash chiqindi endi qachon olib ketiladi?", 'When will mixed waste be collected from now on?',
                 'Когда теперь будут вывозить смешанные отходы?', 'Коли тепер вивозитимуть змішані відходи?', 'Rác hỗn hợp từ nay được thu gom khi nào?'),
         ['Každou středu', 'Každý čtvrtek', 'Každé pondělí', 'Jednou za měsíc']),
       q('q2', L('Jak často se bude odvážet bioodpad?', "Bioodpad qanchalik tez-tez olib ketiladi?", 'How often will bio-waste be collected?',
                 'Как часто будут вывозить биоотходы?', 'Як часто вивозитимуть біовідходи?', 'Rác hữu cơ được thu gom bao lâu một lần?'),
         ['Jednou za dva týdny', 'Každý den', 'Dvakrát týdně', 'Jednou za rok']),
       q('q3', L('Kam můžete dát starý nábytek?', "Eski mebelni qayerga olib borish mumkin?", 'Where can you take old furniture?',
                 'Куда можно отвезти старую мебель?', 'Куди можна відвезти старі меблі?', 'Bạn có thể mang đồ nội thất cũ đến đâu?'),
         ['Do sběrného dvora', 'Do žluté popelnice', 'Na obecní úřad', 'Před dům'])]),

    T('own-a2r-015', L('Ztráty a nálezy', "Yo'qolgan va topilgan narsalar", 'Lost and found', 'Бюро находок', 'Бюро знахідок', 'Đồ thất lạc'),
      'NAŠLI JSME KLÍČE\n\nVe čtvrtek ráno jsme na dětském hřišti v parku našli klíče s červenou kožešinovou kuličkou.\n'
      'Klíče si můžete vyzvednout v kavárně Lípa naproti parku, každý den od 8 do 20 hodin.\n'
      'Řekněte prosím, kolik klíčů na kroužku je.',
      [q('q1', L('Kde byly klíče nalezeny?', "Kalitlar qayerda topilgan?", 'Where were the keys found?',
                 'Где нашли ключи?', 'Де знайшли ключі?', 'Chìa khóa được tìm thấy ở đâu?'),
         ['Na dětském hřišti', 'V kavárně', 'V autobuse', 'Na nádraží']),
       q('q2', L('Kde si můžete klíče vyzvednout?', "Kalitlarni qayerdan olish mumkin?", 'Where can you collect the keys?',
                 'Где можно забрать ключи?', 'Де можна забрати ключі?', 'Bạn có thể nhận lại chìa khóa ở đâu?'),
         ['V kavárně Lípa', 'Na policii', 'Na obecním úřadě', 'Ve škole']),
       q('q3', L('Co musíte říct, když si přijdete pro klíče?', "Kalitlarni olishga kelganda nimani aytishingiz kerak?", 'What must you say when you come for the keys?',
                 'Что нужно сказать, когда придёте за ключами?', 'Що треба сказати, коли прийдете по ключі?', 'Bạn phải nói gì khi đến nhận chìa khóa?'),
         ['Kolik klíčů je na kroužku', 'Svoje telefonní číslo', 'Kde bydlíte', 'Jakou barvu má vaše auto'])]),

    T('own-a2r-016', L('Půjčovna kol', 'Velosiped ijarasi', 'Bike rental', 'Прокат велосипедов', 'Прокат велосипедів', 'Cho thuê xe đạp'),
      'PŮJČOVNA KOL U ŘEKY\n\nOtevřeno: duben–říjen, denně 9:00–19:00\n\n'
      'Městské kolo: 1 hodina 80 Kč, celý den 350 Kč\nElektrokolo: 1 hodina 150 Kč, celý den 600 Kč\nDětská sedačka: zdarma\n\n'
      'Při půjčení potřebujete občanský průkaz nebo pas. Helmu dostanete s kolem.',
      [q('q1', L('Kolik stojí elektrokolo na celý den?', "Elektr velosiped bir kunga qancha turadi?", 'How much is an e-bike for a whole day?',
                 'Сколько стоит электровелосипед на целый день?', 'Скільки коштує електровелосипед на цілий день?', 'Thuê xe đạp điện cả ngày giá bao nhiêu?'),
         ['600 Kč', '150 Kč', '350 Kč', '80 Kč']),
       q('q2', L('Co potřebujete, když si chcete půjčit kolo?', "Velosiped olish uchun nima kerak?", 'What do you need to rent a bike?',
                 'Что нужно, чтобы взять велосипед напрокат?', 'Що потрібно, щоб узяти велосипед напрокат?', 'Bạn cần gì để thuê xe đạp?'),
         ['Doklad totožnosti', 'Vlastní helmu', 'Fotografii', 'Kreditní kartu']),
       q('q3', L('Kdy je půjčovna zavřená?', "Ijara punkti qachon yopiq?", 'When is the rental shop closed?',
                 'Когда прокат закрыт?', 'Коли прокат зачинений?', 'Khi nào cửa hàng cho thuê đóng cửa?'),
         ['V zimě', 'V neděli', 'V létě', 'Každé ráno'])]),

    T('own-a2r-017', L('Sousedská slavnost', "Qo'shnilar bayrami", 'Neighbourhood party', 'Соседский праздник', 'Сусідське свято', 'Tiệc hàng xóm'),
      'Milí sousedé,\n\nzveme vás na sousedskou slavnost na dvoře našeho domu v sobotu 7. června od 15 hodin.\n'
      'Připravíme gril a limonádu. Budeme rádi, když přinesete něco malého k jídlu, třeba salát nebo koláč.\n'
      'Pro děti bude malování na obličej. Pokud bude pršet, slavnost bude ve společenské místnosti v přízemí.\n\nVýbor domu',
      [q('q1', L('Kde bude slavnost, když bude hezké počasí?', "Havo yaxshi bo'lsa, bayram qayerda bo'ladi?", 'Where will the party be if the weather is nice?',
                 'Где будет праздник, если погода будет хорошей?', 'Де буде свято, якщо погода буде гарна?', 'Nếu trời đẹp, bữa tiệc tổ chức ở đâu?'),
         ['Na dvoře domu', 'V restauraci', 'V parku', 'Ve škole']),
       q('q2', L('Co mají sousedé přinést?', "Qo'shnilar nima olib kelishi kerak?", 'What should the neighbours bring?',
                 'Что должны принести соседи?', 'Що мають принести сусіди?', 'Hàng xóm nên mang gì?'),
         ['Něco malého k jídlu', 'Gril', 'Limonádu', 'Židle']),
       q('q3', L('Co bude pro děti?', "Bolalar uchun nima bo'ladi?", 'What will there be for children?',
                 'Что будет для детей?', 'Що буде для дітей?', 'Có gì dành cho trẻ em?'),
         ['Malování na obličej', 'Divadlo', 'Kino', 'Plavání'])]),

    T('own-a2r-018', L('Nabídka práce', 'Ish taklifi', 'Job offer', 'Предложение работы', 'Пропозиція роботи', 'Tin tuyển dụng'),
      'HLEDÁME SKLADNÍKA / SKLADNICI\n\nSklad nábytku v Kolíně hledá nového kolegu nebo kolegyni.\n'
      'Práce: příjem a kontrola zboží, práce na počítači.\nNabízíme: práci na plný úvazek, ranní směny 6:00–14:30, obědy zdarma, 5 týdnů dovolené.\n'
      'Požadujeme: češtinu na úrovni A2, řidičský průkaz na vysokozdvižný vozík je výhodou.\n\nŽivotopis pošlete do 30. září na prace@sklad-kolin.cz.',
      [q('q1', L('Jaké směny nabízí firma?', "Kompaniya qanday smenalarni taklif qiladi?", 'What shifts does the company offer?',
                 'Какие смены предлагает компания?', 'Які зміни пропонує компанія?', 'Công ty có ca làm việc nào?'),
         ['Ranní', 'Noční', 'Odpolední', 'Víkendové']),
       q('q2', L('Co je pro práci nutné?', "Bu ish uchun nima shart?", 'What is required for the job?',
                 'Что обязательно для этой работы?', 'Що обов’язково для цієї роботи?', 'Công việc này bắt buộc yêu cầu gì?'),
         ['Čeština na úrovni A2', 'Řidičský průkaz na vozík', 'Vysoká škola', 'Angličtina']),
       q('q3', L('Do kdy se musíte přihlásit?', "Qachongacha ariza berish kerak?", 'By when must you apply?',
                 'До какого числа нужно подать заявку?', 'До якого числа потрібно подати заявку?', 'Bạn phải nộp hồ sơ trước ngày nào?'),
         ['Do 30. září', 'Do konce roku', 'Do pondělí', 'Do 6:00'])]),

    T('own-a2r-019', L('Třídní schůzka', "Ota-onalar majlisi", "Parents' meeting", 'Родительское собрание', 'Батьківські збори', 'Họp phụ huynh'),
      'Vážení rodiče,\n\nzveme vás na třídní schůzku třídy 3. B ve středu 18. listopadu v 17:00 v učebně č. 21.\n'
      'Budeme mluvit o výletě do Olomouce a o vysvědčení. Výlet bude stát 450 Kč, peníze prosím pošlete do 1. prosince.\n'
      'Pokud nemůžete přijít, napište mi prosím zprávu přes školní aplikaci.\n\nS pozdravem\nMgr. Hana Dvořáková, třídní učitelka',
      [q('q1', L('Kde bude třídní schůzka?', "Majlis qayerda bo'ladi?", 'Where will the meeting be?',
                 'Где пройдёт собрание?', 'Де відбудуться збори?', 'Cuộc họp diễn ra ở đâu?'),
         ['V učebně č. 21', 'V tělocvičně', 'V Olomouci', 'Online']),
       q('q2', L('Kolik stojí výlet?', "Sayohat qancha turadi?", 'How much does the trip cost?',
                 'Сколько стоит поездка?', 'Скільки коштує поїздка?', 'Chuyến đi giá bao nhiêu?'),
         ['450 Kč', '21 Kč', '1 800 Kč', 'Je zdarma']),
       q('q3', L('Co mají udělat rodiče, kteří nemohou přijít?', "Kela olmaydigan ota-onalar nima qilishi kerak?", 'What should parents who cannot come do?',
                 'Что должны сделать родители, которые не могут прийти?', 'Що мають зробити батьки, які не можуть прийти?', 'Phụ huynh không đến được thì làm gì?'),
         ['Napsat zprávu přes aplikaci', 'Zavolat řediteli', 'Poslat peníze', 'Přijít v sobotu'])]),

    T('own-a2r-020', L('Prádelna v domě', 'Uydagi kir yuvish xonasi', 'Laundry room rules', 'Прачечная в доме', 'Пральня в будинку', 'Phòng giặt chung'),
      'PRAVIDLA PRÁDELNY\n\n1. Pračku si rezervujte na papíře na dveřích.\n2. Prát můžete od 7:00 do 21:00.\n'
      '3. Po praní vyčistěte filtr a nechte dvířka pračky otevřená.\n4. Prádlo si odneste nejpozději do 2 hodin.\n\nKlíč od prádelny je u paní Jelínkové, byt č. 4.',
      [q('q1', L('Jak si rezervujete pračku?', "Kir yuvish mashinasini qanday band qilasiz?", 'How do you book the washing machine?',
                 'Как забронировать стиральную машину?', 'Як забронювати пральну машину?', 'Làm thế nào để đặt máy giặt?'),
         ['Na papíře na dveřích', 'Telefonem', 'E-mailem', 'U správce v kanceláři']),
       q('q2', L('Co musíte udělat po praní?', "Kir yuvgandan keyin nima qilish kerak?", 'What must you do after washing?',
                 'Что нужно сделать после стирки?', 'Що потрібно зробити після прання?', 'Bạn phải làm gì sau khi giặt?'),
         ['Vyčistit filtr', 'Zavřít okno', 'Zaplatit', 'Vypnout světlo v celém domě']),
       q('q3', L('Kde je klíč od prádelny?', "Kir yuvish xonasining kaliti qayerda?", 'Where is the laundry room key?',
                 'Где ключ от прачечной?', 'Де ключ від пральні?', 'Chìa khóa phòng giặt ở đâu?'),
         ['U paní Jelínkové', 'Na dveřích', 'U pračky', 'Na obecním úřadě'])]),

    T('own-a2r-021', L('Zpráva o balíku', "Posilka haqida xabar", 'Parcel notification', 'Сообщение о посылке', 'Повідомлення про посилку', 'Thông báo bưu kiện'),
      'Váš balík č. 4471 je připraven na výdejním místě v trafice Na Rohu, Husova 5.\n'
      'Vyzvedněte si ho do pátku do 18:00. Při vyzvednutí řekněte kód 2859.\nPokud si balík nevyzvednete, vrátí se odesílateli.',
      [q('q1', L('Kde je balík?', "Posilka qayerda?", 'Where is the parcel?',
                 'Где посылка?', 'Де посилка?', 'Bưu kiện đang ở đâu?'),
         ['V trafice Na Rohu', 'Na poště', 'Doma u souseda', 'U odesílatele']),
       q('q2', L('Co musíte říct při vyzvednutí?', "Olishda nimani aytishingiz kerak?", 'What must you say when collecting it?',
                 'Что нужно сказать при получении?', 'Що треба сказати при отриманні?', 'Bạn phải nói gì khi nhận hàng?'),
         ['Kód 2859', 'Číslo domu', 'Svoje rodné číslo', 'Číslo účtu']),
       q('q3', L('Co se stane, když si balík nevyzvednete?', "Posilkani olmasangiz nima bo'ladi?", 'What happens if you do not collect the parcel?',
                 'Что будет, если не забрать посылку?', 'Що станеться, якщо не забрати посилку?', 'Nếu không nhận bưu kiện thì sao?'),
         ['Vrátí se odesílateli', 'Přivezou ho domů', 'Zaplatíte pokutu', 'Zůstane tam měsíc'])]),

    T('own-a2r-022', L('Veterinární ordinace', 'Veterinariya klinikasi', "Vet's surgery", 'Ветеринарная клиника', 'Ветеринарна клініка', 'Phòng khám thú y'),
      'VETERINÁRNÍ ORDINACE MUDr. VET. TOMÁŠ KRAUS\n\nOčkování psů proti vzteklině: sobota 21. března, 8:00–11:00, na návsi u hasičské zbrojnice.\n'
      'Cena: 250 Kč. Přineste očkovací průkaz psa.\nPes musí mít vodítko a náhubek.\n\nBěžné ordinační hodiny: Po–Pá 14:00–18:00.',
      [q('q1', L('Kde bude očkování psů?', "Itlarni emlash qayerda bo'ladi?", 'Where will the dogs be vaccinated?',
                 'Где будут прививать собак?', 'Де щеплюватимуть собак?', 'Tiêm phòng cho chó diễn ra ở đâu?'),
         ['Na návsi u hasičské zbrojnice', 'V ordinaci', 'Ve škole', 'V parku u řeky']),
       q('q2', L('Co musíte přinést?', "Nima olib kelishingiz kerak?", 'What must you bring?',
                 'Что нужно принести?', 'Що потрібно принести?', 'Bạn phải mang theo gì?'),
         ['Očkovací průkaz psa', 'Fotografii psa', 'Krmení', 'Pas majitele']),
       q('q3', L('Kdy jsou běžné ordinační hodiny?', "Odatdagi qabul vaqti qachon?", 'When are the usual surgery hours?',
                 'Когда обычные часы приёма?', 'Коли звичайні години прийому?', 'Giờ khám thông thường là khi nào?'),
         ['Ve všední dny odpoledne', 'Jen v sobotu', 'Každý den ráno', 'V neděli'])]),

    T('own-a2r-023', L('Program kina', 'Kino dasturi', 'Cinema programme', 'Программа кинотеатра', 'Програма кінотеатру', 'Lịch chiếu phim'),
      'KINO SVĚT – PROGRAM NA VÍKEND\n\nPátek 19:30 – Cesta domů (česká komedie)\nSobota 15:00 – Malý drak (pohádka pro děti, česky)\n'
      'Sobota 20:00 – Noc v horách (thriller, anglicky s českými titulky)\nNeděle 17:00 – Cesta domů\n\nVstupné: dospělí 180 Kč, děti do 12 let 110 Kč. Ve středu je vstupné pro všechny 120 Kč.',
      [q('q1', L('Kdy můžete vidět pohádku pro děti?', "Bolalar ertagini qachon ko'rish mumkin?", "When can you see the children's film?",
                 'Когда можно посмотреть детскую сказку?', 'Коли можна подивитися дитячу казку?', 'Khi nào có thể xem phim cổ tích cho trẻ em?'),
         ['V sobotu v 15:00', 'V pátek v 19:30', 'V neděli v 17:00', 'V sobotu ve 20:00']),
       q('q2', L('Ve kterém jazyce je film Noc v horách?', "«Noc v horách» filmi qaysi tilda?", 'In which language is the film Noc v horách?',
                 'На каком языке фильм «Ночь в горах»?', 'Якою мовою фільм «Ніч у горах»?', 'Phim Noc v horách bằng tiếng gì?'),
         ['V angličtině s titulky', 'V češtině', 'V němčině', 'Bez zvuku']),
       q('q3', L('Kolik zaplatí dítě (8 let) v sobotu?', "8 yoshli bola shanba kuni qancha to'laydi?", 'How much does an 8-year-old child pay on Saturday?',
                 'Сколько заплатит ребёнок 8 лет в субботу?', 'Скільки заплатить 8-річна дитина в суботу?', 'Trẻ 8 tuổi trả bao nhiêu vào thứ Bảy?'),
         ['110 Kč', '180 Kč', '120 Kč', 'Nic'])]),

    T('own-a2r-024', L('Hledáme hlídání', 'Enaga kerak', 'Babysitter wanted', 'Ищем няню', 'Шукаємо няню', 'Cần người trông trẻ'),
      'HLEDÁME HLÍDÁNÍ\n\nJsme rodina se dvěma dětmi (4 a 7 let) a hledáme paní nebo slečnu na hlídání.\n'
      'Kdy: úterý a čtvrtek od 15:00 do 18:00. Práce: vyzvednout děti ze školky a ze školy, jít s nimi na hřiště a připravit svačinu.\n'
      'Platíme 200 Kč za hodinu. Bydlíme v Praze 6, blízko metra Dejvická.\n\nVolejte prosím večer: 731 000 000 (Marie).',
      [q('q1', L('Kolik je dětí v rodině?', "Oilada nechta bola bor?", 'How many children are in the family?',
                 'Сколько детей в семье?', 'Скільки дітей у родині?', 'Gia đình có mấy con?'),
         ['Dvě', 'Jedno', 'Tři', 'Čtyři']),
       q('q2', L('Co bude chůva dělat?', "Enaga nima qiladi?", 'What will the babysitter do?',
                 'Что будет делать няня?', 'Що робитиме няня?', 'Người trông trẻ sẽ làm gì?'),
         ['Vyzvedávat děti a připravovat svačinu', 'Uklízet celý byt', 'Vařit večeři pro celou rodinu', 'Učit děti angličtinu']),
       q('q3', L('Kdy máte volat?', "Qachon qo'ng'iroq qilishingiz kerak?", 'When should you call?',
                 'Когда нужно звонить?', 'Коли треба телефонувати?', 'Bạn nên gọi khi nào?'),
         ['Večer', 'Ráno', 'V poledne', 'Jen v úterý'])]),

    T('own-a2r-025', L('Firemní večírek', 'Korporativ kecha', 'Company party', 'Корпоратив', 'Корпоратив', 'Tiệc công ty'),
      'Milé kolegyně, milí kolegové,\n\nletošní firemní večírek bude v pátek 12. prosince od 18:00 v restauraci Modrý dům, Náměstí Míru 3.\n'
      'Večeře a nápoje platí firma. Můžete přijít s partnerem nebo partnerkou.\nProsím, napište mi do 1. prosince, jestli přijdete a jestli chcete vegetariánské jídlo.\n\nDěkuji\nPetra Malá, personální oddělení',
      [q('q1', L('Kdo platí večeři?', "Kechki ovqat uchun kim to'laydi?", 'Who pays for the dinner?',
                 'Кто платит за ужин?', 'Хто платить за вечерю?', 'Ai trả tiền bữa tối?'),
         ['Firma', 'Každý sám', 'Personální oddělení ze svých peněz', 'Restaurace']),
       q('q2', L('S kým můžou zaměstnanci přijít?', "Xodimlar kim bilan kelishi mumkin?", 'Who can the employees bring?',
                 'С кем могут прийти сотрудники?', 'З ким можуть прийти працівники?', 'Nhân viên có thể dẫn ai theo?'),
         ['S partnerem nebo partnerkou', 'S dětmi', 'Se zákazníky', 'S nikým']),
       q('q3', L('Co mají zaměstnanci napsat do 1. prosince?', "Xodimlar 1-dekabrgacha nimani yozishi kerak?", 'What should employees write by 1 December?',
                 'Что сотрудники должны написать до 1 декабря?', 'Що працівники мають написати до 1 грудня?', 'Nhân viên cần báo gì trước ngày 1/12?'),
         ['Jestli přijdou a jaké jídlo chtějí', 'Jakou hudbu chtějí', 'Kolik peněz dají', 'Svoji adresu'])]),
]
