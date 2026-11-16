import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../constants/colors.dart';
import '../constants/data.dart';
import 'common/reveal.dart';
import 'common/ui.dart';

class StatsStrip extends StatelessWidget {
  const StatsStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = context.isMobile;
    return ContentWidth(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = mobile ? 2 : 4;
          final width = (constraints.maxWidth - 20 * (columns - 1)) / columns;
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              for (var i = 0; i < PortfolioData.stats.length; i++)
                SizedBox(
                  width: width,
                  child: Reveal(
                    delay: Duration(milliseconds: 120 * i),
                    duration: const Duration(milliseconds: 1600),
                    child: HoverCard(
                      padding: EdgeInsets.all(mobile ? 20 : 28),
                      glow: [
                        AppColors.primary,
                        AppColors.violet,
                        AppColors.secondary,
                        AppColors.amber,
                      ][i],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: AppColors.brandGradient.createShader,
                            child: CountUp(
                              value: PortfolioData.stats[i].value,
                              suffix: PortfolioData.stats[i].suffix,
                              style: headingStyle(mobile ? 36 : 52),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            PortfolioData.stats[i].label,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Endlessly scrolling band of technologies.
class TechMarquee extends StatefulWidget {
  const TechMarquee({super.key});

  @override
  State<TechMarquee> createState() => _TechMarqueeState();
}

class _TechMarqueeState extends State<TechMarquee>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      final dt = (elapsed - _last).inMicroseconds / 1e6;
      _last = elapsed;
      if (_paused ||
          !_controller.hasClients ||
          !_controller.position.hasContentDimensions) {
        return;
      }
      _controller.jumpTo(_controller.offset + 50 * dt);
    })
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = PortfolioData.marquee;
    return MouseRegion(
      onEnter: (_) => _paused = true,
      onExit: (_) => _paused = false,
      child: Transform.rotate(
        angle: -0.02,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.08),
                AppColors.violet.withValues(alpha: 0.12),
                AppColors.secondary.withValues(alpha: 0.08),
              ],
            ),
            border: const Border.symmetric(
              horizontal: BorderSide(color: AppColors.border),
            ),
          ),
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => const LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white,
                Colors.white,
                Colors.transparent,
              ],
              stops: [0, 0.1, 0.9, 1],
            ).createShader(rect),
            child: ListView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Text(
                        items[i % items.length],
                        style: headingStyle(22,
                            color: i.isEven
                                ? AppColors.textPrimary
                                : AppColors.textSecondary),
                      ),
                      const SizedBox(width: 56),
                      const Text('✦',
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
