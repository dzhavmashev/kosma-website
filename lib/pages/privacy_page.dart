import 'package:flutter/material.dart';

import '../i18n.dart';
import '../widgets/block.dart';

/// Политика конфиденциальности сканера (заглушка; текст перенесём из
/// scaner-main/docs/site/scanner/privacy/index.html).
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key, required this.lang});
  final Lang lang;

  @override
  Widget build(BuildContext context) {
    final s = S(lang);
    final t = Theme.of(context).textTheme;
    return Band(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kosma ${s.scanner} — ${s.privacy}', style: t.headlineLarge),
            const SizedBox(height: 12),
            Text(s.draft, style: t.bodySmall),
          ],
        ),
      ),
    );
  }
}
