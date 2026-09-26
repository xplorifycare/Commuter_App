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
    final tokens = AppThemeTokens.of(context);

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
      backgroundColor: tokens.bg,
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

          // Floating Pill Bottom Navigation Bar (GetMyBusApp_v4.jsx)
          Positioned(
            left: 18,
            right: 18,
            bottom: 16 + MediaQuery.of(context).padding.bottom,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: tokens.surface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(tokens.isDark ? 0.45 : 0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_rounded, 'Home', tokens),
                  _buildNavItem(1, Icons.search_rounded, 'Search', tokens),
                  _buildNavItem(2, Icons.confirmation_number_outlined, 'Tickets', tokens),
                  _buildNavItem(3, Icons.notifications_none_rounded, 'Alerts', tokens),
                  _buildNavItem(4, Icons.person_outline_rounded, 'Profile', tokens),
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
    IconData icon,
    String label,
    AppThemeTokens tokens,
  ) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? tokens.ink : tokens.faint;

    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: () => _onTabTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isSelected ? tokens.tint : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
