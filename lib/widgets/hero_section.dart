import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/reveal.dart';
import 'common/ui.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewWork;

  const HeroSection({
    super.key,
    required this.onViewWork,
  });

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    final mobile = context.isMobile;
    final height = MediaQuery.sizeOf(context).height;

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Reveal(child: _AvailableBadge()),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 150),
          child: Text("Hi, I'm", style: monoStyle(mobile ? 16 : 18)),
        ),
        const SizedBox(height: 12),
        Reveal(
          delay: const Duration(milliseconds: 250),
          child: GradientText(
            PortfolioData.name,
            style: headingStyle(mobile ? 52 : (desktop ? 96 : 76))
                .copyWith(letterSpacing: -2),
          ),
        ),
        const SizedBox(height: 12),
        Reveal(
          delay: const Duration(milliseconds: 400),
          child: _Typewriter(fontSize: mobile ? 24 : 38),
        ),
        const SizedBox(height: 28),
        Reveal(
          delay: const Duration(milliseconds: 550),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              PortfolioData.tagline,
              style: TextStyle(
                fontSize: mobile ? 16 : 19,
                color: AppColors.textSecondary,
                height: 1.65,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Reveal(
          delay: const Duration(milliseconds: 700),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              GradientButton(
                label: 'View my work',
                icon: Icons.arrow_forward_rounded,
                onTap: onViewWork,
              ),
              GradientButton(
                label: 'Download CV',
                icon: Icons.download_rounded,
                outlined: true,
                onTap: openResume,
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Reveal(
          delay: const Duration(milliseconds: 850),
          child: Row(
            children: [
              _Social(FontAwesomeIcons.linkedinIn,
                  () => openUrl(PortfolioData.linkedin)),
              _Social(
                  FontAwesomeIcons.github, () => openUrl(PortfolioData.github)),
              _Social(FontAwesomeIcons.envelope,
                  () => openUrl('mailto:${PortfolioData.email}')),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  '📍 ${PortfolioData.location}',
                  style: const TextStyle(color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: desktop ? height : 0),
      child: ContentWidth(
        child: Padding(
          padding: EdgeInsets.only(top: mobile ? 120 : 140, bottom: 60),
          child: Column(
            children: [
              desktop
                  ? Row(
                      children: [
                        Expanded(flex: 6, child: intro),
                        const Expanded(
                          flex: 4,
                          child: Reveal(
                            delay: Duration(milliseconds: 500),
                            scale: 0.85,
                            offset: Offset(60, 0),
                            child: _PhoneShowcase(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        intro,
                        const SizedBox(height: 60),
                        const Center(
                          child: Reveal(
                            scale: 0.9,
                            child: _PhoneShowcase(),
                          ),
                        ),
                      ],
                    ),
              if (desktop) ...[
                const SizedBox(height: 40),
                const _ScrollHint(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailableBadge extends StatefulWidget {
  const _AvailableBadge();

  @override
  State<_AvailableBadge> createState() => _AvailableBadgeState();
}

class _AvailableBadgeState extends State<_AvailableBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.green.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 6 + 8 * _pulse.value,
                    height: 6 + 8 * _pulse.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green
                          .withValues(alpha: 0.5 * (1 - _pulse.value)),
                    ),
                  ),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Open to roles & freelance projects',
            style: monoStyle(13, color: AppColors.green),
          ),
        ],
      ),
    );
  }
}

class _Typewriter extends StatefulWidget {
  final double fontSize;
  const _Typewriter({required this.fontSize});

  @override
  State<_Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<_Typewriter> {
  late final Timer _timer;
  int _role = 0;
  int _chars = 0;
  bool _deleting = false;
  int _hold = 0;
  bool _cursor = true;
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 60), (_) => _step());
  }

  void _step() {
    final text = PortfolioData.roles[_role];
    setState(() {
      if (++_tick % 8 == 0) _cursor = !_cursor;
      if (_hold > 0) {
        _hold--;
      } else if (!_deleting) {
        if (_chars < text.length) {
          _chars++;
        } else {
          _deleting = true;
          _hold = 30;
        }
      } else if (_chars > 0) {
        _chars--;
      } else {
        _deleting = false;
        _role = (_role + 1) % PortfolioData.roles.length;
        _hold = 5;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = PortfolioData.roles[_role].substring(0, _chars);
    final style = headingStyle(widget.fontSize, color: AppColors.textSecondary);
    return Row(
      children: [
        Flexible(child: Text(text, style: style, maxLines: 1)),
        AnimatedOpacity(
          opacity: _cursor ? 1 : 0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            width: 3,
            height: widget.fontSize,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _Social extends StatefulWidget {
  final FaIconData icon;
  final VoidCallback onTap;
  const _Social(this.icon, this.onTap);

  @override
  State<_Social> createState() => _SocialState();
}

class _SocialState extends State<_Social> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 46,
            height: 46,
            transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hovered
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: _hovered ? AppColors.primary : AppColors.border,
              ),
            ),
            child: FaIcon(
              widget.icon,
              size: 18,
              color: _hovered ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Stylised phone running a mini fintech dashboard, orbited by tech chips.
class _PhoneShowcase extends StatefulWidget {
  const _PhoneShowcase();

  @override
  State<_PhoneShowcase> createState() => _PhoneShowcaseState();
}

class _PhoneShowcaseState extends State<_PhoneShowcase>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  static const _chips = [
    ('Flutter', FontAwesomeIcons.mobileScreenButton, Alignment(-1.05, -0.75)),
    ('Kotlin', FontAwesomeIcons.android, Alignment(1.1, -0.45)),
    ('Swift', FontAwesomeIcons.apple, Alignment(-1.15, 0.2)),
    ('Firebase', FontAwesomeIcons.fire, Alignment(1.05, 0.45)),
    ('BLoC', FontAwesomeIcons.cubes, Alignment(-0.85, 0.9)),
  ];

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = context.isMobile ? 0.82 : 1.0;
    return SizedBox(
      width: 440 * scale,
      height: 600 * scale,
      child: AnimatedBuilder(
        animation: _float,
        builder: (context, _) {
          final t = _float.value * 2 * math.pi;
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 320 * scale,
                height: 320 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.violet.withValues(alpha: 0.45),
                      AppColors.violet.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, 10 * math.sin(t)),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0012)
                    ..rotateY(0.18 * math.sin(t * 0.5))
                    ..rotateX(0.05 * math.cos(t)),
                  child: Transform.scale(
                    scale: scale,
                    // Lay out at full size, then scale, so the fixed-size
                    // phone never overflows the smaller mobile box.
                    child: const OverflowBox(
                      minWidth: 270,
                      maxWidth: 270,
                      minHeight: 550,
                      maxHeight: 550,
                      child: _Phone(),
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < _chips.length; i++)
                Align(
                  alignment: _chips[i].$3,
                  child: Transform.translate(
                    offset: Offset(0, 12 * math.sin(t + i * 1.3)),
                    child: _FloatingChip(label: _chips[i].$1, icon: _chips[i].$2),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _FloatingChip extends StatelessWidget {
  final String label;
  final FaIconData icon;
  const _FloatingChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 550,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(46),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A3354), Color(0xFF0B1022)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 60,
            spreadRadius: -10,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 40,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Container(
          color: const Color(0xFF0A0F1F),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('9:41',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    width: 70,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.signal_cellular_alt,
                      color: Colors.white, size: 13),
                  const SizedBox(width: 4),
                  const Icon(Icons.battery_full, color: Colors.white, size: 13),
                ],
              ),
              const SizedBox(height: 22),
              const Text('Good morning 👋',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              const SizedBox(height: 4),
              const Text('Your Portfolio',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total value',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                    const SizedBox(height: 6),
                    const Text('₹ 12,48,560',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('▲ 12.4% this month',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 90, child: _AnimatedChart()),
              const SizedBox(height: 14),
              const Text('Active SIPs',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const _SipRow('Bluechip Fund', '₹5,000', AppColors.primary),
              const _SipRow('Midcap Growth', '₹3,000', AppColors.violet),
              const _SipRow('Index 50', '₹2,500', AppColors.secondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SipRow extends StatelessWidget {
  final String name;
  final String amount;
  final Color color;
  const _SipRow(this.name, this.amount, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.trending_up_rounded, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          Text(amount,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _AnimatedChart extends StatefulWidget {
  const _AnimatedChart();

  @override
  State<_AnimatedChart> createState() => _AnimatedChartState();
}

class _AnimatedChartState extends State<_AnimatedChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChartPainter(CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
      size: Size.infinite,
    );
  }
}

class _ChartPainter extends CustomPainter {
  final Animation<double> progress;
  _ChartPainter(this.progress) : super(repaint: progress);

  static const _points = [0.7, 0.55, 0.62, 0.4, 0.48, 0.3, 0.35, 0.15, 0.2, 0.05];

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    for (var i = 0; i < _points.length; i++) {
      final x = size.width * i / (_points.length - 1);
      final y = size.height * _points[i];
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final px = size.width * (i - 1) / (_points.length - 1);
        final py = size.height * _points[i - 1];
        path.cubicTo((px + x) / 2, py, (px + x) / 2, y, x, y);
      }
    }
    final metric = path.computeMetrics().first;
    final visible = metric.extractPath(0, metric.length * (0.35 + 0.65 * progress.value));
    final rect = Offset.zero & size;

    final fill = Path.from(visible)
      ..lineTo(metric.getTangentForOffset(metric.length * (0.35 + 0.65 * progress.value))!.position.dx, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.35),
            AppColors.primary.withValues(alpha: 0),
          ],
        ).createShader(rect),
    );
    canvas.drawPath(
      visible,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..shader = AppColors.brandGradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) => false;
}

class _ScrollHint extends StatefulWidget {
  const _ScrollHint();

  @override
  State<_ScrollHint> createState() => _ScrollHintState();
}

class _ScrollHintState extends State<_ScrollHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 26,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.textMuted, width: 1.5),
          ),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => Align(
              alignment: Alignment(0, -0.6 + 1.0 * _c.value),
              child: Opacity(
                opacity: 1 - _c.value,
                child: Container(
                  width: 4,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('SCROLL', style: monoStyle(11, color: AppColors.textMuted).copyWith(letterSpacing: 4)),
      ],
    );
  }
}
