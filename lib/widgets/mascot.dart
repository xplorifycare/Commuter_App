import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Recurring continuous-stroke bus mascot from GetMyBusApp_v4.jsx.
/// Used across empty and off-hours states.
class Mascot extends StatelessWidget {
  final double size;
  final Color? color;

  const Mascot({
    super.key,
    this.size = 46,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);
    final mascotColor = color ?? tokens.warm;

    return CustomPaint(
      size: Size(size, size),
      painter: _MascotPainter(color: mascotColor),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final Color color;

  const _MascotPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / 48.0;
    canvas.save();
    canvas.scale(scale, scale);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.75
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // 1. Bus outer body: M10 30 V16 a4 4 0 0 1 4 -4 h20 a4 4 0 0 1 4 4 v14
    path.moveTo(10, 30);
    path.lineTo(10, 16);
    path.arcToPoint(
      const Offset(14, 12),
      radius: const Radius.circular(4),
      clockwise: true,
    );
    path.lineTo(34, 12);
    path.arcToPoint(
      const Offset(38, 16),
      radius: const Radius.circular(4),
      clockwise: true,
    );
    path.lineTo(38, 30);

    // 2. Bottom body line: M10 30 h28
    path.moveTo(10, 30);
    path.lineTo(38, 30);

    // 3. Left wheel: M10 30 a3 3 0 1 0 6 0
    path.moveTo(10, 30);
    path.arcToPoint(
      const Offset(16, 30),
      radius: const Radius.circular(3),
      clockwise: false,
    );

    // 4. Right wheel: M32 30 a3 3 0 1 0 6 0
    path.moveTo(32, 30);
    path.arcToPoint(
      const Offset(38, 30),
      radius: const Radius.circular(3),
      clockwise: false,
    );

    // 5. Windshield line: M14 22 h20
    path.moveTo(14, 22);
    path.lineTo(34, 22);

    // 6. Left window divider: M16 12 v8
    path.moveTo(16, 12);
    path.lineTo(16, 20);

    // 7. Right window divider: M32 12 v8
    path.moveTo(32, 12);
    path.lineTo(32, 20);

    // 8. Smile curve 1: M18.5 35.5 c 1.4 1.3 2.9 1.3 4.3 0
    path.moveTo(18.5, 35.5);
    path.cubicTo(19.9, 36.8, 21.4, 36.8, 22.8, 35.5);

    // 9. Smile curve 2: M25.2 35.5 c 1.4 1.3 2.9 1.3 4.3 0
    path.moveTo(25.2, 35.5);
    path.cubicTo(26.6, 36.8, 28.1, 36.8, 29.5, 35.5);

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
