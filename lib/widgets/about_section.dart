import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/reveal.dart';
import 'common/ui.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;

    final story = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          child: Text(
            PortfolioData.bio,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 17,
              height: 1.75,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Reveal(
          delay: const Duration(milliseconds: 120),
          child: Text(
            PortfolioData.bio2,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 17,
              height: 1.75,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Reveal(
          delay: const Duration(milliseconds: 240),
          child: HoverCard(
            padding: const EdgeInsets.all(22),
            glow: AppColors.violet,
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const FaIcon(FontAwesomeIcons.graduationCap,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        PortfolioData.education,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        PortfolioData.educationDetail,
                        style: monoStyle(13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return ContentWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'About me',
            title: 'Engineering mobile products\nthat scale.',
          ),
          desktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: story),
                    const SizedBox(width: 56),
                    const Expanded(flex: 6, child: _SkillGrid()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [story, const SizedBox(height: 40), const _SkillGrid()],
                ),
        ],
      ),
    );
  }
}

class _SkillGrid extends StatelessWidget {
  const _SkillGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 520 ? 2 : 1;
        final width = (constraints.maxWidth - 18 * (columns - 1)) / columns;
        final groups = PortfolioData.skillGroups;
        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: [
            for (var i = 0; i < groups.length; i++)
              SizedBox(
                width: width,
                child: Reveal(
                  delay: Duration(milliseconds: 80 * i),
                  offset: Offset(i.isEven ? -30 : 30, 20),
                  child: HoverCard(
                    padding: const EdgeInsets.all(20),
                    glow: i.isEven ? AppColors.primary : AppColors.secondary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(groups[i].icon,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Text(
                              groups[i].title,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final item in groups[i].items)
                              TagChip(
                                item,
                                color: i.isEven
                                    ? AppColors.primary
                                    : AppColors.violet,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
