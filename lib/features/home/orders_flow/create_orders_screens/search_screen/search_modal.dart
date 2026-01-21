// lib/models/product_model.dart

class ShopifySearchModel {
  final bool success;
  final List<Product> products;
  final int count;

  ShopifySearchModel({
    required this.success,
    required this.products,
    required this.count,
  });

  factory ShopifySearchModel.fromJson(Map<String, dynamic> json) {
    return ShopifySearchModel(
      success: json['success'] ?? false,
      products:
          (json['products'] as List?)
              ?.map((product) => Product.fromJson(product))
              .toList() ??
          [],
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'products': products.map((product) => product.toJson()).toList(),
      'count': count,
    };
  }
}

class Product {
  final int id;
  final String title;
  final String bodyHtml;
  final String productType;
  final String handle;
  final String tags;
  final List<Variant> variants;

  Product({
    required this.id,
    required this.title,
    required this.bodyHtml,
    required this.productType,
    required this.handle,
    required this.tags,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      bodyHtml: json['body_html'] ?? '',
      productType: json['product_type'] ?? '',
      handle: json['handle'] ?? '',
      tags: json['tags'] ?? '',
      variants:
          (json['variants'] as List?)
              ?.map((variant) => Variant.fromJson(variant))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body_html': bodyHtml,
      'product_type': productType,
      'handle': handle,
      'tags': tags,
      'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }
}

class Variant {
  final int? id;
  final int? productId;
  final String title;
  final String price;
  final int position;
  final String inventoryPolicy;
  final String? compareAtPrice;
  final String? option1;
  final String? option2;
  final String? option3;
  final String createdAt;
  final String updatedAt;
  final bool taxable;
  final String barcode;
  final String fulfillmentService;
  final int grams;
  final String? inventoryManagement;
  final bool requiresShipping;
  final String sku;
  final double weight;
  final String weightUnit;
  final int inventoryItemId;
  final int inventoryQuantity;
  final int oldInventoryQuantity;
  final String adminGraphqlApiId;
  final dynamic imageId;

  Variant({
    this.id,
    this.productId,
    required this.title,
    required this.price,
    required this.position,
    required this.inventoryPolicy,
    this.compareAtPrice,
    this.option1,
    this.option2,
    this.option3,
    required this.createdAt,
    required this.updatedAt,
    required this.taxable,
    required this.barcode,
    required this.fulfillmentService,
    required this.grams,
    this.inventoryManagement,
    required this.requiresShipping,
    required this.sku,
    required this.weight,
    required this.weightUnit,
    required this.inventoryItemId,
    required this.inventoryQuantity,
    required this.oldInventoryQuantity,
    required this.adminGraphqlApiId,
    this.imageId,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      productId: json['product_id'],
      title: json['title'] ?? '',
      price: json['price'] ?? '0.00',
      position: json['position'] ?? 0,
      inventoryPolicy: json['inventory_policy'] ?? '',
      compareAtPrice: json['compare_at_price'],
      option1: json['option1'],
      option2: json['option2'],
      option3: json['option3'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      taxable: json['taxable'] ?? false,
      barcode: json['barcode'] ?? '',
      fulfillmentService: json['fulfillment_service'] ?? 'manual',
      grams: json['grams'] ?? 0,
      inventoryManagement: json['inventory_management'],
      requiresShipping: json['requires_shipping'] ?? true,
      sku: json['sku'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      weightUnit: json['weight_unit'] ?? 'kg',
      inventoryItemId: json['inventory_item_id'] ?? 0,
      inventoryQuantity: json['inventory_quantity'] ?? 0,
      oldInventoryQuantity: json['old_inventory_quantity'] ?? 0,
      adminGraphqlApiId: json['admin_graphql_api_id'] ?? '',
      imageId: json['image_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'title': title,
      'price': price,
      'position': position,
      'inventory_policy': inventoryPolicy,
      'compare_at_price': compareAtPrice,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'taxable': taxable,
      'barcode': barcode,
      'fulfillment_service': fulfillmentService,
      'grams': grams,
      'inventory_management': inventoryManagement,
      'requires_shipping': requiresShipping,
      'sku': sku,
      'weight': weight,
      'weight_unit': weightUnit,
      'inventory_item_id': inventoryItemId,
      'inventory_quantity': inventoryQuantity,
      'old_inventory_quantity': oldInventoryQuantity,
      'admin_graphql_api_id': adminGraphqlApiId,
      'image_id': imageId,
    };
  }
}
