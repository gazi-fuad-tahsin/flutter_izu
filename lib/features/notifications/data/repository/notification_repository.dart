import 'package:dartz/dartz.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/models/network_failure.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Fetch all notifications for the current user
  Future<Either<NetworkFailure, List<NotificationModel>>> getNotifications() async {
    try {
      final endpoint = ApiConstants.notification.getNotifications;
      
      final result = await _apiClient.get<List<dynamic>>(
        endpoint,
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) => Left(failure),
        (success) {
          final notificationList = <NotificationModel>[];
          if (success.data is List) {
            for (var item in success.data as List) {
              if (item is Map<String, dynamic>) {
                notificationList.add(NotificationModel.fromJson(item));
              }
            }
          }
          return Right(notificationList);
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Error fetching notifications: $e'),
      );
    }
  }

  /// Fetch notifications with pagination
  Future<Either<NetworkFailure, List<NotificationModel>>> getNotificationsWithPage(
    int page,
    int limit,
  ) async {
    try {
      final endpoint = ApiConstants.notification.getNotificationsWithPage(page, limit);
      
      final result = await _apiClient.get<List<dynamic>>(
        endpoint,
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) => Left(failure),
        (success) {
          final notificationList = <NotificationModel>[];
          if (success.data is List) {
            for (var item in success.data as List) {
              if (item is Map<String, dynamic>) {
                notificationList.add(NotificationModel.fromJson(item));
              }
            }
          }
          return Right(notificationList);
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Error fetching notifications: $e'),
      );
    }
  }

  /// Mark notification as read
  Future<Either<NetworkFailure, NotificationModel>> markNotificationAsRead(
    String notificationId,
  ) async {
    try {
      final endpoint = ApiConstants.notification.markAsRead(notificationId);

      final result = await _apiClient.put<dynamic>(
        endpoint,
        data: {},
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) => Left(failure),
        (success) {
          try {
            // Handle both direct Map and wrapped response
            dynamic data = success.data;
            
            // If data is a Map, use it directly for parsing
            if (data is Map<String, dynamic>) {
              return Right(NotificationModel.fromJson(data));
            }
            
            return Left(
              UnknownFailure(message: 'Invalid response format: ${data.runtimeType}'),
            );
          } catch (parseError) {
            return Left(
              UnknownFailure(message: 'Error parsing notification: $parseError'),
            );
          }
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Error marking notification as read: $e'),
      );
    }
  }
}
