import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/reveal.dart';
import 'common/ui.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            eyebrow: 'Experience',
            title: 'Where I\'ve made an impact.',
            subtitle:
                'Six-plus years across enterprise Fintech, EdTech and E-commerce teams, plus independent freelance work — growing from shipping features to leading full-cycle delivery.',
          ),
          _Timeline(),
        ],
      ),
    );
  }
}

/// Vertical timeline whose gradient line "draws" itself as you scroll.
class _Timeline extends StatefulWidget {
  const _Timeline();

  @override
  State<_Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<_Timeline> {
  ScrollPosition? _position;
  double _progress = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position?.removeListener(_update);
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_update);
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  void _update() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final anchor = MediaQuery.sizeOf(context).height * 0.6;
    final p = ((anchor - top) / box.size.height).clamp(0.0, 1.0);
    if ((p - _progress).abs() > 0.002) setState(() => _progress = p);
  }

  @override
  void dispose() {
    _position?.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    final items = PortfolioData.experience;
    const dotColumn = 56.0;

    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: desktop ? Alignment.topCenter : Alignment.topLeft,
            child: SizedBox(
              width: dotColumn,
              child: Center(
                child: Container(
                  width: 2,
                  color: AppColors.border,
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    heightFactor: _progress,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary,
                            AppColors.violet,
                            AppColors.secondary,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [
            for (var i = 0; i < items.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: _TimelineRow(
                  exp: items[i],
                  index: i,
                  desktop: desktop,
                  dotColumn: dotColumn,
                  lit: _progress >= (i + 0.2) / items.length,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final Experience exp;
  final int index;
  final bool desktop;
  final double dotColumn;
  final bool lit;

  const _TimelineRow({
    required this.exp,
    required this.index,
    required this.desktop,
    required this.dotColumn,
    required this.lit,
  });

  @override
  Widget build(BuildContext context) {
    final leftSide = index.isEven;
    final dot = SizedBox(
      width: dotColumn,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.only(top: 28),
          width: lit ? 20 : 14,
          height: lit ? 20 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lit ? exp.accent : AppColors.background,
            border: Border.all(color: exp.accent, width: 3),
            boxShadow: [
              if (lit)
                BoxShadow(
                  color: exp.accent.withValues(alpha: 0.7),
                  blurRadius: 18,
                ),
            ],
          ),
        ),
      ),
    );

    final card = Reveal(
      offset: Offset(desktop ? (leftSide ? -60 : 60) : 40, 0),
      child: _ExperienceCard(exp: exp),
    );

    if (!desktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [dot, const SizedBox(width: 8), Expanded(child: card)],
      );
    }

    final period = Reveal(
      offset: Offset(leftSide ? 60 : -60, 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Column(
          crossAxisAlignment:
              leftSide ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Text(exp.duration, style: monoStyle(15, color: exp.accent)),
            const SizedBox(height: 6),
            Text(
              exp.summary,
              textAlign: leftSide ? TextAlign.left : TextAlign.right,
              style: const TextStyle(color: AppColors.textMuted, height: 1.5),
            ),
          ],
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: leftSide ? card : period),
        dot,
        Expanded(child: leftSide ? period : card),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Experience exp;
  const _ExperienceCard({required this.exp});

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;
    return HoverCard(
      glow: exp.accent,
      tilt: 0.03,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [exp.accent, exp.accent.withValues(alpha: 0.5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(exp.initials,
                    style: headingStyle(18, color: Colors.white)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exp.role, style: headingStyle(20)),
                    const SizedBox(height: 4),
                    Text(
                      exp.company,
                      style: TextStyle(
                        color: exp.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!desktop) ...[
            const SizedBox(height: 12),
            Text(exp.duration, style: monoStyle(13, color: AppColors.textMuted)),
          ],
          const SizedBox(height: 18),
          for (final h in exp.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.bolt_rounded, size: 16, color: exp.accent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      h,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (exp.projects.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'KEY PROJECTS',
              style: monoStyle(11, color: AppColors.textMuted)
                  .copyWith(letterSpacing: 2),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in exp.projects)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withValues(alpha: 0.04),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      p,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
          ],
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final t in exp.tags) TagChip(t, color: exp.accent)],
          ),
        ],
      ),
    );
  }
}
