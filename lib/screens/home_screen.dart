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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Wordmark + Live Indicator
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/gmb_icon_pin.png',
                  width: 32,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'GetMyBus',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E5AE6),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(width: 4.5),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.statusLive,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Mayyanad Stop, Kollam',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Safety Toolkit & Profile Avatar
          Row(
            children: [
              // Transit Safety Toolkit Button
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      title: const Row(
                        children: [
                          Icon(Icons.shield_rounded, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Transit Safety Toolkit',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      content: const Text(
                        'GetMyBus 24x7 Commuter Support & Helpline:\n\n'
                        '• Highway Patrol Emergency: 112\n'
                        '• Telematics Desk: 1800-425-BUS\n'
                        '• Women Commuter Helpline: 1091',
                        style: TextStyle(fontSize: 13, height: 1.4),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_outlined, size: 16, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(width: 8),

              // Commuter Profile
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.uberBlack,
                child: Text(
                  'J',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
