import 'dart:io';
import 'package:get/get.dart';

import '../../../../../core/base/base_controller.dart';
import '../../../../../core/utils/debug_print.dart';
import '../../data/model/provider_service_model.dart';
import '../../data/repo/provider_jobs_repo_impl.dart';

class ProviderJobsController extends BaseController {
  final _repo = ProviderJobsRepositoryImpl();

  final RxList<ProviderServiceModel> services = RxList<ProviderServiceModel>([]);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProviderServices();
  }

  /// Fetch provider services/jobs
  Future<void> fetchProviderServices() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('📋 Fetching provider services...');

      final providerServices = await _repo.getProviderServices();
      services.value = providerServices;

      DPrint.log('✅ Services fetched successfully: ${services.length}');
    } catch (e) {
      DPrint.log('❌ Error fetching services: $e');
      errorMessage.value = 'Failed to load services';
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete service
  Future<void> deleteService(String serviceId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('🗑️ Deleting service: $serviceId');

      await _repo.deleteService(serviceId);
      services.removeWhere((service) => service.id == serviceId);

      DPrint.log('✅ Service deleted successfully');
      Get.snackbar(
        'Success',
        'Service deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      DPrint.log('❌ Error deleting service: $e');
      errorMessage.value = 'Failed to delete service';
      Get.snackbar(
        'Error',
        'Failed to delete service',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update service
  Future<void> updateService(ProviderServiceModel updatedService) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('✏️ Updating service: ${updatedService.id}');

      await _repo.updateService(updatedService);
      final index = services.indexWhere((s) => s.id == updatedService.id);
      if (index >= 0) {
        services[index] = updatedService;
      }

      DPrint.log('✅ Service updated successfully');
      Get.snackbar(
        'Success',
        'Service updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      DPrint.log('❌ Error updating service: $e');
      errorMessage.value = 'Failed to update service';
      Get.snackbar(
        'Error',
        'Failed to update service',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new service
  Future<void> addService(ProviderServiceModel newService) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DPrint.log('➕ Adding new service');

      await _repo.addService(newService);
      services.add(newService);

      DPrint.log('✅ Service added successfully');
      Get.snackbar(
        'Success',
        'Service added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      DPrint.log('❌ Error adding service: $e');
      errorMessage.value = 'Failed to add service';
      Get.snackbar(
        'Error',
        'Failed to add service',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset controller
  void resetController() {
    services.clear();
    errorMessage.value = '';
    isLoading.value = false;
  }

  /// Create new service on the server and fetch updated list
  Future<bool> createService({
    required String categoryId,
    required String title,
    required double price,
    required String details,
    required File primaryImage,
    required List<File> additionalImages,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final success = await _repo.createService(
        categoryId: categoryId,
        title: title,
        price: price,
        details: details,
        primaryImage: primaryImage,
        additionalImages: additionalImages,
      );

      if (success) {
        DPrint.log('✅ Service created, refreshing list...');
        // Refresh independently — don't let it fail the success result
        fetchProviderServices().catchError((_) {});
        return true;
      }
      return false;
    } catch (e) {
      DPrint.log('❌ Exception in controller createService: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
