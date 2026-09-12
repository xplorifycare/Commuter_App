import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/theme.dart';

class CashlessBookingModal extends StatefulWidget {
  final String busName;
  final String destination;
  final int baseFare;
  final VoidCallback? onTicketCreated;

  const CashlessBookingModal({
    super.key,
    required this.busName,
    required this.destination,
    this.baseFare = 22,
    this.onTicketCreated,
  });

  static Future<void> show(
    BuildContext context, {
    required String busName,
    required String destination,
    int baseFare = 22,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CashlessBookingModal(
        busName: busName,
        destination: destination,
        baseFare: baseFare,
      ),
    );
  }

  @override
  State<CashlessBookingModal> createState() => _CashlessBookingModalState();
}

class _CashlessBookingModalState extends State<CashlessBookingModal> {
  int _passengerCount = 1;
  bool _isStudentConcession = false;
  String _selectedPaymentMethod = 'UPI'; // UPI, PhonePe, Cash
  bool _isProcessing = false;
  bool _isBooked = false;

  int get _ticketPrice {
    final unitPrice = _isStudentConcession ? 6 : widget.baseFare;
    return unitPrice * _passengerCount;
  }

  void _handlePay() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate instant UPI network clearance
    await Future.delayed(const Duration(milliseconds: 1100));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isBooked = true;
      });
      widget.onTicketCreated?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SafeArea(
        top: false,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
          child: _isBooked ? _buildSuccessTicketView() : _buildBookingFormView(),
        ),
      ),
    );
  }

  Widget _buildBookingFormView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Instant Bus Ticket',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.busName} • Contactless ETM',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/gmb_logo_color.png',
                height: 24,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Route Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.trip_origin_rounded, size: 15, color: AppColors.primary),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Mayyanad Stop',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, size: 15, color: AppColors.textMuted),
                const SizedBox(width: 8),
                const Icon(Icons.location_on_rounded, size: 15, color: AppColors.accentDark),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    widget.destination,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Passenger Counter & Concession Row
          Row(
            children: [
              // Passenger Count
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Passengers',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                      ),
                      Row(
                        children: [
                          _buildCounterBtn(
                            icon: Icons.remove,
                            onTap: _passengerCount > 1
                                ? () => setState(() => _passengerCount--)
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '$_passengerCount',
                              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                          ),
                          _buildCounterBtn(
                            icon: Icons.add,
                            onTap: _passengerCount < 6
                                ? () => setState(() => _passengerCount++)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Student Concession Chip
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isStudentConcession = !_isStudentConcession;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                  decoration: BoxDecoration(
                    color: _isStudentConcession ? AppColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _isStudentConcession ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isStudentConcession ? Icons.check_circle_rounded : Icons.school_outlined,
                        size: 15,
                        color: _isStudentConcession ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Student Pass',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isStudentConcession ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Payment Methods
          const Text(
            'PAYMENT METHOD',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              _buildPaymentChip('UPI', 'UPI / GPay', Icons.account_balance_wallet_rounded),
              const SizedBox(width: 8),
              _buildPaymentChip('PhonePe', 'PhonePe', Icons.phone_android_rounded),
              const SizedBox(width: 8),
              _buildPaymentChip('Cash', 'Cash at ETM', Icons.payments_rounded),
            ],
          ),
          const SizedBox(height: 18),

          // Total Fare & CTA Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL FARE',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 0.5),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹$_ticketPrice',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'incl. taxes',
                        style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),

              // Pay Button
              SizedBox(
                width: 170,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handlePay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.uberBlack,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pay Cashless',
                              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 15),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterBtn({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: onTap != null ? AppColors.surfaceSecondary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 15,
          color: onTap != null ? AppColors.textPrimary : AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildPaymentChip(String key, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPaymentMethod = key),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.06) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 17,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessTicketView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 3D Cartoon Ticket Illustration with Gold Coins
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/ticket_3d.jpg',
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),

          const Text(
            'Payment Confirmed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.statusLive.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '₹5 cashback credited to wallet',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.statusLive),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Show this dynamic QR code to conductor’s handheld ETM',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // Digital Ticket Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.busName,
                          style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          'Mayyanad → Technopark TVM',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '₹$_ticketPrice',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // QR Code
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: QrImageView(
                    data: 'GMB-ETM-${widget.busName}-KL02BB4521-TKT8921-$_ticketPrice',
                    version: QrVersions.auto,
                    size: 140.0,
                    embeddedImage: const AssetImage('assets/images/gmb_icon_pin.png'),
                    embeddedImageStyle: const QrEmbeddedImageStyle(
                      size: Size(28, 28),
                    ),
                    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.uberBlack),
                    dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AppColors.uberBlack),
                  ),
                ),
                const SizedBox(height: 12),

                // PIN Code
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ETM PIN: ',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Text(
                        'GMB-7419',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Close Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.uberBlack,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
