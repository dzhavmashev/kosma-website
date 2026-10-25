import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';
import 'theme/theme_store.dart';
import 'theme/tokens.dart';

class KosmaSite extends StatefulWidget {
  const KosmaSite({super.key, this.initialLocation});

  /// Для тестов: стартовый адрес вместо адреса браузера.
  final String? initialLocation;

  @override
  State<KosmaSite> createState() => _KosmaSiteState();
}

class _KosmaSiteState extends State<KosmaSite> {
  @override
  void initState() {
    super.initState();
    themeLight.value = loadLightPref() ?? false;
    themeLight.addListener(_onTheme);
  }

  /// Цвета K.* читаются при сборке, а не через Theme — поэтому при смене темы пересобираем
  /// всё дерево (состояние и прокрутка сохраняются).
  void _onTheme() {
    saveLightPref(themeLight.value);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      void rebuild(Element e) {
        e.markNeedsBuild();
        e.visitChildren(rebuild);
      }

      WidgetsBinding.instance.rootElement?.visitChildren(rebuild);
    });
  }

  late final GoRouter _router = buildRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  void dispose() {
    themeLight.removeListener(_onTheme);
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Kosma',
    debugShowCheckedModeBanner: false,
    theme: buildSiteTheme(),
    routerConfig: _router,
  );
}
