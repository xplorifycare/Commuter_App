import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class AmbientBackground extends StatefulWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient: Soft Blue at top 30%, clean white below
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.32, 0.33, 1.0],
                colors: [
                  Color(0xFFEBF3FF), // Soft blue tint at the very top
                  Color(0xFFFAFBFF), // Fade to clean greyish white
                  Color(0xFFFAFBFF), // Pure background color
                  Color(0xFFFAFBFF), // Pure background color
                ],
              ),
            ),
          ),
          
          // Ambient blurred blobs locked in the top 30%
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final angle = _controller.value * 2 * math.pi;
              
              // Drift offsets restricted strictly to the top area (y-axis range 0 to 0.25)
              final blob1X = 0.65 + 0.15 * math.cos(angle);
              final blob1Y = 0.08 + 0.05 * math.sin(angle);
              
              final blob2X = 0.2 + 0.1 * math.sin(angle + math.pi / 2);
              final blob2Y = 0.12 + 0.05 * math.cos(angle + math.pi / 2);

              final blob3X = 0.8 + 0.1 * math.cos(angle * 2);
              final blob3Y = 0.22 + 0.04 * math.sin(angle * 2);

              return Stack(
                children: [
                  // Blob 1: Royal Blue Glow (Top Right)
                  Positioned(
                    left: screenWidth * blob1X - 160,
                    top: screenHeight * blob1Y - 160,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2563EB).withOpacity(0.12),
                      ),
                    ),
                  ),
                  // Blob 2: Cyan Glow (Top Left)
                  Positioned(
                    left: screenWidth * blob2X - 160,
                    top: screenHeight * blob2Y - 160,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF06B6D4).withOpacity(0.14),
                      ),
                    ),
                  ),
                  // Blob 3: Light Blue Glow (Top Center-Right)
                  Positioned(
                    left: screenWidth * blob3X - 140,
                    top: screenHeight * blob3Y - 140,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFDCEBFF).withOpacity(0.18),
                      ),
                    ),
                  ),
                  // Soft blur filter over the top region
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 65.0, sigmaY: 65.0),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          
          // Content overlay
          Positioned.fill(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
