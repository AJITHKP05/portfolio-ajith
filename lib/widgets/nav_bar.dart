import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/ui.dart';

/// Floating glass navigation bar with active-section highlight and a
/// gradient scroll-progress indicator.
class NavBar extends StatelessWidget {
  final List<String> sections;
  final int activeIndex;
  final double progress;
  final bool scrolled;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogoTap;

  const NavBar({
    super.key,
    required this.sections,
    required this.activeIndex,
    required this.progress,
    required this.scrolled,
    required this.onSelect,
    required this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    final compact = !context.isDesktop;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: scrolled ? 16 : 0, sigmaY: scrolled ? 16 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: scrolled ? 0.7 : 0),
            border: Border(
              bottom: BorderSide(
                color: scrolled ? AppColors.border : Colors.transparent,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ContentWidth(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(vertical: scrolled ? 14 : 24),
                  child: Row(
                    children: [
                      _Logo(onTap: onLogoTap),
                      const Spacer(),
                      if (compact)
                        IconButton(
                          icon: const Icon(Icons.menu_rounded,
                              color: AppColors.textPrimary),
                          onPressed: () => _openMenu(context),
                        )
                      else ...[
                        for (var i = 0; i < sections.length; i++)
                          _NavLink(
                            label: sections[i],
                            active: i == activeIndex,
                            onTap: () => onSelect(i),
                          ),
                        const SizedBox(width: 16),
                        _ResumeButton(),
                      ],
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress.clamp(0, 1),
                  child: Container(
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'menu',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, _, _) => Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: AppColors.surface,
          child: SizedBox(
            width: 280,
            height: double.infinity,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.textPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 24),
                    for (var i = 0; i < sections.length; i++)
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onSelect(i);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                sections[i],
                                style: TextStyle(
                                  color: i == activeIndex
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    GradientButton(
                      label: 'Resume',
                      icon: Icons.download_rounded,
                      onTap: openResume,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      transitionBuilder: (context, animation, _, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;
  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('AK', style: headingStyle(16, color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Text(PortfolioData.name, style: headingStyle(18).copyWith(letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = _hovered || widget.active;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: highlighted
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                width: widget.active ? 28 : (_hovered ? 14 : 0),
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumeButton extends StatefulWidget {
  @override
  State<_ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends State<_ResumeButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: openResume,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.primary),
            color: AppColors.primary.withValues(alpha: _hovered ? 0.15 : 0),
          ),
          child: Text('Resume', style: monoStyle(14)),
        ),
      ),
    );
  }
}
