import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n.dart';
import '../theme/tokens.dart';

/// Общий каркас всех страниц kosma.tech: шапка (знак, продукты, RU/EN), контент, футер.
class SiteShell extends StatelessWidget {
  const SiteShell({super.key, required this.lang, required this.path, required this.child});

  final Lang lang;

  /// Путь текущей страницы без языкового префикса — для переключателя языка.
  final String path;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Header(lang: lang, path: path)),
        SliverToBoxAdapter(child: _Constrained(child: child)),
        SliverFillRemaining(hasScrollBody: false, child: Align(alignment: Alignment.bottomCenter, child: _Footer(lang: lang))),
      ],
    ),
  );
}

class _Constrained extends StatelessWidget {
  const _Constrained({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: K.maxWidth),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: K.gutter), child: child),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.lang, required this.path});
  final Lang lang;
  final String path;

  @override
  Widget build(BuildContext context) {
    final s = S(lang);
    final narrow = MediaQuery.sizeOf(context).width < 640;
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: K.line))),
      child: _Constrained(
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              Semantics(
                link: true,
                label: 'Kosma',
                child: InkWell(
                  onTap: () => context.go(lang.href('/')),
                  child: Row(
                    children: [
                      Image.asset('assets/logo/kosma-mark-dark.png', width: 28, height: 28),
                      const SizedBox(width: 10),
                      const Text('KOSMA', style: TextStyle(fontFamily: K.display, fontSize: 18, letterSpacing: 5.4)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (!narrow) ...[
                TextButton(onPressed: () => context.go(lang.href('/scanner')), child: Text(s.scanner)),
                const SizedBox(width: 4),
                TextButton(onPressed: null, child: Text('${s.warehouse} · ${s.soon}')),
                const SizedBox(width: 16),
              ],
              _LangSwitch(lang: lang, path: path),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangSwitch extends StatelessWidget {
  const _LangSwitch({required this.lang, required this.path});
  final Lang lang;
  final String path;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final l in Lang.values)
        TextButton(
          // та же страница на другом языке
          onPressed: l == lang ? null : () => context.go(l.href(path)),
          child: Text(
            l.name.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w600, color: l == lang ? K.accent : K.muted),
          ),
        ),
    ],
  );
}

class _Footer extends StatelessWidget {
  const _Footer({required this.lang});
  final Lang lang;

  @override
  Widget build(BuildContext context) {
    final s = S(lang);
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: K.line))),
      child: _Constrained(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Wrap(
            spacing: 24,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('© Kosma · ${s.slogan}', style: Theme.of(context).textTheme.bodySmall),
              TextButton(onPressed: () => context.go(lang.href('/scanner')), child: Text(s.scanner)),
              TextButton(onPressed: () => context.go(lang.href('/scanner/privacy')), child: Text(s.privacy)),
            ],
          ),
        ),
      ),
    );
  }
}
