import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/auth/presentation/controller/auth_controller.dart';

void showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Log Out',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF808080),
          ),
        ),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2870BC),
              ),
            ),
          ),
          // Confirm Button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Call logout from auth controller
              _performLogout();
            },
            child: const Text(
              'Yes, Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// Helper function to perform logout
Future<void> _performLogout() async {
  try {
    // Get AuthController with proper type
    final authController = Get.find<AuthController>();
    
    // Call logout which handles everything:
    // 1. Shows success snackbar
    // 2. Clears tokens
    // 3. Navigates to login screen
    await authController.logout();
  } catch (e) {
    print('Error during logout: $e');
    Get.snackbar(
      'Error',
      'Something went wrong during logout',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }
}
