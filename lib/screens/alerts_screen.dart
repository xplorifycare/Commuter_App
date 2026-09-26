import 'package:flutter/material.dart';
import '../config/theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'title': 'Bus Approaching',
        'desc': 'Route 42 (To Chinnakada) arrives at Kadappakkada in 4 mins.',
        'time': 'Just now',
        'icon': Icons.directions_bus_outlined,
        'unread': true,
      },
      {
        'title': 'Wallet Top-up Successful',
        'desc': '₹200.00 added to GetMyBus Wallet via UPI.',
        'time': '2h ago',
        'icon': Icons.account_balance_wallet_outlined,
        'unread': false,
      },
      {
        'title': 'Trip Completed',
        'desc': 'Ticket GMB-2609-77341 validated by conductor. Hope you had a pleasant trip!',
        'time': 'Yesterday',
        'icon': Icons.check_circle_outline_rounded,
        'unread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 100),
          physics: const BouncingScrollPhysics(),
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Alerts',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.46,
                    color: AppColors.ink,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All alerts marked as read')),
                    );
                  },
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Open Alert List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alerts.length,
              itemBuilder: (context, i) {
                final a = alerts[i];
                final isUnread = a['unread'] as bool;

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: i == 0
                        ? null
                        : const Border(
                            top: BorderSide(color: AppColors.line, width: 1.0),
                          ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(
                          a['icon'] as IconData,
                          size: 18,
                          color: isUnread ? AppColors.primary : AppColors.ink,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  a['title'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  a['time'] as String,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.faint,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              a['desc'] as String,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.sub,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
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
