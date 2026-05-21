import 'package:dartz/dartz.dart';
import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/network/constants/api_constants.dart';
import 'package:izu/core/network/models/network_failure.dart';
import 'package:izu/core/network/models/network_success.dart';

import '../model/pending_request_model.dart';

class ProviderHomeRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Either<NetworkFailure, NetworkSuccess<List<PendingRequest>>>> getPendingRequests() async {
    try {
      final result = await _apiClient.get<List<dynamic>>(
        ApiConstants.provider.pendingRequests,
        fromJsonT: (json) => json is List ? json : [json],
      );

      return result.fold(
        (failure) => Left(failure),
        (success) {
          final pendingRequests = (success.data)
              .map((item) => PendingRequest.fromJson(item as Map<String, dynamic>))
              .toList();
          return Right(
            NetworkSuccess<List<PendingRequest>>(
              data: pendingRequests,
              message: success.message,
              statusCode: success.statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Failed to fetch pending requests: $e'),
      );
    }
  }

  Future<Either<NetworkFailure, NetworkSuccess<PendingRequest>>> acceptRequest(String bookingId) async {
    try {
      final result = await _apiClient.patch<Map<String, dynamic>>(
        ApiConstants.provider.acceptRequest(bookingId),
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );

      return result.fold(
        (failure) => Left(failure),
        (success) {
          final acceptedRequest = _mapPendingRequestResponse(success.data);
          return Right(
            NetworkSuccess<PendingRequest>(
              data: acceptedRequest,
              message: success.message,
              statusCode: success.statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Failed to accept request: $e'),
      );
    }
  }

  Future<Either<NetworkFailure, NetworkSuccess<PendingRequest>>> cancelRequest(String bookingId) async {
    try {
      final result = await _apiClient.patch<Map<String, dynamic>>(
        ApiConstants.provider.cancelRequest(bookingId),
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );

      return result.fold(
        (failure) => Left(failure),
        (success) {
          final cancelledRequest = _mapPendingRequestResponse(success.data);
          return Right(
            NetworkSuccess<PendingRequest>(
              data: cancelledRequest,
              message: success.message,
              statusCode: success.statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Failed to cancel request: $e'),
      );
    }
  }

  PendingRequest _mapPendingRequestResponse(Map<String, dynamic> json) {
    return PendingRequest(
      id: json['_id']?.toString() ?? '',
      userId: _mapUserInfo(json['userId'], fallbackName: 'User'),
      serviceId: _mapServiceInfo(json['serviceId']),
      title: json['title']?.toString() ?? '',
      bookingTime: json['bookingTime']?.toString() ?? '',
      location: _mapLocationInfo(json['location']),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      providerId: _mapUserInfo(json['providerId'], fallbackName: 'Provider'),
      extraNote: json['extraNote']?.toString(),
      providerAmount: (json['providerAmount'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? '',
      bookingType: json['bookingType']?.toString() ?? '',
      estimatedHours: (json['estimatedHours'] as num?)?.toInt() ?? 0,
    );
  }

  UserInfo _mapUserInfo(dynamic value, {required String fallbackName}) {
    if (value is Map<String, dynamic>) {
      return UserInfo.fromJson(value);
    }

    return UserInfo(
      id: value?.toString() ?? '',
      name: fallbackName,
      email: '',
      profileImage: '',
    );
  }

  ServiceInfo _mapServiceInfo(dynamic value) {
    if (value is Map<String, dynamic>) {
      return ServiceInfo.fromJson(value);
    }

    return ServiceInfo(
      id: value?.toString() ?? '',
      category: null,
      serviceDetails: null,
      providerId: null,
    );
  }

  LocationInfo _mapLocationInfo(dynamic value) {
    if (value is Map<String, dynamic>) {
      return LocationInfo.fromJson(value);
    }

    return LocationInfo(
      type: 'Point',
      coordinates: const [0.0, 0.0],
      address: '',
    );
  }
}
