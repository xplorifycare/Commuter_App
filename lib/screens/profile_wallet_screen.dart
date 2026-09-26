import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../services/theme_service.dart';
import 'onboarding_screen.dart';

class ProfileWalletScreen extends StatelessWidget {
  const ProfileWalletScreen({super.key});

  void _openOnboarding(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OnboardingScreen(
          onFinish: () => Navigator.of(context).pop(),
        ),
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
            // 1. Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.46,
                    color: tokens.ink,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings opened')),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Icon(
                        Icons.settings_outlined,
                        size: 18,
                        color: tokens.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 2. User Row (Avatar + Info + Edit)
            Row(
              children: [
                // 52x52 Ink Avatar "J"
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: tokens.ink,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'J',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: tokens.bg,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Name & Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jassim S.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tokens.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '+91 98•••••210',
                        style: TextStyle(
                          fontSize: 13,
                          color: tokens.sub,
                        ),
                      ),
                    ],
                  ),
                ),

                // Edit Text Button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile')),
                    );
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: tokens.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 3. Wallet Card with Ambient Accent Circle (v4)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: tokens.line),
                color: tokens.surface,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Ambient Accent Circle at Top-Right
                  Positioned(
                    right: -18,
                    top: -18,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tokens.tint.withOpacity(0.7),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.credit_card_rounded,
                                    size: 16, color: tokens.sub),
                                const SizedBox(width: 8),
                                Text(
                                  'Wallet',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: tokens.sub,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Wallet history')),
                                );
                              },
                              child: Text(
                                'History →',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: tokens.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '₹245.50',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.28,
                            color: tokens.ink,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening UPI instant wallet recharge...'),
                              ),
                            );
                          },
                          child: Text(
                            '+ Add money',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: tokens.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Illustration spot (optional) — tiny line-art coin or houseboat motif could sit inside the soft circle behind the balance, top-right of the wallet card',
              style: TextStyle(
                fontSize: 10.5,
                color: tokens.faint,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 18),

            // 4. CO₂ Carbon Savings Impact Pill (v4)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: tokens.successBg,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.eco_rounded,
                    size: 16,
                    color: tokens.success,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "You've saved ",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: tokens.ink,
                        ),
                        children: const [
                          TextSpan(
                            text: '~4.2 kg',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                          TextSpan(
                            text: ' CO₂ this month by riding the bus',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // 5. Saved Places Section
            Text(
              'Saved places',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tokens.ink,
              ),
            ),
            const SizedBox(height: 4),
            _buildSettingsRow(
              icon: Icons.home_outlined,
              label: 'Home',
              tokens: tokens,
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.work_outline_rounded,
              label: 'Work',
              tokens: tokens,
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.add_rounded,
              label: 'Add new place',
              isLast: true,
              tokens: tokens,
              onTap: () {},
            ),
            const SizedBox(height: 22),

            // 6. Settings Section (including Dark Theme Switch)
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: tokens.ink,
              ),
            ),
            const SizedBox(height: 4),
            _buildSettingsRow(
              icon: Icons.dark_mode_outlined,
              label: 'Dark theme',
              tokens: tokens,
              right: Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: tokens.isDark,
                  activeColor: tokens.primary,
                  onChanged: (val) {
                    try {
                      context.read<ThemeProvider>().toggleTheme();
                    } catch (_) {}
                  },
                ),
              ),
              onTap: () {
                try {
                  context.read<ThemeProvider>().toggleTheme();
                } catch (_) {}
              },
            ),
            _buildSettingsRow(
              icon: Icons.credit_card_rounded,
              label: 'Payment methods',
              tokens: tokens,
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.notifications_none_rounded,
              label: 'Notifications',
              tokens: tokens,
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.language_rounded,
              label: 'Language',
              tokens: tokens,
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.help_outline_rounded,
              label: 'Help & support',
              tokens: tokens,
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.auto_stories_outlined,
              label: 'Onboarding walkthrough',
              tokens: tokens,
              onTap: () => _openOnboarding(context),
            ),
            _buildSettingsRow(
              icon: Icons.logout_rounded,
              label: 'Log out',
              isDanger: true,
              isLast: true,
              tokens: tokens,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logging out...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required String label,
    required AppThemeTokens tokens,
    bool isDanger = false,
    bool isLast = false,
    Widget? right,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: tokens.line,
                    width: 1.0,
                  ),
                ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.5),
              child: Icon(
                icon,
                size: 18,
                color: isDanger ? tokens.danger : tokens.ink,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDanger ? tokens.danger : tokens.ink,
                ),
              ),
            ),
            right ??
                (!isDanger
                    ? Text(
                        '›',
                        style: TextStyle(
                          fontSize: 18,
                          color: tokens.faint,
                        ),
                      )
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}
