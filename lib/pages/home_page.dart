import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n.dart';
import '../theme/tokens.dart';
import '../widgets/block.dart';
import '../widgets/page_scope.dart';
import '../widgets/phone_frame.dart';

/// Корень kosma.tech: бренд, продукты (Сканер, Склад, HR), три направления, связь.
/// Тексты утверждены по шагам в документе «Контент сайта kosma.tech».
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.lang});
  final Lang lang;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _hero = GlobalKey();
  final _products = GlobalKey();
  final _directions = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l = widget.lang;
    final s = S(l);
    final t = Theme.of(context).textTheme;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Title(
      title: l.tr('Kosma — порядок во всём', 'Kosma — order in everything'),
      color: K.bg,
      child: Column(
        children: [
          PageBlock(
            lang: l,
            anchor: _hero,
            next: _products,
            grid: true,
            topLine: false,
            reveal: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('KOSMA.TECH', style: TextStyle(fontFamily: K.mono, fontSize: 13, letterSpacing: 1.8, color: K.accent)),
                      const SizedBox(height: 24),
                      Text(s.slogan, style: t.displayLarge?.copyWith(fontSize: wide ? 76 : 46, height: 1.04)),
                      const SizedBox(height: 24),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: Text(
                          l.tr(
                            'Kosma разрабатывает электронику и IoT-устройства, пишет программы на заказ и выпускает собственные продукты. Название — от греческого kosmos: «порядок» и «мироздание» в одном слове.',
                            'Kosma builds electronics and IoT devices, writes custom software and ships its own products. The name comes from the Greek kosmos: "order" and "universe" in one word.',
                          ),
                          style: t.bodyLarge?.copyWith(color: K.muted),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilledButton(
                            style: _bigButton,
                            onPressed: () => context.go(l.href('/scanner')),
                            child: Text(l.tr('Kosma Сканер →', 'Kosma Scanner →')),
                          ),
                          OutlinedButton(
                            style: _bigButton.copyWith(
                              foregroundColor: const WidgetStatePropertyAll(K.text),
                              side: const WidgetStatePropertyAll(BorderSide(color: K.lineStrong)),
                            ),
                            onPressed: () => scrollToKey(context, _products),
                            child: Text(l.tr('Все продукты', 'All products')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (wide) ...[
                  const SizedBox(width: 56),
                  Image.asset('assets/logo/kosma-mark-dark.png', width: 280, height: 280, semanticLabel: l.tr('Знак Kosma', 'Kosma mark')),
                ],
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _products,
            next: _directions,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(s.products),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _ScannerCard(lang: l, wide: wide),
                    _ComingCard(
                      tag: l.tr('02 · В РАЗРАБОТКЕ', '02 · IN DEVELOPMENT'),
                      title: s.warehouse,
                      text: l.tr(
                        'Складской учёт: номенклатура, приход, расход, перемещение, списание и инвентаризация.',
                        'Stock accounting: item catalog, receipts, issues, transfers, write-offs and stocktaking.',
                      ),
                    ),
                    _ComingCard(
                      tag: l.tr('03 · В ПЛАНАХ', '03 · PLANNED'),
                      title: s.hr,
                      text: l.tr(
                        'Приложение для работы с персоналом: сотрудники, отпуска, графики и другие кадровые задачи.',
                        'An app for working with staff: employees, leave, schedules and other HR tasks.',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PageBlock(
            lang: l,
            anchor: _directions,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(l.tr('Три направления', 'Three directions')),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _Direction(
                      title: l.tr('Электроника и IoT', 'Electronics and IoT'),
                      text: l.tr('Устройства: плата, прошивка, связь и серверная часть.', 'Devices: board, firmware, connectivity and server side.'),
                    ),
                    _Direction(
                      title: l.tr('Заказная разработка', 'Custom development'),
                      text: l.tr(
                        'Мобильные и веб-приложения, серверная часть и интеграции под задачу заказчика.',
                        "Mobile and web apps, back end and integrations built around the customer's task.",
                      ),
                    ),
                    _Direction(
                      title: l.tr('Собственные продукты', 'Own products'),
                      text: l.tr(
                        'Каждый продукт Kosma задуман так, чтобы работать сам по себе.',
                        'Every Kosma product is designed to work on its own.',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  l.tr('Заказная разработка и вопросы по продуктам', 'Custom development and product questions') +
                      (kContactEmail.isEmpty ? '' : ': $kContactEmail'),
                  style: t.bodyMedium?.copyWith(color: K.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final _bigButton = ButtonStyle(
  minimumSize: const WidgetStatePropertyAll(Size(0, 52)),
  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
);

/// Карточка Сканера: единственный готовый продукт, ведёт на его страницу.
class _ScannerCard extends StatelessWidget {
  const _ScannerCard({required this.lang, required this.wide});
  final Lang lang;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final l = lang;
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: wide ? 560 : double.infinity,
      child: Material(
        color: K.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: K.line)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.go(l.href('/scanner')),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.tr('01 · СКОРО В GOOGLE PLAY', '01 · COMING SOON TO GOOGLE PLAY'),
                        style: const TextStyle(fontFamily: K.mono, fontSize: 12, letterSpacing: 1.4, color: K.scan),
                      ),
                      const SizedBox(height: 12),
                      Text(l.tr('Kosma Сканер', 'Kosma Scanner'), style: t.headlineLarge),
                      const SizedBox(height: 12),
                      Text(
                        l.tr(
                          'Сканер штрихкодов и QR для склада, магазина и инвентаризации. Камера телефона или встроенный сканер ТСД, количество считается само, в конце — файл или отправка в вашу систему.',
                          'Barcode and QR scanner for warehouses, shops and stocktaking. Phone camera or the built-in scanner of a handheld terminal, the count adds itself, and at the end a file or a send to your system.',
                        ),
                        style: t.bodySmall?.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l.tr('Android · iOS · ТСД', 'Android · iOS · Handheld terminals'),
                        style: const TextStyle(fontFamily: K.mono, fontSize: 12, color: K.neutral500),
                      ),
                      const SizedBox(height: 16),
                      Text(l.tr('Подробнее →', 'Learn more →'), style: const TextStyle(fontWeight: FontWeight.w600, color: K.lavender300)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                PhoneFrame(
                  asset: 'assets/shots/sessions-${l.name}.png',
                  label: l.tr('Экран сессий', 'Sessions screen'),
                  width: 132,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Карточка будущего продукта: рамка приглушена, ссылки нет.
class _ComingCard extends StatelessWidget {
  const _ComingCard({required this.tag, required this.title, required this.text});
  final String tag;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 300,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: K.lineStrong)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tag, style: const TextStyle(fontFamily: K.mono, fontSize: 12, letterSpacing: 1.4, color: K.neutral500)),
              const SizedBox(height: 12),
              Text(title, style: t.headlineLarge?.copyWith(color: K.muted)),
              const SizedBox(height: 12),
              Text(text, style: t.bodySmall?.copyWith(fontSize: 15, color: K.neutral500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Direction extends StatelessWidget {
  const _Direction({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SizedBox(
      width: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.headlineMedium),
          const SizedBox(height: 10),
          Text(text, style: t.bodyMedium?.copyWith(color: K.muted)),
        ],
      ),
    );
  }
}
