class Message {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromUser;
  final List<MessageAttachment> attachments;

  Message({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromUser,
    this.attachments = const [],
  });

  factory Message.fromSocket(Map<String, dynamic> data) {
    DateTime timestamp;
    try {
      timestamp = DateTime.parse(data['createdAt'].toString());
    } catch (_) {
      timestamp = DateTime.now();
    }

    final rawFiles = data['fileUrl'];
    final attachments = rawFiles is List
        ? rawFiles
            .whereType<Map<String, dynamic>>()
            .map((a) => MessageAttachment(
                  id: a['_id']?.toString() ?? a['url']?.toString() ?? '',
                  name: (a['name'] as String?) ?? 'Attachment',
                  contentType: (a['content'] as String?) ?? 'file',
                  url: (a['url'] as String?) ?? '',
                ))
            .where((a) => a.url.isNotEmpty)
            .toList()
        : <MessageAttachment>[];

    return Message(
      id: data['_id']?.toString() ?? DateTime.now().toIso8601String(),
      content: (data['content'] as String?) ?? '',
      timestamp: timestamp,
      isFromUser: (data['isMe'] as bool?) ?? false,
      attachments: attachments,
    );
  }

  /// chatId this message belongs to — present in socket events
  static String? chatIdFromSocket(Map<String, dynamic> data) {
    return data['chat']?.toString() ?? data['chatId']?.toString();
  }
}

class MessageAttachment {
  final String id;
  final String name;
  final String contentType;
  final String url;

  const MessageAttachment({
    required this.id,
    required this.name,
    required this.contentType,
    required this.url,
  });
}
