import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n.dart';
import '../widgets/block.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, required this.lang});
  final Lang lang;

  @override
  Widget build(BuildContext context) {
    final s = S(lang);
    return Band(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('404', style: Theme.of(context).textTheme.displayLarge),
            Text(s.notFound, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(lang.href('/')),
              child: Text(s.toHome),
            ),
          ],
        ),
      ),
    );
  }
}
