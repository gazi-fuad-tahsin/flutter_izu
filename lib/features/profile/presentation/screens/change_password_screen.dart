import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/presentation/controller/user_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password
              TextField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2870BC), width: 1.5),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _showCurrentPassword = !_showCurrentPassword),
                    child: Icon(
                      _showCurrentPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              // New Password
              TextField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2870BC), width: 1.5),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _showNewPassword = !_showNewPassword),
                    child: Icon(
                      _showNewPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2870BC), width: 1.5),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                    child: Icon(
                      _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 32),
              // Save Button
              Obx(() {
                final userController = Get.find<UserController>();
                final isLoading = userController.isChangingPassword.value;

                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            final current = _currentPasswordController.text.trim();
                            final newPass = _newPasswordController.text.trim();
                            final confirmPass = _confirmPasswordController.text.trim();

                            // Validation
                            if (current.isEmpty) {
                              Get.snackbar(
                                'Validation',
                                'Please enter current password',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (newPass.isEmpty) {
                              Get.snackbar(
                                'Validation',
                                'Please enter new password',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (confirmPass.isEmpty) {
                              Get.snackbar(
                                'Validation',
                                'Please confirm new password',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (newPass != confirmPass) {
                              Get.snackbar(
                                'Validation',
                                'New password and confirm password do not match',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            if (newPass.length < 6) {
                              Get.snackbar(
                                'Validation',
                                'New password must be at least 6 characters',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }

                            // Call API
                            final success = await userController.changePassword(
                              currentPassword: current,
                              newPassword: newPass,
                              confirmPassword: confirmPass,
                            );

                            if (success) {
                              Get.snackbar(
                                'Success',
                                'Password changed successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );

                              // Clear fields
                              _currentPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmPasswordController.clear();

                              // Navigate back after a short delay
                              await Future.delayed(const Duration(milliseconds: 500));
                              Get.back();
                            } else {
                              Get.snackbar(
                                'Error',
                                'Failed to change password. Please check your current password.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2870BC),
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
