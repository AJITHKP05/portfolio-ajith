import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/colors.dart';
import '../../constants/data.dart';
import 'reveal.dart';

extension Responsive on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  bool get isMobile => screenWidth < 700;
  bool get isDesktop => screenWidth >= 1100;
}

TextStyle headingStyle(double size, {Color color = AppColors.textPrimary}) =>
    GoogleFonts.spaceGrotesk(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.1,
      letterSpacing: -0.5,
    );

TextStyle monoStyle(double size, {Color color = AppColors.primary}) =>
    GoogleFonts.jetBrainsMono(fontSize: size, color: color);

Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

Future<void> openResume() async {
  // Flutter web serves bundled assets under an extra `assets/` prefix.
  final path = kIsWeb
      ? 'assets/${PortfolioData.resumeAsset}'
      : PortfolioData.resumeAsset;
  await launchUrl(Uri.parse(path), webOnlyWindowName: '_blank');
}

/// Constrains content to a centred, max-width column with responsive padding.
class ContentWidth extends StatelessWidget {
  final Widget child;
  const ContentWidth({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 20 : 48),
          child: child,
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;

  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.gradient = AppColors.brandGradient,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(text, style: style, textAlign: textAlign),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: monoStyle(13)
                    .copyWith(letterSpacing: 3),
              ),
              const SizedBox(width: 16),
              Container(
                width: 60,
                height: 2,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: headingStyle(mobile ? 32 : 48)),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Text(
                subtitle!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 17,
                  height: 1.6,
                ),
              ),
            ),
          ],
          SizedBox(height: mobile ? 36 : 56),
        ],
      ),
    );
  }
}

/// Glassy card that lifts, glows and tilts toward the cursor on hover.
class HoverCard extends StatefulWidget {
  final Widget child;
  final Color glow;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final double tilt;

  const HoverCard({
    super.key,
    required this.child,
    this.glow = AppColors.primary,
    this.padding = const EdgeInsets.all(28),
    this.onTap,
    this.tilt = 0.06,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovered = false;
  Offset _pointer = Offset.zero; // -1..1 in each axis

  void _onHover(PointerHoverEvent e, Size size) {
    setState(() {
      _pointer = Offset(
        (e.localPosition.dx / size.width) * 2 - 1,
        (e.localPosition.dy / size.height) * 2 - 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(_hovered ? -_pointer.dy * widget.tilt : 0)
      ..rotateY(_hovered ? _pointer.dx * widget.tilt : 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          cursor: widget.onTap != null
              ? SystemMouseCursors.click
              : MouseCursor.defer,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() {
            _hovered = false;
            _pointer = Offset.zero;
          }),
          onHover: (e) => _onHover(
            e,
            Size(constraints.maxWidth, math.max(1, context.size?.height ?? 1)),
          ),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              transform: matrix
                ..translateByDouble(0.0, _hovered ? -8.0 : 0.0, 0.0, 1.0),
              transformAlignment: Alignment.center,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.card.withValues(alpha: 0.85),
                    AppColors.surface.withValues(alpha: 0.65),
                  ],
                ),
                border: Border.all(
                  color: _hovered
                      ? widget.glow.withValues(alpha: 0.6)
                      : AppColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.glow.withValues(alpha: _hovered ? 0.25 : 0),
                    blurRadius: 40,
                    spreadRadius: -4,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool outlined;

  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.outlined = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.outlined ? AppColors.textPrimary : Colors.white;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.05 : 1,
          duration: const Duration(milliseconds: 200),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: widget.outlined ? null : AppColors.brandGradient,
              color: widget.outlined
                  ? Colors.white.withValues(alpha: _hovered ? 0.08 : 0.03)
                  : null,
              border: widget.outlined
                  ? Border.all(
                      color: _hovered ? AppColors.primary : AppColors.border,
                    )
                  : null,
              boxShadow: widget.outlined
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.violet
                            .withValues(alpha: _hovered ? 0.55 : 0.3),
                        blurRadius: _hovered ? 32 : 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: fg,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.icon != null) ...[
                  const SizedBox(width: 10),
                  AnimatedSlide(
                    offset: Offset(_hovered ? 0.25 : 0, 0),
                    duration: const Duration(milliseconds: 200),
                    child: Icon(widget.icon, color: fg, size: 18),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  final Color color;

  const TagChip(this.label, {super.key, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: monoStyle(12, color: color)),
    );
  }
}
