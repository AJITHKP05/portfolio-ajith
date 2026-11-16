import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/reveal.dart';
import 'common/ui.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    return ContentWidth(
      child: Column(
        children: [
          Reveal(
            scale: 0.92,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: AppColors.brandGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.violet.withValues(alpha: 0.3),
                    blurRadius: 80,
                    spreadRadius: -10,
                  ),
                ],
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: mobile ? 24 : 64,
                  vertical: mobile ? 48 : 72,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  color: AppColors.surface,
                ),
                child: Column(
                  children: [
                    Text('What\'s next?', style: monoStyle(15)),
                    const SizedBox(height: 18),
                    GradientText(
                      'Let\'s build something\ngreat together.',
                      textAlign: TextAlign.center,
                      style: headingStyle(mobile ? 34 : 56),
                    ),
                    const SizedBox(height: 22),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: const Text(
                        'I\'m open to senior mobile engineering roles and freelance work — from MVPs for startups to scaling existing Flutter apps. Whether it\'s a question or an idea, my inbox is always open.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 17,
                          height: 1.65,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        GradientButton(
                          label: 'Say hello',
                          icon: Icons.send_rounded,
                          onTap: () =>
                              openUrl('mailto:${PortfolioData.email}'),
                        ),
                        GradientButton(
                          label: 'Connect on LinkedIn',
                          icon: Icons.north_east_rounded,
                          outlined: true,
                          onTap: () => openUrl(PortfolioData.linkedin),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: const [
                        _ContactTile(
                          icon: FontAwesomeIcons.envelope,
                          label: 'Email',
                          value: PortfolioData.email,
                          url: 'mailto:${PortfolioData.email}',
                        ),
                        _ContactTile(
                          icon: FontAwesomeIcons.phone,
                          label: 'Phone',
                          value: PortfolioData.phone,
                          url: 'tel:${PortfolioData.phone}',
                        ),
                        _ContactTile(
                          icon: FontAwesomeIcons.github,
                          label: 'GitHub',
                          value: 'ajithkp05',
                          url: PortfolioData.github,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 80),
          const _Footer(),
        ],
      ),
    );
  }
}

class _ContactTile extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final String value;
  final String url;

  const _ContactTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.url,
  });

  @override
  State<_ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<_ContactTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => openUrl(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: _hovered ? 0.06 : 0.02),
            border: Border.all(
              color: _hovered ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              FaIcon(widget.icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.label,
                        style: monoStyle(11, color: AppColors.textMuted)),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: 'Copy',
                child: IconButton(
                  icon: const Icon(Icons.copy_rounded,
                      size: 16, color: AppColors.textMuted),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.card,
                        behavior: SnackBarBehavior.floating,
                        width: 280,
                        content: Text('${widget.label} copied',
                            style:
                                const TextStyle(color: AppColors.textPrimary)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: AppColors.border),
        const SizedBox(height: 28),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            Text('Designed & built with',
                style: monoStyle(13, color: AppColors.textMuted)),
            const FlutterLogo(size: 14),
            Text('Flutter by ${PortfolioData.name}',
                style: monoStyle(13, color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 8),
        Text('© ${DateTime.now().year} · All rights reserved',
            style: monoStyle(12, color: AppColors.textMuted)),
        const SizedBox(height: 32),
      ],
    );
  }
}
