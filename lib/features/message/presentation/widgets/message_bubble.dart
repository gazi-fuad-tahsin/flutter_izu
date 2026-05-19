import 'package:flutter/material.dart';

import '../../data/model/message_model.dart';
import '../screens/message_media_viewer_screen.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final String? receiverAvatarUrl;

  const MessageBubble({
    super.key,
    required this.message,
    this.receiverAvatarUrl,
  });

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment:
            message.isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isFromUser) ...[
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFEAEAEA),
              backgroundImage: receiverAvatarUrl != null &&
                      receiverAvatarUrl!.startsWith('http')
                  ? NetworkImage(receiverAvatarUrl!)
                  : const AssetImage('assets/images/profile_image.png')
                      as ImageProvider,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isFromUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isFromUser
                        ? const Color(0xFF2870BC)
                        : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: message.isFromUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (message.attachments.isNotEmpty) ...[
                        for (int i = 0; i < message.attachments.length; i++) ...[
                          _buildAttachment(context, message.attachments[i]),
                          if (i != message.attachments.length - 1)
                            const SizedBox(height: 8),
                        ],
                        if (message.content.trim().isNotEmpty)
                          const SizedBox(height: 8),
                      ],
                      if (message.content.trim().isNotEmpty)
                        Text(
                          message.content,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: message.isFromUser
                                ? Colors.white
                                : const Color(0xFF000000),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF808080),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(BuildContext context, MessageAttachment attachment) {
    final isImage = attachment.contentType == 'image';
    final isVideo = attachment.contentType == 'video';

    if (isImage) {
      return GestureDetector(
        onTap: () => _openMediaViewer(
          context,
          attachment.url,
          'image',
          attachment.name,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            attachment.url,
            width: 220,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildFileTile(
              attachment,
              icon: Icons.image_not_supported_outlined,
            ),
          ),
        ),
      );
    }

    if (isVideo) {
      return GestureDetector(
        onTap: () => _openMediaViewer(
          context,
          attachment.url,
          'video',
          attachment.name,
        ),
        child: _buildFileTile(
          attachment,
          icon: Icons.videocam_rounded,
        ),
      );
    }

    return _buildFileTile(attachment);
  }

  void _openMediaViewer(
    BuildContext context,
    String mediaUrl,
    String mediaType,
    String title,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MessageMediaViewerScreen(
          mediaUrl: mediaUrl,
          mediaType: mediaType,
          title: title,
        ),
      ),
    );
  }

  Widget _buildFileTile(
    MessageAttachment attachment, {
    IconData icon = Icons.insert_drive_file_outlined,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isFromUser
            ? Colors.white.withOpacity(0.12)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: message.isFromUser ? Colors.white24 : const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2870BC).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2870BC),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: message.isFromUser ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  attachment.contentType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: message.isFromUser
                        ? Colors.white70
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
