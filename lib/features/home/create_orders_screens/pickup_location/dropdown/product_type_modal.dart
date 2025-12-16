class ProductTypeResponse {
  final bool success;
  final String message;
  final ProductTypeData data;

  ProductTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductTypeResponse.fromJson(Map<String, dynamic> json) {
    return ProductTypeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ProductTypeData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class ProductTypeData {
  final List<ProductTypeCategory> productTypes;
  final int total;

  ProductTypeData({required this.productTypes, required this.total});

  factory ProductTypeData.fromJson(Map<String, dynamic> json) {
    final productTypesList = json['product_types'] as List<dynamic>? ?? [];
    return ProductTypeData(
      productTypes: productTypesList
          .map((category) => ProductTypeCategory.fromJson(category))
          .toList(),
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_types': productTypes
          .map((category) => category.toJson())
          .toList(),
      'total': total,
    };
  }

  // Helper method to get all items flattened
  List<ProductTypeItem> getAllItems() {
    return productTypes.expand((category) => category.items).toList();
  }

  // Helper method to get items by category
  List<ProductTypeItem> getItemsByCategory(String category) {
    final foundCategory = productTypes.firstWhere(
      (cat) => cat.category == category,
      orElse: () =>
          ProductTypeCategory(category: '', categoryName: '', items: []),
    );
    return foundCategory.items;
  }
}

class ProductTypeCategory {
  final String category;
  final String categoryName;
  final List<ProductTypeItem> items;

  ProductTypeCategory({
    required this.category,
    required this.categoryName,
    required this.items,
  });

  factory ProductTypeCategory.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return ProductTypeCategory(
      category: json['category'] ?? '',
      categoryName: json['category_name'] ?? '',
      items: itemsList.map((item) => ProductTypeItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'category_name': categoryName,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ProductTypeItem {
  final int id;
  final String name;
  final String category;
  final String description;
  final double valueMultiplier;
  final String? icon;

  ProductTypeItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.valueMultiplier,
    this.icon,
  });

  factory ProductTypeItem.fromJson(Map<String, dynamic> json) {
    return ProductTypeItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      valueMultiplier: (json['value_multiplier'] as num?)?.toDouble() ?? 1.0,
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'value_multiplier': valueMultiplier,
      'icon': icon,
    };
  }

  // For dropdown display
  @override
  String toString() => name;

  // Helper to check if item matches search
  bool matchesSearch(String query) {
    final lowercaseQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowercaseQuery) ||
        description.toLowerCase().contains(lowercaseQuery) ||
        category.toLowerCase().contains(lowercaseQuery);
  }
}

// Packageing Type
class PackagingTypeResponse {
  final bool success;
  final String message;
  final PackagingTypeData data;

  PackagingTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PackagingTypeResponse.fromJson(Map<String, dynamic> json) {
    return PackagingTypeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PackagingTypeData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class PackagingTypeData {
  final List<PackagingTypeItem> packagingTypes;
  final int total;

  PackagingTypeData({required this.packagingTypes, required this.total});

  factory PackagingTypeData.fromJson(Map<String, dynamic> json) {
    final packagingTypesList = json['packaging_types'] as List<dynamic>? ?? [];
    return PackagingTypeData(
      packagingTypes: packagingTypesList
          .map((item) => PackagingTypeItem.fromJson(item))
          .toList(),
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packaging_types': packagingTypes.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }

  // Helper method to get all items
  List<PackagingTypeItem> getAllItems() {
    return packagingTypes;
  }

  // Helper to check if item matches search
  List<PackagingTypeItem> searchItems(String query) {
    if (query.isEmpty) return packagingTypes;

    final lowercaseQuery = query.toLowerCase();
    return packagingTypes
        .where(
          (item) =>
              item.name.toLowerCase().contains(lowercaseQuery) ||
              item.description.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }
}

class PackagingTypeItem {
  final int id;
  final String name;
  final String description;
  final double handlingMultiplier;
  final bool requiresDimensions;
  final String? icon;

  PackagingTypeItem({
    required this.id,
    required this.name,
    required this.description,
    required this.handlingMultiplier,
    required this.requiresDimensions,
    this.icon,
  });

  factory PackagingTypeItem.fromJson(Map<String, dynamic> json) {
    return PackagingTypeItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      handlingMultiplier:
          (json['handling_multiplier'] as num?)?.toDouble() ?? 1.0,
      requiresDimensions: json['requires_dimensions'] ?? false,
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'handling_multiplier': handlingMultiplier,
      'requires_dimensions': requiresDimensions,
      'icon': icon,
    };
  }

  // For dropdown display
  @override
  String toString() => name;

  // Helper to check if item matches search
  bool matchesSearch(String query) {
    final lowercaseQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowercaseQuery) ||
        description.toLowerCase().contains(lowercaseQuery);
  }
}
