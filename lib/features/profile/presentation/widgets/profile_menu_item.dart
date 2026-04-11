import 'package:flutter/material.dart';

/// Reusable profile menu item widget
class ProfileMenuItem extends StatelessWidget {
  final String? iconPath; // For custom icon assets
  final IconData? icon; // For Material icons
  final String title;
  final VoidCallback onTap;
  final bool isLogOut;

  const ProfileMenuItem({
    super.key,
    this.iconPath,
    this.icon,
    required this.title,
    required this.onTap,
    this.isLogOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Custom Icon or Material Icon
                if (iconPath != null)
                  Image.asset(
                    iconPath!,
                    width: 22,
                    height: 22,
                    color: isLogOut ? const Color(0xFFE74C3C) : null,
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: isLogOut ? const Color(0xFFE74C3C) : Colors.black87,
                    size: 22,
                  ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isLogOut ? const Color(0xFFE74C3C) : Colors.black87,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: isLogOut ? const Color(0xFFE74C3C) : Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
