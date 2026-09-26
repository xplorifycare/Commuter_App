import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/theme.dart';
import '../widgets/illustration_placeholder.dart';
import '../widgets/route_badge.dart';

class DigitalTicketScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const DigitalTicketScreen({super.key, this.onBack});

  @override
  State<DigitalTicketScreen> createState() => _DigitalTicketScreenState();
}

class _DigitalTicketScreenState extends State<DigitalTicketScreen> {
  bool _scanned = false;

  void _simulateScan() {
    setState(() => _scanned = true);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() => _scanned = false);
      }
    });
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
                  'My ticket',
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
                      const SnackBar(content: Text('Ticket share link copied')),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                      child: Icon(
                        Icons.share_outlined,
                        size: 18,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 2. Illustration Placeholder (height 150)
            const IllustrationPlaceholder(
              label: 'Illustration — commuter holding a confirmed bus ticket',
              height: 150,
            ),
            const SizedBox(height: 22),

            // 3. Ticket Card Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge 42 & Confirmed
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RouteBadge(num: '42'),
                    Text(
                      'Confirmed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Timing & Destinations
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '9:40 AM',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Kollam Bus Stand',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.faint,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '→',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.faint,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '9:58 AM',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Chinnakada',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.faint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date, Seat, Bus No
                Container(
                  padding: const EdgeInsets.only(top: 18),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.line, width: 1.0),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.faint,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '26 Sep 2026',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seat',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.faint,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'A14',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bus no.',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.faint,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'KL-23 4521',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 4. Boarding-Pass Style Tear Notches & Tap-to-Scan Simulation (v3)
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Left Cutout Notch
                Positioned(
                  left: -32,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                        border: Border.all(color: AppColors.line),
                      ),
                    ),
                  ),
                ),
                // Right Cutout Notch
                Positioned(
                  right: -32,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                        border: Border.all(color: AppColors.line),
                      ),
                    ),
                  ),
                ),
                // Perforated Content
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppColors.line,
                        width: 1.5,
                      ),
                      bottom: BorderSide(
                        color: AppColors.line,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _simulateScan,
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 108,
                          height: 108,
                          decoration: BoxDecoration(
                            color: _scanned ? AppColors.success : AppColors.ink,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: _scanned
                              ? const Center(
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 44,
                                    color: Colors.white,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: QrImageView(
                                    data: 'GMB-2609-77341',
                                    version: QrVersions.auto,
                                    size: 92,
                                    eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: Colors.white,
                                    ),
                                    dataModuleStyle: const QrDataModuleStyle(
                                      dataModuleShape: QrDataModuleShape.square,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        _scanned ? 'Boarding confirmed' : 'Show this code to the conductor',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.sub,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'GMB-2609-77341',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.faint,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (!_scanned) ...[
                        const SizedBox(height: 6),
                        const Text(
                          '(tap the code to preview the scan confirmation)',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.faint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // 5. Fare Breakdown
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Base fare',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.sub,
                      ),
                    ),
                    Text(
                      '₹13.00',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Taxes & fees',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.sub,
                      ),
                    ),
                    Text(
                      '₹2.00',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.line, width: 1.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total paid',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        '₹15.00',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 6. Shareable Trip Card & WhatsApp CTA (v3)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share this trip',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GETMYBUS',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.8,
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Kollam → Chinnakada',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Route 42 · 18 min · on time',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening WhatsApp share...')),
                      );
                    },
                    icon: const Icon(Icons.share_rounded, size: 16, color: Colors.white),
                    label: const Text(
                      'Share to WhatsApp',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.whatsappGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 7. Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ticket added to Apple/Google Wallet'),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: AppColors.line),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Add to wallet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Receipt downloaded successfully'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.ink,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
