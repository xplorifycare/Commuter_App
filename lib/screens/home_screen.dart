import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/illustration_placeholder.dart';
import '../widgets/live_rail_chip.dart';
import '../widgets/route_badge.dart';
import 'live_tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenTickets;
  final VoidCallback? onOpenAlerts;

  const HomeScreen({
    super.key,
    this.onOpenSearch,
    this.onOpenTickets,
    this.onOpenAlerts,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _noBuses = false;

  void _openLiveTracking(BuildContext context,
      {String routeId = '42', String destination = 'Chinnakada'}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveTrackingScreen(
          routeId: routeId,
          destination: destination,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 100),
          physics: const BouncingScrollPhysics(),
          children: [
            // 1. Header (Good morning / Where to? / Malayalam Subtitle)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.sub,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Where to?',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.46,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'എവിടേക്ക്?',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: AppColors.faint,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: widget.onOpenAlerts,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 22,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // 2. Search Field
            GestureDetector(
              onTap: widget.onOpenSearch,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: AppColors.faint,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search a stop, route or destination',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.faint,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),

            // 3. Illustration & Live Status Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IllustrationPlaceholder(
                  label: 'Illustration — commuter checking live bus location',
                  height: 160,
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => _openLiveTracking(context),
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Live',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '3 buses near you',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.17,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Route 42, 7B and 12 · within 5 min',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.sub,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'View map →',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // 4. Action Row (Nearby / Routes / Tickets)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionItem(
                  icon: Icons.location_on_outlined,
                  label: 'Nearby',
                  onTap: () => _openLiveTracking(context),
                ),
                _buildActionItem(
                  icon: Icons.explore_outlined,
                  label: 'Routes',
                  onTap: widget.onOpenSearch,
                ),
                _buildActionItem(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Tickets',
                  onTap: widget.onOpenTickets,
                ),
              ],
            ),
            const SizedBox(height: 26),

            // 5. Live Near You Horizontal Rail / NoBusesState (v3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Live near you',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _noBuses = !_noBuses;
                    });
                  },
                  child: Text(
                    _noBuses ? 'Show live buses' : 'Preview: no buses',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.faint,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_noBuses)
              const NoBusesState()
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    LiveRailChip(
                      route: '42',
                      eta: '4 min',
                      crowdColor: AppColors.success,
                      onTap: () => _openLiveTracking(context, routeId: '42'),
                    ),
                    const SizedBox(width: 10),
                    LiveRailChip(
                      route: '7B',
                      eta: '6 min',
                      crowdColor: AppColors.orange,
                      onTap: () => _openLiveTracking(context, routeId: '7B', destination: 'Chavara'),
                    ),
                    const SizedBox(width: 10),
                    LiveRailChip(
                      route: '12',
                      eta: '9 min',
                      crowdColor: AppColors.success,
                      onTap: () => _openLiveTracking(context, routeId: '12'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // 6. Milestone Commuter Reward Banner (v3)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '2 trips to your free ride',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Illustration — line-art bus crossing a small finish flag, milestone reward banner',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),

            // 7. Recent Trips Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Recent trips',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onOpenSearch,
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.sub,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Recent Trips List with RouteBadge
            _buildTripRow(
              route: '42',
              from: 'Kadappakada → Chinnakada',
              meta: '12 min ago',
              fare: '₹15',
              showTopBorder: false,
              onTap: () => _openLiveTracking(context, routeId: '42'),
            ),
            _buildTripRow(
              route: '7B',
              from: 'Kollam Bus Stand → Chavara',
              meta: 'Yesterday',
              fare: '₹22',
              showTopBorder: true,
              onTap: () => _openLiveTracking(context, routeId: '7B', destination: 'Chavara'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.ink,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.sub,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripRow({
    required String route,
    required String from,
    required String meta,
    required String fare,
    required bool showTopBorder,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: showTopBorder
              ? const Border(
                  top: BorderSide(color: AppColors.line, width: 1.0),
                )
              : null,
        ),
        child: Row(
          children: [
            RouteBadge(num: route),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    from,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.faint,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              fare,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.sub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state for the Home live rail during off-hours (late night / pre-dawn)
class NoBusesState extends StatelessWidget {
  const NoBusesState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.line,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 17,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No live buses right now',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Service resumes 5:30 AM · Illustration — line-art bus parked at a depot under a crescent moon',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.sub,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
