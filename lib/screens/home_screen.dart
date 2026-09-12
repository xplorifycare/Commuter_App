import 'dart:ui';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.85)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/gmb_icon_pin.png',
                        width: 34,
                        height: 34,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Flexible(
                                child: Text(
                                  'Hello, Jassim 👋',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 5.5,
                                height: 5.5,
                                decoration: const BoxDecoration(
                                  color: AppColors.statusLive,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'Mayyanad Stop • NH66 Live',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
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
              const SizedBox(width: 10),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary.withOpacity(0.78),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.shield_outlined,
                    size: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: AppColors.brandGradient,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Center(
                  child: Text(
                    'J',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
