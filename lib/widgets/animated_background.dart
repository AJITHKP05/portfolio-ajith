import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/colors.dart';

/// Full-screen backdrop: drifting aurora blobs with scroll parallax, a faded
/// grid, twinkling stars and a soft spotlight that follows the cursor.
class AnimatedBackground extends StatefulWidget {
  final ScrollController scrollController;
  final ValueNotifier<Offset?> pointer;

  const AnimatedBackground({
    super.key,
    required this.scrollController,
    required this.pointer,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _BackgroundPainter(
          time: _controller,
          scroll: widget.scrollController,
          pointer: widget.pointer,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final Animation<double> time;
  final ScrollController scroll;
  final ValueNotifier<Offset?> pointer;

  _BackgroundPainter({
    required this.time,
    required this.scroll,
    required this.pointer,
  }) : super(repaint: Listenable.merge([time, scroll, pointer]));

  static final List<Offset> _stars = List.generate(
    70,
    (i) => Offset(
      (math.sin(i * 12.9898) * 43758.5453) % 1,
      (math.sin(i * 78.233) * 12345.6789) % 1,
    ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final t = time.value * 2 * math.pi;
    final offset = scroll.hasClients ? scroll.offset : 0.0;

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.background,
    );

    void blob(Color color, double x, double y, double r, double parallax) {
      final center = Offset(x * size.width, y * size.height - offset * parallax);
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
          ).createShader(Rect.fromCircle(center: center, radius: r)),
      );
    }

    final base = math.max(size.width, size.height);
    blob(AppColors.violet, 0.15 + 0.08 * math.sin(t), 0.2 + 0.06 * math.cos(t),
        base * 0.45, 0.08);
    blob(AppColors.primary, 0.85 + 0.06 * math.cos(t * 2),
        0.35 + 0.08 * math.sin(t), base * 0.38, 0.15);
    blob(AppColors.secondary, 0.55 + 0.1 * math.sin(t + 1),
        0.95 + 0.05 * math.cos(t * 2), base * 0.35, 0.05);

    // Grid that drifts with scroll and fades toward the edges.
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;
    const cell = 64.0;
    final shift = (offset * 0.3) % cell;
    for (double x = 0; x < size.width; x += cell) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = -shift; y < size.height; y += cell) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          radius: 0.9,
          colors: [
            AppColors.background.withValues(alpha: 0),
            AppColors.background.withValues(alpha: 0.85),
          ],
        ).createShader(Offset.zero & size),
    );

    // Twinkling stars with slight parallax.
    for (var i = 0; i < _stars.length; i++) {
      final s = _stars[i];
      final twinkle = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(t * 3 + i));
      final y = (s.dy.abs() * size.height - offset * 0.05 * (1 + i % 3)) %
          size.height;
      canvas.drawCircle(
        Offset(s.dx.abs() * size.width, y),
        i % 7 == 0 ? 1.6 : 1,
        Paint()..color = Colors.white.withValues(alpha: 0.35 * twinkle),
      );
    }

    final p = pointer.value;
    if (p != null) {
      canvas.drawCircle(
        p,
        320,
        Paint()
          ..shader = RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.10),
              AppColors.primary.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: p, radius: 320)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) => false;
}
