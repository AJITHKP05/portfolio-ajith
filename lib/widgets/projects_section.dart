import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/reveal.dart';
import 'common/ui.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _filter = PortfolioData.projectDomains.first;

  @override
  Widget build(BuildContext context) {
    final projects = PortfolioData.projects
        .where((p) => _filter == 'All' || p.domain == _filter)
        .toList();

    return ContentWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Featured work',
            title: 'Apps I\'ve built & shipped.',
            subtitle:
                'Production apps across banking, investments, commerce, education and enterprise — each with measurable impact.',
          ),
          Reveal(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final d in PortfolioData.projectDomains)
                  _FilterChip(
                    label: d,
                    count: d == 'All'
                        ? PortfolioData.projects.length
                        : PortfolioData.projects
                            .where((p) => p.domain == d)
                            .length,
                    selected: d == _filter,
                    onTap: () => setState(() => _filter = d),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final columns = w > 1000 ? 3 : (w > 640 ? 2 : 1);
              final cardWidth = (w - 24 * (columns - 1)) / columns;
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 450),
                switchInCurve: Curves.easeOutCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                layoutBuilder: (current, previous) => Stack(
                  alignment: Alignment.topLeft,
                  children: [...previous, ?current],
                ),
                child: Wrap(
                  key: ValueKey(_filter),
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    for (var i = 0; i < projects.length; i++)
                      SizedBox(
                        width: cardWidth,
                        child: Reveal(
                          delay: Duration(milliseconds: 90 * (i % columns)),
                          offset: const Offset(0, 60),
                          scale: 0.95,
                          child: _ProjectCard(project: projects[i]),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: selected ? AppColors.brandGradient : null,
            color: selected
                ? null
                : Colors.white.withValues(alpha: _hovered ? 0.08 : 0.03),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : (_hovered ? AppColors.primary : AppColors.border),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.count}',
                style: monoStyle(
                  12,
                  color: selected ? Colors.white70 : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final p = project;
    return HoverCard(
      glow: p.colors.first,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(19)),
              gradient: LinearGradient(
                colors: [
                  p.colors.first.withValues(alpha: 0.35),
                  p.colors.last.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -24,
                  child: FaIcon(
                    p.icon,
                    size: 110,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(colors: p.colors),
                            boxShadow: [
                              BoxShadow(
                                color: p.colors.first.withValues(alpha: 0.5),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child:
                              FaIcon(p.icon, size: 18, color: Colors.white),
                        ),
                        const Spacer(),
                        Text(p.year.isEmpty ? p.domain : '${p.domain} · ${p.year}',
                            style: monoStyle(12, color: Colors.white70)),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GradientText(
                          p.metric,
                          style: headingStyle(34),
                          gradient: LinearGradient(
                            colors: [Colors.white, p.colors.first],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            p.metricLabel,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: headingStyle(19)),
                const SizedBox(height: 6),
                Text(
                  p.tagline,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                for (final h in p.highlights)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 7),
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: p.colors),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            h,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final s in p.stack)
                      Text(
                        '#$s',
                        style: monoStyle(12, color: p.colors.first),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
