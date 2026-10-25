import 'dart:async';

import 'package:flutter/material.dart';

import '../i18n.dart';
import '../theme/tokens.dart';
import 'phone_frame.dart';

/// Демо в первом экране Сканера: телефон с рамкой и линией скана и счётчик «СКАНОВ · ДЕМО».
/// Данные — примеры, не настоящие сканы. При «уменьшить движение» анимация и счёт стоят.
class ScanDemo extends StatefulWidget {
  const ScanDemo({super.key, required this.lang});
  final Lang lang;

  @override
  State<ScanDemo> createState() => _ScanDemoState();
}

class _ScanDemoState extends State<ScanDemo>
    with SingleTickerProviderStateMixin {
  static const _codes = [
    '4600702001234',
    '4810268031228',
    '4607001771562',
    '4870204391517',
  ];

  late final AnimationController _line = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  Timer? _timer;
  int _total = 36;
  final _recent = <MapEntry<String, int>>[
    const MapEntry('4600702001234', 12),
    const MapEntry('4870204391517', 9),
    const MapEntry('4607001771562', 1),
  ];
  int _tick = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _line.stop();
      _timer?.cancel();
      _timer = null;
    } else {
      if (!_line.isAnimating) _line.repeat(reverse: true);
      _timer ??= Timer.periodic(
        const Duration(milliseconds: 1400),
        (_) => _scan(),
      );
    }
  }

  void _scan() {
    if (!mounted) return;
    final code = _codes[_tick++ % _codes.length];
    setState(() {
      final prev = _recent.where((e) => e.key == code).firstOrNull;
      _recent
        ..removeWhere((e) => e.key == code)
        ..insert(0, MapEntry(code, prev == null ? 1 : prev.value + 1));
      if (_recent.length > 3) _recent.removeLast();
      _total++;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.lang;
    final t = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RepaintBoundary(
          child: PhoneFrame(
            asset: 'assets/shots/summing-${l.name}.webp',
            label: l.tr(
              'Экран сессии Kosma Сканер',
              'Kosma Scanner session screen',
            ),
            width: 270,
            overlay: IgnorePointer(
              child: AnimatedBuilder(
                animation: _line,
                builder: (context, _) =>
                    CustomPaint(painter: _FramePainter(_line.value)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: 270,
          decoration: BoxDecoration(
            color: K.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: K.line),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$_total',
                      style: TextStyle(
                        fontFamily: K.display,
                        fontSize: 34,
                        color: K.scan,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      l.tr('СКАНОВ · ДЕМО', 'SCANS · DEMO'),
                      style: t.labelSmall?.copyWith(
                        fontFamily: K.mono,
                        fontSize: 10,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 10, 12, 10),
                  child: Column(
                    children: [
                      for (var i = 0; i < _recent.length; i++)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '…${_recent[i].key.substring(_recent[i].key.length - 4)}  ×${_recent[i].value}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: K.mono,
                              fontSize: 12,
                              color: i == 0 ? K.scan : K.muted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Рамка скана с угловыми скобками и бегущей линией — «цвет скана» приложения.
class _FramePainter extends CustomPainter {
  const _FramePainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.22,
      size.width * 0.8,
      size.height * 0.3,
    );
    final corner = Paint()
      ..color = K.scanOnScreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    const c = 20.0;
    final path = Path()
      ..moveTo(r.left, r.top + c)
      ..lineTo(r.left, r.top)
      ..lineTo(r.left + c, r.top)
      ..moveTo(r.right - c, r.top)
      ..lineTo(r.right, r.top)
      ..lineTo(r.right, r.top + c)
      ..moveTo(r.left, r.bottom - c)
      ..lineTo(r.left, r.bottom)
      ..lineTo(r.left + c, r.bottom)
      ..moveTo(r.right - c, r.bottom)
      ..lineTo(r.right, r.bottom)
      ..lineTo(r.right, r.bottom - c);
    canvas.drawPath(path, corner);
    final y = r.top + 8 + (r.height - 16) * Curves.easeInOut.transform(t);
    final glow = Paint()
      ..color = K.scanOnScreen.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final line = Paint()..color = K.scanOnScreen;
    final rect = Rect.fromLTWH(r.left + 8, y - 1.5, r.width - 16, 3);
    canvas.drawRect(rect, glow);
    canvas.drawRect(rect, line);
  }

  @override
  bool shouldRepaint(_FramePainter old) => old.t != t;
}
