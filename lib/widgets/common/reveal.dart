import 'package:flutter/material.dart';

/// Fades/slides [child] into view the first time it scrolls into the viewport.
///
/// Descendants can read the progress via [RevealScope.of] to drive their own
/// effects (e.g. count-up numbers).
class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final double scale;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 800),
    this.offset = const Offset(0, 40),
    this.scale = 1,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  ScrollPosition? _position;
  bool _triggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_check);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top < viewport * 0.92 && top + box.size.height > 0) {
      _triggered = true;
      _position?.removeListener(_check);
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RevealScope(
      animation: _curve,
      child: AnimatedBuilder(
        animation: _curve,
        child: widget.child,
        builder: (context, child) {
          final t = _curve.value;
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: widget.offset * (1 - t),
              child: Transform.scale(
                scale: widget.scale + (1 - widget.scale) * t,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}

class RevealScope extends InheritedNotifier<Animation<double>> {
  const RevealScope({
    super.key,
    required Animation<double> animation,
    required super.child,
  }) : super(notifier: animation);

  static double of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<RevealScope>()
            ?.notifier
            ?.value ??
        1;
  }
}

/// Number that counts up as its enclosing [Reveal] animates in.
class CountUp extends StatelessWidget {
  final int value;
  final String suffix;
  final TextStyle style;

  const CountUp({
    super.key,
    required this.value,
    required this.suffix,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final t = RevealScope.of(context);
    return Text('${(value * t).round()}$suffix', style: style);
  }
}
