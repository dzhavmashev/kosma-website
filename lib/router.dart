import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'i18n.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
import 'pages/privacy_page.dart';
import 'pages/scanner_page.dart';
import 'widgets/site_shell.dart';

/// Страница сайта: путь без языкового префикса и её содержимое.
class SitePage {
  const SitePage(this.path, this.builder);
  final String path;
  final Widget Function(Lang lang) builder;
}

/// Все страницы. Умный дом на публичном сайте не показывается (/smart-home/ — отдельный
/// приватный сервис, его маршрутизирует Caddy мимо Flutter-сайта).
final sitePages = <SitePage>[
  SitePage('/', (l) => HomePage(lang: l)),
  SitePage('/scanner', (l) => ScannerPage(lang: l)),
  SitePage('/scanner/privacy', (l) => PrivacyPage(lang: l)),
];

GoRouter buildRouter({String? initialLocation}) => GoRouter(
  initialLocation: initialLocation,
  routes: [
    for (final lang in Lang.values)
      for (final page in sitePages)
        GoRoute(
          path: lang.href(page.path),
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: SiteShell(lang: lang, path: page.path, child: page.builder(lang)),
          ),
        ),
  ],
  errorBuilder: (context, state) {
    final lang = state.uri.path == '/en' || state.uri.path.startsWith('/en/') ? Lang.en : Lang.ru;
    return SiteShell(lang: lang, path: '/', child: NotFoundPage(lang: lang));
  },
);
