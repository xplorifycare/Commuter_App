import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../config/theme.dart';
import '../widgets/cashless_booking_modal.dart';

class NearbyStopsScreen extends StatefulWidget {
  const NearbyStopsScreen({super.key});

  @override
  State<NearbyStopsScreen> createState() => _NearbyStopsScreenState();
}

class _NearbyStopsScreenState extends State<NearbyStopsScreen>
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;

  String _selectedStop = 'Mayyanad Junction';
  String _selectedFilter = 'All Stops';

  final List<Map<String, dynamic>> _stopsData = [
    {
      'name': 'Mayyanad Junction',
      'point': const LatLng(8.835489, 76.643381),
      'distance': '120 m',
      'walkTime': '2 min walk',
      'busesPerHour': '14 buses/hr',
      'nextBus': 'Venad Fast Passenger',
      'nextEta': '3 min',
      'isClosest': true,
    },
    {
      'name': 'Kottiyam Junction',
      'point': const LatLng(8.8660, 76.6709),
      'distance': '1.8 km',
      'walkTime': '6 min transit',
      'busesPerHour': '22 buses/hr',
      'nextBus': 'Royal King Electric AC',
      'nextEta': '6 min',
      'isHub': true,
    },
    {
      'name': 'Chathannoor Stand',
      'point': const LatLng(8.8576, 76.7235),
      'distance': '4.2 km',
      'walkTime': '12 min transit',
      'busesPerHour': '18 buses/hr',
      'nextBus': 'St. Jude Superfast',
      'nextEta': '9 min',
    },
    {
      'name': 'Parippally Junction',
      'point': const LatLng(8.8091, 76.7628),
      'distance': '8.5 km',
      'walkTime': 'Express stop',
      'busesPerHour': '16 buses/hr',
      'nextBus': 'Kairali Express',
      'nextEta': '14 min',
    },
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onSelectStop(Map<String, dynamic> stop) {
    setState(() {
      _selectedStop = stop['name'] as String;
    });
    _mapController.move(stop['point'] as LatLng, 14.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── 1. REAL OPENSTREETMAP BACKGROUND ──
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(8.8354, 76.6432),
                initialZoom: 13.5,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://mt{s}.google.com/vt/lyrs=m&hl=en&gl=in&x={x}&y={y}&z={z}&scale=2&apistyle=s.t:33|p.v:off,s.t:49|p.v:off,s.t:81|p.v:off,s.t:2|p.v:off,s.t:50|p.v:off',
                  subdomains: const ['0', '1', '2', '3'],
                  userAgentPackageName: 'in.getmybus.app',
                  maxZoom: 20,
                ),
                MarkerLayer(
                  markers: _stopsData.map((stop) {
                    final isSelected = stop['name'] == _selectedStop;
                    return Marker(
                      point: stop['point'] as LatLng,
                      width: 120,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _onSelectStop(stop),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.uberBlack
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      stop['name'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: isSelected
                                  ? AppColors.uberBlack
                                  : Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // ── 2. TOP FLOATING SEARCH & FILTER BAR ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: _buildTopSearchHeader(),
          ),

          // ── 3. BOTTOM STOPS LIST SHEET ──
          DraggableScrollableSheet(
            initialChildSize: 0.44,
            minChildSize: 0.20,
            maxChildSize: 0.82,
            snap: true,
            snapSizes: const [0.20, 0.44, 0.82],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sheet Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Boarding Stops Nearby',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.statusLive.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '4 STOPS ACTIVE',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.statusLive,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Filter row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'All Stops',
                            'Closest First',
                            'Major Hubs',
                            'EV Stops'
                          ].map((f) {
                            final isSel = _selectedFilter == f;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedFilter = f),
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? AppColors.uberBlack
                                      : AppColors.surfaceSecondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSel
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSel
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Stops List
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: _stopsData.length,
                        itemBuilder: (context, index) {
                          final stop = _stopsData[index];
                          final isSelected = stop['name'] == _selectedStop;
                          return _buildStopCard(stop, isSelected);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTopSearchHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search nearby stop or junction...',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          Icon(Icons.tune_rounded, size: 18, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _buildStopCard(Map<String, dynamic> stop, bool isSelected) {
    return GestureDetector(
      onTap: () => _onSelectStop(stop),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop['name'],
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary),
                      ),
                      Text(
                        '${stop['distance']} • ${stop['walkTime']} • ${stop['busesPerHour']}',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Next bus row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.directions_bus_rounded,
                              size: 13,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            stop['nextBus'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Arrives in ${stop['nextEta']}',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusLive),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => CashlessBookingModal.show(
                    context,
                    busName: stop['nextBus'],
                    destination: 'Technopark TVM',
                  ),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Board From Here',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded,
                          size: 13, color: AppColors.primary),
                    ],
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
