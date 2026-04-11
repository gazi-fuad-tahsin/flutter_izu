import 'package:flutter/material.dart';

/// Reusable OTP Verification Status Popup
/// Shows success or failure with appropriate icons and messages
class OtpVerificationPopup extends StatefulWidget {
  final bool isSuccess;
  final String message;
  final Duration displayDuration;
  final VoidCallback? onDismiss;

  const OtpVerificationPopup({
    super.key,
    required this.isSuccess,
    required this.message,
    this.displayDuration = const Duration(seconds: 3),
    this.onDismiss,
  });

  @override
  State<OtpVerificationPopup> createState() => _OtpVerificationPopupState();
}

class _OtpVerificationPopupState extends State<OtpVerificationPopup> {
  @override
  void initState() {
    super.initState();
    // Auto-dismiss after specified duration
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        Navigator.pop(context);
        widget.onDismiss?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status Icon with animated appearance
              ScaleTransition(
                scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                  CurvedAnimation(
                    parent: ModalRoute.of(context)!.animation!,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isSuccess
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Image.asset(
                      widget.isSuccess
                          ? 'assets/icons/success.png'
                          : 'assets/icons/failed.png',
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Status Message
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Optional decorative dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show OTP verification popup
void showOtpVerificationPopup({
  required BuildContext context,
  required bool isSuccess,
  required String message,
  Duration displayDuration = const Duration(seconds: 3),
  VoidCallback? onDismiss,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => OtpVerificationPopup(
      isSuccess: isSuccess,
      message: message,
      displayDuration: displayDuration,
      onDismiss: onDismiss,
    ),
  );
}
