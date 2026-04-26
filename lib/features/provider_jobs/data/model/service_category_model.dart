class ServiceCategoryModel {
  final String id;
  final String name;
  final String categoryImage;
  final bool isActive;

  ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.categoryImage,
    required this.isActive,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      categoryImage: json['catImage'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'catImage': categoryImage,
      'isActive': isActive,
    };
  }
}
