import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Shimmering skeleton block for smooth loading states (v4).
class Skeleton extends StatefulWidget {
  final double? width;
  final double height;
  final double? radius;

  const Skeleton({
    super.key,
    this.width,
    this.height = 14,
    this.radius,
  });

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);
    final borderRadius = BorderRadius.circular(widget.radius ?? AppRadius.chip);

    final baseColor = tokens.isDark ? const Color(0xFF1C2130) : const Color(0xFFEEF0F4);
    final highlightColor = tokens.isDark ? const Color(0xFF262C3C) : const Color(0xFFE2E5EE);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-2.0 + (_controller.value * 4.0), 0),
              end: Alignment(-1.0 + (_controller.value * 4.0), 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Home screen shimmer skeleton layout from GetMyBusApp_v4.jsx
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 100),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 92, height: 12, radius: AppRadius.chip),
                SizedBox(height: 8),
                Skeleton(width: 150, height: 22, radius: 6),
              ],
            ),
            Skeleton(width: 20, height: 20, radius: 999),
          ],
        ),
        SizedBox(height: 26),
        Skeleton(height: 50, radius: AppRadius.card),
        SizedBox(height: 26),
        Skeleton(height: 190, radius: AppRadius.sheet),
        SizedBox(height: 26),
        Row(
          children: [
            Expanded(child: Skeleton(height: 54, radius: AppRadius.card)),
            SizedBox(width: 12),
            Expanded(child: Skeleton(height: 54, radius: AppRadius.card)),
            SizedBox(width: 12),
            Expanded(child: Skeleton(height: 54, radius: AppRadius.card)),
          ],
        ),
        SizedBox(height: 26),
        Skeleton(height: 92, radius: AppRadius.card),
        SizedBox(height: 26),
        Skeleton(height: 80, radius: AppRadius.sheet),
      ],
    );
  }
}

/// Search results shimmer skeleton from GetMyBusApp_v4.jsx
class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (i) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              Skeleton(width: 38, height: 38, radius: AppRadius.chip),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(width: 140, height: 13, radius: AppRadius.chip),
                    SizedBox(height: 6),
                    Skeleton(width: 90, height: 11, radius: AppRadius.chip),
                  ],
                ),
              ),
              Skeleton(width: 44, height: 16, radius: AppRadius.chip),
            ],
          ),
        );
      }),
    );
  }
}
