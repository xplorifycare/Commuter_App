import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Small horizontal-scroll chip used in the Home "Live rail" (v4).
/// Features a 3px per-route color accent strip along the top border.
class LiveRailChip extends StatelessWidget {
  final String route;
  final String eta;
  final Color crowdColor;
  final VoidCallback? onTap;

  const LiveRailChip({
    super.key,
    required this.route,
    required this.eta,
    required this.crowdColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);
    final Color routeColor = tokens.getRouteColor(route);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          constraints: const BoxConstraints(minWidth: 92),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: tokens.line),
            color: tokens.surface,
          ),
          child: Stack(
            children: [
              // Top 3px per-route accent strip
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 3,
                child: Container(
                  color: routeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          route,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: routeColor,
                          ),
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: crowdColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      eta,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.17,
                        color: tokens.ink,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'away',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: tokens.faint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
