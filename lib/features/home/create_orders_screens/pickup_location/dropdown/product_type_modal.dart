// product type model
class ProductTypeResponse {
  final bool success;
  final String message;
  final List<ProductTypeCategory> data;

  ProductTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductTypeResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    return ProductTypeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataList
          .map((categoryJson) => ProductTypeCategory.fromJson(categoryJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((category) => category.toJson()).toList(),
    };
  }
}

class ProductTypeCategory {
  final String category;
  final String categoryLabel;
  final List<ProductTypeItem> products;

  ProductTypeCategory({
    required this.category,
    required this.categoryLabel,
    required this.products,
  });

  factory ProductTypeCategory.fromJson(Map<String, dynamic> json) {
    final productsList = json['products'] as List<dynamic>? ?? [];

    return ProductTypeCategory(
      category: json['category'] ?? '',
      categoryLabel: json['category_label'] ?? '',
      products: productsList
          .map((item) => ProductTypeItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'category_label': categoryLabel,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}

class ProductTypeItem {
  final int id;
  final String name;
  final String category;
  final String description;
  final double baseValueMultiplier;
  final String icon;
  final String categoryLabel;

  ProductTypeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.baseValueMultiplier,
    required this.icon,
    required this.categoryLabel,
  });

  factory ProductTypeItem.fromJson(Map<String, dynamic> json) {
    return ProductTypeItem(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      baseValueMultiplier: _parseDouble(json['base_value_multiplier']),
      icon: json['icon']?.toString() ?? 'box',
      categoryLabel: json['category_label']?.toString() ?? '',
    );
  }
  static double _parseDouble(dynamic value) {
    if (value == null) return 1.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 1.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'base_value_multiplier': baseValueMultiplier,
      'icon': icon,
      'category_label': categoryLabel,
    };
  }

  // Display name with category
  String get displayName => '$name ($categoryLabel)';

  @override
  String toString() => name;

  bool matchesSearch(String query) {
    final lowercaseQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowercaseQuery) ||
        description.toLowerCase().contains(lowercaseQuery) ||
        category.toLowerCase().contains(lowercaseQuery) ||
        categoryLabel.toLowerCase().contains(lowercaseQuery);
  }
}

/////////////////////////////
// Packageing Type
class PackagingTypeResponse {
  final bool success;
  final String message;
  final List<PackagingTypeItem> data;

  PackagingTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PackagingTypeResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    return PackagingTypeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataList.map((item) => PackagingTypeItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class PackagingTypeItem {
  final int id;
  final String name;
  final String description;
  final double? fixedWeightKg;
  final bool requiresDimensions;
  final double? typicalCapacityKg;
  final double handlingMultiplier;
  final String icon;

  PackagingTypeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.fixedWeightKg,
    required this.requiresDimensions,
    required this.typicalCapacityKg,
    required this.handlingMultiplier,
    required this.icon,
  });

  factory PackagingTypeItem.fromJson(Map<String, dynamic> json) {
    return PackagingTypeItem(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      fixedWeightKg: _parseNullableDouble(json['fixed_weight_kg']),
      requiresDimensions: json['requires_dimensions'] is bool
          ? json['requires_dimensions']
          : (json['requires_dimensions']?.toString() == 'true'),
      typicalCapacityKg: _parseNullableDouble(json['typical_capacity_kg']),
      handlingMultiplier: _parseDouble(json['handling_multiplier']),
      icon: json['icon']?.toString() ?? 'box',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 1.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 1.0;
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    final parsed = double.tryParse(value.toString());
    return parsed;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fixed_weight_kg': fixedWeightKg,
      'requires_dimensions': requiresDimensions,
      'typical_capacity_kg': typicalCapacityKg,
      'handling_multiplier': handlingMultiplier,
      'icon': icon,
    };
  }

  @override
  String toString() => name;

  bool matchesSearch(String query) {
    final lowercaseQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowercaseQuery) ||
        description.toLowerCase().contains(lowercaseQuery);
  }
}
