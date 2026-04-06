import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../constants/colors.dart';
import '../constants/data.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onCheckWork;
  const HeroSection({super.key, required this.onCheckWork});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: sizingInformation.isDesktop ? 100 : 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Text(
                  "Hi, my name is",
                  style: GoogleFonts.firaCode(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  PortfolioData.name,
                  style: TextStyle(
                    fontSize: sizingInformation.isDesktop ? 80 : 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: Text(
                  "I build things for mobile & web.",
                  style: TextStyle(
                    fontSize: sizingInformation.isDesktop ? 60 : 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                duration: const Duration(milliseconds: 1400),
                child: SizedBox(
                  width: sizingInformation.isDesktop ? 600 : double.infinity,
                  child: Text(
                    PortfolioData.bio,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              FadeInUp(
                duration: const Duration(milliseconds: 1600),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onCheckWork,
                    child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Check out my work!",
                      style: GoogleFonts.firaCode(
                        color: AppColors.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              ),
            ],
          ),
        );
      },
    );
  }
}
