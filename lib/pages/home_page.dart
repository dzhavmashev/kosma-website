import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n.dart';
import '../theme/tokens.dart';

/// Корень kosma.tech: бренд и продукты (заглушка каркаса).
class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.lang});
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
          Text(s.slogan, style: t.displayLarge),
          const SizedBox(height: 12),
          Text(s.draft, style: t.bodySmall),
          const SizedBox(height: 48),
          Text(s.products.toUpperCase(), style: t.labelSmall),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ProductCard(title: s.scanner, subtitle: s.scannerTagline, onTap: () => context.go(lang.href('/scanner'))),
              _ProductCard(title: s.warehouse, subtitle: s.soon),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.title, required this.subtitle, this.onTap});
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 360,
    child: Material(
      color: K.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: K.line)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    ),
  );
}
