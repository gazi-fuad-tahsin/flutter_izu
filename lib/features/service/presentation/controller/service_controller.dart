import 'package:get/get.dart';
import 'package:izu/core/utils/debug_print.dart';
import 'package:izu/features/service/data/models/service_detail_model.dart';
import 'package:izu/features/service/data/models/service_model.dart';
import 'package:izu/features/service/domain/repo/service_repo.dart';

class ServiceController extends GetxController {
  final ServiceRepository serviceRepository;

  ServiceController({required this.serviceRepository});

  final Rx<Map<String, List<ServiceModel>>> _allServices = Rx<Map<String, List<ServiceModel>>>({});
  final Rx<String> _selectedCategory = Rx<String>('');
  final Rx<ServiceDetailModel?> _serviceDetail = Rx<ServiceDetailModel?>(null);
  final RxBool _isLoadingDetail = RxBool(false);

  get allServices => _allServices.value;
  get selectedCategory => _selectedCategory.value;
  get serviceDetail => _serviceDetail.value;
  get isLoadingDetail => _isLoadingDetail.value;
  
  // Get all category names in order
  List<String> get categoryNames {
    return _allServices.value.keys.toList();
  }
  
  // Get services for selected category
  List<ServiceModel> get selectedCategoryServices {
    if (_selectedCategory.value.isEmpty) return [];
    return _allServices.value[_selectedCategory.value] ?? [];
  }
  
  // Set selected category
  void setSelectedCategory(String categoryName) {
    _selectedCategory.value = categoryName;
  }
  
  // Featured artisans - one from each category (take first service from each category)
  List<ServiceModel> get featuredArtisans {
    if (_allServices.value.isEmpty) return [];
    
    final featured = <ServiceModel>[];
    _allServices.value.forEach((categoryName, services) {
      if (services.isNotEmpty) {
        featured.add(services.first);
      }
    });
    
    // Return first 5 featured artisans
    return featured.take(5).toList();
  }

  // Nearby artisans - all services from all categories (limited to 5)
  List<ServiceModel> get nearbyArtisans {
    if (_allServices.value.isEmpty) return [];
    
    final nearby = <ServiceModel>[];
    _allServices.value.forEach((categoryName, services) {
      nearby.addAll(services);
    });
    
    // Return first 5 nearby artisans
    return nearby.take(5).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      DPrint.log("🔄 Fetching services...");
      DPrint.log("🛜 Calling endpoint: /api/v1/services");
      
      final result = await serviceRepository.fetchServices();
      
      result.fold(
        (fail) {
          DPrint.log("❌ Failed to fetch services: ${fail.message}");
          DPrint.log("   Error details: ${fail.toString()}");
        },
        (success) {
          DPrint.log("✅ Services fetched successfully!");
          _allServices.value = success.data;
          
          // Set default category to first one
          if (success.data.isNotEmpty) {
            _selectedCategory.value = success.data.keys.first;
            DPrint.log("📌 Default category set to: ${_selectedCategory.value}");
          }
          
          DPrint.log("📦 Loaded services from ${success.data.length} categories");
          DPrint.log("   Categories: ${success.data.keys.join(', ')}");
          DPrint.log("📦 Featured artisans count: ${featuredArtisans.length}");
        },
      );
    } catch (e) {
      DPrint.log("❌ Exception fetching services: $e");
      DPrint.log("   Stack trace: ${StackTrace.current}");
    }
  }

  void clearServices() {
    _allServices.value = {};
    DPrint.log("🗑️ Services cleared");
  }

  Future<void> fetchServiceDetail(String serviceId) async {
    try {
      _isLoadingDetail.value = true;
      DPrint.log("🔄 Fetching service detail for ID: $serviceId");
      
      final result = await serviceRepository.fetchServiceDetail(serviceId);
      
      result.fold(
        (fail) {
          DPrint.log("❌ Failed to fetch service detail: ${fail.message}");
          DPrint.log("   Error details: ${fail.toString()}");
          _serviceDetail.value = null;
        },
        (success) {
          DPrint.log("✅ Service detail fetched successfully!");
          DPrint.log("   Title: ${success.data.serviceDetails.title}");
          DPrint.log("   Provider: ${success.data.providerId.name}");
          DPrint.log("   Images count: ${success.data.serviceDetails.serviceThumbnails.length}");
          _serviceDetail.value = success.data;
        },
      );
    } catch (e) {
      DPrint.log("❌ Exception fetching service detail: $e");
      DPrint.log("   Stack trace: ${StackTrace.current}");
      _serviceDetail.value = null;
    } finally {
      _isLoadingDetail.value = false;
    }
  }

  void clearServiceDetail() {
    _serviceDetail.value = null;
    DPrint.log("🗑️ Service detail cleared");
  }
}
