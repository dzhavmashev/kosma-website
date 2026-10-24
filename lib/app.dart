import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router.dart';
import 'theme/tokens.dart';

class KosmaSite extends StatefulWidget {
  const KosmaSite({super.key, this.initialLocation});

  /// Для тестов: стартовый адрес вместо адреса браузера.
  final String? initialLocation;

  @override
  State<KosmaSite> createState() => _KosmaSiteState();
}

class _KosmaSiteState extends State<KosmaSite> {
  late final GoRouter _router = buildRouter(initialLocation: widget.initialLocation);

  @override
  void dispose() {
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
