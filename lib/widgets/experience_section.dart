import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../constants/colors.dart';
import '../constants/data.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isDesktop = sizingInformation.isDesktop;
        return FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Where I've Worked",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: isDesktop ? 32 : 24,
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
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTabBar(),
                        const SizedBox(width: 40),
                        Expanded(child: _buildContent()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: PortfolioData.experience.asMap().entries.map((entry) {
                              return _buildTabButton(entry.key, entry.value['company'] as String, isHorizontal: true);
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildContent(),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppColors.surface, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: PortfolioData.experience.asMap().entries.map((entry) {
          int index = entry.key;
          String company = entry.value['company'] as String;
          return _buildTabButton(index, company, isHorizontal: false);
        }).toList(),
      ),
    );
  }

  Widget _buildTabButton(int index, String company, {required bool isHorizontal}) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      hoverColor: AppColors.surface.withOpacity(0.5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          border: isHorizontal
              ? Border(bottom: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 2))
              : Border(left: BorderSide(color: isSelected ? AppColors.primary : Colors.transparent, width: 2)),
          color: isSelected ? AppColors.surface.withOpacity(0.5) : Colors.transparent,
        ),
        child: Text(
          company,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final exp = PortfolioData.experience[_selectedIndex];
    final projects = exp['projects'] as List<dynamic>;

    return FadeIn(
      key: ValueKey(_selectedIndex),
      duration: const Duration(milliseconds: 500),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 22, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: exp['role'] as String),
                TextSpan(
                  text: ' @ ${exp['company']}',
                  style: const TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            exp['duration'] as String,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, fontFamily: 'FiraCode'),
          ),
          const SizedBox(height: 25),
          ...projects.map((project) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(Icons.arrow_right, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project['name'] as String,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          project['description'] as String,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
