import 'package:flutter/material.dart';
import '../config/theme.dart';

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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minWidth: 92),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  route,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.17,
                color: AppColors.ink,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'away',
              style: TextStyle(
                fontSize: 10.5,
                color: AppColors.faint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
