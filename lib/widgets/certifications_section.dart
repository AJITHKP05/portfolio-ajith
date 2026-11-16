import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/reveal.dart';
import 'common/ui.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final certs = PortfolioData.certificates;
    return ContentWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            eyebrow: 'Certifications',
            title: 'Learning in the community.',
            subtitle:
                'Participation certificates from developer community events I\'ve been part of.',
          ),
          for (var i = 0; i < certs.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Reveal(
                delay: Duration(milliseconds: 100 * i),
                offset: const Offset(0, 60),
                scale: 0.94,
                child: _CertificateCard(cert: certs[i], reversed: i.isOdd),
              ),
            ),
        ],
      ),
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final Certificate cert;
  final bool reversed;
  const _CertificateCard({required this.cert, this.reversed = false});

  void _openViewer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: cert.title,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, _, _) => SafeArea(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: InteractiveViewer(
                  maxScale: 4,
                  child: Hero(
                    tag: cert.image,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(cert.image),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppColors.card),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
      transitionBuilder: (context, animation, _, child) => FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.92, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = context.isDesktop;

    final preview = ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Hero(
            tag: cert.image,
            child: AspectRatio(
              aspectRatio: cert.aspectRatio,
              child: Image.asset(cert.image, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.zoom_in_rounded,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text('View', style: monoStyle(12, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const TagChip('Participation', color: AppColors.green),
            const SizedBox(width: 10),
            Text(cert.date, style: monoStyle(13, color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 18),
        Text(cert.title, style: headingStyle(desktop ? 30 : 24)),
        const SizedBox(height: 8),
        Text(
          cert.type,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          cert.description,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 22),
        _InfoRow(FontAwesomeIcons.peopleGroup, cert.issuer),
        _InfoRow(FontAwesomeIcons.locationDot, cert.venue),
        const SizedBox(height: 22),
        GradientButton(
          label: 'View certificate',
          icon: Icons.open_in_full_rounded,
          outlined: true,
          onTap: () => _openViewer(context),
        ),
      ],
    );

    return HoverCard(
      glow: AppColors.primary,
      tilt: 0.02,
      onTap: () => _openViewer(context),
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection:
                  reversed ? TextDirection.rtl : TextDirection.ltr,
              children: [
                Expanded(flex: 5, child: preview),
                const SizedBox(width: 40),
                Expanded(flex: 4, child: details),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [preview, const SizedBox(height: 24), details],
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final FaIconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: FaIcon(icon, size: 14, color: AppColors.textMuted),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
