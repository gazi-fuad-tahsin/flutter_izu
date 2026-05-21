import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/provider_service_model.dart';
import '../../data/repo/service_category_repository.dart';
import '../../data/model/service_category_model.dart';
import '../controller/provider_jobs_controller.dart';
import '../widgets/additional_image_picker_card.dart';
import '../widgets/image_picker_card.dart';

class EditServiceScreen extends StatefulWidget {
  final ProviderServiceModel service;

  const EditServiceScreen({super.key, required this.service});

  @override
  State<EditServiceScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  late TextEditingController serviceAmountController;
  late TextEditingController serviceDetailsController;
  String? selectedCategory;
  String? selectedCategoryId;
  bool isLoading = false;
  bool showAdditionalImages = false;
  bool isCategoriesLoading = true;
  List<ServiceCategoryModel> categories = [];
  List<File?> additionalImages = [null, null];
  File? selectedImage;
  final ImagePicker _imagePicker = ImagePicker();
  final ServiceCategoryRepository _categoryRepository = ServiceCategoryRepository();

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing service
    serviceAmountController = TextEditingController(
      text: widget.service.pricePerHour.toStringAsFixed(0),
    );
    serviceDetailsController = TextEditingController(
      text: widget.service.serviceDetails,
    );
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await _categoryRepository.getServiceCategories();
      setState(() {
        categories = fetchedCategories;
        // Match the existing category by name or id
        final match = categories.firstWhere(
          (c) => c.id == widget.service.categoryId || c.name == widget.service.category,
          orElse: () => categories.isNotEmpty ? categories.first : ServiceCategoryModel(id: '', name: '', categoryImage: '', isActive: false),
        );
        selectedCategory = match.name.isNotEmpty ? match.name : (categories.isNotEmpty ? categories.first.name : null);
        selectedCategoryId = match.id.isNotEmpty ? match.id : (categories.isNotEmpty ? categories.first.id : null);
        isCategoriesLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => isCategoriesLoading = false);
      Get.snackbar('Error', 'Failed to load categories', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void dispose() {
    serviceAmountController.dispose();
    serviceDetailsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked != null) setState(() => selectedImage = File(picked.path));
    } catch (_) {}
  }

  Future<void> _pickAdditionalImage(int index) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked != null) setState(() => additionalImages[index] = File(picked.path));
    } catch (_) {}
  }

  Future<void> _handleUpdate() async {
    if (selectedCategoryId == null || selectedCategoryId!.isEmpty) {
      Get.snackbar('Error', 'Please select a service category', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (serviceAmountController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter service amount', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    final price = double.tryParse(serviceAmountController.text.trim());
    if (price == null) {
      Get.snackbar('Error', 'Please enter a valid amount', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (serviceDetailsController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter service details', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (mounted) setState(() => isLoading = true);

    try {
      final controller = Get.find<ProviderJobsController>();
      final nonNullAdditional = additionalImages.whereType<File>().toList();

      final success = await controller.updateExistingService(
        serviceId: widget.service.id,
        categoryId: selectedCategoryId!,
        title: selectedCategory!,
        price: price,
        details: serviceDetailsController.text.trim(),
        primaryImage: selectedImage,
        additionalImages: nonNullAdditional,
      );

      if (mounted) setState(() => isLoading = false);

      if (success) {
        Get.back();
        Get.snackbar(
          'Updated',
          'Service updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to update service. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      Get.snackbar('Error', 'Failed to update service: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Service',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              const Text('Service Thumbnail',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
              const SizedBox(height: 12),
              // Show existing image URL as preview if no new image selected
              if (selectedImage == null && widget.service.image.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.service.image,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, size: 48, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2870BC),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                )
              else
                ImagePickerCard(selectedImage: selectedImage, onTap: _pickImage),

              const SizedBox(height: 32),

              // Category
              const Text('Service Category',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
              const SizedBox(height: 12),
              isCategoriesLoading
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8)),
                      child: const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2870BC))),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8)),
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: categories
                            .map((c) => DropdownMenuItem(
                                value: c.name,
                                child: Text(c.name, style: const TextStyle(fontSize: 14, color: Colors.black))))
                            .toList(),
                        onChanged: (value) {
                          final cat = categories.firstWhere((c) => c.name == value, orElse: () => categories.first);
                          setState(() {
                            selectedCategory = value;
                            selectedCategoryId = cat.id;
                          });
                        },
                      ),
                    ),

              const SizedBox(height: 24),

              // Amount
              const Text('Service Amount',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
              const SizedBox(height: 12),
              TextField(
                controller: serviceAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '\$120',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF2870BC), width: 2)),
                ),
              ),

              const SizedBox(height: 24),

              // Details
              const Text('Service Details',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black)),
              const SizedBox(height: 12),
              TextField(
                controller: serviceDetailsController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Describe your service...',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF2870BC), width: 2)),
                ),
              ),

              const SizedBox(height: 24),

              // Additional images toggle
              Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => setState(() => showAdditionalImages = !showAdditionalImages),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade400, width: 2)),
                        child: Icon(showAdditionalImages ? Icons.remove : Icons.add,
                            color: Colors.grey.shade600, size: 28),
                      ),
                    ),
                  ),
                  if (showAdditionalImages) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Add more images (${additionalImages.where((img) => img != null).length}/2)',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(
                        2,
                        (index) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: index == 0 ? 12 : 0),
                            child: AdditionalImagePickerCard(
                              selectedImage: additionalImages[index],
                              onTap: () => _pickAdditionalImage(index),
                              onDelete: () {
                                setState(() => additionalImages[index] = null);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 32),

              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2870BC),
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Update Service',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
