import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/theme.dart';

/// Full-screen boarding mode takeover overlay from GetMyBusApp_v4.jsx.
/// Expands the ticket QR code to arm's-length size with a blurred dimmed backdrop.
class BoardingModeOverlay extends StatefulWidget {
  final String ticketId;
  final VoidCallback onClose;

  const BoardingModeOverlay({
    super.key,
    this.ticketId = 'GMB-2609-77341',
    required this.onClose,
  });

  @override
  State<BoardingModeOverlay> createState() => _BoardingModeOverlayState();
}

class _BoardingModeOverlayState extends State<BoardingModeOverlay> {
  bool _scanned = false;

  void _confirm() {
    if (_scanned) return;
    setState(() => _scanned = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        widget.onClose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      behavior: HitTestBehavior.opaque,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Backdrop Blur + Dim
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  color: const Color(0xBD08090E), // rgba(8,9,14,0.74)
                ),
              ),
            ),

            // Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Arm's-length 224x224 QR Card
                  GestureDetector(
                    onTap: _confirm,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 224,
                      height: 224,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.sheet),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x80000000),
                            blurRadius: 60,
                            offset: Offset(0, 30),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (!_scanned)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: QrImageView(
                                data: widget.ticketId,
                                version: QrVersions.auto,
                                size: 184,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: AppColors.ink,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: AppColors.ink,
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 204,
                              height: 204,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(AppRadius.card),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 58,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Text
                  Text(
                    _scanned ? 'Boarding confirmed' : 'Show this to the conductor',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Ticket ID
                  Text(
                    widget.ticketId,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 11.5,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tap to close helper
                  Text(
                    'Tap anywhere to close',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.48),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
