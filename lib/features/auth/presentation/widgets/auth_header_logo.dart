import 'package:flutter/material.dart';

class AuthHeaderLogo extends StatelessWidget {
  const AuthHeaderLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: Image.asset(
        'assets/images/izu_logo.png',
        width: 160,
        fit: BoxFit.contain,
      ),
    );
  }
}
