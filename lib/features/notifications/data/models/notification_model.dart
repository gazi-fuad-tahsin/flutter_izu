class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
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
