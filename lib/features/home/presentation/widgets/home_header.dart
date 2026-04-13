import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String greeting;
  final int notificationCount;
  final String avatarAsset;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.greeting,
    required this.notificationCount,
    required this.avatarAsset,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          ClipOval(
            child: _buildAvatarImage(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                Text(greeting, style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              children: [
                const Icon(Icons.notifications_none, size: 28, color: Colors.black87),
                if (notificationCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        notificationCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build avatar image handling both network and asset images
  Widget _buildAvatarImage() {
    // Check if avatarAsset looks like a URL (network image)
    if (avatarAsset.startsWith('http')) {
      return Image.network(
        avatarAsset,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar();
        },
      );
    } else {
      // Asset image
      return Image.asset(
        avatarAsset,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar();
        },
      );
    }
  }

  /// Build fallback avatar when image fails to load
  Widget _buildFallbackAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: Icon(Icons.person, color: Colors.grey.shade500),
    );
  }
}
