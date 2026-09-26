import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Live pulsing indicator dot with radiating outer ring (v4).
class PulseDot extends StatefulWidget {
  final Color? color;
  final double size;

  const PulseDot({
    super.key,
    this.color,
    this.size = 6,
  });

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
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
    final dotColor = widget.color ?? tokens.success;
    final outerSize = widget.size + 8;

    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radiating outer pulse ring
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final scale = 0.6 + (_controller.value * 1.4); // 0.6 to 2.0
              final opacity = (1.0 - _controller.value) * 0.9; // 0.9 to 0.0
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size + 4,
                  height: widget.size + 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dotColor.withOpacity(opacity.clamp(0.0, 1.0)),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            },
          ),
          // Solid center dot
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
        ],
      ),
    );
  }
}
