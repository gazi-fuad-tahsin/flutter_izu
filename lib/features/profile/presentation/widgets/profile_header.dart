import 'package:flutter/material.dart';

/// Profile header with user avatar, name and edit button
class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final VoidCallback? onEditPressed;

  const ProfileHeader({
    super.key,
    required this.userName,
    required this.userAvatar,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar and Name
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: userAvatar.isNotEmpty
                      ? Image.asset(
                          userAvatar,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.grey.shade500,
                          size: 28,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          // Edit Button
          GestureDetector(
            onTap: onEditPressed,
            child: Image.asset(
              'assets/icons/edit-05.png',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
