import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/about_section.dart';
import '../widgets/animated_background.dart';
import '../widgets/certifications_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/projects_section.dart';
import '../widgets/stats_marquee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _sections = [
    'About',
    'Experience',
    'Projects',
    'Certifications',
    'Contact',
  ];

  final ScrollController _scroll = ScrollController();
  final ValueNotifier<Offset?> _pointer = ValueNotifier(null);
  final List<GlobalKey> _keys = List.generate(_sections.length, (_) => GlobalKey());

  int _active = -1;
  double _progress = 0;
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = _scroll.position;
    final progress =
        pos.maxScrollExtent > 0 ? pos.pixels / pos.maxScrollExtent : 0.0;
    final viewport = MediaQuery.sizeOf(context).height;

    var active = -1;
    for (var i = 0; i < _keys.length; i++) {
      final box = _keys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      if (box.localToGlobal(Offset.zero).dy < viewport * 0.4) active = i;
    }
    if (pos.pixels >= pos.maxScrollExtent - 4) active = _keys.length - 1;

    final scrolled = pos.pixels > 20;
    if (active != _active ||
        scrolled != _scrolled ||
        (progress - _progress).abs() > 0.002) {
      setState(() {
        _active = active;
        _scrolled = scrolled;
        _progress = progress;
      });
    }
  }

  void _scrollTo(int index) {
    final ctx = _keys[index].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToTop() {
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MouseRegion(
        onHover: (e) => _pointer.value = e.position,
        onExit: (_) => _pointer.value = null,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBackground(
                scrollController: _scroll,
                pointer: _pointer,
              ),
            ),
            ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  children: [
                    HeroSection(onViewWork: () => _scrollTo(2)),
                    const TechMarquee(),
                    const SizedBox(height: 100),
                    const StatsStrip(),
                    const SizedBox(height: 140),
                    AboutSection(key: _keys[0]),
                    const SizedBox(height: 160),
                    ExperienceSection(key: _keys[1]),
                    const SizedBox(height: 140),
                    ProjectsSection(key: _keys[2]),
                    const SizedBox(height: 160),
                    CertificationsSection(key: _keys[3]),
                    const SizedBox(height: 160),
                    ContactSection(key: _keys[4]),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: NavBar(
                sections: _sections,
                activeIndex: _active,
                progress: _progress,
                scrolled: _scrolled,
                onSelect: _scrollTo,
                onLogoTap: _scrollToTop,
              ),
            ),
            Positioned(
              right: 24,
              bottom: 24,
              child: AnimatedScale(
                scale: _progress > 0.08 ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: _BackToTop(progress: _progress, onTap: _scrollToTop),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackToTop extends StatelessWidget {
  final double progress;
  final VoidCallback onTap;

  const _BackToTop({required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                  backgroundColor: AppColors.border,
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.card,
                ),
                child: const Icon(Icons.arrow_upward_rounded,
                    color: AppColors.textPrimary, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
