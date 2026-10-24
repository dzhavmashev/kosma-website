
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kosma_website/app.dart';
import 'package:kosma_website/i18n.dart';
import 'package:kosma_website/widgets/block.dart';

/// Экран 1440×900 и «уменьшить движение»: демо-анимации стоят, pumpAndSettle завершается.
void setUpDesktop(WidgetTester tester) {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
}

void main() {
  testWidgets('ru без префикса: главная → Сканер; переключатель EN ведёт на /en/scanner', (tester) async {
    setUpDesktop(tester);
    await tester.pumpWidget(const KosmaSite(initialLocation: '/'));
    await tester.pumpAndSettle();
    expect(find.text('Порядок во всём'), findsOneWidget);
    expect(find.textContaining('Умный дом'), findsNothing);
    expect(find.text('HR'), findsWidgets);

    await tester.tap(find.widgetWithText(TextButton, 'Сканер').first);
    await tester.pumpAndSettle();
    expect(find.text('Отсканировали — количество посчитано'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'EN'));
    await tester.pumpAndSettle();
    expect(find.text('Scan it — the count is done'), findsOneWidget);
  });

  testWidgets('en: /en/scanner/privacy и 404 на неизвестный путь', (tester) async {
    setUpDesktop(tester);
    await tester.pumpWidget(const KosmaSite(initialLocation: '/en/scanner/privacy'));
    await tester.pumpAndSettle();
    expect(find.text('Kosma Scanner — Privacy Policy'), findsOneWidget);
    expect(find.textContaining('Firebase Crashlytics'), findsWidgets);

    await tester.pumpWidget(const KosmaSite(key: ValueKey('404'), initialLocation: '/en/nope'));
    await tester.pumpAndSettle();
    expect(find.text('Page not found'), findsOneWidget);
  });

  testWidgets('Сканер: «к следующему блоку» прокручивает, «наверх» возвращает к началу', (tester) async {
    setUpDesktop(tester);
    await tester.pumpWidget(const KosmaSite(initialLocation: '/scanner'));
    await tester.pumpAndSettle();
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable).first);
    expect(scrollable.position.pixels, 0);
    expect(find.byIcon(Icons.arrow_upward_rounded).hitTestable(), findsNothing);

    // кнопка первого блока лежит ниже экрана 900 px — нажимаем её обработчик напрямую
    tester.widget<NextButton>(find.byType(NextButton).first).onTap();
    await tester.pumpAndSettle();
    expect(scrollable.position.pixels, greaterThan(300));

    await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
    await tester.pumpAndSettle();
    expect(scrollable.position.pixels, 0);
  });

  testWidgets('Сканер ru: утверждённые тексты — тарифы, FAQ, HR в футере', (tester) async {
    setUpDesktop(tester);
    await tester.pumpWidget(const KosmaSite(initialLocation: '/scanner'));
    await tester.pumpAndSettle();
    expect(find.text('Free — бесплатно'), findsOneWidget);
    expect(find.textContaining(r'$9.99 в месяц или $59.99 в год.'), findsOneWidget);
    expect(find.text('Как отменить подписку?'), findsOneWidget);
    expect(find.text('HR · скоро'), findsWidgets);
  });

  test('href: тот же путь в другом языке', () {
    expect(Lang.ru.href('/'), '/');
    expect(Lang.en.href('/'), '/en');
    expect(Lang.en.href('/scanner/privacy'), '/en/scanner/privacy');
    expect(Lang.ru.href('/scanner'), '/scanner');
  });
}
