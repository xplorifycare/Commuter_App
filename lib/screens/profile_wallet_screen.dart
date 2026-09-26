import 'package:flutter/material.dart';
import '../config/theme.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 100),
          physics: const BouncingScrollPhysics(),
          children: [
            // 1. Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile',
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
                      const SnackBar(content: Text('Settings opened')),
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
            const SizedBox(height: 22),

            // 2. User Row (Avatar + Info + Edit)
            Row(
              children: [
                // 52x52 Ink Avatar "J"
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'J',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Name & Phone
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jassim S.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '+91 98•••••210',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.sub,
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
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 3. Wallet Card with Ambient Accent Circle (v3)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
                color: Colors.white,
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
                        color: AppColors.tint.withOpacity(0.7),
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
                            const Row(
                              children: [
                                Icon(Icons.credit_card_rounded,
                                    size: 16, color: AppColors.sub),
                                SizedBox(width: 8),
                                Text(
                                  'Wallet',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.sub,
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
                              child: const Text(
                                'History →',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '₹245.50',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.28,
                            color: AppColors.ink,
                            fontFeatures: [FontFeature.tabularFigures()],
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
                          child: const Text(
                            '+ Add money',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
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
            const Text(
              'Illustration spot (optional) — tiny line-art coin or houseboat motif could sit inside the soft circle behind the balance, top-right of the wallet card',
              style: TextStyle(
                fontSize: 10.5,
                color: AppColors.faint,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 18),

            // 4. CO₂ Carbon Savings Impact Pill (v3)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.eco_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "You've saved ",
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.ink,
                        ),
                        children: [
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
            const Text(
              'Saved places',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            _buildSettingsRow(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.work_outline_rounded,
              label: 'Work',
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.add_rounded,
              label: 'Add new place',
              isLast: true,
              onTap: () {},
            ),
            const SizedBox(height: 22),

            // 5. Settings Section
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
            _buildSettingsRow(
              icon: Icons.credit_card_rounded,
              label: 'Payment methods',
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.notifications_none_rounded,
              label: 'Notifications',
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.language_rounded,
              label: 'Language',
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.help_outline_rounded,
              label: 'Help & support',
              onTap: () {},
            ),
            _buildSettingsRow(
              icon: Icons.auto_stories_outlined,
              label: 'Onboarding walkthrough',
              onTap: () => _openOnboarding(context),
            ),
            _buildSettingsRow(
              icon: Icons.logout_rounded,
              label: 'Log out',
              isDanger: true,
              isLast: true,
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
    bool isDanger = false,
    bool isLast = false,
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
              : const Border(
                  bottom: BorderSide(
                    color: AppColors.line,
                    width: 1.0,
                  ),
                ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDanger ? AppColors.danger : AppColors.ink,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDanger ? AppColors.danger : AppColors.ink,
                ),
              ),
            ),
            if (!isDanger)
              const Text(
                '›',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.faint,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
