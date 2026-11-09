/// Category models matching com.lifeuse.money.models.dto.CategoryResponse & CategoryRequest
class CategoryModel {
  final int id;
  final int? userId;
  final String name;
  final String? icon;
  final String? color;
  final bool essential;
  final bool system;
  final DateTime? createdAt;

  const CategoryModel({
    required this.id,
    this.userId,
    required this.name,
    this.icon,
    this.color,
    required this.essential,
    required this.system,
    this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      color: json['color']?.toString(),
      essential: json['essential'] == true,
      system: json['system'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'icon': icon,
      'color': color,
      'essential': essential,
      'system': system,
      'createdAt': createdAt?.toUtc().toIso8601String(),
    };
  }
}

class CategoryRequest {
  final String name;
  final String? icon;
  final String? color;
  final bool essential;

  const CategoryRequest({
    required this.name,
    this.icon,
    this.color,
    this.essential = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
      'essential': essential,
    };
  }
}
