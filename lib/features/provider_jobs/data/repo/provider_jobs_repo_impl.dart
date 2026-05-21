import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/utils/debug_print.dart';
import 'package:izu/core/network/constants/api_constants.dart';

import '../model/provider_service_model.dart';
import 'provider_jobs_repo.dart';

class ProviderJobsRepositoryImpl extends ProviderJobsRepository {
  final _apiClient = ApiClient();

  @override
  Future<List<ProviderServiceModel>> getProviderServices() async {
    try {
      DPrint.log('🔄 Fetching provider own services from /api/v1/services/own-services...');

      final result = await _apiClient.get<dynamic>(
        '/api/v1/services/own-services',
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) {
          DPrint.log('❌ Failed to fetch services: ${failure.message}');
          throw Exception(failure.message);
        },
        (success) {
          DPrint.log('✅ Services response: ${success.data}');
          
          final servicesList = success.data as List<dynamic>;
          final services = servicesList
              .map((item) => ProviderServiceModel.fromJson(item as Map<String, dynamic>))
              .toList();
          
          DPrint.log('✅ Parsed ${services.length} services');
          return services;
        },
      );
    } catch (e) {
      DPrint.log('❌ Exception fetching services: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateService(ProviderServiceModel service) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addService(ProviderServiceModel service) async {
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createService({
    required String categoryId,
    required String title,
    required double price,
    required String details,
    required File primaryImage,
    required List<File> additionalImages,
  }) async {
    try {
      DPrint.log('🔄 Creating new service: title=$title, categoryId=$categoryId, price=$price');

      final List<MultipartFile> thumbnailFiles = [];
      
      // Primary thumbnail
      thumbnailFiles.add(
        await MultipartFile.fromFile(
          primaryImage.path,
          filename: primaryImage.path.split('/').last,
        ),
      );

      // Additional images
      for (final img in additionalImages) {
        thumbnailFiles.add(
          await MultipartFile.fromFile(
            img.path,
            filename: img.path.split('/').last,
          ),
        );
      }

      final detailsMap = {
        "title": title,
        "perSessionPrice": price,
        "hourlyPrice": price,
        "details": details,
        "isActive": true,
        "address": "Downtown",
        "serviceType": "hourly"
      };

      final formDataMap = {
        "category": categoryId,
        "serviceDetails": jsonEncode(detailsMap),
        "serviceThumbnails": thumbnailFiles,
      };

      DPrint.log('📤 Form data map: $formDataMap');

      final formData = FormData.fromMap(formDataMap);

      final result = await _apiClient.post<dynamic>(
        ApiConstants.service.getServices,
        formData: formData,
        isFormData: true,
        fromJsonT: (json) => json,
      );

      return result.fold(
        (failure) {
          DPrint.log('❌ Failed to create service: ${failure.message}');
          return false;
        },
        (success) {
          DPrint.log('✅ Service created successfully: ${success.data}');
          return true;
        },
      );
    } catch (e) {
      DPrint.log('❌ Exception creating service: $e');
      return false;
    }
  }
}
