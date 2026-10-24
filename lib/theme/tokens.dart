import 'package:flutter/material.dart';

/// Токены бренда Kosma (брендбук): лаванда, тёплые нейтральные, Jost — заголовки,
/// Golos Text — текст, JetBrains Mono — коды. Основная тема сайта — тёмная.
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

  static const bg = neutral950;
  static const surface = neutral900;
  static const line = neutral800;
  static const text = neutral50;
  static const muted = neutral400;
  static const accent = lavender500;

  /// Янтарь — «цвет скана» тёмной темы приложения: рамка, линия скана, счётчик.
  static const scan = Color(0xFFFFC21A);

  /// Более глубокая подложка (футер, чередующиеся блоки) и усиленная линия.
  static const surfaceDeep = Color(0xFF0E0F12);
  static const lineStrong = neutral700;

  static const display = 'Jost';
  static const body = 'GolosText';
  static const mono = 'JetBrainsMono';

  /// Максимальная ширина контента и боковые поля.
  static const maxWidth = 1200.0;
  static const gutter = 24.0;
}

ThemeData buildSiteTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: K.lavender600, brightness: Brightness.dark).copyWith(
    primary: K.accent,
    onPrimary: K.neutral950,
    surface: K.bg,
    onSurface: K.text,
  );
  TextStyle display(double size, [FontWeight w = FontWeight.w400]) =>
      TextStyle(fontFamily: K.display, fontSize: size, fontWeight: w, color: K.text, height: 1.15);
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: K.bg,
    fontFamily: K.body,
    textTheme: TextTheme(
      displayLarge: display(56),
      displayMedium: display(40),
      headlineLarge: display(32, FontWeight.w500),
      headlineMedium: display(24, FontWeight.w500),
      titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: K.text),
      bodyLarge: const TextStyle(fontSize: 18, height: 1.55, color: K.text),
      bodyMedium: const TextStyle(fontSize: 16, height: 1.5, color: K.text),
      bodySmall: const TextStyle(fontSize: 14, height: 1.45, color: K.muted),
      labelSmall: const TextStyle(fontFamily: K.display, fontSize: 12, letterSpacing: 2.2, color: K.muted),
    ),
  );
}
