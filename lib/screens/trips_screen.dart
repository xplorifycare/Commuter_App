import 'package:flutter/material.dart';
import '../config/theme.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int _selectedTab = 0; // 0 = One way, 1 = Round trip, 2 = Archive
  int _selectedDateIndex = 3; // Selected 22 Feb
  bool _showingTicketDetail = false;

  final List<Map<String, String>> _dates = [
    {'day': '19', 'month': 'Feb', 'weekday': 'Mon'},
    {'day': '20', 'month': 'Feb', 'weekday': 'Tue'},
    {'day': '21', 'month': 'Feb', 'weekday': 'Wed'},
    {'day': '22', 'month': 'Feb', 'weekday': 'Thu'},
    {'day': '23', 'month': 'Feb', 'weekday': 'Fri'},
    {'day': '24', 'month': 'Feb', 'weekday': 'Sat'},
    {'day': '25', 'month': 'Feb', 'weekday': 'Sun'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showingTicketDetail ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: _showingTicketDetail
              ? _buildImage5TicketDetailView()
              : _buildImage5BookingView(),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── SCREEN A: BOOK TICKETS & SCHEDULES (Image 5 Left)
  // ══════════════════════════════════════════════════════════════
  Widget _buildImage5BookingView() {
    return ListView(
      key: const ValueKey('booking_view'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        // Top Greeting Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Jassim Collins',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.notifications_none_rounded, size: 20, color: AppColors.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Bold Title
        const Text(
          'Book Tickets',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 14),

        // Segmented Tab Pill: [One way] | [Round trip] | [Archive]
        _buildSegmentedTabRow(),
        const SizedBox(height: 18),

        // Origin / Destination Card with Swap Button
        _buildOriginDestinationCard(),
        const SizedBox(height: 20),

        // Horizontal Date Selector Strip
        _buildDateStrip(),
        const SizedBox(height: 24),

        // "The Fastest" Section Header + Filter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'The Fastest',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.tune_rounded, size: 14, color: AppColors.textPrimary),
                  SizedBox(width: 4),
                  Text('Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Search Result Bus Card 1 (Tap to view Boarding Pass)
        _buildFastestTripCard(
          routeCode: 'FP 6620 Express Corridor',
          fromTime: '7:25 AM',
          fromPlace: 'Mayyanad Stop',
          toTime: '8:15 AM',
          toPlace: 'Technopark TVM',
          duration: '50m',
          seatClass: 'Fast Passenger',
          price: '₹22',
          onTap: () => setState(() => _showingTicketDetail = true),
        ),
        const SizedBox(height: 12),

        // Search Result Bus Card 2
        _buildFastestTripCard(
          routeCode: 'EL 1040 Electric Low Floor',
          fromTime: '7:45 AM',
          fromPlace: 'Mayyanad Stop',
          toTime: '8:32 AM',
          toPlace: 'Technopark TVM',
          duration: '47m',
          seatClass: 'Electric AC',
          price: '₹35',
          onTap: () => setState(() => _showingTicketDetail = true),
        ),
      ],
    );
  }

  Widget _buildSegmentedTabRow() {
    final tabs = ['One way', 'Round trip', 'Archive'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOriginDestinationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // From Stop
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF10B981), width: 3),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('From', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                        SizedBox(height: 2),
                        Text('Mayyanad Stop, Kollam', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, indent: 26),
              const SizedBox(height: 12),

              // To Stop
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.purplePrimary, width: 3),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('To', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                        SizedBox(height: 2),
                        Text('Technopark Kazhakkoottam', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Floating Swap Button
          Positioned(
            right: 0,
            top: 24,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(Icons.swap_vert_rounded, size: 20, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStrip() {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = _selectedDateIndex == index;
          final d = _dates[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 48,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? const Color(0xFF0F172A) : Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isSelected ? 0.15 : 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    d['day']!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    d['month']!,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white70 : Colors.grey.shade500,
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

  Widget _buildFastestTripCard({
    required String routeCode,
    required String fromTime,
    required String fromPlace,
    required String toTime,
    required String toPlace,
    required String duration,
    required String seatClass,
    required String price,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'IC • NH66',
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF10B981)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    routeCode,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Route Timeline
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fromTime, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(fromPlace, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6))),
                  ],
                ),
                Row(
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                    Container(width: 40, height: 1.5, color: Colors.white24),
                    const Icon(Icons.directions_bus_rounded, size: 14, color: Colors.white),
                    Container(width: 40, height: 1.5, color: Colors.white24),
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(toTime, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(toPlace, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$seatClass • $duration',
                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white70),
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── SCREEN B: PHYSICAL NOTCH CUTOUT BOARDING PASS (Image 5 Right)
  // ══════════════════════════════════════════════════════════════
  Widget _buildImage5TicketDetailView() {
    return ListView(
      key: const ValueKey('ticket_detail_view'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        // Top Back Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => setState(() => _showingTicketDetail = false),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
            ),
            const Text(
              'Upcoming Trips',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white70),
            ),
            const SizedBox(width: 40),
          ],
        ),
        const SizedBox(height: 18),

        Text(
          '22 Feb, 7:25 AM',
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.60), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        const Text(
          'Mayyanad - Technopark',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
        ),
        const SizedBox(height: 20),

        // Physical Ticket Cutout Card with side notches
        _buildPhysicalNotchedCard(),
        const SizedBox(height: 22),

        // Mint Green Download Button (Image 5)
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Boarding Pass saved to downloads!')),
            );
          },
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: const Color(0xFF10B981).withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 6)),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.download_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'Download PDF',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Physical Boarding Pass Card with semicircular notch cutouts on edges and barcode
  Widget _buildPhysicalNotchedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 28, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upper Ticket Body
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Passenger',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Jassim McAllister',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 18),

                // Times & Route Timeline
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('8:25 AM', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                    Text('50 min', style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontWeight: FontWeight.w700)),
                    const Text('9:15 AM', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle)),
                    Expanded(child: Container(height: 1.5, color: Colors.grey.shade300)),
                    const Icon(Icons.directions_bus_rounded, size: 16, color: Color(0xFF0F172A)),
                    Expanded(child: Container(height: 1.5, color: Colors.grey.shade300)),
                    Container(width: 7, height: 7, decoration: const BoxDecoration(color: Color(0xFF0F172A), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mayyanad Stop', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
                    Text('Technopark TVM', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Colors.grey.shade800)),
                  ],
                ),
                const SizedBox(height: 20),

                Text(
                  'Booking Reference',
                  style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                const Text(
                  'GMB-2026-789458',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
                const SizedBox(height: 18),

                // Telematics Matrix Columns (Image 5)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMatrixCol('Bus Unit', '15'),
                    _buildMatrixCol('Trip Code', 'FP4521'),
                    _buildMatrixCol('Seat', '14'),
                  ],
                ),
              ],
            ),
          ),

          // Semicircular Cutout Notches Separator
          SizedBox(
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left Cutout Notch
                Positioned(
                  left: -12,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF111827), // Matches background
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Dashed Line
                Positioned.fill(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(
                          24,
                          (index) => Expanded(
                            child: Container(
                              color: index % 2 == 0 ? Colors.grey.shade300 : Colors.transparent,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Right Cutout Notch
                Positioned(
                  right: -12,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF111827), // Matches background
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lower Ticket Body (Scannable Barcode)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
            child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      48,
                      (i) => Container(
                        width: (i % 3 == 0 || i % 7 == 0) ? 3.0 : 1.5,
                        height: 38,
                        color: Colors.black.withOpacity((i % 5 == 0) ? 0.3 : 0.85),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Show barcode to bus conductor ETM scanner',
                  style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
