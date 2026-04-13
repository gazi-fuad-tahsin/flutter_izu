class CategoryModel {
  final String id;
  final String name;
  final String catImage;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.catImage,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      catImage: json['catImage'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'catImage': catImage,
      'isActive': isActive,
    };
  }
}
