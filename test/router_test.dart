import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosma_website/app.dart';
import 'package:kosma_website/i18n.dart';

void main() {
  testWidgets('ru без префикса: главная → Сканер; переключатель EN ведёт на /en/scanner', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const KosmaSite(initialLocation: '/'));
    await tester.pumpAndSettle();
    expect(find.text('Порядок во всём'), findsOneWidget);
    expect(find.textContaining('Умный дом'), findsNothing);

    await tester.tap(find.widgetWithText(TextButton, 'Сканер').first);
    await tester.pumpAndSettle();
    expect(find.text('Kosma Сканер'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'EN'));
    await tester.pumpAndSettle();
    expect(find.text('Kosma Scanner'), findsOneWidget);
  });

  testWidgets('en: /en/scanner/privacy и 404 на неизвестный путь', (tester) async {
    await tester.pumpWidget(const KosmaSite(initialLocation: '/en/scanner/privacy'));
    await tester.pumpAndSettle();
    expect(find.text('Kosma Scanner — Privacy policy'), findsOneWidget);

    await tester.pumpWidget(const KosmaSite(key: ValueKey('404'), initialLocation: '/en/nope'));
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);
  });

  test('href: тот же путь в другом языке', () {
    expect(Lang.ru.href('/'), '/');
    expect(Lang.en.href('/'), '/en');
    expect(Lang.en.href('/scanner/privacy'), '/en/scanner/privacy');
    expect(Lang.ru.href('/scanner'), '/scanner');
  });
}
