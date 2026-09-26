import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Reusable route badge — background/text tint derived from the
/// route's fixed color in AppColors.routeColors rather than always primary.
class RouteBadge extends StatelessWidget {
  final String num;
  final double size;

  const RouteBadge({
    super.key,
    required this.num,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = AppColors.getRouteColor(num);
    final double radius = size >= 34 ? 12 : 10;
    final double fontSize = size >= 34 ? 13 : 12;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10), // #RRGGBB1A (10% tint)
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text(
          num,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
