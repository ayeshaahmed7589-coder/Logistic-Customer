// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_order_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
  orderNumber: json['order_number'] as String,
  trackingCode: json['tracking_code'] as String,
  customerId: (json['customer_id'] as num).toInt(),
  orderType: json['order_type'] as String,
  serviceType: json['service_type'] as String,
  priority: json['priority'] as String,
  status: json['status'] as String,
  pickupAddress: json['pickup_address'] as String,
  pickupLatitude: json['pickup_latitude'] as String,
  pickupLongitude: json['pickup_longitude'] as String,
  pickupContactName: json['pickup_contact_name'] as String,
  pickupContactPhone: json['pickup_contact_phone'] as String,
  pickupCity: json['pickup_city'] as String,
  pickupState: json['pickup_state'] as String,
  pickupPostalCode: json['pickup_postal_code'] as String,
  deliveryAddress: json['delivery_address'] as String,
  deliveryLatitude: json['delivery_latitude'] as String,
  deliveryLongitude: json['delivery_longitude'] as String,
  deliveryContactName: json['delivery_contact_name'] as String,
  deliveryContactPhone: json['delivery_contact_phone'] as String,
  deliveryCity: json['delivery_city'] as String,
  deliveryState: json['delivery_state'] as String,
  deliveryPostalCode: json['delivery_postal_code'] as String,
  distanceKm: json['distance_km'] as String,
  estimatedCost: json['estimated_cost'] as String,
  finalCost: json['final_cost'] as String,
  serviceFee: json['service_fee'] as String,
  taxAmount: json['tax_amount'] as String,
  addOnsCost: json['add_ons_cost'] as String,
  addOns: (json['addOns'] as List<dynamic>?)?.map((e) => e as String).toList(),
  paymentMethod: json['payment_method'] as String,
  paymentStatus: json['payment_status'] as String,
  specialInstructions: json['special_instructions'] as String?,
  vehicleType: json['vehicle_type'] as String?,
  pricingBreakdown: json['pricing_breakdown'] == null
      ? null
      : PricingBreakdown.fromJson(
          json['pricing_breakdown'] as Map<String, dynamic>,
        ),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  id: (json['id'] as num).toInt(),
  customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
  'order_number': instance.orderNumber,
  'tracking_code': instance.trackingCode,
  'customer_id': instance.customerId,
  'order_type': instance.orderType,
  'service_type': instance.serviceType,
  'priority': instance.priority,
  'status': instance.status,
  'pickup_address': instance.pickupAddress,
  'pickup_latitude': instance.pickupLatitude,
  'pickup_longitude': instance.pickupLongitude,
  'pickup_contact_name': instance.pickupContactName,
  'pickup_contact_phone': instance.pickupContactPhone,
  'pickup_city': instance.pickupCity,
  'pickup_state': instance.pickupState,
  'pickup_postal_code': instance.pickupPostalCode,
  'delivery_address': instance.deliveryAddress,
  'delivery_latitude': instance.deliveryLatitude,
  'delivery_longitude': instance.deliveryLongitude,
  'delivery_contact_name': instance.deliveryContactName,
  'delivery_contact_phone': instance.deliveryContactPhone,
  'delivery_city': instance.deliveryCity,
  'delivery_state': instance.deliveryState,
  'delivery_postal_code': instance.deliveryPostalCode,
  'distance_km': instance.distanceKm,
  'estimated_cost': instance.estimatedCost,
  'final_cost': instance.finalCost,
  'service_fee': instance.serviceFee,
  'tax_amount': instance.taxAmount,
  'add_ons_cost': instance.addOnsCost,
  'addOns': instance.addOns,
  'payment_method': instance.paymentMethod,
  'payment_status': instance.paymentStatus,
  'special_instructions': instance.specialInstructions,
  'vehicle_type': instance.vehicleType,
  'pricing_breakdown': instance.pricingBreakdown,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'id': instance.id,
  'customer': instance.customer,
  'items': instance.items,
};

PricingBreakdown _$PricingBreakdownFromJson(Map<String, dynamic> json) =>
    PricingBreakdown(
      baseFare: (json['base_fare'] as num).toDouble(),
      distanceCost: (json['distance_cost'] as num).toDouble(),
      distanceKm: (json['distance_km'] as num).toDouble(),
      weightCharge: (json['weight_charge'] as num).toDouble(),
      addOnsCost: (json['add_ons_cost'] as num).toDouble(),
      serviceFee: (json['service_fee'] as num).toDouble(),
      serviceFeePercentage: (json['service_fee_percentage'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      taxPercentage: (json['tax_percentage'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$PricingBreakdownToJson(PricingBreakdown instance) =>
    <String, dynamic>{
      'base_fare': instance.baseFare,
      'distance_cost': instance.distanceCost,
      'distance_km': instance.distanceKm,
      'weight_charge': instance.weightCharge,
      'add_ons_cost': instance.addOnsCost,
      'service_fee': instance.serviceFee,
      'service_fee_percentage': instance.serviceFeePercentage,
      'tax': instance.tax,
      'tax_percentage': instance.taxPercentage,
      'total': instance.total,
      'currency': instance.currency,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  customerType: json['customer_type'] as String,
  companyName: json['company_name'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  profilePhoto: json['profile_photo'] as String?,
  gender: json['gender'] as String?,
  preferredLanguage: json['preferred_language'] as String?,
  taxNumber: json['tax_number'] as String?,
  billingAddress: json['billing_address'] as String?,
  shippingAddress: json['shipping_address'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
  country: json['country'] as String?,
  postalCode: json['postal_code'] as String?,
  shopifyCustomerId: json['shopify_customer_id'] as String?,
  creditLimit: json['credit_limit'] as String,
  totalOrders: (json['total_orders'] as num).toInt(),
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'customer_type': instance.customerType,
  'company_name': instance.companyName,
  'date_of_birth': instance.dateOfBirth,
  'profile_photo': instance.profilePhoto,
  'gender': instance.gender,
  'preferred_language': instance.preferredLanguage,
  'tax_number': instance.taxNumber,
  'billing_address': instance.billingAddress,
  'shipping_address': instance.shippingAddress,
  'city': instance.city,
  'state': instance.state,
  'country': instance.country,
  'postal_code': instance.postalCode,
  'shopify_customer_id': instance.shopifyCustomerId,
  'credit_limit': instance.creditLimit,
  'total_orders': instance.totalOrders,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
  'user': instance.user,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  role: json['role'] as String,
  isActive: json['is_active'] as bool,
  status: json['status'] as String,
  emailVerifiedAt: json['email_verified_at'] as String?,
  phoneVerifiedAt: json['phone_verified_at'] as String?,
  lastLoginAt: json['last_login_at'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'role': instance.role,
  'is_active': instance.isActive,
  'status': instance.status,
  'email_verified_at': instance.emailVerifiedAt,
  'phone_verified_at': instance.phoneVerifiedAt,
  'last_login_at': instance.lastLoginAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  id: (json['id'] as num).toInt(),
  orderId: (json['order_id'] as num).toInt(),
  productName: json['product_name'] as String,
  description: json['description'] as String?,
  productSku: json['product_sku'] as String,
  shopifyProductId: json['shopify_product_id'] as String?,
  quantity: (json['quantity'] as num).toInt(),
  weightKg: json['weight_kg'] as String,
  volume: json['volume'] as String?,
  dimensions: json['dimensions'] as String?,
  declaredValue: json['declared_value'] as String,
  specialHandling: json['special_handling'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  deletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'id': instance.id,
  'order_id': instance.orderId,
  'product_name': instance.productName,
  'description': instance.description,
  'product_sku': instance.productSku,
  'shopify_product_id': instance.shopifyProductId,
  'quantity': instance.quantity,
  'weight_kg': instance.weightKg,
  'volume': instance.volume,
  'dimensions': instance.dimensions,
  'declared_value': instance.declaredValue,
  'special_handling': instance.specialHandling,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'deleted_at': instance.deletedAt,
};

OrderRequestBody _$OrderRequestBodyFromJson(Map<String, dynamic> json) =>
    OrderRequestBody(
      pickupAddress: json['pickup_address'] as String,
      pickupLatitude: (json['pickup_latitude'] as num).toDouble(),
      pickupLongitude: (json['pickup_longitude'] as num).toDouble(),
      pickupContactName: json['pickup_contact_name'] as String,
      pickupContactPhone: json['pickup_contact_phone'] as String,
      pickupCity: json['pickup_city'] as String,
      pickupState: json['pickup_state'] as String,
      pickupPostalCode: json['pickup_postal_code'] as String,
      deliveryAddress: json['delivery_address'] as String,
      deliveryLatitude: (json['delivery_latitude'] as num).toDouble(),
      deliveryLongitude: (json['delivery_longitude'] as num).toDouble(),
      deliveryContactName: json['delivery_contact_name'] as String,
      deliveryContactPhone: json['delivery_contact_phone'] as String,
      deliveryCity: json['delivery_city'] as String,
      deliveryState: json['delivery_state'] as String,
      deliveryPostalCode: json['delivery_postal_code'] as String,
      serviceType: json['service_type'] as String,
      vehicleType: json['vehicle_type'] as String,
      priority: json['priority'] as String,
      paymentMethod: json['payment_method'] as String,
      addOns: (json['add_ons'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialInstructions: json['special_instructions'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderRequestBodyToJson(OrderRequestBody instance) =>
    <String, dynamic>{
      'pickup_address': instance.pickupAddress,
      'pickup_latitude': instance.pickupLatitude,
      'pickup_longitude': instance.pickupLongitude,
      'pickup_contact_name': instance.pickupContactName,
      'pickup_contact_phone': instance.pickupContactPhone,
      'pickup_city': instance.pickupCity,
      'pickup_state': instance.pickupState,
      'pickup_postal_code': instance.pickupPostalCode,
      'delivery_address': instance.deliveryAddress,
      'delivery_latitude': instance.deliveryLatitude,
      'delivery_longitude': instance.deliveryLongitude,
      'delivery_contact_name': instance.deliveryContactName,
      'delivery_contact_phone': instance.deliveryContactPhone,
      'delivery_city': instance.deliveryCity,
      'delivery_state': instance.deliveryState,
      'delivery_postal_code': instance.deliveryPostalCode,
      'service_type': instance.serviceType,
      'vehicle_type': instance.vehicleType,
      'priority': instance.priority,
      'payment_method': instance.paymentMethod,
      'add_ons': instance.addOns,
      'special_instructions': instance.specialInstructions,
      'items': instance.items,
    };

OrderItemRequest _$OrderItemRequestFromJson(Map<String, dynamic> json) =>
    OrderItemRequest(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      description: json['description'] as String,
      shopifyProductId: json['shopify_product_id'] as String?,
      productSku: json['product_sku'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderItemRequestToJson(OrderItemRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'weight': instance.weight,
      'description': instance.description,
      'shopify_product_id': instance.shopifyProductId,
      'product_sku': instance.productSku,
      'value': instance.value,
    };
