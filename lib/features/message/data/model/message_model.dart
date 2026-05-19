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
