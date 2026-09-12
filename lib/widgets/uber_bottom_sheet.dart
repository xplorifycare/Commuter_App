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
  String _selectedFilter = 'All';
  bool _stopAlarmEnabled = true;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: _getInitialChildSize(),
      minChildSize: 0.18,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.18, 0.44, 0.88],
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Restrained Sheet Grab Handle (32 x 4)
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
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
        return 0.44;
      case UberSheetState.busSelection:
        return 0.58;
      case UberSheetState.activeTracking:
        return 0.60;
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
  // VIEW 1: DISCOVERY (Linear + Google Maps Minimal Mobility Panel)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildDiscoveryView() {
    return Column(
      key: const ValueKey('discovery_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Google Maps / Uber style Origin-Destination Module
        _buildRouteInputModule(),
        const SizedBox(height: 14),

        // 2. Corridor Quick Chips
        _buildCorridorQuickChips(),
        const SizedBox(height: 20),

        // 3. Live Departures Board (Linear-style dense tabular departure rows)
        _buildLiveDeparturesHeader(),
        const SizedBox(height: 10),

        _buildDepartureRow(
          routeCode: '66A',
          routeBadgeColor: const Color(0xFF1E293B),
          busName: 'Venad Fast Passenger',
          plate: 'KL 02 BB 4521',
          destination: 'To Technopark Kazhakkoottam',
          etaMinutes: 3,
          seatsFree: 14,
          vehicleType: 'Fast Passenger',
          fare: 22,
          isFastest: true,
          onTap: () {
            widget.onDestinationSelected('Technopark Kazhakkoottam');
            widget.onBusSelected('Venad Fast Passenger');
          },
        ),
        const SizedBox(height: 8),

        _buildDepartureRow(
          routeCode: '66E',
          routeBadgeColor: AppColors.accent,
          busName: 'Royal King Electric AC',
          plate: 'KL 01 CZ 8819',
          destination: 'To TVM Central Terminal',
          etaMinutes: 7,
          seatsFree: 4,
          vehicleType: 'Low Floor AC',
          fare: 35,
          isElectric: true,
          onTap: () {
            widget.onDestinationSelected('TVM Central Stand');
            widget.onBusSelected('Royal King Electric AC');
          },
        ),
        const SizedBox(height: 8),

        _buildDepartureRow(
          routeCode: '14S',
          routeBadgeColor: const Color(0xFF475569),
          busName: 'St. Jude Superfast',
          plate: 'KL 02 AK 3302',
          destination: 'To Kollam Chinnakkada Stand',
          etaMinutes: 11,
          seatsFree: 21,
          vehicleType: 'Express Corridor',
          fare: 18,
          onTap: () {
            widget.onDestinationSelected('Kollam Chinnakkada Stand');
            widget.onBusSelected('St. Jude Superfast');
          },
        ),

        // Navbar bottom clearance
        const SizedBox(height: 84),
      ],
    );
  }

  /// 1. Origin-Destination Route Module (Google Maps & Uber style)
  Widget _buildRouteInputModule() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Origin Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mayyanad Stop',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Current boarding stop • NH66',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onOpenStopsTab,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.borderLight),
          // Destination Row
          InkWell(
            onTap: () => widget.onDestinationSelected('Technopark Kazhakkoottam'),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Where to? (e.g. Technopark, Kollam)',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule_rounded, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          'Now ▾',
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
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Corridor Quick Chips
  Widget _buildCorridorQuickChips() {
    final chips = [
      {'label': 'Technopark', 'eta': '32m', 'dest': 'Technopark Kazhakkoottam', 'bus': 'Venad Fast Passenger'},
      {'label': 'Kollam Stand', 'eta': '18m', 'dest': 'Kollam Chinnakkada Stand', 'bus': 'St. Jude Superfast'},
      {'label': 'Chathannoor', 'eta': '12m', 'dest': 'Chathannoor Junction', 'bus': 'Venad Fast Passenger'},
      {'label': 'TVM Central', 'eta': '52m', 'dest': 'TVM Central Stand', 'bus': 'Royal King Electric AC'},
    ];

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return GestureDetector(
            onTap: () {
              widget.onDestinationSelected(chip['dest']!);
              widget.onBusSelected(chip['bus']!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    chip['label']!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    chip['eta']!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 3. Live Departures Header
  Widget _buildLiveDeparturesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'LIVE DEPARTURES FROM MAYYANAD',
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDFA),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFCCFBF1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '4s Telemetry',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F766E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Linear-style Departure Row
  Widget _buildDepartureRow({
    required String routeCode,
    required Color routeBadgeColor,
    required String busName,
    required String plate,
    required String destination,
    required int etaMinutes,
    required int seatsFree,
    required String vehicleType,
    required int fare,
    bool isFastest = false,
    bool isElectric = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x04000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Route Code Badge (e.g. [ 66A ])
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: routeBadgeColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    routeCode,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    busName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                // ETA
                Text(
                  '$etaMinutes min',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              destination,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // HSRP Plate Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    plate,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$seatsFree seats free • $vehicleType',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹$fare',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.uberBlack,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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
  // VIEW 2: BUS SELECTION (Linear-style Route Comparison)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildBusSelectionView() {
    final destination = widget.selectedDestination ?? 'Technopark Kazhakkoottam';
    return Column(
      key: const ValueKey('bus_selection_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackHeader(
          title: 'Trip to $destination',
          subtitle: '18.4 km via NH66 • Typical transit time 28-35 min',
          onBack: widget.onBackToDiscovery,
        ),
        const SizedBox(height: 12),

        // Route Timeline Card
        _buildTransitTimelineArcCard(),
        const SizedBox(height: 12),

        // Filter Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildFilterPill('All'),
              _buildFilterPill('Express'),
              _buildFilterPill('Electric AC'),
              _buildFilterPill('Limited'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        _buildBusOptionCard(
          routeCode: '66A',
          routeColor: const Color(0xFF1E293B),
          busName: 'Venad Fast Passenger',
          busPlate: 'KL 02 BB 4521',
          etaMinutes: 3,
          arrivalTime: '08:42 AM',
          seatsAvailable: 14,
          fare: 22,
          isRecommended: true,
          onSelect: () => widget.onBusSelected('Venad Fast Passenger'),
        ),
        const SizedBox(height: 8),

        _buildBusOptionCard(
          routeCode: '66E',
          routeColor: AppColors.accent,
          busName: 'Royal King Electric AC',
          busPlate: 'KL 01 CZ 8819',
          etaMinutes: 7,
          arrivalTime: '08:46 AM',
          seatsAvailable: 4,
          fare: 35,
          isElectric: true,
          onSelect: () => widget.onBusSelected('Royal King Electric AC'),
        ),
        const SizedBox(height: 8),

        _buildBusOptionCard(
          routeCode: '14S',
          routeColor: const Color(0xFF475569),
          busName: 'St. Jude Superfast',
          busPlate: 'KL 02 AK 3302',
          etaMinutes: 11,
          arrivalTime: '08:50 AM',
          seatsAvailable: 21,
          fare: 18,
          onSelect: () => widget.onBusSelected('St. Jude Superfast'),
        ),
        const SizedBox(height: 84),
      ],
    );
  }

  /// Linear-style Transit Timeline Arc Card
  Widget _buildTransitTimelineArcCard() {
    final destination = widget.selectedDestination ?? 'Technopark Kazhakkoottam';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Origin
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mayyanad',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '08:15 AM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Text(
                          '22 min direct',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: AppColors.border,
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 9, color: AppColors.textSecondary),
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: AppColors.border,
                            ),
                          ),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 1.5),
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
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Text(
                    '08:37 AM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, size: 12, color: AppColors.accent),
                SizedBox(width: 4),
                Text(
                  'NH66 Highway Corridor • 42 km/h avg speed • Smooth traffic',
                  style: TextStyle(
                    fontSize: 10.5,
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
  // VIEW 3: ACTIVE TRACKING (Minimal Telematics & Direct UPI Action)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildActiveTrackingView() {
    return Column(
      key: const ValueKey('active_tracking_view'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackHeader(
          title: 'Live Tracking',
          subtitle: widget.selectedBusName ?? 'Venad Fast Passenger',
          onBack: widget.onBackToBusSelection,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCCFBF1)),
            ),
            child: const Text(
              'GPS Active (4s)',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F766E),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Arrival Panel (Off-black solid surface, crisp white typography)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Arriving at Mayyanad in',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF334155),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'KL 02 BB 4521',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                '3 mins',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '480 m away • 42 km/h (On schedule)',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 12),
              // Progress hairline
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: const LinearProgressIndicator(
                  value: 0.82,
                  minHeight: 3,
                  backgroundColor: Color(0xFF334155),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Walking Direction
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.directions_walk_rounded, size: 18, color: AppColors.textPrimary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Walk to Mayyanad Stop • 120 m (2 min walk)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Conductor / ETM Telematics Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.badge_outlined, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suresh Kumar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Verified Conductor • Contactless ETM',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.phone_outlined, size: 16, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Direct UPI Boarding Ticket CTA
        SizedBox(
          width: double.infinity,
          height: 48,
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
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Book Ticket • ₹22 (UPI)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Secondary Action Pills
        Row(
          children: [
            Expanded(
              child: _buildSecondaryAction(
                icon: Icons.share_outlined,
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
                icon: _stopAlarmEnabled ? Icons.notifications_active_outlined : Icons.notifications_off_outlined,
                label: _stopAlarmEnabled ? 'Alarm on' : 'Set alarm',
                isHighlighted: _stopAlarmEnabled,
                onTap: () => setState(() => _stopAlarmEnabled = !_stopAlarmEnabled),
              ),
            ),
          ],
        ),
        const SizedBox(height: 84),
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
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 16, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildFilterPill(String label) {
    final isSelected = _selectedFilter == label || (_selectedFilter == 'All' && label == 'All');
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.uberBlack : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? AppColors.uberBlack : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBusOptionCard({
    required String routeCode,
    required Color routeColor,
    required String busName,
    required String busPlate,
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
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isRecommended ? AppColors.primary : AppColors.border,
            width: isRecommended ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: routeColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                routeCode,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    busName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$etaMinutes min • $arrivalTime ($seatsAvailable seats free)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.uberBlack,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Track',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
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

  Widget _buildSecondaryAction({
    required IconData icon,
    required String label,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.surfaceSecondary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
            ),
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
