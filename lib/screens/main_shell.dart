import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'home_screen.dart';
import 'route_search_screen.dart';
import 'digital_ticket_screen.dart';
import 'alerts_screen.dart';
import 'profile_wallet_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onOpenSearch: () => _onTabTapped(1),
        onOpenTickets: () => _onTabTapped(2),
        onOpenAlerts: () => _onTabTapped(3),
      ),
      RouteSearchScreen(
        onBack: () => _onTabTapped(0),
      ),
      DigitalTicketScreen(
        onBack: () => _onTabTapped(0),
      ),
      const AlertsScreen(),
      const ProfileWalletScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Screen PageView
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: screens,
            ),
          ),

          // Exact 5-Tab Figma Bottom Navigation Dock
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom > 0
                    ? MediaQuery.of(context).padding.bottom
                    : 8,
                top: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.96),
                border: const Border(
                  top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                  _buildNavItem(1, Icons.search_rounded, Icons.search_rounded, 'Search'),
                  _buildNavItem(2, Icons.confirmation_number_rounded, Icons.confirmation_number_outlined, 'Tickets'),
                  _buildNavItem(3, Icons.notifications_rounded, Icons.notifications_none_rounded, 'Alerts'),
                  _buildNavItem(4, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              size: 22,
              color: isSelected
                  ? AppColors.brandBlue
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? AppColors.brandBlue
                    : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
