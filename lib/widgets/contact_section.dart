import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/colors.dart';
import '../constants/data.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "What's Next?",
                style: TextStyle(color: AppColors.primary, fontSize: 18, fontFamily: 'FiraCode'),
              ),
              const SizedBox(height: 20),
              Text(
                "Get In Touch",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: sizingInformation.isDesktop ? 50 : 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 600,
                child: Text(
                  "I'm always looking for new opportunities and freelancing projects. Whether you have a question or just want to say hi, I'll try my best to get back to you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 18, height: 1.6),
                ),
              ),
              const SizedBox(height: 50),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _launchUrl("mailto:${PortfolioData.email}"),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Say Hello",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontFamily: 'FiraCode',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedin, color: AppColors.textSecondary),
                    onPressed: () => _launchUrl(PortfolioData.linkedin),
                    hoverColor: AppColors.primary.withOpacity(0.1),
                    splashRadius: 25,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.envelope, color: AppColors.textSecondary),
                    onPressed: () => _launchUrl("mailto:${PortfolioData.email}"),
                    hoverColor: AppColors.primary.withOpacity(0.1),
                    splashRadius: 25,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.phone, color: AppColors.textSecondary),
                    onPressed: () => _launchUrl("tel:${PortfolioData.phone}"),
                    hoverColor: AppColors.primary.withOpacity(0.1),
                    splashRadius: 25,
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
