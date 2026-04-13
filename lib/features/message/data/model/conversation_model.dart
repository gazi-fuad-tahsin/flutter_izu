import 'message_model.dart';

class Conversation {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<Message> messages;
  final bool isActive;

  Conversation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.messages,
    this.isActive = true,
  });

  // Helper to format time for display
  String getTimeDisplay() {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastMessageTime.month}/${lastMessageTime.day}';
    }
  }
}
