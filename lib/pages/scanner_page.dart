import 'package:flutter/material.dart';

import '../i18n.dart';
import '../theme/tokens.dart';
import '../widgets/block.dart';
import '../widgets/phone_frame.dart';
import '../widgets/scan_demo.dart';

/// Страница продукта «Kosma Сканер». Тексты утверждены по шагам (3а–3г, 4, 5) в документе
/// «Контент сайта kosma.tech»; тот же контент идёт в Google Play и App Store.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.lang});
  final Lang lang;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _hero = GlobalKey();
  final _how = GlobalKey();
  final _features = GlobalKey();
  final _plans = GlobalKey();
  final _shots = GlobalKey();
  final _faq = GlobalKey();
  final _download = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l = widget.lang;
    final t = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Title(
      title: l.tr('Kosma Сканер — сканер штрихкодов и QR для склада и ТСД', 'Kosma Scanner — barcode and QR scanner for warehouses and handheld terminals'),
      color: K.bg,
      child: Column(
        children: [
          PageBlock(
            lang: l,
            anchor: _hero,
            next: _how,
            grid: true,
            topLine: false,
            reveal: false,
            child: Flex(
              direction: wide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: wide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.tr('KOSMA СКАНЕР · ANDROID · iOS · ТСД', 'KOSMA SCANNER · ANDROID · iOS · RUGGED HANDHELDS'),
                        style: const TextStyle(fontFamily: K.mono, fontSize: 13, letterSpacing: 1.8, color: K.scan),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l.tr('Отсканировали — количество посчитано', 'Scan it — the count is done'),
                        style: t.displayLarge?.copyWith(fontSize: wide ? 68 : 40, height: 1.05),
                      ),
                      const SizedBox(height: 24),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: Text(
                          l.tr(
                            'Сканер штрихкодов и QR для склада, магазина и инвентаризации. Работает камерой телефона и встроенным сканером ТСД.',
                            'Barcode and QR scanner for warehouses, shops and stocktaking. Works with the phone camera and the built-in scanner of a handheld terminal.',
                          ),
                          style: t.bodyLarge?.copyWith(color: K.muted, fontSize: 19),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _StoreButton(label: l.tr('Скоро в Google Play', 'Coming soon to Google Play'), filled: true),
                          _StoreButton(label: l.tr('Скоро в App Store', 'Coming soon to App Store')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l.tr('Бесплатно — 3 сессии в месяц. Pro — по подписке.', 'Free — 3 sessions a month. Pro — by subscription.'),
                        style: t.bodySmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: wide ? 56 : 0, height: wide ? 0 : 40),
                ScanDemo(lang: l),
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _how,
            next: _features,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(l.tr('КАК РАБОТАЕТ', 'HOW IT WORKS')),
                const SizedBox(height: 12),
                SectionTitle(l.tr('Скан → количество → файл или ваша система', 'Scan → count → file or your system')),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    for (final (i, step) in _steps(l).indexed) _StepCard(number: '0${i + 1}', title: step.$1, text: step.$2),
                  ],
                ),
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _features,
            next: _plans,
            color: K.surfaceDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(l.tr('ФУНКЦИИ', 'FEATURES')),
                const SizedBox(height: 12),
                SectionTitle(l.tr('Для склада, магазина и ТСД', 'For warehouses, shops and handheld terminals')),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [for (final f in _features_(l)) _FeatureCard(tag: f.$1, title: f.$2, text: f.$3)],
                ),
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _plans,
            next: _shots,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(l.tr('ТАРИФЫ', 'PLANS')),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _PlanCard(
                      title: l.tr('Free — бесплатно', 'Free'),
                      lines: l.tr(
                        '3 сессии в месяц, сброс 1-го числа. Ещё одну можно получить за короткий ролик, не чаще раза в день.|Сканы и время работы не ограничены.|Справочник до 500 товаров, экспорт CSV, ячейки хранения.|С рекламой.',
                        '3 sessions a month, reset on the 1st. One more can be earned with a short video, once a day at most.|Scans and session time are not limited.|Catalog up to 500 items, CSV export, storage cells.|With ads.',
                      ).split('|'),
                    ),
                    _PlanCard(
                      pro: true,
                      title: l.tr('Pro — по подписке', 'Pro — by subscription'),
                      lines: l.tr(
                        r'$9.99 в месяц или $59.99 в год.|В Казахстане, Кыргызстане, Узбекистане, Таджикистане, Армении, Азербайджане, Молдове и Грузии — $3.99 в месяц или $24.99 в год.|Без лимита сессий и без рекламы, справочник без ограничений.|План / факт, XLSX, письмо на заданный адрес, Google Таблица, отправка в ваш API с curl, объединение сессий.',
                        r'$9.99 a month or $59.99 a year.|In Kazakhstan, Kyrgyzstan, Uzbekistan, Tajikistan, Armenia, Azerbaijan, Moldova and Georgia — $3.99 a month or $24.99 a year.|No session limit, no ads, unlimited catalog.|Plan / fact, XLSX, e-mail to a set address, Google Sheets, sending to your API with curl, merging sessions.',
                      ).split('|'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l.tr(
                    'Пробный период 7 дней. Отмена в любой момент в магазине приложений. Цену в вашей стране показывает магазин.',
                    'A 7-day trial. Cancel any time in the app store. The store shows the price in your country.',
                  ),
                  style: t.bodySmall,
                ),
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _shots,
            next: _faq,
            color: K.surfaceDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel(l.tr('СКРИНШОТЫ', 'SCREENSHOTS')),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 20,
                  runSpacing: 28,
                  children: [
                    for (final s in _shots_(l))
                      SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PhoneFrame(asset: 'assets/shots/${s.$1}-${l.name}.png', label: s.$2, width: 200),
                            const SizedBox(height: 12),
                            Text(s.$2, style: t.bodyMedium),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(l.tr('Адреса и данные на экранах — примеры.', 'Addresses and data on the screens are examples.'), style: t.bodySmall),
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _faq,
            next: _download,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(l.tr('Вопросы и ответы', 'Questions and answers')),
                const SizedBox(height: 32),
                for (final q in _faq_(l))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.$1, style: t.titleMedium?.copyWith(fontSize: 18)),
                          const SizedBox(height: 6),
                          Text(q.$2, style: t.bodyMedium?.copyWith(color: K.muted)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _download,
            color: K.surfaceDeep,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(l.tr('Скачать', 'Download')),
                const SizedBox(height: 20),
                // Ссылку на Google Play подставим после публикации приложения.
                Text(l.tr('Google Play · [ссылка после публикации]', 'Google Play · [link after publication]'), style: t.bodyLarge),
                const SizedBox(height: 6),
                Text(l.tr('App Store · скоро', 'App Store · coming soon'), style: t.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<(String, String)> _steps(Lang l) => [
  (
    l.tr('Сканируйте.', 'Scan.'),
    l.tr(
      'Камера телефона, кнопка сканера ТСД или внешний Bluetooth-сканер в режиме клавиатуры. На каждый скан — бип и вибро, их можно отключить.',
      "Phone camera, the terminal's scan key or an external Bluetooth scanner in keyboard mode. Every scan gives a beep and vibration; both can be turned off.",
    ),
  ),
  (
    l.tr('Количество считается само.', 'The count adds itself.'),
    l.tr(
      'В суммирующем режиме повторный скан увеличивает количество, коробки вводятся как ×N. В поштучном каждый скан — отдельная строка со временем. Количество можно поправить вручную, последний скан — отменить, код или название — найти поиском.',
      'In summing mode a repeat scan raises the count and boxes are entered as ×N. In one-by-one mode each scan is a row with its time. You can correct the count by hand, undo the last scan and search by code or name.',
    ),
  ),
  (
    l.tr('Файл или ваша система.', 'A file or your system.'),
    l.tr(
      'CSV — бесплатно. XLSX, письмо на заданный адрес, Google Таблица и отправка JSON в ваш API — в Pro.',
      'CSV is free. XLSX, e-mail to a set address, Google Sheets and JSON to your API are in Pro.',
    ),
  ),
];

List<(String, String, String)> _features_(Lang l) => [
  (
    l.tr('ТСД', 'TERMINAL'),
    l.tr('Встроенный сканер терминала', 'Built-in terminal scanner'),
    l.tr(
      'Код приходит по нажатию кнопки сканера, камера не нужна. Honeywell, Zebra, Urovo, Newland, Chainway, Sunmi.',
      'The code arrives when you press the scan key, no camera needed. Honeywell, Zebra, Urovo, Newland, Chainway, Sunmi.',
    ),
  ),
  (
    l.tr('КАМЕРА', 'CAMERA'),
    l.tr('Камера телефона', 'Phone camera'),
    l.tr(
      'EAN-13, EAN-8, UPC-A, UPC-E, QR, DataMatrix, Code 128 и другие форматы. Фонарик и подсказка включить его, когда темно.',
      'EAN-13, EAN-8, UPC-A, UPC-E, QR, DataMatrix, Code 128 and other formats. A flashlight, and a hint to turn it on when it is dark.',
    ),
  ),
  (
    l.tr('СПРАВОЧНИК', 'CATALOG'),
    l.tr('Названия вместо кодов', 'Names instead of codes'),
    l.tr(
      'Загрузите CSV или XLSX из 1С, Excel или Google Таблиц: колонки определяются сами, Windows-1251 читается. Во Free — до 500 товаров, в Pro — без ограничений.',
      'Load CSV or XLSX from 1C, Excel or Google Sheets: columns are detected automatically, Windows-1251 is read. Free — up to 500 items, Pro — unlimited.',
    ),
  ),
  (
    l.tr('ПЛАН / ФАКТ · PRO', 'PLAN / FACT · PRO'),
    l.tr('Инвентаризация по заданию', 'Stocktaking against a task'),
    l.tr(
      'Загрузите файл с кодами и количествами: после пересчёта видны недостача, излишки и коды не из задания. Расхождения можно выгрузить.',
      'Load a file with codes and quantities: after the count you see shortages, surpluses and codes not in the task. The differences can be exported.',
    ),
  ),
  (
    l.tr('МАРКИРОВКА', 'MARKING'),
    l.tr('GS1 и «Честный знак»', 'GS1 and “Chestny Znak”'),
    l.tr(
      'Расшифровывает данные кода: GTIN, серию, партию, срок годности, дату производства. В поштучном режиме предупреждает, если код уже был в сессии.',
      'Decodes the code data: GTIN, serial number, batch, expiry date, production date. In one-by-one mode it warns if the code was already in the session.',
    ),
  ),
  (
    l.tr('ЯЧЕЙКИ', 'CELLS'),
    l.tr('Привязка к месту хранения', 'Tied to a storage place'),
    l.tr(
      'Отсканируйте штрихкод ячейки — следующие товары попадут в неё. В экспорте появится колонка «Ячейка».',
      'Scan the cell barcode — the next items go into it. The export gets a “Cell” column.',
    ),
  ),
  (
    l.tr('ОБЪЕДИНЕНИЕ · PRO', 'MERGE · PRO'),
    l.tr('Несколько устройств — одна сессия', 'Several devices, one session'),
    l.tr(
      'Добавьте в сессию файл экспорта с другого устройства: количество одинаковых кодов в одной ячейке складывается.',
      'Add an export file from another device to the session: quantities of identical codes in one cell are summed.',
    ),
  ),
  (
    l.tr('ОТКЛИК', 'FEEDBACK'),
    l.tr('Слышно и чувствуется', 'Heard and felt'),
    l.tr(
      'Бип на скан, двойной на повтор, низкий на ошибку. Вибро — отдельным переключателем.',
      'A beep on scan, a double beep on a repeat, a low one on an error. Vibration has its own switch.',
    ),
  ),
  (
    l.tr('ЭКСПОРТ', 'EXPORT'),
    l.tr('CSV, XLSX, письмо', 'CSV, XLSX, e-mail'),
    l.tr(
      'CSV с разделителем «;», «,» или Tab — бесплатно. XLSX и письмо на заданный адрес — в Pro. Файл можно отправить через «Поделиться» или сохранить в «Загрузки» (на iPhone — в «Файлы»).',
      'CSV with “;”, “,” or Tab separator — free. XLSX and e-mail to a set address — in Pro. Send the file via “Share” or save it to Downloads (on iPhone — to Files).',
    ),
  ),
  (
    l.tr('API · PRO', 'API · PRO'),
    l.tr('Отправка в вашу систему', 'Send to your system'),
    l.tr(
      'Адрес, метод POST или PUT, авторизация Bearer, Basic или API-ключ. Проверка соединения, готовая команда curl, JSON, повторная отправка без дублей, история отправок.',
      'Address, POST or PUT, Bearer, Basic or API-key authorization. Connection test, a ready curl command, JSON, resend without duplicates, send history.',
    ),
  ),
  (
    l.tr('ДАННЫЕ', 'DATA'),
    l.tr('Сканы — на устройстве', 'Scans stay on the device'),
    l.tr(
      'Каждый скан записывается в память устройства сразу. Сканы не отправляются на серверы Kosma; в Pro они уходят только на адрес, который вы указали.',
      'Every scan is written to device memory at once. Scans are not sent to Kosma servers; in Pro they go only to the address you set.',
    ),
  ),
  (
    l.tr('ИНТЕРФЕЙС', 'INTERFACE'),
    l.tr('Тёмная и светлая темы', 'Dark and light themes'),
    l.tr(
      'Крупные кнопки для работы в перчатках, русский и English, вертикальная ориентация.',
      'Large buttons for work in gloves, Russian and English, portrait orientation.',
    ),
  ),
];

List<(String, String)> _shots_(Lang l) => [
  ('sessions', l.tr('Приёмка, отгрузка и инвентаризация — каждая своей сессией', 'Receiving, shipping and stocktaking — each in its own session')),
  ('summing', l.tr('Скан — и количество растёт', 'Scan — and the count grows')),
  ('tsd', l.tr('Сканер терминала готов — нажмите кнопку', 'Terminal scanner ready — press the key')),
  ('export', l.tr('CSV бесплатно, XLSX в Pro', 'CSV is free, XLSX in Pro')),
  ('api', l.tr('Отправка сессии в вашу систему', 'Send a session to your system')),
];

List<(String, String)> _faq_(Lang l) => [
  (
    l.tr('Какие ТСД поддерживаются?', 'Which terminals are supported?'),
    l.tr(
      'Honeywell, Zebra, Urovo, Newland, Chainway, Sunmi. На ТСД камера по умолчанию выключена, её можно включить кнопкой в сессии.',
      'Honeywell, Zebra, Urovo, Newland, Chainway, Sunmi. On a terminal the camera is off by default and can be turned on with a button in the session.',
    ),
  ),
  (
    l.tr('Чем Free отличается от Pro?', 'How is Free different from Pro?'),
    l.tr(
      'Free — 3 сессии в месяц и реклама, начатую сессию можно довести до конца. Pro добавляет XLSX, план / факт, отправку в вашу систему и убирает лимиты и рекламу.',
      'Free — 3 sessions a month and ads, a started session can be finished. Pro adds XLSX, plan / fact, sending to your system and removes limits and ads.',
    ),
  ),
  (
    l.tr('Куда уходят сканы?', 'Where do scans go?'),
    l.tr(
      'Сканы и справочник хранятся на устройстве. В Pro они отправляются только на адрес, который вы указали. Во Free приложение показывает рекламу, а отчёты о сбоях передаются — подробности в политике конфиденциальности.',
      'Scans and the catalog stay on the device. In Pro they are sent only to the address you set. In Free the app shows ads and sends crash reports — see the privacy policy.',
    ),
  ),
  (
    l.tr('Как отменить подписку?', 'How do I cancel the subscription?'),
    l.tr('В любой момент, в магазине приложений.', 'Any time, in the app store.'),
  ),
];

/// Кнопка магазина: пока приложение не опубликовано — не ссылка, а «скоро».
class _StoreButton extends StatelessWidget {
  const _StoreButton({required this.label, this.filled = false});
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    child: Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? K.text : null,
        borderRadius: BorderRadius.circular(12),
        border: filled ? null : Border.all(color: K.lineStrong),
      ),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: filled ? K.bg : K.text)),
    ),
  );
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.number, required this.title, required this.text});
  final String number;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 360,
      child: DecoratedBox(
        decoration: BoxDecoration(color: K.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: K.line)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(number, style: const TextStyle(fontFamily: K.mono, fontSize: 32, color: K.scan)),
              const SizedBox(height: 12),
              Text(title, style: t.titleMedium?.copyWith(fontSize: 19)),
              const SizedBox(height: 8),
              Text(text, style: t.bodySmall?.copyWith(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Карточка функции: метка одного цвета у всех карточек (лаванда).
class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.tag, required this.title, required this.text});
  final String tag;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 368,
      child: DecoratedBox(
        decoration: BoxDecoration(color: K.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: K.line)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tag, style: const TextStyle(fontFamily: K.mono, fontSize: 12, letterSpacing: 1.2, color: K.lavender300)),
              const SizedBox(height: 8),
              Text(title, style: t.titleMedium?.copyWith(fontSize: 18)),
              const SizedBox(height: 6),
              Text(text, style: t.bodySmall?.copyWith(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.title, required this.lines, this.pro = false});
  final String title;
  final List<String> lines;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 560,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: pro ? K.lavender700 : K.line),
          gradient: pro ? const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [K.lavender900, K.surface], stops: [0, 0.6]) : null,
          color: pro ? null : K.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t.headlineLarge),
              const SizedBox(height: 16),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(line, style: t.bodyMedium?.copyWith(color: pro ? K.lavender300 : K.muted)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
