import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/texts.dart';
import '../../../../core/common/widgets/app_skeleton.dart';
import '../../data/models/notification_model.dart';
import '../controller/notification_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(NotificationController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          appTexts.notifications.tr,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: _controller.notifications.isEmpty || _controller.isMarkingAsRead.value
                  ? null
                  : () => _controller.markAllAsReadAndRefresh(),
              child: _controller.isMarkingAsRead.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Read all',
                      style: TextStyle(
                        color: _controller.notifications.isEmpty
                            ? Colors.grey
                            : const Color(0xFF1E88E5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (_controller.isLoading.value) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(7, (_) => const NotificationItemSkeleton()),
            );
          }

          if (_controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${_controller.error.value}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _controller.refreshNotifications(),
                    child: Text(appTexts.retry.tr),
                  ),
                ],
              ),
            );
          }

          if (_controller.notifications.isEmpty) {
            return Center(
              child: Text(appTexts.noNotificationsYet.tr),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _controller.refreshNotifications();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // New Notifications Section
                  if (_controller.newNotifications.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      child: Text(
                        appTexts.newText.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: _controller.newNotifications
                            .map((notification) =>
                                _buildNotificationTile(notification))
                            .toList(),
                      ),
                    ),
                  ],

                  // Earlier Notifications Section
                  if (_controller.earlierNotifications.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Text(
                        appTexts.earlier.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: _controller.earlierNotifications
                            .map((notification) =>
                                _buildNotificationTile(notification))
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return GestureDetector(
      onTap: () {
        _controller.markAsReadAndRefresh(notification.id);
      },
      child: Obx(
        () {
          final isMarking = _controller.isMarkingAsRead.value;
          return Opacity(
            opacity: isMarking ? 0.6 : 1.0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon
                      _buildNotificationIcon(notification.notificationType),
                      const SizedBox(width: 12),

                      // Title and Message
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            if (!notification.read)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF43A047).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    appTexts.unread.tr,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF43A047),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Time
                      Text(
                        _controller.getTimeAgo(notification.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    Color iconColor;
    IconData iconData;

    switch (type) {
      case NotificationType.bookingCancelled:
        iconData = Icons.cancel;
        iconColor = const Color(0xFFE53935); // Bright red
        break;
      case NotificationType.requestConfirmed:
        iconData = Icons.check_circle;
        iconColor = const Color(0xFF43A047); // Bright green
        break;
      case NotificationType.serviceReview:
        iconData = Icons.star;
        iconColor = const Color(0xFF43A047); // Bright green
        break;
      case NotificationType.bookingOngoing:
        iconData = Icons.send;
        iconColor = const Color(0xFF1E88E5); // Bright blue
        break;
      case NotificationType.info:
        iconData = Icons.info;
        iconColor = const Color(0xFF757575); // Darker grey
        break;
    }

    return SizedBox(
      width: 24,
      height: 24,
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
