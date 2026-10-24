import 'package:flutter/material.dart';

/// Прокрутка страницы, общая для шапки, блоков и кнопки «наверх»:
/// контроллер, ключ футера (цель «к следующему блоку» у последнего блока).
class PageScope extends InheritedWidget {
  const PageScope({super.key, required this.controller, required this.footerKey, required super.child});

  final ScrollController controller;
  final GlobalKey footerKey;

  static PageScope of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<PageScope>()!;

  @override
  bool updateShouldNotify(PageScope old) => controller != old.controller || footerKey != old.footerKey;
}

/// Плавно прокрутить к блоку; при системной настройке «уменьшить движение» — мгновенно.
Future<void> scrollToKey(BuildContext context, GlobalKey key) async {
  final target = key.currentContext;
  if (target == null) return;
  final reduce = MediaQuery.disableAnimationsOf(context);
  await Scrollable.ensureVisible(
    target,
    duration: reduce ? Duration.zero : const Duration(milliseconds: 700),
    curve: Curves.easeInOutCubic,
  );
}

/// Плавно вернуться наверх страницы.
Future<void> scrollToTop(BuildContext context) async {
  final c = PageScope.of(context).controller;
  if (!c.hasClients) return;
  final reduce = MediaQuery.disableAnimationsOf(context);
  if (reduce) {
    c.jumpTo(0);
    return;
  }
  await c.animateTo(0, duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic);
}
