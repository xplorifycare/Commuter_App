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
  UberSheetState _sheetState = UberSheetState.discovery;
  String? _selectedDestination;
  String? _selectedBusName;

  void _onDestinationSelected(String destination) {
    setState(() {
      _selectedDestination = destination;
      _sheetState = UberSheetState.busSelection;
    });
  }

  void _onBusSelected(String busName) {
    setState(() {
      _selectedBusName = busName;
      _sheetState = UberSheetState.activeTracking;
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
      body: Stack(
        children: [
          // ── 1. FULL SCREEN LIVE REAL MAP (OPENSTREETMAP / CARTO) ──
          Positioned.fill(
            child: UberMapView(
              liveBuses: activeBuses,
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

          // ── 2. UBER TOP FLOATING APP BAR ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: _buildTopFloatingBar(),
          ),

          // ── 3. UBER DYNAMIC SLIDING BOTTOM SHEET ──
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
      ),
    );
  }

  Widget _buildTopFloatingBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/gmb_icon_pin.png',
            width: 26,
            height: 26,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          const Text(
            'GetMyBus',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFCCFBF1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'NH66 Live Corridor',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F766E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.my_location_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
