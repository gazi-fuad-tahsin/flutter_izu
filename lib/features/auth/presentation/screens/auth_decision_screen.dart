import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/app_images.dart';
import 'LogIn_screen.dart';
import 'create_account_screen.dart';
import 'role_selection_screen.dart';

class AuthDecisionScreen extends StatelessWidget {
  final String? selectedRole;

  const AuthDecisionScreen({super.key, this.selectedRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // Light gray background like Image 3
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                 child: Image.asset(
                    AppImages.appLogo, // Using available logo
                    fit: BoxFit.contain,
                  ),
              ),

              const SizedBox(height: 32),

              // Title - shows role if pre-selected, otherwise generic welcome
              if (selectedRole != null)
                Text(
                  'You\'re joining as a ${selectedRole == 'beardfriend' ? 'User' : 'Provider'}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                )
              else
                const Text(
                  'Welcome to OWVO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

              const SizedBox(height: 48),

              // Log In Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const LoginRoleScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A), // Dark blue/black
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // If no role selected, go to RoleSelectionScreen first
                    if (selectedRole == null) {
                      Get.to(() => const RoleSelectionScreen());
                    } else {
                      Get.to(() => CreateAccountScreen(selectedRole: selectedRole!));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),

               // Terms and Privacy
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
                 child: RichText(
                  textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280), // Gray text
                      ),
                      children: [
                        const TextSpan(text: 'Signing up means you agree to our '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: TextStyle(
                            color: Colors.blue[600],
                             fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(text: ' and acknowledge our '),
                         TextSpan(
                          text: 'Privacy Policy.',
                           style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
