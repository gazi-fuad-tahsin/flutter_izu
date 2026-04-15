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
}
