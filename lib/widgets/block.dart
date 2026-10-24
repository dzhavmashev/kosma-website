import 'package:flutter/material.dart';

import '../i18n.dart';
import '../theme/tokens.dart';
import 'page_scope.dart';

/// Контент ограниченной ширины с боковыми полями.
class Band extends StatelessWidget {
  const Band({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: K.maxWidth),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: K.gutter), child: child),
    ),
  );
}

/// Блок страницы: фон, контент, плавное появление и кнопка «к следующему блоку».
/// [anchor] — ключ блока (цель для предыдущего); [next] — ключ следующего блока,
/// без него кнопка ведёт к футеру.
class PageBlock extends StatelessWidget {
  const PageBlock({
    super.key,
    required this.lang,
    required this.anchor,
    required this.child,
    this.next,
    this.color,
    this.grid = false,
    this.topLine = true,
    this.reveal = true,
  });

  final Lang lang;
  final GlobalKey anchor;
  final GlobalKey? next;
  final Widget child;
  final Color? color;
  final bool grid;
  final bool topLine;
  final bool reveal;

  @override
  Widget build(BuildContext context) {
    final target = next ?? PageScope.of(context).footerKey;
    return KeyedSubtree(
      key: anchor,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, border: topLine ? const Border(top: BorderSide(color: K.line)) : null),
        child: Stack(
          children: [
            if (grid) const Positioned.fill(child: CustomPaint(painter: _GridPainter())),
            Band(
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 136),
                child: reveal ? Reveal(child: child) : child,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 40,
              child: Center(
                child: NextButton(label: S(lang).next, onTap: () => scrollToKey(context, target)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Сетка бренда на фоне первого экрана.
class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = K.accent.withValues(alpha: 0.07)
      ..strokeWidth = 1;
    const step = 48.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

/// Появление при входе блока в экран: прозрачность и сдвиг вверх, один раз.
/// При «уменьшить движение» содержимое показывается сразу.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child});
  final Widget child;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  bool _shown = false;
  ScrollController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final c = PageScope.of(context).controller;
    if (c != _controller) {
      _controller?.removeListener(_check);
      _controller = c..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * 0.88) setState(() => _shown = true);
  }

  @override
  void dispose() {
    _controller?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    const d = Duration(milliseconds: 700);
    return AnimatedSlide(
      offset: _shown ? Offset.zero : const Offset(0, 0.05),
      duration: d,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(opacity: _shown ? 1 : 0, duration: d, curve: Curves.easeOut, child: widget.child),
    );
  }
}

/// Круглая кнопка «к следующему блоку» со стрелкой, которая слегка покачивается.
class NextButton extends StatefulWidget {
  const NextButton({super.key, required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> with SingleTickerProviderStateMixin {
  late final AnimationController _bob = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));
  bool _hover = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _bob.stop();
    } else if (!_bob.isAnimating) {
      _bob.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: widget.label,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hover ? K.lavender900 : K.surface.withValues(alpha: 0.85),
            border: Border.all(color: _hover ? K.accent : K.lineStrong),
          ),
          child: AnimatedBuilder(
            animation: _bob,
            builder: (context, child) => Transform.translate(offset: Offset(0, _bob.value * 4), child: child),
            child: const Icon(Icons.arrow_downward_rounded, size: 20, color: K.text),
          ),
        ),
      ),
    ),
  );
}

/// Кнопка «наверх»: появляется, когда страница прокручена, плавно возвращает к началу.
class UpButton extends StatelessWidget {
  const UpButton({super.key, required this.lang});
  final Lang lang;

  @override
  Widget build(BuildContext context) {
    final c = PageScope.of(context).controller;
    return ListenableBuilder(
      listenable: c,
      builder: (context, _) {
        final visible = c.hasClients && c.offset > 320;
        return Positioned(
          right: 20,
          bottom: 20,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedOpacity(
              opacity: visible ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: Semantics(
                button: true,
                label: S(lang).up,
                child: Material(
                  color: K.surface,
                  elevation: 6,
                  shape: const CircleBorder(side: BorderSide(color: K.lineStrong)),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => scrollToTop(context),
                    child: const SizedBox(width: 48, height: 48, child: Icon(Icons.arrow_upward_rounded, color: K.text)),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Метка над заголовком блока (моно, капсом).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontFamily: K.mono, fontSize: 12, letterSpacing: 1.7, color: K.accent),
  );
}

/// Заголовок блока.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 640;
    return Text(text, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: narrow ? 30 : 44));
  }
}
