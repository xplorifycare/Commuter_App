import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/illustration_placeholder.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  static const bool seasonalOnam = false;

  final List<Map<String, String>> _slides = const [
    {
      'headline': 'Know exactly\nwhen it arrives.',
      'headlineMl': 'ബസ് എപ്പോൾ എത്തുമെന്ന് കൃത്യമായി അറിയാം',
      'body':
          'Live GPS tracking for every private bus route in Kollam — no more guessing at the stop.',
      'illustration':
          'Hero illustration — a single-line-art commuter at a bus stop watching a bus approach on a curved road, warm and calm, primary-blue line art on tint background',
      'image': 'assets/images/gmb_commuter_cartoon.jpg',
    },
    {
      'headline': 'Board without\nthe queue.',
      'headlineMl': 'ക്യൂ ഇല്ലാതെ ബസിൽ കയറാം',
      'body':
          'Buy your ticket in the app and show the code — no cash, no counting change.',
      'illustration':
          'Illustration — minimal line art of a phone showing a QR ticket being scanned by a conductor, single stroke weight, primary-blue on tint background',
      'image': 'assets/images/gmb_safety_cartoon.jpg',
    },
    {
      'headline': 'Top up once,\nride all week.',
      'headlineMl': 'ഒരിക്കൽ റീചാർജ് ചെയ്യൂ, ആഴ്ചയിലുടനീളം യാത്ര ചെയ്യൂ',
      'body':
          'Keep a running balance across every route and skip the fumbling at the door.',
      'illustration':
          'Illustration — minimal line art of a wallet with a single coin sliding in, one stroke weight, primary-blue on tint background',
      'image': 'assets/images/gmb_mascot_tracker.jpg',
    },
  ];

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinish();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(26, 20, 26, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seasonal Onam Bar (if active)
              if (seasonalOnam) ...[
                Row(
                  children: [
                    for (final color in const [
                      Color(0xFFFFC93C),
                      Color(0xFFFF6B6B),
                      Color(0xFF4ECDC4),
                      Color(0xFF2B57FF),
                      Color(0xFF8B5CF6),
                    ])
                      Expanded(
                        child: Container(
                          height: 3,
                          color: color,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
              ],

              // App Brand Header
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.directions_bus_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'GetMyBus',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.14,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Page Slider
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (idx) => setState(() => _currentIndex = idx),
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Illustration card / placeholder
                        Container(
                          width: double.infinity,
                          height: 280,
                          decoration: BoxDecoration(
                            color: AppColors.tint,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            slide['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                IllustrationPlaceholder(
                              label: slide['illustration']!,
                              height: 280,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Title
                        Text(
                          slide['headline']!,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.54,
                            height: 1.25,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Malayalam Subtitle
                        Text(
                          slide['headlineMl']!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.faint,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Body
                        Text(
                          slide['body']!,
                          style: const TextStyle(
                            fontSize: 14.5,
                            color: AppColors.sub,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Slide Pill Indicators
                        Row(
                          children: List.generate(_slides.length, (idx) {
                            final isActive = idx == _currentIndex;
                            return GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  idx,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 6),
                                width: isActive ? 18 : 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? AppColors.ink
                                      : AppColors.line,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Bottom Actions
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ink,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isLast ? 'Get started' : 'Next',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (!isLast)
                    GestureDetector(
                      onTap: widget.onFinish,
                      behavior: HitTestBehavior.opaque,
                      child: const Center(
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.sub,
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: widget.onFinish,
                      behavior: HitTestBehavior.opaque,
                      child: const Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.sub,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign in',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
