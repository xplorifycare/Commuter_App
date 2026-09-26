import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/crowd_gauge.dart';
import '../widgets/illustration_placeholder.dart';
import '../widgets/route_badge.dart';
import 'live_tracking_screen.dart';

class RouteSearchScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const RouteSearchScreen({super.key, this.onBack});

  @override
  State<RouteSearchScreen> createState() => _RouteSearchScreenState();
}

class _RouteSearchScreenState extends State<RouteSearchScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = const [
    'Fastest',
    'Cheapest',
    'Fewest stops',
    'AC Buses',
  ];

  final List<Map<String, dynamic>> _routes = const [
    {
      'num': '42',
      'time': '9:40 → 9:58 AM',
      'meta': '18 min · 4 stops',
      'fare': '₹15',
      'crowd': 'Low',
      'crowdColor': AppColors.success,
      'destination': 'Chinnakada',
    },
    {
      'num': '7B',
      'time': '9:45 → 10:12 AM',
      'meta': '27 min · 7 stops',
      'fare': '₹22',
      'crowd': 'Medium',
      'crowdColor': AppColors.orange,
      'destination': 'Chavara',
    },
    {
      'num': '12',
      'time': '9:52 → 10:20 AM',
      'meta': '28 min · 6 stops',
      'fare': '₹18',
      'crowd': 'Low',
      'crowdColor': AppColors.success,
      'destination': 'Chinnakada',
    },
  ];

  void _openLiveTracking(Map<String, dynamic> route) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveTrackingScreen(
          routeId: route['num'] as String,
          destination: route['destination'] as String,
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
            // 1. ScreenHeader
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onBack ?? () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 19,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Search routes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.16,
                    color: AppColors.ink,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search filters opened')),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Icon(
                        Icons.settings_outlined,
                        size: 18,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Kerala-Touch Illustration Spot (v3)
            const IllustrationPlaceholder(
              label: 'Illustration — minimal single-line bus stop signpost with a faint coconut-palm silhouette, Kerala touch',
              height: 120,
            ),
            const SizedBox(height: 18),

            // 3. From / To Card (in #F1F3F8)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // FROM
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: AppColors.faint,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'Kollam Bus Stand',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Divider
                  Container(
                    height: 1,
                    color: AppColors.lineDivider,
                    margin: const EdgeInsets.only(left: 4, top: 12, bottom: 12),
                  ),

                  // TO
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: AppColors.faint,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'Chinnakada',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. Filter Underline Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final isSelected = _selectedFilterIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = i),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: EdgeInsets.only(right: i < _filters.length - 1 ? 20 : 0),
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected ? AppColors.ink : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Text(
                        _filters[i],
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppColors.ink : AppColors.sub,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 18),

            // 5. Results Header & Sort
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '6 routes found',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.sub,
                  ),
                ),
                Text(
                  'Sort: Fastest ▾',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // 6. Open Route List with CrowdGauge (size sm)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _routes.length,
              itemBuilder: (context, i) {
                final r = _routes[i];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: i == 0
                        ? null
                        : const Border(
                            top: BorderSide(color: AppColors.line, width: 1.0),
                          ),
                  ),
                  child: Column(
                    children: [
                      // Top Row: Badge, Time, Fare
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RouteBadge(num: r['num'] as String),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r['time'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    r['meta'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.faint,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                r['fare'] as String,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 1),
                              const Text(
                                'per seat',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.faint,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Bottom Row: CrowdGauge & Track bus →
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CrowdGauge(
                            level: r['crowd'] as String,
                            color: r['crowdColor'] as Color,
                            size: CrowdGaugeSize.sm,
                          ),
                          GestureDetector(
                            onTap: () => _openLiveTracking(r),
                            behavior: HitTestBehavior.opaque,
                            child: const Text(
                              'Track bus →',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
