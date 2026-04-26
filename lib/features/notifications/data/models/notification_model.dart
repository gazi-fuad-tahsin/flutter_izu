class NotificationModel {
  final String id;
  final String userId;
  final String providerId;
  final String? bookingId;
  final String type;
  final String message;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.providerId,
    this.bookingId,
    required this.type,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  /// Factory constructor to parse from API JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      providerId: json['providerId'] ?? '',
      bookingId: json['bookingId'] != null ? json['bookingId']['_id'] ?? '' : null,
      type: json['type'] ?? 'info',
      message: json['message'] ?? '',
      read: json['read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Get notification type enum
  NotificationType get notificationType {
    switch (type) {
      case 'request-accepted':
      case 'request-confirmed':
        return NotificationType.requestConfirmed;
      case 'booking-cancelled':
        return NotificationType.bookingCancelled;
      case 'service-review':
        return NotificationType.serviceReview;
      case 'booking-ongoing':
        return NotificationType.bookingOngoing;
      default:
        return NotificationType.info;
    }
  }

  /// Get title from message (using message as title since API doesn't provide separate title)
  String get title => message;
}

enum NotificationType {
  bookingCancelled,
  requestConfirmed,
  serviceReview,
  bookingOngoing,
  info,
}

extension NotificationTypeExtension on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.bookingCancelled:
        return 'Booking Cancelled';
      case NotificationType.requestConfirmed:
        return 'Request Confirmed';
      case NotificationType.serviceReview:
        return 'Service Review Submitted';
      case NotificationType.bookingOngoing:
        return 'Booking Ongoing';
      case NotificationType.info:
        return 'Information';
    }
  }

  IconType get iconType {
    switch (this) {
      case NotificationType.bookingCancelled:
        return IconType.cancelled;
      case NotificationType.requestConfirmed:
        return IconType.confirmed;
      case NotificationType.serviceReview:
        return IconType.review;
      case NotificationType.bookingOngoing:
        return IconType.ongoing;
      case NotificationType.info:
        return IconType.info;
    }
  }
}

enum IconType {
  cancelled,
  confirmed,
  review,
  ongoing,
  info,
}
