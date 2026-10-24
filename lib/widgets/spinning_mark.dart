import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Знак Kosma как в загрузчике (kosma-splash): кольцо неподвижно, лавандовая точка с «разрывом»
/// кольца вокруг неё облетает круг (ease-in-out, как сегмент loop в Lottie). Рисуется кодом,
/// поэтому разрыв прозрачный и работает на любом фоне.
/// [loop] = false — знак стоит, оборот делает при наведении (шапка).
/// При системной настройке «уменьшить анимацию» знак неподвижен.
class SpinningMark extends StatefulWidget {
  const SpinningMark({
    super.key,
    required this.size,
    this.label,
    this.loop = true,
  });

  final double size;
  final String? label;
  final bool loop;

  @override
  State<SpinningMark> createState() => _SpinningMarkState();
}

class _SpinningMarkState extends State<SpinningMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.loop
        ? const Duration(milliseconds: 2400)
        : const Duration(milliseconds: 1000),
  );
  // Кривая загрузчика: cubic-bezier(0.65, 0, 0.35, 1).
  static const _ease = Cubic(0.65, 0, 0.35, 1);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _c.stop();
      _c.value = 0;
    } else if (widget.loop && !_c.isAnimating) {
      _c.repeat();
    }
  }

  void _spin() {
    if (widget.loop ||
        _c.isAnimating ||
        MediaQuery.disableAnimationsOf(context)) {
      return;
    }
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mark = RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) =>
              CustomPaint(painter: _MarkPainter(_ease.transform(_c.value))),
        ),
      ),
    );
    return MouseRegion(
      onEnter: (_) => _spin(),
      child: widget.label == null
          ? ExcludeSemantics(child: mark)
          : Semantics(image: true, label: widget.label, child: mark),
    );
  }
}

/// Геометрия бренда (viewBox 100): кольцо r=34, штрих 9; точка r=10 на r=34 от центра;
/// «разрыв» — круг r=12.5 вокруг точки. В покое точка в верхнем правом углу (−45°).
class _MarkPainter extends CustomPainter {
  const _MarkPainter(this.turn);
  final double turn; // 0..1 — доля полного оборота

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 100;
    canvas.scale(k);
    const center = Offset(50, 50);
    const orbit = 34.0;
    final angle = -0.785398163 + turn * 6.283185307; // −45° + оборот по часовой
    final dot = center + Offset.fromDirection(angle, orbit);

    canvas.saveLayer(const Rect.fromLTWH(0, 0, 100, 100), Paint());
    canvas.drawCircle(
      center,
      orbit,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..color = K.text
        ..isAntiAlias = true,
    );
    canvas.drawCircle(dot, 12.5, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
    canvas.drawCircle(dot, 10, Paint()..color = K.accent);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.turn != turn;
}
