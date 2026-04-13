import 'package:get/get.dart';

import '../../data/models/notification_model.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> newNotifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> earlierNotifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  void _loadNotifications() {
    // Sample data - in real app, this would come from API/database
    final sampleNotifications = [
      NotificationModel(
        id: '1',
        title: 'booking Cancelled,',
        message: 'Your booking has been cancelled',
        type: NotificationType.bookingCancelled,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Request Confirmed',
        message: 'Your request has been confirmed',
        type: NotificationType.requestConfirmed,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Service Review Submitted',
        message: 'Your service review has been submitted',
        type: NotificationType.serviceReview,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: '4',
        title: 'Booking Ongoing',
        message: 'Your booking is currently ongoing',
        type: NotificationType.bookingOngoing,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: '5',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationModel(
        id: '6',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationModel(
        id: '7',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      NotificationModel(
        id: '8',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        isRead: true,
      ),
      NotificationModel(
        id: '9',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 31)),
        isRead: true,
      ),
      NotificationModel(
        id: '10',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 31)),
        isRead: true,
      ),
      NotificationModel(
        id: '11',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 31)),
        isRead: true,
      ),
      NotificationModel(
        id: '12',
        title: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        message: 'Lorem ipsum is a dummy or placeholder text commonly used in graphic',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(minutes: 31)),
        isRead: true,
      ),
    ];

    notifications.assignAll(sampleNotifications);
    _categorizeNotifications();
  }

  void _categorizeNotifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    newNotifications.clear();
    earlierNotifications.clear();

    for (var notification in notifications) {
      final notifDate = DateTime(notification.timestamp.year, notification.timestamp.month, notification.timestamp.day);
      
      if (notifDate == today) {
        newNotifications.add(notification);
      } else {
        earlierNotifications.add(notification);
      }
    }
  }

  String getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d';
    } else {
      return '${(difference.inDays / 30).floor()}mo';
    }
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = NotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        type: notifications[index].type,
        timestamp: notifications[index].timestamp,
        isRead: true,
      );
      notifications.refresh();
      _categorizeNotifications();
    }
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    _categorizeNotifications();
  }
}
