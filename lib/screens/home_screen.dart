import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../services/socket_service.dart';
import '../widgets/uber_map_view.dart';
import '../widgets/uber_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenStops;
  final VoidCallback? onOpenTickets;

  const HomeScreen({
    super.key,
    this.onOpenStops,
    this.onOpenTickets,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFullMapMode = false;
  UberSheetState _sheetState = UberSheetState.discovery;
  String? _selectedDestination;
  String? _selectedBusName;

  void _openFullMap({String? destination, String? busName}) {
    setState(() {
      _isFullMapMode = true;
      if (destination != null) {
        _selectedDestination = destination;
        _sheetState = busName != null
            ? UberSheetState.activeTracking
            : UberSheetState.busSelection;
      }
      if (busName != null) {
        _selectedBusName = busName;
      }
    });
  }

  void _closeFullMap() {
    setState(() {
      _isFullMapMode = false;
      _selectedDestination = null;
      _selectedBusName = null;
      _sheetState = UberSheetState.discovery;
    });
  }

  void _onDestinationSelected(String destination) {
    setState(() {
      _selectedDestination = destination;
      _sheetState = UberSheetState.busSelection;
      _isFullMapMode = true;
    });
  }

  void _onBusSelected(String busName) {
    setState(() {
      _selectedBusName = busName;
      _sheetState = UberSheetState.activeTracking;
      _isFullMapMode = true;
    });
  }

  void _onBackToDiscovery() {
    setState(() {
      _selectedDestination = null;
      _selectedBusName = null;
      _sheetState = UberSheetState.discovery;
    });
  }

  void _onBackToBusSelection() {
    setState(() {
      _selectedBusName = null;
      _sheetState = UberSheetState.busSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    final activeBuses = socketService.activeBuses.values.toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _isFullMapMode
            ? _buildFullMapTrackingView(activeBuses)
            : _buildImage1DashboardView(activeBuses),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── 1. FULL SCREEN LIVE TRACKING VIEW (When Map Expanded) ──
  // ══════════════════════════════════════════════════════════════
  Widget _buildFullMapTrackingView(List<dynamic> activeBuses) {
    return Stack(
      key: const ValueKey('full_map_view'),
      children: [
        Positioned.fill(
          child: UberMapView(
            liveBuses: activeBuses.cast(),
            selectedBusName: _selectedBusName,
            selectedDestination: _selectedDestination,
            sheetState: _sheetState,
            onBusSelected: _onBusSelected,
            onRecenter: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Centered on Mayyanad Junction, Kollam'),
                  duration: Duration(seconds: 1),
                  backgroundColor: AppColors.uberBlack,
                ),
              );
            },
          ),
        ),

        // Floating Back to Dashboard Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          child: GestureDetector(
            onTap: _closeFullMap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.14),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.textPrimary),
                  SizedBox(width: 6),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Sheet
        Positioned.fill(
          child: UberBottomSheet(
            currentState: _sheetState,
            selectedDestination: _selectedDestination,
            selectedBusName: _selectedBusName,
            onDestinationSelected: _onDestinationSelected,
            onBusSelected: _onBusSelected,
            onBackToDiscovery: _onBackToDiscovery,
            onBackToBusSelection: _onBackToBusSelection,
            onOpenStopsTab: widget.onOpenStops,
            onOpenTicketsTab: widget.onOpenTickets,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── 2. COMMUTER DASHBOARD VIEW (Exact Image 1 & 4 UI/UX) ──
  // ══════════════════════════════════════════════════════════════
  Widget _buildImage1DashboardView(List<dynamic> activeBuses) {
    return SafeArea(
      key: const ValueKey('dashboard_view'),
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        physics: const BouncingScrollPhysics(),
        children: [
          // ── A. TOP BAR (Image 1: Bell, Location Unavailable/Schedule, QR Scan) ──
          _buildImage1TopBar(),
          const SizedBox(height: 16),

          // ── B. FRAMED MAP PREVIEW CARD (Image 1: Regional map card with View Map pill) ──
          _buildImage1MapCard(activeBuses),
          const SizedBox(height: 16),

          // ── C. SEARCH PILL (Image 1: Where do you wanna go ? + Mic) ──
          _buildImage1SearchPill(),
          const SizedBox(height: 24),

          // ── D. "MORE WAYS TO TRAVEL" (Image 1: City Bus, Metro 50% OFF, Intercity) ──
          _buildMoreWaysToTravelSection(),
          const SizedBox(height: 20),

          // ── E. SAFETY BANNER (Image 1: Travel safe, stay secure!) ──
          _buildSafetyBanner(),
          const SizedBox(height: 24),

          // ── F. PLACES VIEWED CAROUSEL (Image 4: Destination photo cards) ──
          _buildPlacesViewedSection(),
          const SizedBox(height: 24),

          // ── G. RECENT ACTIVITY (Image 4: Trip logs with fares and status) ──
          _buildRecentActivitySection(),
        ],
      ),
    );
  }

  /// Top Bar matching Image 1: [Bell] | [Location / View Bus Schedule >] | [QR Code]
  Widget _buildImage1TopBar() {
    return Row(
      children: [
        // Notification Bell Disc
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.notifications_none_rounded, size: 22, color: AppColors.textPrimary),
              Positioned(
                top: 10,
                right: 11,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Center Location Status & Bus Schedule Pill (Image 1)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.near_me_rounded, size: 14, color: AppColors.statusLive),
                  SizedBox(width: 4),
                  Text(
                    'Mayyanad, Kollam',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => _openFullMap(destination: 'Technopark Kazhakkoottam'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: AppColors.purpleLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.purplePrimary.withOpacity(0.4)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_bus_filled_rounded, size: 12, color: AppColors.purplePrimary),
                      SizedBox(width: 4),
                      Text(
                        'View Bus Schedule ›',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.purplePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Deep Purple QR Scanner Disc (Image 1)
        GestureDetector(
          onTap: () => widget.onOpenTickets?.call(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.purplePrimary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.purplePrimary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.qr_code_scanner_rounded, size: 22, color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Framed Map Preview Card (Image 1) with View Map 🧭 overlay button
  Widget _buildImage1MapCard(List<dynamic> activeBuses) {
    return Container(
      height: 205,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Embedded live map tile
            Positioned.fill(
              child: UberMapView(
                liveBuses: activeBuses.cast(),
                selectedBusName: null,
                selectedDestination: null,
                sheetState: UberSheetState.discovery,
                onBusSelected: (bus) => _openFullMap(busName: bus),
              ),
            ),

            // Top Gradient Soft Fade
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 30,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.08), Colors.transparent],
                  ),
                ),
              ),
            ),

            // Bottom Left GPS Recenter Puck (Image 1)
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.my_location_rounded, size: 19, color: AppColors.textPrimary),
              ),
            ),

            // Bottom Right "View Map 🧭" Pill Button (Image 1)
            Positioned(
              bottom: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => _openFullMap(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Map',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.explore_outlined, size: 16, color: AppColors.textPrimary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Search Pill (Image 1): [↗ Where do you wanna go ?        🎤]
  Widget _buildImage1SearchPill() {
    return GestureDetector(
      onTap: () => _openFullMap(destination: 'Technopark Kazhakkoottam'),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.purplePrimary.withOpacity(0.40)),
          boxShadow: [
            BoxShadow(
              color: AppColors.purplePrimary.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.near_me_rounded, size: 20, color: AppColors.statusLive),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Where do you wanna go ?',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(Icons.mic_none_rounded, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  /// "More ways to travel" Section (Image 1: City Bus, Metro 50% OFF, Intercity Coming Soon)
  Widget _buildMoreWaysToTravelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More ways to travel',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 1. City Bus
            Expanded(
              child: _buildServiceCard(
                title: 'City Bus',
                icon: Icons.directions_bus_rounded,
                iconColor: const Color(0xFF2563EB),
                badgeText: null,
                onTap: () => _openFullMap(busName: 'Venad Fast Passenger'),
              ),
            ),
            const SizedBox(width: 10),

            // 2. Metro (*50% OFF)
            Expanded(
              child: _buildServiceCard(
                title: 'Metro',
                icon: Icons.subway_rounded,
                iconColor: const Color(0xFF0D9488),
                badgeText: '*50% OFF',
                badgeColor: const Color(0xFFEA580C),
                onTap: () => _openFullMap(busName: 'Royal King Electric AC'),
              ),
            ),
            const SizedBox(width: 10),

            // 3. Intercity (Coming Soon)
            Expanded(
              child: _buildServiceCard(
                title: 'Intercity',
                icon: Icons.airport_shuttle_rounded,
                iconColor: const Color(0xFF9333EA),
                badgeText: 'Coming Soon',
                badgeColor: const Color(0xFF64748B),
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    String? badgeText,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (badgeText != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor ?? AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Center(
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 26, color: iconColor),
                  ),
                ),
                const SizedBox(height: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Safety Banner (Image 1: Travel safe, stay secure!)
  Widget _buildSafetyBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF7DD3FC)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Travel safe, stay secure!',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Share live bus location with family and emergency contacts.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF075985),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Setup Now ↗',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              size: 28,
              color: Color(0xFF0284C7),
            ),
          ),
        ],
      ),
    );
  }

  /// Places Viewed Section (Image 4)
  Widget _buildPlacesViewedSection() {
    final places = [
      {
        'title': 'Technopark Kazhakkoottam',
        'sub': 'Phase 1 & 3 • 32 min',
        'destination': 'Technopark Kazhakkoottam',
        'tag': 'IT HUB',
      },
      {
        'title': 'Kollam Chinnakkada Stand',
        'sub': 'Clock Tower • 18 min',
        'destination': 'Kollam Chinnakkada Stand',
        'tag': 'CENTRAL',
      },
      {
        'title': 'Chathannoor Junction',
        'sub': 'NH66 Crossway • 12 min',
        'destination': 'Chathannoor Junction',
        'tag': 'FEEDER',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Places Viewed',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            GestureDetector(
              onTap: () => _openFullMap(destination: 'Technopark Kazhakkoottam'),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.purplePrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: places.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = places[index];
              return GestureDetector(
                onTap: () => _openFullMap(destination: item['destination']),
                child: Container(
                  width: 190,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.purpleLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['tag']!,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.purplePrimary,
                              ),
                            ),
                          ),
                          const Icon(Icons.bookmark_border_rounded, size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['sub']!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Recent Activity Section (Image 4: Trip logs with fares and status)
  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            GestureDetector(
              onTap: () => widget.onOpenTickets?.call(),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.purplePrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRecentActivityItem(
          title: 'Mayyanad ➔ Technopark Phase 1',
          time: 'Today • 08:30 AM',
          fare: '₹22.00',
          isSuccess: true,
          onTap: () => _openFullMap(busName: 'Venad Fast Passenger'),
        ),
        const SizedBox(height: 10),
        _buildRecentActivityItem(
          title: 'Kollam Stand ➔ Mayyanad Jn',
          time: 'Yesterday • 06:15 PM',
          fare: '₹18.00',
          isSuccess: true,
          onTap: () => _openFullMap(busName: 'St. Jude Superfast'),
        ),
      ],
    );
  }

  Widget _buildRecentActivityItem({
    required String title,
    required String time,
    required String fare,
    required bool isSuccess,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.directions_bus_rounded,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 12,
                        color: isSuccess ? AppColors.statusLive : AppColors.statusError,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$time • $fare',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
