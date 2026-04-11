import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../../../home/presentation/screens/user_home_screen.dart';

class SelfieVerificationScreen extends StatelessWidget {
  const SelfieVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Selfie Verification',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Verify your identity by taking a photo\nthat matches your ID provided',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              
              // The Camera Overlay Frame Mockup
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  // We simulate the corners with a Stack or CustomPaint. 
                  // For simplicity, a stack of angled borders works well.
                ),
                child: Stack(
                  children: [
                    // Top Left
                    Positioned(
                      top: 0, left: 0,
                      child: _buildCorner(isTop: true, isLeft: true),
                    ),
                    // Top Right
                    Positioned(
                      top: 0, right: 0,
                      child: _buildCorner(isTop: true, isLeft: false),
                    ),
                    // Bottom Left
                    Positioned(
                      bottom: 0, left: 0,
                      child: _buildCorner(isTop: false, isLeft: true),
                    ),
                    // Bottom Right
                    Positioned(
                      bottom: 0, right: 0,
                      child: _buildCorner(isTop: false, isLeft: false),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              AuthButton(
                text: 'Open Camera',
                onPressed: () {
                  // Simulate successful profile creation/camera upload directly to Home.
                  Get.offAll(() => const UserHomeScreen());
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Colors.black, width: 8) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Colors.black, width: 8) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Colors.black, width: 8) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Colors.black, width: 8) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          bottomRight: !isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
        ),
      ),
    );
  }
}
