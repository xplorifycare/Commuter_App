import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import '../config/theme.dart';
import '../data/corridor_route.dart';
import '../widgets/illustration_placeholder.dart';

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
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;
  late final List<LatLng> _routePoints;
  bool _showInteractiveMap = true;

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
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _recenterMap() {
    _mapController.move(_busPosition, 14.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 19,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Live tracking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.16,
                    color: AppColors.ink,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showInteractiveMap = !_showInteractiveMap;
                    });
                    _recenterMap();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 2. Map / Illustration Spot (height 200)
            if (_showInteractiveMap)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.line),
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
                              color: AppColors.primary,
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
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
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
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: const Text(
                            'Placeholder view',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.sub,
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
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.tint,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          widget.routeId,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'To ${widget.destination}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'via Kadappakada Rd',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.sub,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '4 min',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      '1.2 km away',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.faint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Crowd Level Indicator
            Row(
              children: [
                const Text(
                  'Crowd level',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.sub,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 20,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 20,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Low',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // 5. Route Stops Section
            const Text(
              'Route stops',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
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
                  dotBg = Colors.white;
                  dotBorder = Border.all(color: AppColors.primary, width: 2);
                } else if (state == 'current') {
                  dotBg = AppColors.primary;
                  dotBorder = Border.all(color: AppColors.primary, width: 2);
                } else {
                  dotBg = AppColors.primary;
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
                          Container(
                            width: 1,
                            height: 44,
                            color: AppColors.line,
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s['meta']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.faint,
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
