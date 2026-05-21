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
  Future<bool> deleteServiceById(String serviceId) async {
    try {
      DPrint.log('🗑 Deleting service: $serviceId');
      final result = await _apiClient.delete<Map<String, dynamic>>(
        ApiConstants.service.deleteService(serviceId),
        fromJsonT: (json) => json is Map<String, dynamic> ? json : {},
      );
      return result.fold(
        (failure) {
          DPrint.error('❌ Delete failed: ${failure.message}');
          return false;
        },
        (success) {
          DPrint.log('✅ Service deleted: ${success.data}');
          return true;
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception deleting service: $e');
      return false;
    }
  }

  @override
  Future<ProviderServiceModel?> getServiceById(String serviceId) async {
    try {
      DPrint.log('🔄 Fetching service by id: $serviceId');
      final result = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.service.getServiceById(serviceId),
        fromJsonT: (json) => json as Map<String, dynamic>,
      );
      return result.fold(
        (failure) {
          DPrint.error('❌ Get service failed: ${failure.message}');
          return null;
        },
        (success) {
          DPrint.log('✅ Service fetched: ${success.data}');
          return ProviderServiceModel.fromJson(success.data);
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception getting service: $e');
      return null;
    }
  }

  @override
  Future<bool> updateServiceById({
    required String serviceId,
    required String categoryId,
    required String title,
    required double price,
    required String details,
    File? primaryImage,
    List<File> additionalImages = const [],
  }) async {
    try {
      DPrint.log('✏️ Updating service: $serviceId');

      final detailsMap = {
        "title": title,
        "perSessionPrice": price,
        "hourlyPrice": price,
        "details": details,
        "isActive": true,
        "address": "Downtown",
        "serviceType": "hourly",
      };

      final formDataMap = <String, dynamic>{
        "category": categoryId,
        "serviceDetails": jsonEncode(detailsMap),
      };

      // Only add images if new ones are selected
      final List<MultipartFile> thumbnailFiles = [];
      if (primaryImage != null) {
        thumbnailFiles.add(await MultipartFile.fromFile(
          primaryImage.path,
          filename: primaryImage.path.split('/').last,
        ));
      }
      for (final img in additionalImages) {
        thumbnailFiles.add(await MultipartFile.fromFile(
          img.path,
          filename: img.path.split('/').last,
        ));
      }
      if (thumbnailFiles.isNotEmpty) {
        formDataMap["serviceThumbnails"] = thumbnailFiles;
      }

      final formData = FormData.fromMap(formDataMap);

      final result = await _apiClient.patch<dynamic>(
        ApiConstants.service.updateService(serviceId),
        fromJsonT: (json) => json,
        data: formData,
        options: Options(headers: ApiConstants.multipartHeaders),
      );

      return result.fold(
        (failure) {
          DPrint.error('❌ Update failed: ${failure.message}');
          return false;
        },
        (success) {
          DPrint.log('✅ Service updated: ${success.data}');
          return true;
        },
      );
    } catch (e) {
      DPrint.error('❌ Exception updating service: $e');
      return false;
    }
  }

  @override
  Future<void> deleteService(String serviceId) async {}

  @override
  Future<void> updateService(ProviderServiceModel service) async {}

  @override
  Future<void> addService(ProviderServiceModel service) async {}

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
