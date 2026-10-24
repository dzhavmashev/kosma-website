import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Экран приложения в рамке телефона. Скриншоты — 1080×2400, поэтому пропорция 9:20.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({
    super.key,
    required this.asset,
    required this.label,
    this.width = 200,
    this.overlay,
  });

  final String asset;

  /// Описание экрана для скринридеров.
  final String label;
  final double width;

  /// Поверх скриншота (рамка и линия скана).
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    final radius = width * 0.14;
    return Semantics(
      image: true,
      label: label,
      child: Container(
        width: width,
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          color: K.bg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: K.line, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius * 0.8),
          child: AspectRatio(
            aspectRatio: 1080 / 2400,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  asset,
                  cacheWidth: (width * 3).ceil(),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  excludeFromSemantics: true,
                ),
                ?overlay,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
