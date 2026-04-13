import 'dart:io';

import 'package:flutter/material.dart';

class ImagePickerCard extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onTap;
  final String? placeholder;

  const ImagePickerCard({
    Key? key,
    required this.selectedImage,
    required this.onTap,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF2870BC),
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload_outlined,
                      color: Color(0xFF2870BC),
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '10.0 MB maximum file size',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      placeholder ?? 'Upload image',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2870BC),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
