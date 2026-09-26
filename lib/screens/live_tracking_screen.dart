import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../config/theme.dart';
import '../data/corridor_route.dart';
import '../widgets/crowd_gauge.dart';
import '../widgets/illustration_placeholder.dart';
import '../widgets/pulse_dot.dart';
import '../widgets/route_badge.dart';

class LiveTrackingScreen extends StatefulWidget {
  final String routeId;
  final String busName;
  final String destination;
  final VoidCallback? onBack;

  const LiveTrackingScreen({
    super.key,
    this.routeId = '42',
    this.busName = 'Venad Fast Passenger',
    this.destination = 'Chinnakada',
    this.onBack,
  });

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;
  late final AnimationController _refreshController;
  late final AnimationController _flowController;
  late final List<LatLng> _routePoints;
  bool _showInteractiveMap = true;
  bool _refreshing = false;
  int _eta = 4;

  // Real-time bus simulation point along route
  final LatLng _busPosition = const LatLng(8.8895, 76.6020); // Near Kadappakkada

  final List<Map<String, String>> _stops = const [
    {'name': 'Kollam Bus Stand', 'meta': 'Departed 9:40 AM', 'state': 'done'},
    {'name': 'Kadappakada', 'meta': 'Departed 9:52 AM', 'state': 'done'},
    {'name': 'Thattamala', 'meta': 'ETA 10:02 AM', 'state': 'current'},
    {'name': 'Chinnakada', 'meta': 'ETA 10:11 AM', 'state': 'upcoming'},
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _routePoints = kRealCorridorRoute;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    _refreshController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  void _recenterMap() {
    _mapController.move(_busPosition, 14.5);
  }

  void _doRefresh() {
    setState(() {
      _refreshing = true;
      _eta = _eta > 2 ? _eta - 1 : 4;
    });
    _refreshController.forward(from: 0.0);
    _recenterMap();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _refreshing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Scaffold(
      backgroundColor: tokens.bg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 100),
          physics: const BouncingScrollPhysics(),
          children: [
            // 1. ScreenHeader
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onBack ?? () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 19,
                        color: tokens.ink,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Live tracking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.16,
                    color: tokens.ink,
                  ),
                ),
                GestureDetector(
                  onTap: _doRefresh,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _refreshController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _refreshing
                                ? _refreshController.value * 2 * 3.1415926535
                                : 0.0,
                            child: child,
                          );
                        },
                        child: Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: tokens.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_refreshing) ...[
              const SizedBox(height: 12),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: tokens.line,
                  borderRadius: BorderRadius.circular(999),
                ),
                clipBehavior: Clip.antiAlias,
                child: AnimatedBuilder(
                  animation: _refreshController,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment(
                        -1.0 + (_refreshController.value * 2.0),
                        0.0,
                      ),
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.directions_bus_rounded,
                    size: 14,
                    color: tokens.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ] else ...[
              const SizedBox(height: 22),
            ],

            // 2. Map / Illustration Spot (height 200)
            if (_showInteractiveMap)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sheet),
                  border: Border.all(color: tokens.line),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _busPosition,
                        initialZoom: 14.2,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.all,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'in.getmybus.commuter',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routePoints,
                              strokeWidth: 4.0,
                              color: tokens.primary,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _busPosition,
                              width: 38,
                              height: 38,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: tokens.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x662B57FF),
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.directions_bus_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: PulseDot(color: tokens.primary, size: 8),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showInteractiveMap = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: tokens.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(AppRadius.chip),
                            border: Border.all(color: tokens.line),
                          ),
                          child: Text(
                            'Placeholder view',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: tokens.sub,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              GestureDetector(
                onTap: () => setState(() => _showInteractiveMap = true),
                child: const IllustrationPlaceholder(
                  label: 'Illustration — live map with bus route and marker',
                  height: 200,
                ),
              ),
            const SizedBox(height: 22),

            // 3. Route Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RouteBadge(num: widget.routeId),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To ${widget.destination}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: tokens.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'via Kadappakada Rd',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: tokens.sub,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, -0.2),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: Text(
                        '$_eta min',
                        key: ValueKey<int>(_eta),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: tokens.primary,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '1.2 km away',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: tokens.faint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Unified CrowdGauge Row (v4)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Crowd level',
                  style: TextStyle(
                    fontSize: 13,
                    color: tokens.sub,
                  ),
                ),
                CrowdGauge(
                  level: 'Low',
                  color: tokens.success,
                  size: CrowdGaugeSize.md,
                ),
              ],
            ),
            const SizedBox(height: 26),

            // 5. Route Stops Section with Flowing Dashed Line (v4)
            Text(
              'Route stops',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tokens.ink,
              ),
            ),
            const SizedBox(height: 16),

            // Route Stops Timeline
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _stops.length,
              itemBuilder: (context, i) {
                final s = _stops[i];
                final state = s['state']!;
                final isLast = i == _stops.length - 1;

                Color dotBg;
                Border? dotBorder;

                if (state == 'upcoming') {
                  dotBg = tokens.surface;
                  dotBorder = Border.all(color: tokens.primary, width: 2);
                } else if (state == 'current') {
                  dotBg = tokens.primary;
                  dotBorder = Border.all(color: tokens.primary, width: 2);
                } else {
                  dotBg = tokens.primary;
                  dotBorder = null;
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator column
                    Column(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: dotBg,
                            border: dotBorder,
                          ),
                        ),
                        if (!isLast)
                          state == 'current'
                              ? AnimatedBuilder(
                                  animation: _flowController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 2,
                                      height: 44,
                                      margin: const EdgeInsets.only(top: 3),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(
                                              0, -1.0 + (_flowController.value * 2.0)),
                                          end: Alignment(
                                              0, 1.0 + (_flowController.value * 2.0)),
                                          colors: [
                                            tokens.primary,
                                            tokens.line,
                                            tokens.primary,
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 1,
                                  height: 44,
                                  color: tokens.line,
                                  margin: const EdgeInsets.only(top: 3),
                                ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // Stop title and metadata
                    Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['name']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: tokens.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s['meta']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: tokens.faint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
