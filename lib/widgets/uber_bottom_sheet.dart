import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'cashless_booking_modal.dart';

enum UberSheetState {
  discovery,     // State 1: Discovery, curated promo, shortcuts & fleet spotlight
  busSelection,  // State 2: Ride chooser with 3D bus cards & HSRP number plates
  activeTracking // State 3: Live cockpit with conductor card & booking CTA
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
      minChildSize: 0.18,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.18, 0.50, 0.88],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag Handle
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
              const SizedBox(height: 10),

              // Scrollable Sheet Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _buildCurrentStateContent(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  double _getInitialChildSize() {
    switch (widget.currentState) {
      case UberSheetState.discovery:
        return 0.48;
      case UberSheetState.busSelection:
        return 0.58;
      case UberSheetState.activeTracking:
        return 0.62;
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

  // ════════════════════════════════════════════════════════════════════════════
  // STATE 1: DISCOVERY & "WHERE TO?" (UBER / SWIGGY QUALITY)
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildDiscoveryView() {
    return Column(
      key: const ValueKey('discovery_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Minimalist "Where to?" Search Bar (Uber Style) ──
        GestureDetector(
          onTap: () => widget.onDestinationSelected('Technopark Kazhakkoottam'),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.uberBlack,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search_rounded, size: 16, color: Colors.white),
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
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Search stops, towns, or colleges',
                        style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.schedule_rounded, size: 13, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'Now',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // ── 2. Category Filter Chips (Swiggy Style) ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildCategoryPill('Express', '3 min', isSelected: true, onTap: () {
                widget.onDestinationSelected('Technopark Kazhakkoottam');
                widget.onBusSelected('Venad Fast Passenger');
              }),
              _buildCategoryPill('Electric AC', '7 min', onTap: () {
                widget.onDestinationSelected('Technopark Kazhakkoottam');
                widget.onBusSelected('Royal King Electric AC');
              }),
              _buildCategoryPill('Passes', 'Offers', onTap: widget.onOpenTicketsTab),
              _buildCategoryPill('Nearby Stops', 'Radar', onTap: widget.onOpenStopsTab),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── 3. Curated Commuter Card (Swiggy / Zomato Clean Card) ──
        GestureDetector(
          onTap: () {
            widget.onDestinationSelected('Technopark Kazhakkoottam');
            widget.onBusSelected('Venad Fast Passenger');
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/gmb_logo_color.png',
                            width: 54,
                            height: 18,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'NH66 LIVE',
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Live Private Bus Tracking',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Real-time GPS telematics with instant UPI conductor ticketing.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text(
                            'Catch next bus',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    'assets/images/kerala_promo_3d.jpg',
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── 4. Live Nearby Bus Spotlight Card with HSRP Plate ──
        GestureDetector(
          onTap: () {
            widget.onDestinationSelected('Technopark Kazhakkoottam');
            widget.onBusSelected('Venad Fast Passenger');
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // 3D Bus Avatar Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/bus_3d.jpg',
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Bus Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildHsrpPlatePill('KL 02 BB 4521'),
                          const SizedBox(width: 8),
                          const Text(
                            '3 min away',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.statusLive),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Venad Fast Passenger',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Row(
                        children: [
                          Icon(Icons.airline_seat_recline_normal_rounded, size: 13, color: AppColors.statusLive),
                          SizedBox(width: 3),
                          Text('14 seats free', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.statusLive)),
                          SizedBox(width: 6),
                          Text('• Contactless ETM', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                const Icon(Icons.chevron_right_rounded, size: 22, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        // ── 5. Frequent Destinations (Uber Style Shortcuts) ──
        const Text(
          'FREQUENT DESTINATIONS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 8),

        _buildDestinationRow(
          title: 'Technopark Kazhakkoottam',
          subtitle: 'Phase 1 & 3 • NH66 Corridor',
          eta: '32 min',
          icon: Icons.business_rounded,
          onTap: () => widget.onDestinationSelected('Technopark Kazhakkoottam'),
        ),
        _buildDestinationRow(
          title: 'CET Engineering College',
          subtitle: 'Sreekaryam, Trivandrum',
          eta: '44 min',
          icon: Icons.school_rounded,
          onTap: () => widget.onDestinationSelected('CET College TVM'),
        ),
        _buildDestinationRow(
          title: 'TKM College of Engineering',
          subtitle: 'Karikode, Kollam',
          eta: '18 min',
          icon: Icons.apartment_rounded,
          onTap: () => widget.onDestinationSelected('TKM College Kollam'),
        ),
        _buildDestinationRow(
          title: 'Thiruvananthapuram Central',
          subtitle: 'Thampanoor Bus Terminal',
          eta: '52 min',
          icon: Icons.train_rounded,
          onTap: () => widget.onDestinationSelected('TVM Central Stand'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCategoryPill(String title, String subtitle, {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.uberBlack : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.uberBlack : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.18) : Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHsrpPlatePill(String plateNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black45, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0.5),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text(
              'IND',
              style: TextStyle(fontSize: 6.5, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            plateNumber,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.uberBlack,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationRow({
    required String title,
    required String subtitle,
    required String eta,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 0.6)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.surfaceSecondary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              eta,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STATE 2: RIDE SELECTION (UBER RIDE CHOOSER WITH 3D CARDS)
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildBusSelectionView() {
    return Column(
      key: const ValueKey('bus_selection_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back & Header
        Row(
          children: [
            GestureDetector(
              onTap: widget.onBackToDiscovery,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.uberBlack),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose your bus',
                    style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  Text(
                    'Mayyanad Jn ➔ ${widget.selectedDestination ?? 'Technopark'}',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.primary, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildSimpleCategoryFilter('All Buses (3)'),
              _buildSimpleCategoryFilter('Express (1)'),
              _buildSimpleCategoryFilter('Electric AC (1)'),
              _buildSimpleCategoryFilter('Limited Stop (1)'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Bus 1: Venad Fast Passenger
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

        // Bus 2: Royal King Electric AC
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

        // Bus 3: St. Jude Superfast
        _buildBusOptionCard(
          busName: 'St. Jude Superfast',
          busPlate: 'KL 02 AK 3302',
          tagBadge: 'Comfort Seats',
          etaMinutes: 11,
          arrivalTime: '08:50 AM',
          seatsAvailable: 21,
          fare: 18,
          onSelect: () => widget.onBusSelected('St. Jude Superfast'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSimpleCategoryFilter(String label) {
    final isSelected = _selectedCategory == label || (_selectedCategory == 'All' && label.startsWith('All'));
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.uberBlack : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRecommended ? AppColors.primary : AppColors.border,
            width: isRecommended ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // 3D Cartoon Bus Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/bus_3d.jpg',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Specs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildHsrpPlatePill(busPlate),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isElectric
                                  ? AppColors.accent.withOpacity(0.12)
                                  : AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tagBadge,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: isElectric ? AppColors.accentDark : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        busName,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '$etaMinutes min away • Reaches $arrivalTime',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.statusLive),
                      ),
                    ],
                  ),
                ),

                // Fare & Track Button
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹$fare',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isRecommended ? AppColors.primary : AppColors.uberBlack,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Track',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Seat status row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.airline_seat_recline_normal_rounded, size: 13, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '$seatsAvailable seats available',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: seatsAvailable > 5 ? AppColors.statusLive : AppColors.statusWarning,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'ETM UPI Verified',
                    style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // STATE 3: ACTIVE TRACKING COCKPIT (UBER QUALITY WITH 3D CONDUCUTOR)
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildActiveTrackingView() {
    return Column(
      key: const ValueKey('active_tracking_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Back Row
        Row(
          children: [
            GestureDetector(
              onTap: widget.onBackToBusSelection,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 18, color: AppColors.uberBlack),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Live Tracking',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.wifi_tethering_rounded, size: 12, color: AppColors.accentDark),
                  SizedBox(width: 4),
                  Text(
                    'GPS 4G',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.accentDark),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Arrival Countdown Banner
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arrives in',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                ),
                Text(
                  '3 mins',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: -0.8),
                ),
                Text(
                  '480 meters away • 42 km/h',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.statusLive.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 13, color: AppColors.statusLive),
                  SizedBox(width: 4),
                  Text(
                    'On Time',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.statusLive),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Gentle Pedestrian Walking Nudge
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: const Row(
            children: [
              Icon(Icons.directions_walk_rounded, color: Color(0xFFB45309), size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start walking to Mayyanad Junction',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB45309),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      '120 meters • 2 min walk. You will arrive 1 minute before the bus.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Conductor Card with 3D Conductor Asset
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/conductor_3d.jpg',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suresh Kumar',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                    Text(
                      '★ 4.9 (1,240 trips) • Conductor',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Handheld ETM Cashless Verified',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              // Call Button
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_rounded, size: 16, color: AppColors.uberBlack),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Primary Cashless Booking CTA
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => CashlessBookingModal.show(
              context,
              busName: widget.selectedBusName ?? 'Venad Fast Passenger',
              destination: widget.selectedDestination ?? 'Technopark TVM',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.uberBlack,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/gmb_icon_pin.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Book Instant UPI Ticket (₹22)',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Secondary Actions
        Row(
          children: [
            Expanded(
              child: _buildSecondaryAction(
                icon: Icons.share_location_rounded,
                label: 'Share Trip',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live trip link copied to clipboard!'),
                      backgroundColor: AppColors.uberBlack,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSecondaryAction(
                icon: _stopAlarmEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                label: _stopAlarmEnabled ? 'Alarm Set' : 'Set Alarm',
                isHighlighted: _stopAlarmEnabled,
                onTap: () {
                  setState(() => _stopAlarmEnabled = !_stopAlarmEnabled);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.primaryLight : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted ? AppColors.primary.withOpacity(0.3) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: isHighlighted ? AppColors.primary : AppColors.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
