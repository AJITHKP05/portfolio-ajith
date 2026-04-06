import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../constants/colors.dart';
import '../constants/data.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "About Me",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: sizingInformation.isDesktop ? 32 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: AppColors.surface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                children: [
                  SizedBox(
                    width: sizingInformation.isDesktop ? 500 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "I am an innovative Mobile Engineer dedicated to shipping world-class applications. By focusing on Clean Architecture algorithms, robust state management via BLoC, and seamless UI/UX design, I continuously strive to push the boundaries of mobile performance and cross-functional agile collaboration.",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 18, height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Here are a few technologies I've been working with recently:",
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          children: PortfolioData.skills.map((skill) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.arrow_right, color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  skill,
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
