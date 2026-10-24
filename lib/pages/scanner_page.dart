import 'package:flutter/material.dart';

import '../i18n.dart';

/// Страница продукта «Kosma Сканер» (заглушка каркаса; секции — по макету).
class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key, required this.lang});
  final Lang lang;

  @override
  Widget build(BuildContext context) {
    final s = S(lang);
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Kosma ${s.scanner}', style: t.displayMedium),
          const SizedBox(height: 12),
          Text(s.scannerTagline, style: t.bodyLarge),
          const SizedBox(height: 12),
          Text(s.draft, style: t.bodySmall),
        ],
      ),
    );
  }
}
