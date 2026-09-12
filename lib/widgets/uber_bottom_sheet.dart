import 'dart:ui';

import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'cashless_booking_modal.dart';

enum UberSheetState {
  discovery,
  busSelection,
  activeTracking,
}

class UberBottomSheet extends StatefulWidget {
  final UberSheetState currentState;
  final String? selectedDestination;
  final String? selectedBusName;
  final ValueChanged<String> onDestinationSelected;
  final ValueChanged<String> onBusSelected;
  final VoidCallback onBackToDiscovery;
  final VoidCallback onBackToBusSelection;
  final VoidCallback? onOpenStopsTab;
  final VoidCallback? onOpenTicketsTab;

  const UberBottomSheet({
    super.key,
    required this.currentState,
    this.selectedDestination,
    this.selectedBusName,
    required this.onDestinationSelected,
    required this.onBusSelected,
    required this.onBackToDiscovery,
    required this.onBackToBusSelection,
    this.onOpenStopsTab,
    this.onOpenTicketsTab,
  });

  @override
  State<UberBottomSheet> createState() => _UberBottomSheetState();
}

class _UberBottomSheetState extends State<UberBottomSheet> {
  String _selectedCategory = 'All';
  bool _stopAlarmEnabled = true;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _getInitialChildSize(),
      minChildSize: 0.22,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.22, 0.58, 0.88],
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.90),
                    width: 1.2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withOpacity(0.12),
                    blurRadius: 28,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Sheet Drag Handle
                  Container(
                    width: 44,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: AppColors.textMuted.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 240),
                        child: _buildCurrentStateContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _getInitialChildSize() {
    switch (widget.currentState) {
      case UberSheetState.discovery:
        return 0.58;
      case UberSheetState.busSelection:
        return 0.64;
      case UberSheetState.activeTracking:
        return 0.66;
    }
  }

  Widget _buildCurrentStateContent() {
    switch (widget.currentState) {
      case UberSheetState.discovery:
        return _buildDiscoveryView();
      case UberSheetState.busSelection:
        return _buildBusSelectionView();
      case UberSheetState.activeTracking:
        return _buildActiveTrackingView();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 1: DISCOVERY (Consumer-Grade Uber / Swiggy / Dispatch Style)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildDiscoveryView() {
    return Column(
      key: const ValueKey('discovery_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Unified Search Pill (Where to? + Now)
        _buildSearchBox(),
        const SizedBox(height: 16),

        // 2. Dark Luxury Hero Promo Card (Image 5 style)
        _buildDarkHeroPromoCard(),
        const SizedBox(height: 20),

        // 3. Four Chunky Category Cards ("What's on your mind?")
        _buildCategorySectionHeader('BUS FLEET & PASSES'),
        const SizedBox(height: 10),
        _buildChunkyCategoryCardsRow(),
        const SizedBox(height: 22),

        // 4. "Places Viewed" Horizontal Carousel (Image 5 style)
        _buildPlacesViewedCarousel(),
        const SizedBox(height: 22),

        // 5. "Live Corridor Buses" Feed (Image 5 "Recent Activity" style)
        _buildLiveCorridorFeed(),

        // Bottom clearance for floating island navbar
        const SizedBox(height: 110),
      ],
    );
  }

  /// 1. Unified Search Box Pill
  Widget _buildSearchBox() {
    return GestureDetector(
      onTap: () => widget.onDestinationSelected('Technopark Kazhakkoottam'),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.search_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where to?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    'Search stop, town, or college',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 14, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Now ▾',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 2. Live Corridor Telematics HUD (Replaces generic 3D marketing promos)
  Widget _buildDarkHeroPromoCard() {
    return GestureDetector(
      onTap: () {
        widget.onDestinationSelected('Technopark Kazhakkoottam');
        widget.onBusSelected('Venad Fast Passenger');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.accent.withOpacity(0.40)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt_rounded, size: 12, color: AppColors.accent),
                            SizedBox(width: 3),
                            Text(
                              'NH66 CORRIDOR',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accent,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.statusLive,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'LIVE TELEMETRY',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.statusLive,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Venad Fast Passenger',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Approaching Mayyanad Stop • On Schedule',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.white.withOpacity(0.72),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _buildDarkHudChip(Icons.event_seat_rounded, '14 seats free'),
                      _buildDarkHudChip(Icons.speed_rounded, '42 km/h'),
                      _buildDarkHudChip(Icons.currency_rupee_rounded, '22 fare'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Track Approaching →',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.uberBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Precision Live ETA / Speed Digital Telematics Dial
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.accent.withOpacity(0.30)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 8,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            color: AppColors.statusLive,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'ETA',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 6),
                      Text(
                        '3',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        'MINS',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'KL 02 BB',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkHudChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.accentLight),
          const SizedBox(width: 3.5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: AppColors.textMuted,
        letterSpacing: 0.8,
      ),
    );
  }

  /// 3. Four Chunky Category Cards (Cohesive agency-grade monochrome design)
  Widget _buildChunkyCategoryCardsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildChunkyCard(
            title: 'Express',
            subtitle: '3 min',
            icon: Icons.directions_bus_filled_rounded,
            onTap: () {
              widget.onDestinationSelected('Technopark Kazhakkoottam');
              widget.onBusSelected('Venad Fast Passenger');
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildChunkyCard(
            title: 'Electric',
            subtitle: 'Low Floor',
            icon: Icons.electric_bolt_rounded,
            onTap: () {
              widget.onDestinationSelected('Technopark Kazhakkoottam');
              widget.onBusSelected('Royal King Electric AC');
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildChunkyCard(
            title: 'Passes',
            subtitle: 'Save 20%',
            icon: Icons.confirmation_number_rounded,
            onTap: widget.onOpenTicketsTab,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildChunkyCard(
            title: 'Stops',
            subtitle: 'Nearby',
            icon: Icons.place_rounded,
            onTap: widget.onOpenStopsTab,
          ),
        ),
      ],
    );
  }

  Widget _buildChunkyCard({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
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
        child: Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.surfaceSecondary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4. "Places Viewed" Horizontal Carousel (Image 5 style)
  Widget _buildPlacesViewedCarousel() {
    final places = [
      {
        'tag': 'IT CORRIDOR',
        'title': 'Technopark Kazhakkoottam',
        'sub': 'Phase 1 & 3 • 32 min',
        'destination': 'Technopark Kazhakkoottam',
        'bus': 'Venad Fast Passenger',
      },
      {
        'tag': 'CENTRAL STAND',
        'title': 'Kollam Chinnakkada Stand',
        'sub': 'Clock Tower • 18 min',
        'destination': 'Kollam Chinnakkada Stand',
        'bus': 'St. Jude Superfast',
      },
      {
        'tag': 'FEEDER HUB',
        'title': 'Chathannoor Junction',
        'sub': 'NH66 Crossway • 12 min',
        'destination': 'Chathannoor Junction',
        'bus': 'Venad Fast Passenger',
      },
      {
        'tag': 'TERMINAL',
        'title': 'TVM Central Stand',
        'sub': 'Thampanoor • 52 min',
        'destination': 'TVM Central Stand',
        'bus': 'Royal King Electric AC',
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
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            GestureDetector(
              onTap: () => widget.onDestinationSelected('Technopark Kazhakkoottam'),
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 106,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: places.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = places[index];
              return GestureDetector(
                onTap: () {
                  widget.onDestinationSelected(item['destination']!);
                  widget.onBusSelected(item['bus']!);
                },
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryDark.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
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
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['tag']!,
                              style: const TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          const Icon(Icons.bookmark_rounded, size: 16, color: AppColors.primary),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

  /// 5. "Live Corridor Buses" Feed (Image 5 "Recent Activity" style)
  Widget _buildLiveCorridorFeed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Live Corridor Buses',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.statusLive.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, size: 7, color: AppColors.statusLive),
                  SizedBox(width: 4),
                  Text(
                    '3 APPROACHING',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.statusLive,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFeedBusItem(
          busName: 'Venad Fast Passenger',
          plate: 'KL 02 BB 4521',
          route: 'Mayyanad ➔ Technopark',
          eta: '3 min',
          status: '14 seats free · Contactless ETM',
          fare: 22,
          isRecommended: true,
          onTap: () {
            widget.onDestinationSelected('Technopark Kazhakkoottam');
            widget.onBusSelected('Venad Fast Passenger');
          },
        ),
        const SizedBox(height: 10),
        _buildFeedBusItem(
          busName: 'Royal King Electric AC',
          plate: 'KL 01 CZ 8819',
          route: 'Mayyanad ➔ TVM Central',
          eta: '7 min',
          status: 'AC Low Floor · Smart Air Conditioned',
          fare: 35,
          isElectric: true,
          onTap: () {
            widget.onDestinationSelected('TVM Central Stand');
            widget.onBusSelected('Royal King Electric AC');
          },
        ),
        const SizedBox(height: 10),
        _buildFeedBusItem(
          busName: 'St. Jude Superfast',
          plate: 'KL 02 AK 3302',
          route: 'Mayyanad ➔ Kollam Stand',
          eta: '11 min',
          status: '21 seats free · Express Corridor',
          fare: 18,
          onTap: () {
            widget.onDestinationSelected('Kollam Chinnakkada Stand');
            widget.onBusSelected('St. Jude Superfast');
          },
        ),
      ],
    );
  }

  Widget _buildFeedBusItem({
    required String busName,
    required String plate,
    required String route,
    required String eta,
    required String status,
    required int fare,
    bool isRecommended = false,
    bool isElectric = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isRecommended ? AppColors.primary.withOpacity(0.35) : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: isRecommended ? AppColors.primary.withOpacity(0.08) : Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isElectric
                    ? const Color(0xFFECFDF5)
                    : (isRecommended ? const Color(0xFFEFF6FF) : AppColors.surfaceSecondary),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isElectric
                      ? const Color(0xFFA7F3D0)
                      : (isRecommended ? const Color(0xFFBFDBFE) : AppColors.border),
                ),
              ),
              child: Center(
                child: Icon(
                  isElectric ? Icons.electric_bolt_rounded : Icons.directions_bus_rounded,
                  size: 24,
                  color: isElectric
                      ? const Color(0xFF059669)
                      : (isRecommended ? AppColors.primary : AppColors.textPrimary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildHsrpPlatePill(plate),
                      const SizedBox(width: 6),
                      if (isElectric)
                        _buildSoftBadge('ELECTRIC AC', color: AppColors.accentDark)
                      else if (isRecommended)
                        _buildSoftBadge('FASTEST', color: AppColors.primary),
                      const Spacer(),
                      Text(
                        eta,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.statusLive,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    busName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹$fare',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.uberBlack,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Track →',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 2: BUS SELECTION (With Transit Timeline Arc - Image 4 Airline Style)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildBusSelectionView() {
    return Column(
      key: const ValueKey('bus_selection_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackHeader(
          title: 'Choose a bus',
          subtitle: 'Mayyanad to ${widget.selectedDestination ?? 'Technopark'}',
          onBack: widget.onBackToDiscovery,
        ),
        const SizedBox(height: 14),

        // Transit Timeline Arc Card (Image 4 flight / transit arc style)
        _buildTransitTimelineArcCard(),
        const SizedBox(height: 16),

        // Category Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildSimpleCategoryFilter('All'),
              _buildSimpleCategoryFilter('Express'),
              _buildSimpleCategoryFilter('Electric AC'),
              _buildSimpleCategoryFilter('Limited Stop'),
            ],
          ),
        ),
        const SizedBox(height: 14),

        _buildBusOptionCard(
          busName: 'Venad Fast Passenger',
          busPlate: 'KL 02 BB 4521',
          tagBadge: 'Fastest',
          etaMinutes: 3,
          arrivalTime: '08:42 AM',
          seatsAvailable: 14,
          fare: 22,
          isRecommended: true,
          onSelect: () => widget.onBusSelected('Venad Fast Passenger'),
        ),
        const SizedBox(height: 10),
        _buildBusOptionCard(
          busName: 'Royal King Electric AC',
          busPlate: 'KL 01 CZ 8819',
          tagBadge: 'Electric AC',
          etaMinutes: 7,
          arrivalTime: '08:46 AM',
          seatsAvailable: 4,
          fare: 35,
          isElectric: true,
          onSelect: () => widget.onBusSelected('Royal King Electric AC'),
        ),
        const SizedBox(height: 10),
        _buildBusOptionCard(
          busName: 'St. Jude Superfast',
          busPlate: 'KL 02 AK 3302',
          tagBadge: 'Comfort',
          etaMinutes: 11,
          arrivalTime: '08:50 AM',
          seatsAvailable: 21,
          fare: 18,
          onSelect: () => widget.onBusSelected('St. Jude Superfast'),
        ),
        const SizedBox(height: 96),
      ],
    );
  }

  /// Transit Timeline Arc Card (Image 4 flight / transit arc style)
  Widget _buildTransitTimelineArcCard() {
    final destination = widget.selectedDestination ?? 'Technopark Kazhakkoottam';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Origin
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mayyanad Stop',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '08:15 AM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),

              // Arc Line with Duration Pill
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.20)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_bus_rounded, size: 12, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text(
                              '22 min',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: AppColors.primary.withOpacity(0.35),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.primary),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: AppColors.primary.withOpacity(0.35),
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Destination
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      destination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '08:37 AM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary.withOpacity(0.60),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.alt_route_rounded, size: 13, color: AppColors.textSecondary),
                SizedBox(width: 5),
                Text(
                  'NH66 Direct Corridor • 18.4 km • Smooth traffic',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 3: ACTIVE TRACKING (Live Telematics & UPI Booking)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildActiveTrackingView() {
    return Column(
      key: const ValueKey('active_tracking_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackHeader(
          title: 'Live tracking',
          subtitle: widget.selectedBusName ?? 'Venad Fast Passenger',
          onBack: widget.onBackToBusSelection,
          trailing: _buildSoftBadge('GPS 4G'),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.20),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arrives in',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '3 mins',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '480 m away · 42 km/h · On time',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Icon(Icons.route_rounded, size: 36, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildInfoStrip(
          icon: Icons.directions_walk_rounded,
          title: 'Start walking to Mayyanad Junction',
          subtitle: '120 m · 2 min walk',
        ),
        const SizedBox(height: 12),
        _buildConductorCard(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => CashlessBookingModal.show(
              context,
              busName: widget.selectedBusName ?? 'Venad Fast Passenger',
              destination: widget.selectedDestination ?? 'Technopark TVM',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.uberBlack,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Book UPI Ticket · ₹22',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildSecondaryAction(
                icon: Icons.share_location_rounded,
                label: 'Share trip',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live trip link copied to clipboard'),
                      backgroundColor: AppColors.uberBlack,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSecondaryAction(
                icon: _stopAlarmEnabled
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_off_rounded,
                label: _stopAlarmEnabled ? 'Alarm on' : 'Set alarm',
                isHighlighted: _stopAlarmEnabled,
                onTap: () => setState(() => _stopAlarmEnabled = !_stopAlarmEnabled),
              ),
            ),
          ],
        ),
        const SizedBox(height: 96),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SHARED REUSABLE COMPONENTS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildBackHeader({
    required String title,
    required String subtitle,
    required VoidCallback onBack,
    Widget? trailing,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildSimpleCategoryFilter(String label) {
    final isSelected = _selectedCategory == label || (_selectedCategory == 'All' && label == 'All');
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.uberBlack : Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.uberBlack : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBusOptionCard({
    required String busName,
    required String busPlate,
    required String tagBadge,
    required int etaMinutes,
    required String arrivalTime,
    required int seatsAvailable,
    required int fare,
    bool isRecommended = false,
    bool isElectric = false,
    required VoidCallback onSelect,
  }) {
    final accent = isElectric ? AppColors.accentDark : AppColors.primary;
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isRecommended ? AppColors.primary.withOpacity(0.35) : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: isRecommended ? AppColors.primary.withOpacity(0.08) : Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isElectric
                    ? const Color(0xFFECFDF5)
                    : (isRecommended ? const Color(0xFFEFF6FF) : AppColors.surfaceSecondary),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isElectric
                      ? const Color(0xFFA7F3D0)
                      : (isRecommended ? const Color(0xFFBFDBFE) : AppColors.border),
                ),
              ),
              child: Center(
                child: Icon(
                  isElectric ? Icons.electric_bolt_rounded : Icons.directions_bus_rounded,
                  size: 24,
                  color: isElectric
                      ? const Color(0xFF059669)
                      : (isRecommended ? AppColors.primary : AppColors.textPrimary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildHsrpPlatePill(busPlate),
                      const SizedBox(width: 6),
                      _buildSoftBadge(tagBadge, color: accent),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    busName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$etaMinutes min · $arrivalTime · $seatsAvailable seats free',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹$fare',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.uberBlack,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConductorCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Text(
                'SK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suresh Kumar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '4.9 rating · ETM verified',
                  style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.phone_rounded, size: 17, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStrip({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFB45309), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF92400E),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF92400E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryAction({
    required IconData icon,
    required String label,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isHighlighted ? AppColors.primary.withOpacity(0.20) : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHsrpPlatePill(String plateNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        plateNumber,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: AppColors.uberBlack,
        ),
      ),
    );
  }

  Widget _buildSoftBadge(String label, {Color color = AppColors.primary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: color),
      ),
    );
  }
}
