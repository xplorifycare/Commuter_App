import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/illustration_placeholder.dart';
import 'live_tracking_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenTickets;
  final VoidCallback? onOpenAlerts;

  const HomeScreen({
    super.key,
    this.onOpenSearch,
    this.onOpenTickets,
    this.onOpenAlerts,
  });

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
            // 1. Header (Good morning / Where to?)
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
                  ],
                ),
                GestureDetector(
                  onTap: onOpenAlerts,
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
              onTap: onOpenSearch,
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
                      Column(
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
                  onTap: onOpenSearch,
                ),
                _buildActionItem(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Tickets',
                  onTap: onOpenTickets,
                ),
              ],
            ),
            const SizedBox(height: 26),

            // 5. Recent Trips Section
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
                  onTap: onOpenSearch,
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

            // Recent Trips List
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
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.tint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  route,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
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
