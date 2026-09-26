import 'package:flutter/material.dart';
import '../config/theme.dart';

enum CrowdGaugeSize { sm, md }

class CrowdGauge extends StatelessWidget {
  final String level;
  final Color color;
  final bool showLabel;
  final CrowdGaugeSize size;

  const CrowdGauge({
    super.key,
    required this.level,
    required this.color,
    this.showLabel = true,
    this.size = CrowdGaugeSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final int filled = level == 'Low'
        ? 1
        : level == 'Medium'
            ? 2
            : 3;
    final double barW = size == CrowdGaugeSize.sm ? 14 : 20;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Container(
              margin: EdgeInsets.only(right: i < 2 ? 3 : 0),
              width: barW,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: i < filled ? color : AppColors.line,
              ),
            );
          }),
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            level,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ],
    );
  }
}
