import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:izu/core/network/services/socket_service.dart';

import '../../data/models/notification_model.dart';
import '../../data/repository/notification_repository.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> newNotifications = <NotificationModel>[].obs;
  final RxList<NotificationModel> earlierNotifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isMarkingAsRead = false.obs;
  final RxString error = ''.obs;

  late final NotificationRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = NotificationRepository();
    _loadNotifications();
    _listenToSocketNotifications();
  }

  void _listenToSocketNotifications() {
    final socketService = Get.find<SocketService>();
    ever(socketService.liveNotification, (data) {
      if (data == null) return;
      try {
        final incoming = NotificationModel.fromJson(data);
        // Deduplicate: skip if already in the list
        if (notifications.any((n) => n.id == incoming.id)) return;
        notifications.insert(0, incoming);
        _categorizeNotifications();
        DPrint.log('🔔 Live notification added: ${incoming.message}');
      } catch (e) {
        DPrint.error('Failed to parse socket notification: $e');
      }
    });
  }

  /// Load notifications from API
  void _loadNotifications() async {
    isLoading.value = true;
    error.value = '';

    final result = await _repository.getNotifications();

    result.fold(
      (failure) {
        error.value = failure.message;
        DPrint.error('Error loading notifications: ${failure.message}');
        isLoading.value = false;
      },
      (notificationList) {
        notifications.assignAll(notificationList);
        _categorizeNotifications();
        isLoading.value = false;
        DPrint.info('Loaded ${notificationList.length} notifications');
      },
    );
  }

  /// Mark notification as read and refetch notifications
  Future<void> markAsReadAndRefresh(String notificationId) async {
    isMarkingAsRead.value = true;
    try {
      final result = await _repository.markNotificationAsRead(notificationId);

      result.fold(
        (failure) {
          DPrint.error('Error marking notification as read: ${failure.message}');
          Get.snackbar(
            'Error',
            'Failed to mark notification as read',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        (updatedNotification) {
          DPrint.info('Notification marked as read: ${updatedNotification.id}');
          // Refetch notifications to get updated list
          _loadNotifications();
        },
      );
    } catch (e) {
      DPrint.error('Exception marking notification as read: $e');
      Get.snackbar(
        'Error',
        'An error occurred while marking notification as read',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isMarkingAsRead.value = false;
    }
  }

  /// Mark all notifications as read and refetch notifications
  Future<void> markAllAsReadAndRefresh() async {
    isMarkingAsRead.value = true;
    try {
      final result = await _repository.markAllNotificationsAsRead();

      result.fold(
        (failure) {
          DPrint.error('Error marking all notifications as read: ${failure.message}');
          Get.snackbar(
            'Error',
            'Failed to mark all notifications as read',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        (response) {
          DPrint.info('All notifications marked as read: $response');
          _loadNotifications();
        },
      );
    } catch (e) {
      DPrint.error('Exception marking all notifications as read: $e');
      Get.snackbar(
        'Error',
        'An error occurred while marking all notifications as read',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isMarkingAsRead.value = false;
    }
  }

  /// Categorize notifications into new and earlier
  void _categorizeNotifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    newNotifications.clear();
    earlierNotifications.clear();

    for (var notification in notifications) {
      final notifDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );
      
      if (notifDate == today) {
        newNotifications.add(notification);
      } else {
        earlierNotifications.add(notification);
      }
    }

    // Sort by date (most recent first)
    newNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    earlierNotifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get unread notifications count
  int get unreadCount => notifications.where((n) => !n.read).length;

  /// Format time ago
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

  /// Mark notification as read (local operation - deprecated, use markAsReadAndRefresh)
  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = NotificationModel(
        id: notification.id,
        userId: notification.userId,
        providerId: notification.providerId,
        bookingId: notification.bookingId,
        type: notification.type,
        message: notification.message,
        read: true,
        createdAt: notification.createdAt,
      );
      notifications.refresh();
      _categorizeNotifications();
    }
  }

  /// Delete notification (local operation for now)
  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    _categorizeNotifications();
  }

  /// Refresh notifications
  void refreshNotifications() {
    _loadNotifications();
  }
}
