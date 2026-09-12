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

  /// Top Bar: GetMyBus Official Brand Header & Quick Actions
  Widget _buildImage1TopBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Brand Row: Official GetMyBus Logo + Notification Bell & Conductor ETM Scan
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // GetMyBus Official Wordmark + Tagline
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/gmb_icon_pin.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Get',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.brandBlue,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'MyBus',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.brandCyan,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'know before you go.',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlueDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right Action Discs: [Notification Bell] & [Conductor ETM / UPI QR]
            Row(
              children: [
                // Notification Bell Disc
                Container(
                  width: 42,
                  height: 42,
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
                      const Icon(Icons.notifications, size: 20, color: AppColors.brandBlue),
                      Positioned(
                        top: 10,
                        right: 10,
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
                const SizedBox(width: 10),

                // Conductor ETM Scan / UPI QR Disc in GetMyBus Royal Blue
                GestureDetector(
                  onTap: () => widget.onOpenTickets?.call(),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandBlue.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.qr_code, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Live Corridor Status & Bus Schedule Pill
        Row(
          children: [
            // Live Status Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.near_me_rounded, size: 13, color: AppColors.statusLive),
                  SizedBox(width: 5),
                  Text(
                    'Mayyanad, Kollam',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // View Bus Schedule Pill
            GestureDetector(
              onTap: () => _openFullMap(destination: 'Technopark Kazhakkoottam'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.brandBlueLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_bus, size: 13, color: AppColors.brandBlue),
                    SizedBox(width: 4),
                    Text(
                      'Bus Schedule ›',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'View Map',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                          'assets/images/pixar_compass_3d.jpg',
                          width: 18,
                          height: 18,
                          fit: BoxFit.cover,
                        ),
                      ),
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

  /// Search Pill (GetMyBus): [↗ Where do you wanna go ?        🎤]
  Widget _buildImage1SearchPill() {
    return GestureDetector(
      onTap: () => _openFullMap(destination: 'Technopark Kazhakkoottam'),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.near_me_rounded, size: 20, color: AppColors.brandCyan),
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

  /// Bus Services & Fleet Section (100% BUS ONLY: City Bus, Fast Passenger, Intercity AC)
  Widget _buildMoreWaysToTravelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bus Services & Fleet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.brandBlueLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Kerala Transit',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // 1. City Bus (3D Pixar Bus)
            Expanded(
              child: _buildServiceCard(
                title: 'City Bus',
                imageAsset: 'assets/images/pixar_bus.jpg',
                badgeText: 'Local',
                badgeColor: AppColors.brandBlue,
                onTap: () => _openFullMap(busName: 'Venad Fast Passenger'),
              ),
            ),
            const SizedBox(width: 10),

            // 2. Fast Passenger (Limited Stop Highway Express - 3D Commute Express Bus)
            Expanded(
              child: _buildServiceCard(
                title: 'Fast Passenger',
                imageAsset: 'assets/images/bus_3d.jpg',
                badgeText: '*EXPRESS*',
                badgeColor: const Color(0xFFEA580C),
                onTap: () => _openFullMap(busName: 'Royal King Electric AC'),
              ),
            ),
            const SizedBox(width: 10),

            // 3. Intercity Coach (Long Distance AC Low Floor - 3D Pixar Coach)
            Expanded(
              child: _buildServiceCard(
                title: 'Intercity',
                imageAsset: 'assets/images/pixar_intercity.jpg',
                badgeText: 'AC Fleet',
                badgeColor: const Color(0xFF0891B2),
                onTap: () => _openFullMap(destination: 'Technopark Kazhakkoottam'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String imageAsset,
    String? badgeText,
    Color? badgeColor,
    bool isComingSoon = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 126,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        decoration: BoxDecoration(
          color: isComingSoon ? const Color(0xFFF1F5F9) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title + optional Top Badge (e.g. *50% OFF)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (badgeText != null) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: badgeColor ?? AppColors.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        fontSize: 7.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const Spacer(),

            // 3D Pixar Vehicle Asset
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageAsset,
                  height: isComingSoon ? 50 : 56,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const Spacer(),

            // Bottom Coming Soon pill if applicable
            if (isComingSoon)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 2),
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
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Safety tracking & emergency contact sharing active')),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/pixar_shield.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Places Viewed Section (Image 4 & reference design with landmark photos)
  Widget _buildPlacesViewedSection() {
    final places = [
      {
        'title': 'Technopark Campus',
        'location': 'Kazhakkoottam',
        'sub': 'Aug 21 • 05:37 PM',
        'destination': 'Technopark Kazhakkoottam',
        'image': 'assets/images/place_technopark.jpg',
      },
      {
        'title': 'Clock Tower Square',
        'location': 'Chinnakkada, Kollam',
        'sub': 'Aug 20 • 03:15 PM',
        'destination': 'Kollam Chinnakkada Stand',
        'image': 'assets/images/place_chinnakkada.jpg',
      },
      {
        'title': 'Varkala Cliff Beach',
        'location': 'Varkala',
        'sub': 'Aug 19 • 06:45 PM',
        'destination': 'Varkala Cliff Beach',
        'image': 'assets/images/place_varkala.jpg',
      },
      {
        'title': 'Town Junction',
        'location': 'Chathannoor',
        'sub': 'Aug 18 • 11:20 AM',
        'destination': 'Chathannoor Junction',
        'image': 'assets/images/place_chathannoor.jpg',
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
                  color: AppColors.brandBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 98,
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
                  width: 260,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Photo thumbnail on the left
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          item['image']!,
                          width: 78,
                          height: 78,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 78,
                            height: 78,
                            color: AppColors.brandBlueLight,
                            child: const Icon(
                              Icons.location_city_rounded,
                              color: AppColors.brandBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Details on the right
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Location pin + Bookmark button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_rounded,
                                        size: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 2),
                                      Flexible(
                                        child: Text(
                                          item['location']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.bookmark_rounded,
                                    size: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['title']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item['sub']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
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

  /// Recent Activity Section (Image 4 & reference design style)
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
                  color: AppColors.brandBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildRecentActivityItem(
          title: 'Mayyanad ➔ Technopark Phase 1',
          time: 'Aug 28 • 05:37PM',
          fare: '₹22.00',
          imageAsset: 'assets/images/pixar_bus.jpg',
          isSuccess: true,
          onTap: () => _openFullMap(busName: 'Venad Fast Passenger'),
        ),
        const SizedBox(height: 10),
        _buildRecentActivityItem(
          title: 'Kollam Stand ➔ Mayyanad Jn',
          time: 'Aug 27 • 06:15PM',
          fare: '₹18.00',
          imageAsset: 'assets/images/bus_3d.jpg',
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
    required String imageAsset,
    required bool isSuccess,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Vehicle container with green checkmark status badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    imageAsset,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.directions_bus_rounded,
                        size: 24,
                        color: AppColors.brandBlue,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 15,
                      color: AppColors.statusLive,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            // Title & Timestamp
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
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fare,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // "View ➔" link
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
