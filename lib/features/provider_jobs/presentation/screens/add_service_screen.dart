import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/service_category_model.dart';
import '../../data/repo/service_category_repository.dart';
import '../widgets/additional_image_picker_card.dart';
import '../widgets/image_picker_card.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  late TextEditingController serviceAmountController;
  late TextEditingController serviceDetailsController;
  String? selectedCategory;
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
    serviceAmountController = TextEditingController();
    serviceDetailsController = TextEditingController();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await _categoryRepository.getServiceCategories();
      setState(() {
        categories = fetchedCategories;
        // Set first category as default if available
        if (categories.isNotEmpty) {
          selectedCategory = categories[0].name;
        }
        isCategoriesLoading = false;
      });
    } catch (e) {
      setState(() => isCategoriesLoading = false);
      Get.snackbar(
        'Error',
        'Failed to load categories',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    serviceAmountController.dispose();
    serviceDetailsController.dispose();
    super.dispose();
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
          'Set Your Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Thumbnail Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Thumbnail',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ImagePickerCard(
                    selectedImage: selectedImage,
                    onTap: _pickImage,
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Service Category Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Category',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  isCategoriesLoading
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2870BC),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: categories
                                .map((category) => DropdownMenuItem(
                                      value: category.name,
                                      child: Text(
                                        category.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedCategory = value);
                            },
                          ),
                        ),
                ],
              ),

              const SizedBox(height: 24),

              // Service Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Amount',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: serviceAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '\$120',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF2870BC),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Service Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Details',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: serviceDetailsController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText:
                          'Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development.',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF2870BC),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Add More Images Section
              Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => showAdditionalImages = !showAdditionalImages);
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          showAdditionalImages ? Icons.remove : Icons.add,
                          color: Colors.grey.shade600,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  if (showAdditionalImages) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Add more images (${additionalImages.where((img) => img != null).length}/2)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
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
                                setState(() {
                                  additionalImages[index] = null;
                                });
                                Get.snackbar(
                                  'Deleted',
                                  'Image removed',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
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

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleAddService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2870BC),
                    disabledBackgroundColor: Colors.grey.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddService() async {
    // Validate fields
    if (serviceAmountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter service amount',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (serviceDetailsController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter service details',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // TODO: Implement API call to add service
      await Future.delayed(const Duration(milliseconds: 500));

      Get.snackbar(
        'Success',
        'Service added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Go back after successful addition
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add service',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final int fileSizeInBytes = await imageFile.length();
        final int fileSizeInMB = fileSizeInBytes ~/ (1024 * 1024);

        // Check file size (10 MB max)
        if (fileSizeInMB > 10) {
          Get.snackbar(
            'Error',
            'Image size must be less than 10 MB',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        setState(() {
          selectedImage = imageFile;
        });

        Get.snackbar(
          'Success',
          'Image selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _pickAdditionalImage(int index) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final int fileSizeInBytes = await imageFile.length();
        final int fileSizeInMB = fileSizeInBytes ~/ (1024 * 1024);

        // Check file size (10 MB max)
        if (fileSizeInMB > 10) {
          Get.snackbar(
            'Error',
            'Image size must be less than 10 MB',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        setState(() {
          additionalImages[index] = imageFile;
        });

        Get.snackbar(
          'Success',
          'Image selected successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
