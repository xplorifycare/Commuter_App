import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/theme.dart';

// 1. FLOATING BOUNCE MICRO-ANIMATION WRAPPER
class FloatingBounce extends StatefulWidget {
  final Widget child;
  final double verticalOffset;
  final double? maxOffset;
  final Duration duration;
  final double delayFraction;

  const FloatingBounce({
    super.key,
    required this.child,
    this.verticalOffset = 5.0,
    this.maxOffset,
    this.duration = const Duration(milliseconds: 2400),
    this.delayFraction = 0.0,
  });

  @override
  State<FloatingBounce> createState() => _FloatingBounceState();
}

class _FloatingBounceState extends State<FloatingBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final val = _controller.value;
        final curved = math.sin((val + widget.delayFraction) * math.pi);
        final offset = widget.maxOffset ?? widget.verticalOffset;
        return Transform.translate(
          offset: Offset(0, curved * offset),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// 2. LIVE TELEMATICS SIGNAL EQUALIZER BARS
class LiveTelematicsWave extends StatefulWidget {
  final Color color;
  final double height;
  final double width;
  final int barCount;

  const LiveTelematicsWave({
    super.key,
    this.color = AppColors.statusLive,
    this.height = 14,
    this.width = 18,
    this.barCount = 4,
  });

  @override
  State<LiveTelematicsWave> createState() => _LiveTelematicsWaveState();
}

class _LiveTelematicsWaveState extends State<LiveTelematicsWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _EqualizerPainter(
            progress: _controller.value,
            color: widget.color,
            barCount: widget.barCount,
          ),
        );
      },
    );
  }
}

class _EqualizerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int barCount;

  _EqualizerPainter({
    required this.progress,
    required this.color,
    this.barCount = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;

    final count = math.max(2, barCount);
    final spacing = size.width / (count - 1);

    for (int i = 0; i < count; i++) {
      final x = i * spacing;
      final phase = i * (1.0 / count);
      final heightFactor = 0.3 + 0.7 * (0.5 + 0.5 * math.sin((progress + phase) * 2 * math.pi)).abs();
      final barH = size.height * heightFactor;
      final y1 = size.height - barH;
      final y2 = size.height;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _EqualizerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// 3. ANIMATED RADAR SWEEP BEACON
class AnimatedRadarBeacon extends StatefulWidget {
  final double size;
  final Color color;

  const AnimatedRadarBeacon({
    super.key,
    this.size = 28,
    this.color = AppColors.brandBlue,
  });

  @override
  State<AnimatedRadarBeacon> createState() => _AnimatedRadarBeaconState();
}

class _AnimatedRadarBeaconState extends State<AnimatedRadarBeacon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _RadarBeaconPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _RadarBeaconPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RadarBeaconPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Center solid dot
    final centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerPaint);

    // 2 expanding wave rings
    for (int i = 0; i < 2; i++) {
      final ringProgress = (progress + (i * 0.5)) % 1.0;
      final radius = maxRadius * ringProgress;
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0);

      final ringPaint = Paint()
        ..color = color.withOpacity(opacity * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8;

      canvas.drawCircle(center, radius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarBeaconPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// 4. ANIMATED NFC WAVES GRAPHIC DRAWING
class AnimatedNfcWaves extends StatefulWidget {
  final Color color;
  final double size;

  const AnimatedNfcWaves({
    super.key,
    this.color = AppColors.brandCyan,
    this.size = 54,
  });

  @override
  State<AnimatedNfcWaves> createState() => _AnimatedNfcWavesState();
}

class _AnimatedNfcWavesState extends State<AnimatedNfcWaves>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _NfcWavesPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _NfcWavesPainter extends CustomPainter {
  final double progress;
  final Color color;

  _NfcWavesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final arcCenter = Offset(0, size.height);
    const waveCount = 3;

    for (int i = 0; i < waveCount; i++) {
      final waveOffset = (progress + (i / waveCount)) % 1.0;
      final radius = (size.width * 0.3) + (size.width * 0.7 * waveOffset);
      final alpha = (1.0 - waveOffset).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withOpacity(alpha * 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: arcCenter, radius: radius);
      canvas.drawArc(rect, -math.pi / 2, math.pi / 2, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NfcWavesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// 5. LASER SCANNING BEAM GRAPHIC (For Dynamic QR Tickets)
class LaserScanBeam extends StatefulWidget {
  final double? width;
  final double? height;
  final Color? beamColor;
  final Color? laserColor;
  final Color? bracketColor;

  const LaserScanBeam({
    super.key,
    this.width,
    this.height,
    this.beamColor,
    this.laserColor,
    this.bracketColor,
  });

  @override
  State<LaserScanBeam> createState() => _LaserScanBeamState();
}

class _LaserScanBeamState extends State<LaserScanBeam>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = widget.width ?? (constraints.hasBoundedWidth ? constraints.maxWidth : 170.0);
        final h = widget.height ?? (constraints.hasBoundedHeight ? constraints.maxHeight : 170.0);
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size(w, h),
              painter: _LaserBeamPainter(
                yRatio: _controller.value,
                laserColor: widget.laserColor ?? widget.beamColor ?? AppColors.brandBlue,
                bracketColor: widget.bracketColor ?? widget.laserColor ?? widget.beamColor ?? AppColors.brandBlue,
              ),
            );
          },
        );
      },
    );
  }
}

class _LaserBeamPainter extends CustomPainter {
  final double yRatio;
  final Color laserColor;
  final Color bracketColor;

  _LaserBeamPainter({
    required this.yRatio,
    required this.laserColor,
    required this.bracketColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * yRatio;

    // Glowing vertical gradient curtain
    final curtainRect = Rect.fromLTRB(0, math.max(0, y - 28), size.width, y);
    final curtainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          laserColor.withOpacity(0.0),
          laserColor.withOpacity(0.20),
        ],
      ).createShader(curtainRect);
    canvas.drawRect(curtainRect, curtainPaint);

    // Laser Beam Line
    final beamPaint = Paint()
      ..color = laserColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);
    canvas.drawLine(Offset(0, y), Offset(size.width, y), beamPaint);

    // Corner target brackets [ ]
    final bracketPaint = Paint()
      ..color = bracketColor.withOpacity(0.65)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const bLen = 14.0;
    // Top-left
    canvas.drawLine(const Offset(0, 0), const Offset(bLen, 0), bracketPaint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, bLen), bracketPaint);
    // Top-right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - bLen, 0), bracketPaint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, bLen), bracketPaint);
    // Bottom-left
    canvas.drawLine(Offset(0, size.height), Offset(bLen, size.height), bracketPaint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - bLen), bracketPaint);
    // Bottom-right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - bLen, size.height), bracketPaint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - bLen), bracketPaint);
  }

  @override
  bool shouldRepaint(covariant _LaserBeamPainter oldDelegate) =>
      oldDelegate.yRatio != yRatio ||
      oldDelegate.laserColor != laserColor ||
      oldDelegate.bracketColor != bracketColor;
}

// 6. KERALA TRANSIT CORRIDOR SCHEMATIC GRAPHIC (Vector Drawing)
class TransitCorridorGraphic extends StatefulWidget {
  final String activeBus;
  final String nextStop;
  final String eta;
  final VoidCallback? onViewFullRoute;

  const TransitCorridorGraphic({
    super.key,
    this.activeBus = 'Venad Fast Passenger',
    this.nextStop = 'Chathannoor Jn',
    this.eta = '8 min',
    this.onViewFullRoute,
  });

  @override
  State<TransitCorridorGraphic> createState() => _TransitCorridorGraphicState();
}

class _TransitCorridorGraphicState extends State<TransitCorridorGraphic>
    with SingleTickerProviderStateMixin {
  late AnimationController _busMoveController;

  @override
  void initState() {
    super.initState();
    _busMoveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _busMoveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onViewFullRoute,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.brandBlueLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.alt_route_rounded,
                          size: 16, color: AppColors.brandBlue),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NH66 Transit Line Schematic',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        '${widget.activeBus} • Live Corridor',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.statusLive.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LiveTelematicsWave(
                      color: AppColors.statusLive,
                      height: 10,
                      width: 12,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'ETA ${widget.eta}',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.statusLive,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Custom Vector Graphic Drawing of the Route
          SizedBox(
            height: 68,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _busMoveController,
              builder: (context, _) {
                return CustomPaint(
                  size: const Size(double.infinity, 68),
                  painter: _CorridorSchematicPainter(
                    busProgress: _busMoveController.value,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Stop Labels Row
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mayyanad',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Kottiyam',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Chathannoor',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brandBlue,
                ),
              ),
              Text(
                'Technopark',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}

class _CorridorSchematicPainter extends CustomPainter {
  final double busProgress;

  _CorridorSchematicPainter({required this.busProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * 0.45;
    final w = size.width;

    // 1. Background Inactive Route Line
    final trackPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(12, y), Offset(w - 12, y), trackPaint);

    // 2. Active Gradient Route Line (Up to bus position)
    final busX = 12 + (w - 24) * busProgress;
    final activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.brandBlue, AppColors.brandCyan],
      ).createShader(Rect.fromLTRB(12, y - 3, busX, y + 3))
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(12, y), Offset(busX, y), activePaint);

    // 3. Four Station Stop Node Circles
    final stopPoints = [
      Offset(12, y),
      Offset(12 + (w - 24) * 0.33, y),
      Offset(12 + (w - 24) * 0.66, y),
      Offset(w - 12, y),
    ];

    for (int i = 0; i < stopPoints.length; i++) {
      final pt = stopPoints[i];
      final isPassed = pt.dx <= busX;

      // Outer glow/ring
      final ringPaint = Paint()
        ..color = isPassed ? AppColors.brandBlue : const Color(0xFFCBD5E1)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pt, 6.5, ringPaint);

      // Inner white center
      final centerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(pt, 3, centerPaint);
    }

    // 4. Moving 3D Bus Beacon
    final haloPaint = Paint()
      ..color = AppColors.brandCyan.withOpacity(0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(busX, y), 13, haloPaint);

    final busRect = Rect.fromCircle(center: Offset(busX, y), radius: 8.5);
    final busDiscPaint = Paint()
      ..shader = const RadialGradient(
        colors: [AppColors.brandCyan, AppColors.brandBlue],
      ).createShader(busRect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(busX, y), 8.5, busDiscPaint);

    final busCore = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(busX, y), 3.5, busCore);
  }

  @override
  bool shouldRepaint(covariant _CorridorSchematicPainter oldDelegate) =>
      oldDelegate.busProgress != busProgress;
}
