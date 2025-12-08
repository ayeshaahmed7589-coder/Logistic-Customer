import 'package:json_annotation/json_annotation.dart';

part 'place_order_modal.g.dart';

@JsonSerializable()
class OrderResponse {
  final bool success;
  final String message;
  final OrderData data;

  OrderResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

@JsonSerializable()
class OrderData {
  @JsonKey(name: 'order_number')
  final String orderNumber;

  @JsonKey(name: 'tracking_code')
  final String trackingCode;

  @JsonKey(name: 'customer_id')
  final int customerId;

  @JsonKey(name: 'order_type')
  final String orderType;

  @JsonKey(name: 'service_type')
  final String serviceType;

  final String priority;
  final String status;

  @JsonKey(name: 'pickup_address')
  final String pickupAddress;

  @JsonKey(name: 'pickup_latitude')
  final String pickupLatitude;

  @JsonKey(name: 'pickup_longitude')
  final String pickupLongitude;

  @JsonKey(name: 'pickup_contact_name')
  final String pickupContactName;

  @JsonKey(name: 'pickup_contact_phone')
  final String pickupContactPhone;

  @JsonKey(name: 'pickup_city')
  final String pickupCity;

  @JsonKey(name: 'pickup_state')
  final String pickupState;

  @JsonKey(name: 'pickup_postal_code')
  final String pickupPostalCode;

  @JsonKey(name: 'delivery_address')
  final String deliveryAddress;

  @JsonKey(name: 'delivery_latitude')
  final String deliveryLatitude;

  @JsonKey(name: 'delivery_longitude')
  final String deliveryLongitude;

  @JsonKey(name: 'delivery_contact_name')
  final String deliveryContactName;

  @JsonKey(name: 'delivery_contact_phone')
  final String deliveryContactPhone;

  @JsonKey(name: 'delivery_city')
  final String deliveryCity;

  @JsonKey(name: 'delivery_state')
  final String deliveryState;

  @JsonKey(name: 'delivery_postal_code')
  final String deliveryPostalCode;

  @JsonKey(name: 'distance_km')
  final String distanceKm;

  @JsonKey(name: 'estimated_cost')
  final String estimatedCost;

  @JsonKey(name: 'final_cost')
  final String finalCost;

  @JsonKey(name: 'service_fee')
  final String serviceFee;

  @JsonKey(name: 'tax_amount')
  final String taxAmount;

  @JsonKey(name: 'add_ons_cost')
  final String addOnsCost;

  final List<String>? addOns;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'payment_status')
  final String paymentStatus;

  @JsonKey(name: 'special_instructions')
  final String? specialInstructions;

  @JsonKey(name: 'vehicle_type')
  final String? vehicleType;

  @JsonKey(name: 'pricing_breakdown')
  final PricingBreakdown? pricingBreakdown;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  final int id;
  final Customer customer;
  final List<OrderItem> items;

  OrderData({
    required this.orderNumber,
    required this.trackingCode,
    required this.customerId,
    required this.orderType,
    required this.serviceType,
    required this.priority,
    required this.status,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupContactName,
    required this.pickupContactPhone,
    required this.pickupCity,
    required this.pickupState,
    required this.pickupPostalCode,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.deliveryContactName,
    required this.deliveryContactPhone,
    required this.deliveryCity,
    required this.deliveryState,
    required this.deliveryPostalCode,
    required this.distanceKm,
    required this.estimatedCost,
    required this.finalCost,
    required this.serviceFee,
    required this.taxAmount,
    required this.addOnsCost,
    this.addOns,
    required this.paymentMethod,
    required this.paymentStatus,
    this.specialInstructions,
    this.vehicleType,
    this.pricingBreakdown,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.customer,
    required this.items,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) =>
      _$OrderDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}

@JsonSerializable()
class PricingBreakdown {
  @JsonKey(name: 'base_fare')
  final double baseFare;

  @JsonKey(name: 'distance_cost')
  final double distanceCost;

  @JsonKey(name: 'distance_km')
  final double distanceKm;

  @JsonKey(name: 'weight_charge')
  final double weightCharge;

  @JsonKey(name: 'add_ons_cost')
  final double addOnsCost;

  @JsonKey(name: 'service_fee')
  final double serviceFee;

  @JsonKey(name: 'service_fee_percentage')
  final double serviceFeePercentage;

  final double tax;

  @JsonKey(name: 'tax_percentage')
  final double taxPercentage;

  final double total;
  final String currency;

  PricingBreakdown({
    required this.baseFare,
    required this.distanceCost,
    required this.distanceKm,
    required this.weightCharge,
    required this.addOnsCost,
    required this.serviceFee,
    required this.serviceFeePercentage,
    required this.tax,
    required this.taxPercentage,
    required this.total,
    required this.currency,
  });

  factory PricingBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PricingBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$PricingBreakdownToJson(this);
}

@JsonSerializable()
class Customer {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'customer_type')
  final String customerType;
  @JsonKey(name: 'company_name')
  final String? companyName;
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  @JsonKey(name: 'profile_photo')
  final String? profilePhoto;
  final String? gender;
  @JsonKey(name: 'preferred_language')
  final String? preferredLanguage;
  @JsonKey(name: 'tax_number')
  final String? taxNumber;
  @JsonKey(name: 'billing_address')
  final String? billingAddress;
  @JsonKey(name: 'shipping_address')
  final String? shippingAddress;
  final String? city;
  final String? state;
  final String? country;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @JsonKey(name: 'shopify_customer_id')
  final String? shopifyCustomerId;
  @JsonKey(name: 'credit_limit')
  final String creditLimit;
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  final User user;

  Customer({
    required this.id,
    required this.userId,
    required this.customerType,
    this.companyName,
    this.dateOfBirth,
    this.profilePhoto,
    this.gender,
    this.preferredLanguage,
    this.taxNumber,
    this.billingAddress,
    this.shippingAddress,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.shopifyCustomerId,
    required this.creditLimit,
    required this.totalOrders,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.user,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final String status;
  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;
  @JsonKey(name: 'phone_verified_at')
  final String? phoneVerifiedAt;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.isActive,
    required this.status,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class OrderItem {
  final int id;
  @JsonKey(name: 'order_id')
  final int orderId;
  @JsonKey(name: 'product_name')
  final String productName;
  final String? description;
  @JsonKey(name: 'product_sku')
  final String productSku;
  @JsonKey(name: 'shopify_product_id')
  final String? shopifyProductId;
  final int quantity;
  @JsonKey(name: 'weight_kg')
  final String weightKg;
  final String? volume;
  final String? dimensions;
  @JsonKey(name: 'declared_value')
  final String declaredValue;
  @JsonKey(name: 'special_handling')
  final String? specialHandling;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productName,
    this.description,
    required this.productSku,
    this.shopifyProductId,
    required this.quantity,
    required this.weightKg,
    this.volume,
    this.dimensions,
    required this.declaredValue,
    this.specialHandling,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

// ✅ New class for Order Request Body (Body JSON ke liye)
@JsonSerializable()
class OrderRequestBody {
  @JsonKey(name: 'pickup_address')
  final String pickupAddress;

  @JsonKey(name: 'pickup_latitude')
  final double pickupLatitude;

  @JsonKey(name: 'pickup_longitude')
  final double pickupLongitude;

  @JsonKey(name: 'pickup_contact_name')
  final String pickupContactName;

  @JsonKey(name: 'pickup_contact_phone')
  final String pickupContactPhone;

  @JsonKey(name: 'pickup_city')
  final String pickupCity;

  @JsonKey(name: 'pickup_state')
  final String pickupState;

  @JsonKey(name: 'pickup_postal_code')
  final String pickupPostalCode;

  @JsonKey(name: 'delivery_address')
  final String deliveryAddress;

  @JsonKey(name: 'delivery_latitude')
  final double deliveryLatitude;

  @JsonKey(name: 'delivery_longitude')
  final double deliveryLongitude;

  @JsonKey(name: 'delivery_contact_name')
  final String deliveryContactName;

  @JsonKey(name: 'delivery_contact_phone')
  final String deliveryContactPhone;

  @JsonKey(name: 'delivery_city')
  final String deliveryCity;

  @JsonKey(name: 'delivery_state')
  final String deliveryState;

  @JsonKey(name: 'delivery_postal_code')
  final String deliveryPostalCode;

  @JsonKey(name: 'service_type')
  final String serviceType;

  @JsonKey(name: 'vehicle_type')
  final String vehicleType;

  final String priority;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'add_ons')
  final List<String>? addOns;

  @JsonKey(name: 'special_instructions')
  final String? specialInstructions;

  final List<OrderItemRequest> items;

  OrderRequestBody({
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupContactName,
    required this.pickupContactPhone,
    required this.pickupCity,
    required this.pickupState,
    required this.pickupPostalCode,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.deliveryContactName,
    required this.deliveryContactPhone,
    required this.deliveryCity,
    required this.deliveryState,
    required this.deliveryPostalCode,
    required this.serviceType,
    required this.vehicleType,
    required this.priority,
    required this.paymentMethod,
    this.addOns,
    this.specialInstructions,
    required this.items,
  });

  factory OrderRequestBody.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestBodyFromJson(json);
  Map<String, dynamic> toJson() => _$OrderRequestBodyToJson(this);
}

@JsonSerializable()
class OrderItemRequest {
  final String name;
  final int quantity;
  final double weight;
  final String description;

  @JsonKey(name: 'shopify_product_id')
  final String? shopifyProductId;

  @JsonKey(name: 'product_sku')
  final String productSku;

  final double value;

  OrderItemRequest({
    required this.name,
    required this.quantity,
    required this.weight,
    required this.description,
    this.shopifyProductId,
    required this.productSku,
    required this.value,
  });

  factory OrderItemRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderItemRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemRequestToJson(this);
}
