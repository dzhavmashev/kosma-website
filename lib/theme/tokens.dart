import 'package:flutter/material.dart';

/// Токены бренда Kosma (брендбук): лаванда, тёплые нейтральные, Jost — заголовки,
/// Golos Text — текст, JetBrains Mono — коды. Основная тема сайта — тёмная.
/// Светлая ли тема сейчас. Меняется переключателем в шапке (см. app.dart).
final themeLight = ValueNotifier<bool>(false);

abstract final class K {
  static const lavender300 = Color(0xFFBEBCFE);
  static const lavender500 = Color(0xFF8D7DF0);
  static const lavender600 = Color(0xFF6E5BD8);
  static const lavender700 = Color(0xFF5140A7);
  static const lavender900 = Color(0xFF27195E);
  static const neutral50 = Color(0xFFF3F1EC);
  static const neutral400 = Color(0xFFA09E9A);
  static const neutral500 = Color(0xFF7C7A76);
  static const neutral600 = Color(0xFF595B5E);
  static const neutral700 = Color(0xFF414246);
  static const neutral800 = Color(0xFF2A2B2E);
  static const neutral900 = Color(0xFF1E1F23);
  static const neutral950 = Color(0xFF121317);

  /// Тема сайта: тёмная по умолчанию (брендбук), светлая — переключателем в шапке.
  /// Семантические цвета читаются при сборке виджетов; смена темы перестраивает всё дерево.
  static bool get light => themeLight.value;

  static Color get bg => light ? neutral50 : neutral950;
  static Color get surface => light ? const Color(0xFFFFFFFF) : neutral900;
  static Color get line => light ? const Color(0xFFDCDAD6) : neutral800;
  static Color get text => light ? neutral950 : neutral50;
  static Color get muted => light ? neutral600 : neutral400;
  static Color get accent => light ? lavender600 : lavender500;

  /// Текст на акцентной кнопке.
  static Color get onAccent => light ? const Color(0xFFFFFFFF) : neutral950;

  /// Ссылки и метки лавандой: на тёмном — светлая лаванда, на светлом — тёмная (контраст).
  static Color get link => light ? lavender700 : lavender300;

  /// Мягкая лавандовая заливка (карточка Pro, наведение).
  static Color get accentSoft => light ? const Color(0xFFE4E0FA) : lavender900;

  /// Приглушённый текст третьего уровня (подписи, футер).
  static Color get subtle => neutral500;
  static Color get faint => light ? neutral500 : neutral600;

  /// Янтарь — «цвет скана» тёмной темы приложения: рамка, линия скана, счётчик.
  /// На светлом фоне — темнее, чтобы читался.
  static Color get scan =>
      light ? const Color(0xFFB57A00) : const Color(0xFFFFC21A);

  /// Янтарь поверх скриншотов приложения (они тёмные в любой теме сайта).
  static const scanOnScreen = Color(0xFFFFC21A);

  /// Более глубокая подложка (футер, чередующиеся блоки) и усиленная линия.
  static Color get surfaceDeep =>
      light ? const Color(0xFFEDEBE7) : const Color(0xFF0E0F12);
  static Color get lineStrong => light ? const Color(0xFFC3C1BD) : neutral700;

  static const display = 'Jost';
  static const body = 'GolosText';
  static const mono = 'JetBrainsMono';

  /// Максимальная ширина контента и боковые поля.
  static const maxWidth = 1200.0;
  static const gutter = 24.0;
}

ThemeData buildSiteTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: K.lavender600,
        brightness: K.light ? Brightness.light : Brightness.dark,
      ).copyWith(
        primary: K.accent,
        onPrimary: K.onAccent,
        surface: K.bg,
        onSurface: K.text,
      );
  TextStyle display(double size, [FontWeight w = FontWeight.w400]) => TextStyle(
    fontFamily: K.display,
    fontSize: size,
    fontWeight: w,
    color: K.text,
    height: 1.15,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: K.light ? Brightness.light : Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: K.bg,
    fontFamily: K.body,
    textTheme: TextTheme(
      displayLarge: display(56),
      displayMedium: display(40),
      headlineLarge: display(32, FontWeight.w500),
      headlineMedium: display(24, FontWeight.w500),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: K.text,
      ),
      bodyLarge: TextStyle(fontSize: 18, height: 1.55, color: K.text),
      bodyMedium: TextStyle(fontSize: 16, height: 1.5, color: K.text),
      bodySmall: TextStyle(fontSize: 14, height: 1.45, color: K.muted),
      labelSmall: TextStyle(
        fontFamily: K.display,
        fontSize: 12,
        letterSpacing: 2.2,
        color: K.muted,
      ),
    ),
  );
}
