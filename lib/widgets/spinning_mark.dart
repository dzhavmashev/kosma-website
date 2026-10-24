import 'package:flutter/material.dart';

/// Знак Kosma, который вращается: один оборот ease-in-out, пауза, снова.
/// [loop] = false — оборот только при наведении (шапка), чтобы не отвлекать от текста.
/// При системной настройке «уменьшить анимацию» знак неподвижен.
class SpinningMark extends StatefulWidget {
  const SpinningMark({super.key, required this.size, this.label, this.loop = true});

  final double size;
  final String? label;
  final bool loop;

  @override
  State<SpinningMark> createState() => _SpinningMarkState();
}

class _SpinningMarkState extends State<SpinningMark> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.loop ? const Duration(milliseconds: 7000) : const Duration(milliseconds: 900),
  );
  late final Animation<double> _turns = widget.loop
      ? CurvedAnimation(parent: _c, curve: const Interval(0, 0.5, curve: Curves.easeInOutCubic))
      : CurvedAnimation(parent: _c, curve: Curves.easeInOutCubic);

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
    if (widget.loop || _c.isAnimating || MediaQuery.disableAnimationsOf(context)) return;
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 3.0);
    return MouseRegion(
      onEnter: (_) => _spin(),
      child: RepaintBoundary(
        child: RotationTransition(
          turns: _turns,
          child: Image.asset(
            'assets/logo/kosma-mark-dark.png',
            width: widget.size,
            height: widget.size,
            cacheWidth: (widget.size * dpr).ceil(),
            semanticLabel: widget.label,
            excludeFromSemantics: widget.label == null,
          ),
        ),
      ),
    );
  }
}
