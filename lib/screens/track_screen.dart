import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import '../widgets/glass_card.dart';

class TrackScreen extends StatefulWidget {
  final String busName;

  const TrackScreen({super.key, required this.busName});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> with TickerProviderStateMixin {
  late AnimationController _mapAnimationController;
  late AnimationController _pulseController;
  
  bool _arrivalAlertEnabled = true;
  int _alertStopsCount = 2; // 1 stop, 2 stops, 5 min
  int _etaMinutes = 4;
  String _distanceAway = '650 m';
  
  // Dynamic Walking Countdown state based on animation progress
  String _walkTitle = '🟢 Relax';
  String _walkMessage = 'Start walking in 2 min (Bus arrives in 4 min)';
  Color _walkColor = const Color(0xFF00C853);
  IconData _walkIcon = Icons.spa_rounded;

  @override
  void initState() {
    super.initState();
    
    // Smooth bus animation along road network path
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();

    // Pulse effects
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Simulated real-time coordinate updates updating ETA, distance, and walking suggestions
    _mapAnimationController.addListener(() {
      final double val = _mapAnimationController.value;
      setState(() {
        if (val < 0.35) {
          _etaMinutes = 4;
          _distanceAway = '650 m';
          _walkTitle = '🟢 Relax';
          _walkMessage = 'Start walking in 2 min (Bus arrives in 4 min)';
          _walkColor = const Color(0xFF00C853);
          _walkIcon = Icons.spa_rounded;
        } else if (val < 0.65) {
          _etaMinutes = 3;
          _distanceAway = '480 m';
          _walkTitle = '🚶 Start Walking Now';
          _walkMessage = '120 m • 2 min walk (Bus arriving in 3 min)';
          _walkColor = const Color(0xFFFF9F0A);
          _walkIcon = Icons.directions_walk_rounded;
        } else if (val < 0.85) {
          _etaMinutes = 1;
          _distanceAway = '150 m';
          _walkTitle = '⚡ Boarding Soon';
          _walkMessage = 'Bus is approaching Mayyanad Stop';
          _walkColor = const Color(0xFF2563EB);
          _walkIcon = Icons.run_circle_rounded;
        } else {
          _etaMinutes = 0;
          _distanceAway = 'Arrived';
          _walkTitle = '🟢 Reached Stop';
          _walkMessage = 'Venad Express is ready to board';
          _walkColor = const Color(0xFF00C853);
          _walkIcon = Icons.check_circle_rounded;
        }
      });
    });
  }

  @override
  void dispose() {
    _mapAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFF),
      body: Stack(
        children: [
          // ── 1. FULL SCREEN REALISTIC MAP ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([_mapAnimationController, _pulseController]),
              builder: (context, child) {
                return CustomPaint(
                  painter: RealisticMapPainter(
                    busProgress: _mapAnimationController.value,
                    pulseValue: _pulseController.value,
                    etaText: '$_etaMinutes min',
                  ),
                );
              },
            ),
          ),

          // ── FLOATING MAP CONTROLS (Right hand side overlay) ──
          Positioned(
            right: 16,
            top: screenHeight * 0.32,
            child: Column(
              children: [
                _buildMapFloatingControl(Icons.explore_rounded, 'Compass'),
                const SizedBox(height: 12),
                _buildMapFloatingControl(Icons.traffic_rounded, 'Traffic'),
                const SizedBox(height: 12),
                _buildMapFloatingControl(Icons.gps_fixed_rounded, 'Center', isActive: true),
              ],
            ),
          ),

          // ── TOP APP BAR ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: _buildTopAppBar(),
          ),

          // ── TOP FLOATING TICKET SUMMARY (Simplified Apple Maps style) ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 78,
            left: 16,
            right: 16,
            child: _buildTopStatusCard(),
          ),

          // ── 2. FULL-HEIGHT DRAGGABLE SHEET OVERLAY ──
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.34,
            maxChildSize: 0.85,
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.06),
                      blurRadius: 32.0,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drag Handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color(0xFF101828).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── 15. UNIQUE WALKING COUNTDOWN WIDGET ──
                          _buildWalkingCountdownWidget(),
                          const SizedBox(height: 20),

                          // Header Status
                          _buildLiveUpdatesHeader(),
                          const SizedBox(height: 20),

                          // Live Info Stats (Crowd and ETA)
                          _buildLiveStatsRow(),
                          const SizedBox(height: 20),

                          // Smart Notifications Alert Choice
                          _buildArrivalAlertCard(),
                          const SizedBox(height: 24),

                          // Dynamic Stop Timeline
                          const Text(
                            'Stops Along Route',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF101828)),
                          ),
                          const SizedBox(height: 16),
                          _buildDynamicStopsTimeline(),
                          const SizedBox(height: 28),

                          // Live Activity Feed Log
                          const Text(
                            'Live Activity Feed',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF101828)),
                          ),
                          const SizedBox(height: 16),
                          _buildLiveActivityFeed(),
                          const SizedBox(height: 28),

                          // Exploration/Navigation Buttons
                          _buildActionButtonsGrid(),
                          const SizedBox(height: 28),

                          // Bottom Gradient Call-to-action
                          _buildBottomActionButton(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101828).withOpacity(0.04),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Color(0xFF101828)),
                ),
              ),
              const Text(
                'Track Live',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF101828), letterSpacing: -0.2),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.notifications_active_rounded, size: 16, color: Color(0xFF2563EB)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopStatusCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 32, // Large rounded corners
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.directions_bus_rounded, color: Color(0xFF2563EB), size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.busName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF101828)),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '$_distanceAway away',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF2563EB)),
                      ),
                      Text(
                        '  •  2 Stops Left',
                        style: TextStyle(fontSize: 12, color: const Color(0xFF101828).withOpacity(0.4), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$_etaMinutes min',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF101828), letterSpacing: -0.5),
              ),
              const SizedBox(height: 2),
              const Text(
                '98% On Time',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF00C853)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapFloatingControl(IconData icon, String label, {bool isActive = false}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2563EB) : Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: isActive ? Colors.white : const Color(0xFF101828), size: 20),
        onPressed: () {},
      ),
    );
  }

  Widget _buildWalkingCountdownWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _walkColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _walkColor.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _walkColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_walkIcon, color: _walkColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _walkTitle,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: _walkColor),
                ),
                const SizedBox(height: 4),
                Text(
                  _walkMessage,
                  style: TextStyle(fontSize: 12, color: const Color(0xFF101828).withOpacity(0.65), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveUpdatesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Running Normally',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF101828)),
            ),
            const SizedBox(height: 2),
            Text(
              'Bus passed Kavanad 12 sec ago',
              style: TextStyle(fontSize: 12, color: const Color(0xFF101828).withOpacity(0.5), fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF00C853).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: Color(0xFF00C853), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              const Text(
                'LIVE UPDATES',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFF00C853), letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatsBlock('ETA', '$_etaMinutes min', Icons.timer_outlined),
        _buildStatsBlock('Distance', _distanceAway, Icons.social_distance_rounded),
        _buildStatsBlock('Crowd Level', '👤👤👤○○ Moderate', Icons.people_rounded),
      ],
    );
  }

  Widget _buildStatsBlock(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF101828).withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: const Color(0xFF2563EB)),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: const Color(0xFF101828).withOpacity(0.4), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF101828)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrivalAlertCard() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F0A).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_active_rounded, color: Color(0xFFFF9F0A), size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Arrival Alert Notifications',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                  ),
                ],
              ),
              Switch(
                value: _arrivalAlertEnabled,
                activeColor: const Color(0xFF2563EB),
                onChanged: (val) {
                  setState(() {
                    _arrivalAlertEnabled = val;
                  });
                },
              ),
            ],
          ),
          if (_arrivalAlertEnabled) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAlertSelectionChip(1, '1 stop before'),
                _buildAlertSelectionChip(2, '2 stops before'),
                _buildAlertSelectionChip(5, '5 min before'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAlertSelectionChip(int count, String label) {
    final isSelected = _alertStopsCount == count;
    return GestureDetector(
      onTap: () {
        setState(() {
          _alertStopsCount = count;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF101828).withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isSelected ? Colors.white : const Color(0xFF101828).withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicStopsTimeline() {
    final stops = [
      {'name': 'Kavanad Stop', 'status': 'Completed', 'time': 'Passed'},
      {'name': 'Mayyanad Stop', 'status': 'Current', 'time': 'Arriving'},
      {'name': 'Chinnakada Stop', 'status': 'Upcoming', 'time': '+6 min'},
      {'name': 'Kollam Railway Station', 'status': 'Upcoming', 'time': '+12 min'},
    ];

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 28,
      child: Column(
        children: stops.map((stop) {
          final isLast = stops.indexOf(stop) == stops.length - 1;
          final status = stop['status'];
          Color textColor = const Color(0xFF101828);
          Color dotColor = const Color(0xFF2563EB);
          
          if (status == 'Completed') {
            textColor = Colors.grey;
            dotColor = Colors.grey.withOpacity(0.5);
          } else if (status == 'Current') {
            textColor = const Color(0xFF2563EB);
            dotColor = const Color(0xFF2563EB);
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (status == 'Current')
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB).withOpacity(0.2 * _pulseController.value),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
                          ),
                        )
                      else
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                        ),
                      const SizedBox(width: 16),
                      Text(
                        stop['name'] as String,
                        style: TextStyle(
                          fontWeight: status == 'Current' ? FontWeight.w900 : FontWeight.bold, 
                          fontSize: 14, 
                          color: textColor
                        ),
                      ),
                    ],
                  ),
                  Text(
                    stop['time'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: status == 'Current' ? const Color(0xFF2563EB) : Colors.grey,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0, top: 4.0, bottom: 4.0),
                      child: Container(
                        width: 2,
                        height: 22,
                        color: status == 'Completed' ? Colors.grey.withOpacity(0.2) : const Color(0xFF2563EB).withOpacity(0.15),
                      ),
                    ),
                  ],
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLiveActivityFeed() {
    final feeds = [
      {'time': '09:42', 'msg': 'Bus crossed Kavanad Stop normally'},
      {'time': '09:44', 'msg': 'Approaching Mayyanad Stop (650 m away)'},
      {'time': '09:47', 'msg': 'Estimated boarding available at Mayyanad Jnc'},
    ];

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 28,
      child: Column(
        children: feeds.map((item) {
          final isLast = feeds.indexOf(item) == feeds.length - 1;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['time']!,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Color(0xFF2563EB)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['msg']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF101828)),
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                const SizedBox(height: 10),
                Divider(color: const Color(0xFF101828).withOpacity(0.04), height: 1),
                const SizedBox(height: 10),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtonsGrid() {
    return Column(
      children: [
        Row(
          children: [
            _buildActionIconBtn(Icons.share_rounded, 'Share Trip'),
            const SizedBox(width: 12),
            _buildActionIconBtn(Icons.phone_rounded, 'Call Support'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionIconBtn(Icons.report_problem_rounded, 'Report Issue'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIconBtn(IconData icon, String label) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        borderRadius: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF2563EB)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF06B6D4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Text(
          'Notify When Arriving',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

// ── CUSTOM PAINTER DRAWING A REAL REALISTIC CITY STREET MAP GRID WITH TOP-DOWN VECTOR VEHICLE ──

class RealisticMapPainter extends CustomPainter {
  final double busProgress;
  final double pulseValue;
  final String etaText;

  RealisticMapPainter({required this.busProgress, required this.pulseValue, required this.etaText});

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background with soft map canvas tone (light warm beige/grey)
    final bgPaint = Paint()..color = const Color(0xFFF1F3F6);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 1. Draw water body (Ashtamudi Lake representation at the top)
    final waterPaint = Paint()
      ..color = const Color(0xFFD2E4FF)
      ..style = PaintingStyle.fill;
    final waterPath = Path();
    waterPath.moveTo(0, size.height * 0.15);
    waterPath.quadraticBezierTo(
      size.width * 0.25, 
      size.height * 0.05, 
      size.width * 0.55, 
      size.height * 0.12
    );
    waterPath.quadraticBezierTo(
      size.width * 0.8, 
      size.height * 0.18, 
      size.width, 
      size.height * 0.05
    );
    waterPath.lineTo(size.width, 0);
    waterPath.lineTo(0, 0);
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    // 2. Draw green zones (Parks representation)
    final greenPaint = Paint()..color = const Color(0xFFE2F0D9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(24, size.height * 0.24, 90, 75), 
        const Radius.circular(16)
      ), 
      greenPaint
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.65, size.height * 0.52, 110, 85), 
        const Radius.circular(16)
      ), 
      greenPaint
    );

    // 3. Draw realistic secondary road grids
    final streetPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..strokeCap = ui.StrokeCap.round;

    final List<List<Offset>> secondaryStreets = [
      [const Offset(0, 160), const Offset(140, 160)],
      [const Offset(140, 160), const Offset(140, 480)],
      [const Offset(80, 240), const Offset(280, 240)],
      [const Offset(220, 120), const Offset(220, 360)],
      [const Offset(0, 340), const Offset(180, 340)],
      [const Offset(180, 340), const Offset(380, 340)],
      [const Offset(290, 220), const Offset(290, 480)],
      [const Offset(100, 420), const Offset(360, 420)],
    ];

    for (var street in secondaryStreets) {
      canvas.drawLine(street[0], street[1], streetPaint);
    }

    // 4. Define MAIN TELEMETRY ROAD PATH (NH 66 Route)
    final routePath = Path();
    // Segmented road coords
    routePath.moveTo(60, size.height * 0.58); // Mayyanad Stop
    routePath.lineTo(140, size.height * 0.44); // Intersection 1
    routePath.lineTo(220, size.height * 0.48); // Intersection 2
    routePath.lineTo(290, size.height * 0.32); // Chinnakada
    routePath.lineTo(330, size.height * 0.22); // Destination approach
    routePath.lineTo(340, size.height * 0.16); // Kollam Junction terminal

    final ui.PathMetrics metrics = routePath.computeMetrics();
    final ui.PathMetric metric = metrics.first;
    final double pathLength = metric.length;
    
    final double busOffset = pathLength * busProgress;
    final ui.Tangent tangent = metric.getTangentForOffset(busOffset)!;
    final Offset busPos = tangent.position;
    
    // Rotation angle of the bus matches tangent vector heading exactly
    final double busHeading = -tangent.vector.direction; 

    // Draw main route background casing
    final roadCasingPaint = Paint()
      ..color = const Color(0xFFD0D7DE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, roadCasingPaint);

    // Draw completed road segment in gray
    final completedPath = metric.extractPath(0, busOffset);
    final completedPaint = Paint()
      ..color = const Color(0xFFBDC7D3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(completedPath, completedPaint);

    // Draw upcoming road segment in solid primary blue
    final upcomingPath = metric.extractPath(busOffset, pathLength);
    final upcomingPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(upcomingPath, upcomingPaint);

    // ── 3. DRAW WALK CONNECTOR (Dashed Blue Walking Route from User -> Stop) ──
    final walkPath = Path();
    final Offset userPos = Offset(60, size.height * 0.65); // User location coordinate
    final Offset stopPos = Offset(60, size.height * 0.58); // Mayyanad Stop
    walkPath.moveTo(userPos.dx, userPos.dy);
    walkPath.lineTo(stopPos.dx, stopPos.dy);

    final walkPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    // Draw dashed pattern for walking
    _drawDashedPath(canvas, walkPath, walkPaint, 4.0, 3.0);

    // 5. Draw Street Labels (Apple Maps style)
    _drawStreetLabel(canvas, 'NH 66', Offset(110, size.height * 0.52), rotation: -0.5);
    _drawStreetLabel(canvas, 'Link Rd', Offset(250, size.height * 0.42), rotation: -0.3);
    _drawStreetLabel(canvas, 'Station Rd', Offset(300, size.height * 0.26), rotation: -1.0);

    // 6. Draw location nodes
    final markerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final markerBorderPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // 4. User location node (You)
    final pulsePaint = Paint()
      ..color = const Color(0xFF2563EB).withOpacity(0.12 * (1 - pulseValue))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(userPos, 14 + 14 * pulseValue, pulsePaint);

    canvas.drawCircle(userPos, 7, markerPaint);
    canvas.drawCircle(userPos, 7, markerBorderPaint);
    canvas.drawCircle(userPos, 3, Paint()..color = const Color(0xFF2563EB));

    // Next stop marker (Mayyanad Junction)
    canvas.drawCircle(stopPos, 5, markerPaint);
    canvas.drawCircle(stopPos, 5, markerBorderPaint);

    // Destination Pin (Kollam Junction)
    final Offset destPos = metric.getTangentForOffset(pathLength)!.position;
    canvas.drawCircle(destPos, 8, Paint()..color = const Color(0xFF101828));
    canvas.drawCircle(destPos, 4, Paint()..color = Colors.white);

    // ── 2. DRAW HEADING-ALIGNED VECTOR TOP-DOWN VEHICLE ──
    canvas.save();
    canvas.translate(busPos.dx, busPos.dy);
    canvas.rotate(busHeading + (math.pi / 2)); // Offset by 90deg to match vertical icon orientation

    // Glow around bus
    canvas.drawCircle(Offset.zero, 18, Paint()..color = const Color(0xFF2563EB).withOpacity(0.18));
    
    // Top-down Bus vector model (Solid Blue RRect chassis)
    final busRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-7, -13, 14, 26), 
      const Radius.circular(3.5)
    );
    canvas.drawRRect(busRect, Paint()..color = const Color(0xFF2563EB));

    // Windscreens and Glass panels
    final windscreen = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-5.5, -10.5, 11, 4.5), 
      const Radius.circular(1.0)
    );
    canvas.drawRRect(windscreen, Paint()..color = Colors.white.withOpacity(0.95));

    final rearScreen = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-5.5, 8.0, 11, 3.5), 
      const Radius.circular(1.0)
    );
    canvas.drawRRect(rearScreen, Paint()..color = Colors.white.withOpacity(0.95));

    // Side mirrors
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-8.5, -9, 1.5, 3.5), const Radius.circular(0.5)),
      Paint()..color = const Color(0xFF101828)
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(7.0, -9, 1.5, 3.5), const Radius.circular(0.5)),
      Paint()..color = const Color(0xFF101828)
    );

    // Front headlights
    canvas.drawCircle(const Offset(-4.5, -12.5), 1.5, Paint()..color = const Color(0xFFFFCC00));
    canvas.drawCircle(const Offset(4.5, -12.5), 1.5, Paint()..color = const Color(0xFFFFCC00));

    canvas.restore();

    // ── 7. DRAW FLOATING ETA BUBBLE NEXT TO BUS ──
    _drawEtaBubble(canvas, busPos + const Offset(20, -22), etaText);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    final ui.PathMetrics pathMetrics = path.computeMetrics();
    for (ui.PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double nextDistance = distance + dashWidth;
        final Path extract = pathMetric.extractPath(distance, nextDistance);
        canvas.drawPath(extract, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  void _drawEtaBubble(Canvas canvas, Offset position, String text) {
    // Draw bubble background (soft white)
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(position.dx - 22, position.dy - 11, 44, 22), 
      const Radius.circular(10)
    );
    
    // Bubble drop shadow
    canvas.drawRRect(
      bubbleRect.shift(const Offset(0, 2)), 
      Paint()..color = Colors.black.withOpacity(0.06)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0)
    );

    // Bubble body
    canvas.drawRRect(bubbleRect, Paint()..color = Colors.white);
    canvas.drawRRect(bubbleRect, Paint()..color = const Color(0xFF2563EB).withOpacity(0.08)..style = PaintingStyle.stroke..strokeWidth = 1.0);

    // Write text
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: 9, 
        fontWeight: FontWeight.w900, 
        color: Color(0xFF2563EB),
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  void _drawStreetLabel(Canvas canvas, String label, Offset position, {required double rotation}) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(rotation);
    
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: label.toUpperCase(),
      style: TextStyle(
        fontSize: 8, 
        fontWeight: FontWeight.w900, 
        color: const Color(0xFF101828).withOpacity(0.3),
        letterSpacing: 1.0,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RealisticMapPainter oldDelegate) {
    return oldDelegate.busProgress != busProgress || oldDelegate.pulseValue != pulseValue || oldDelegate.etaText != etaText;
  }
}
