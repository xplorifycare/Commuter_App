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

              // Floating 3D RFID Card Graphic (Image 2 with 3D Pixar asset)
              Center(
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Electric Cyan/Blue Glowing Telematics Halo
                      Positioned(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.brandCyan.withOpacity(0.35),
                                AppColors.brandBlue.withOpacity(0.15),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Tilted Perspective 3D Pixar Smartcard
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateZ(-0.08)
                          ..rotateY(0.06),
                        child: Container(
                          width: 220,
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.50),
                                blurRadius: 28,
                                offset: const Offset(0, 14),
                              ),
                              BoxShadow(
                                color: AppColors.brandCyan.withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'assets/images/pixar_smartcard_3d.jpg',
                              fit: BoxFit.cover,
                            ),
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
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.0,
                  height: 1.12,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => AppColors.brandGradient.createShader(bounds),
                child: const Text(
                  'Smarter.',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.0,
                    height: 1.12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Instant ETM contactless tap on any Kerala bus. Zero physical cash needed.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.65),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const Spacer(),

              // Continue Button
              _buildGradientContinueButton(
                label: 'Explore Benefits',
                onTap: () => setState(() => _activeStep = 1),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── SCREEN 2: 3 BENEFIT STACK CARDS (Image 3 with 3D Pixar Elements)
  // ══════════════════════════════════════════════════════════════
  Widget _buildImage3BenefitsView() {
    return Stack(
      key: const ValueKey('step_1_benefits'),
      children: [
        // Orbital Sparkles
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

              // Card 1: 3D Pixar Bus (Cashless, queueless, stressless)
              _buildBenefitRow(
                imageAsset: 'assets/images/pixar_bus.jpg',
                title: 'Ride cashless, queueless,\nstressless across all buses.',
              ),
              const SizedBox(height: 28),

              // Card 2: 3D Pixar ETM (Instant conductor validation)
              _buildBenefitRow(
                imageAsset: 'assets/images/pixar_etm_3d.jpg',
                title: 'Track usage & tap instantly\non conductor handheld ETM.',
              ),
              const SizedBox(height: 28),

              // Card 3: 3D Pixar Smartcard (Contactless tap & recharge)
              _buildBenefitRow(
                imageAsset: 'assets/images/pixar_smartcard_3d.jpg',
                title: 'Instant UPI tap & recharge\nwith smart NFC microchip.',
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
    required String imageAsset,
    required String title,
  }) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandCyan.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14.5,
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
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/pixar_smartcard_3d.jpg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'GETMYBUS COMMUTER PASS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.brandCyan,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/pixar_etm_3d.jpg',
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
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
