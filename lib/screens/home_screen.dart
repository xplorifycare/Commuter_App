import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/illustration_placeholder.dart';
import '../widgets/live_rail_chip.dart';
import '../widgets/mascot.dart';
import '../widgets/pulse_dot.dart';
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
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) => LiveTrackingScreen(
          routeId: routeId,
          destination: destination,
        ),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(0.08, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: const Cubic(0.22, 1, 0.36, 1)));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: animation.drive(tween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Scaffold(
      backgroundColor: tokens.bg,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: tokens.sub,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Where to?',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.46,
                        color: tokens.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'എവിടേക്ക്?',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: tokens.faint,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: widget.onOpenAlerts,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 22,
                      color: tokens.ink,
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
                  color: tokens.tint,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: tokens.faint,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search a stop, route or destination',
                        style: TextStyle(
                          fontSize: 14,
                          color: tokens.faint,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),

            // 3. Illustration & Live Status Row with PulseDot
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
                                PulseDot(color: tokens.success, size: 6),
                                const SizedBox(width: 6),
                                Text(
                                  'Live',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: tokens.success,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '3 buses near you',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.17,
                                color: tokens.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Route 42, 7B and 12 · within 5 min',
                              style: TextStyle(
                                fontSize: 13,
                                color: tokens.sub,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'View map →',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: tokens.primary,
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
                  tokens: tokens,
                  onTap: () => _openLiveTracking(context),
                ),
                _buildActionItem(
                  icon: Icons.explore_outlined,
                  label: 'Routes',
                  tokens: tokens,
                  onTap: widget.onOpenSearch,
                ),
                _buildActionItem(
                  icon: Icons.confirmation_number_outlined,
                  label: 'Tickets',
                  tokens: tokens,
                  onTap: widget.onOpenTickets,
                ),
              ],
            ),
            const SizedBox(height: 26),

            // 5. Live Near You Horizontal Rail / NoBusesState with Mascot (v4)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Live near you',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.ink,
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
                    style: TextStyle(
                      fontSize: 11,
                      color: tokens.faint,
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
                      crowdColor: tokens.success,
                      onTap: () => _openLiveTracking(context, routeId: '42'),
                    ),
                    const SizedBox(width: 10),
                    LiveRailChip(
                      route: '7B',
                      eta: '6 min',
                      crowdColor: tokens.orange,
                      onTap: () => _openLiveTracking(context, routeId: '7B', destination: 'Chavara'),
                    ),
                    const SizedBox(width: 10),
                    LiveRailChip(
                      route: '12',
                      eta: '9 min',
                      crowdColor: tokens.success,
                      onTap: () => _openLiveTracking(context, routeId: '12'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // 6. Upgraded Milestone Commuter Reward Banner (v4 Warm Terracotta Gradient)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [tokens.warm, const Color(0xFFA65E3D)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.sheet),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33C17A54),
                    blurRadius: 24,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(AppRadius.chip),
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
                            color: Colors.white.withOpacity(0.82),
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
                Text(
                  'Recent trips',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: tokens.ink,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onOpenSearch,
                  child: Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: tokens.sub,
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
              tokens: tokens,
              onTap: () => _openLiveTracking(context, routeId: '42'),
            ),
            _buildTripRow(
              route: '7B',
              from: 'Kollam Bus Stand → Chavara',
              meta: 'Yesterday',
              fare: '₹22',
              showTopBorder: true,
              tokens: tokens,
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
    required AppThemeTokens tokens,
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
              color: tokens.ink,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                color: tokens.sub,
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
    required AppThemeTokens tokens,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: showTopBorder
              ? Border(
                  top: BorderSide(color: tokens.line, width: 1.0),
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: tokens.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: TextStyle(
                      fontSize: 12,
                      color: tokens.faint,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              fare,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: tokens.sub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Upgraded empty state with continuous-stroke Mascot character (v4)
class NoBusesState extends StatelessWidget {
  const NoBusesState({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppThemeTokens.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: tokens.line,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: tokens.tint,
              borderRadius: BorderRadius.circular(AppRadius.chip),
            ),
            child: const Center(
              child: Mascot(size: 34),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No live buses right now',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: tokens.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Service resumes 5:30 AM',
                  style: TextStyle(
                    fontSize: 12,
                    color: tokens.sub,
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
