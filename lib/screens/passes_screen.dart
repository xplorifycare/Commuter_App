import 'package:flutter/material.dart';
import '../config/theme.dart';

class PassesScreen extends StatefulWidget {
  const PassesScreen({super.key});

  @override
  State<PassesScreen> createState() => _PassesScreenState();
}

class _PassesScreenState extends State<PassesScreen> {
  int _activeStep = 0; // 0 = Feature Intro (Image 2), 1 = Benefits (Image 3), 2 = Active Smartcard Pass

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.obsidianDark,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: switch (_activeStep) {
            0 => _buildImage2HeroView(),
            1 => _buildImage3BenefitsView(),
            _ => _buildActivePassDigitalCardView(),
          },
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── SCREEN 1: "ONE PASS, RIDE ANYTIME, TRAVEL SMARTER" (Image 2)
  // ══════════════════════════════════════════════════════════════
  Widget _buildImage2HeroView() {
    return Stack(
      key: const ValueKey('step_0_hero'),
      children: [
        // Orbital Background Rings & Sparkles
        _buildOrbitalDecorations(),

        // Main Content
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back / Info Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.brandBlue.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.brandBlue.withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.nfc_rounded, size: 14, color: AppColors.brandCyan),
                        SizedBox(width: 4),
                        Text(
                          'ETM TAP READY',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.brandCyan,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Floating 3D RFID Card Graphic (Image 2)
              Center(
                child: SizedBox(
                  height: 210,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Electric Cyan/Blue Glowing Telematics Blob
                      Positioned(
                        left: 20,
                        top: 20,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.brandCyan.withOpacity(0.55),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Tilted Perspective Matte Black Smartcard
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateZ(-0.24)
                          ..rotateX(0.18),
                        child: Container(
                          width: 250,
                          height: 150,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.brandCyan.withOpacity(0.35)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.50),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                              BoxShadow(
                                color: AppColors.brandBlue.withOpacity(0.25),
                                blurRadius: 20,
                                offset: const Offset(-8, -4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'GETMYBUS PASS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.contactless_rounded,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 24,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.6)),
                                    ),
                                  ),
                                  const Text(
                                    '•••• 8819',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white60,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Headline Masterpiece (Image 2)
              const Text(
                'One pass\nRide anytime\nTravel',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),

              // Smarter enclosed in the signature gradient hairline pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.brandCyan, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandCyan.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Smarter',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Subtitle
              Text(
                'No fuss, no hassle, just tap your GetMyBus Pass on the conductor\'s handheld ETM and ride smoothly across Kerala.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.65),
                  height: 1.4,
                ),
              ),
              const Spacer(),

              // Gradient Capsule Continue Button (Image 2)
              _buildGradientContinueButton(
                onTap: () => setState(() => _activeStep = 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── SCREEN 2: 3 BENEFIT VALUE CARDS (Image 3)
  // ══════════════════════════════════════════════════════════════
  Widget _buildImage3BenefitsView() {
    return Stack(
      key: const ValueKey('step_1_benefits'),
      children: [
        _buildOrbitalDecorations(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              // Top Back Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _activeStep = 0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const Text(
                    'GETMYBUS PASS BENEFITS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brandCyan,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const Spacer(),

              // Card 1: Ribbon / Loop (Cashless, queueless, stressless)
              _buildBenefitRow(
                icon: Icons.all_inclusive_rounded,
                cardColor: AppColors.brandBlue,
                title: 'Ride cashless, queueless,\nstressless.',
              ),
              const SizedBox(height: 36),

              // Card 2: Bar Chart (Track usage in real time)
              _buildBenefitRow(
                icon: Icons.bar_chart_rounded,
                cardColor: const Color(0xFF0284C7),
                title: 'Track usage & savings in real time.',
              ),
              const SizedBox(height: 36),

              // Card 3: Lightning Bolt (Recharge passes anytime)
              _buildBenefitRow(
                icon: Icons.bolt_rounded,
                cardColor: AppColors.brandCyanDark,
                title: 'Instant UPI tap & recharge\non conductor\'s handheld ETM.',
              ),
              const Spacer(),

              // Gradient Continue Button (Activates Pass)
              _buildGradientContinueButton(
                label: 'Activate Smart Pass',
                onTap: () => setState(() => _activeStep = 2),
              ),
              const SizedBox(height: 10),
              Text(
                'Pass terms and details apply',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.40),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitRow({
    required IconData icon,
    required Color cardColor,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: 84,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cardColor, cardColor.withOpacity(0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.40),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 26),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── SCREEN 3: ACTIVE SMARTCARD PASS (Dynamic NFC / QR View)
  // ══════════════════════════════════════════════════════════════
  Widget _buildActivePassDigitalCardView() {
    return ListView(
      key: const ValueKey('step_2_active'),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      physics: const BouncingScrollPhysics(),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => setState(() => _activeStep = 1),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
            ),
            const Text(
              'MY ACTIVE PASS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.statusLive.withOpacity(0.20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.statusLive),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // High-end Digital Pass Card
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.brandCyan.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandBlue.withOpacity(0.30),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'GETMYBUS COMMUTER PASS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: AppColors.brandCyan,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Icon(Icons.contactless_rounded, color: Colors.white.withOpacity(0.8), size: 24),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Kollam ↔ Technopark',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Valid on all Fast Passenger & Electric AC buses',
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCardMetric('RIDES LEFT', '24 / 30'),
                  _buildCardMetric('EXPIRES', '30 Sep 2026'),
                  _buildCardMetric('SAVINGS', '₹340'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Quick ETM Scanner NFC Instruction
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.purplePrimary.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.nfc_rounded, color: Color(0xFFC084FC), size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tap phone on Conductor ETM',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Hold near the machine for 1-second instant tap verification.',
                      style: TextStyle(fontSize: 11, color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Reset / Re-explore button
        Center(
          child: TextButton(
            onPressed: () => setState(() => _activeStep = 0),
            child: Text(
              'View Pass Presentation ›',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.white.withOpacity(0.50),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── REUSABLE CTA BUTTON & DECORATIONS
  // ══════════════════════════════════════════════════════════════
  Widget _buildGradientContinueButton({
    String label = 'Continue',
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandBlue.withOpacity(0.40),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 32),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.24),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrbitalDecorations() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -40,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.5),
                ),
              ),
            ),
            Positioned(
              top: 40,
              right: -80,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFC084FC).withOpacity(0.08), width: 1.5),
                ),
              ),
            ),
            Positioned(
              top: 70,
              right: 80,
              child: Icon(Icons.star_rounded, size: 14, color: const Color(0xFFF472B6).withOpacity(0.6)),
            ),
            Positioned(
              top: 220,
              right: 40,
              child: Icon(Icons.star_rounded, size: 16, color: const Color(0xFFC084FC).withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
