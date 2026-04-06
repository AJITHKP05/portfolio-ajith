import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:portfolio_web/widgets/hero_section.dart';
import 'package:portfolio_web/widgets/about_section.dart';
import 'package:portfolio_web/widgets/experience_section.dart';
import 'package:portfolio_web/widgets/contact_section.dart';
import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _experienceKey = GlobalKey();

  void _scrollToExperience() {
    if (_experienceKey.currentContext != null) {
      Scrollable.ensureVisible(
        _experienceKey.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ResponsiveBuilder(
                builder: (context, sizingInformation) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizingInformation.isDesktop ? 100 : 20,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HeroSection(onCheckWork: _scrollToExperience),
                        const SizedBox(height: 100),
                        const AboutSection(),
                        const SizedBox(height: 100),
                        ExperienceSection(key: _experienceKey),
                        const SizedBox(height: 100),
                        const ContactSection(),
                        const SizedBox(height: 60),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
