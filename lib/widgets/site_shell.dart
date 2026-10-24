import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../i18n.dart';
import '../theme/tokens.dart';
import 'block.dart';
import 'page_scope.dart';

/// Общий каркас всех страниц kosma.tech: шапка (знак, продукты, RU/EN), контент, футер,
/// кнопка «наверх». Владеет прокруткой страницы — блоки и кнопки берут её из [PageScope].
class SiteShell extends StatefulWidget {
  const SiteShell({super.key, required this.lang, required this.path, required this.child});

  final Lang lang;

  /// Путь текущей страницы без языкового префикса — для переключателя языка.
  final String path;
  final Widget child;

  @override
  State<SiteShell> createState() => _SiteShellState();
}

class _SiteShellState extends State<SiteShell> {
  final _controller = ScrollController();
  final _footerKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageScope(
    controller: _controller,
    footerKey: _footerKey,
    child: Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _controller,
            slivers: [
              SliverToBoxAdapter(child: _Header(lang: widget.lang, path: widget.path)),
              SliverToBoxAdapter(child: widget.child),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: KeyedSubtree(key: _footerKey, child: _Footer(lang: widget.lang)),
                ),
              ),
            ],
          ),
          UpButton(lang: widget.lang),
        ],
      ),
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
    final narrow = MediaQuery.sizeOf(context).width < 760;
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: K.line))),
      child: Band(
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
                const SizedBox(width: 4),
                TextButton(onPressed: null, child: Text('${s.hr} · ${s.soon}')),
                const SizedBox(width: 16),
              ] else
                PopupMenuButton<String>(
                  tooltip: s.menu,
                  icon: const Icon(Icons.menu_rounded),
                  color: K.surface,
                  onSelected: (_) => context.go(lang.href('/scanner')),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'scanner', child: Text(s.scanner)),
                    PopupMenuItem(enabled: false, child: Text('${s.warehouse} · ${s.soon}')),
                    PopupMenuItem(enabled: false, child: Text('${s.hr} · ${s.soon}')),
                  ],
                ),
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
    final t = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: const BoxDecoration(color: K.surfaceDeep, border: Border(top: BorderSide(color: K.line))),
      child: Band(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Wrap(
            spacing: 56,
            runSpacing: 28,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('KOSMA', style: TextStyle(fontFamily: K.display, fontSize: 18, letterSpacing: 5.4)),
                  const SizedBox(height: 10),
                  Text(s.sloganBoth, style: t.bodySmall),
                  if (kContactEmail.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    SelectableText(kContactEmail, style: t.bodySmall),
                  ],
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.products, style: t.bodySmall),
                  const SizedBox(height: 8),
                  InkWell(onTap: () => context.go(lang.href('/scanner')), child: Text(s.scanner, style: t.bodyMedium?.copyWith(color: K.lavender300))),
                  const SizedBox(height: 6),
                  Text('${s.warehouse} · ${s.soon}', style: t.bodyMedium?.copyWith(color: K.neutral600)),
                  const SizedBox(height: 6),
                  Text('${s.hr} · ${s.soon}', style: t.bodyMedium?.copyWith(color: K.neutral600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.documents, style: t.bodySmall),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => context.go(lang.href('/scanner/privacy')),
                    child: Text(s.privacyScanner, style: t.bodyMedium?.copyWith(color: K.lavender300)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
