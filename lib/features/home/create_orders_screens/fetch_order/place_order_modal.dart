

// Order Request Models
class OrderRequestBody {
  final int productTypeId;
  final int packagingTypeId;
  final double totalWeightKg;
  final int itemQuantity;
  final String pickupContactName;
  final String pickupContactPhone;
  final String pickupAddress;
  final String pickupCity;
  final String pickupState;
  final String pickupPostalCode;
  final String deliveryContactName;
  final String deliveryContactPhone;
  final String deliveryAddress;
  final String deliveryCity;
  final String deliveryState;
  final String deliveryPostalCode;
  final String serviceType;
  final String? specialInstructions;
  final SelectedQuote selectedQuote;
  final double estimatedCost;
  final List<String> addOns;
  final double declaredValue;
  final List<OrderItemRequest> items;

  OrderRequestBody({
    required this.productTypeId,
    required this.packagingTypeId,
    required this.totalWeightKg,
    required this.itemQuantity,
    required this.pickupContactName,
    required this.pickupContactPhone,
    required this.pickupAddress,
    required this.pickupCity,
    required this.pickupState,
    required this.pickupPostalCode,
    required this.deliveryContactName,
    required this.deliveryContactPhone,
    required this.deliveryAddress,
    required this.deliveryCity,
    required this.deliveryState,
    required this.deliveryPostalCode,
    required this.serviceType,
    this.specialInstructions,
    required this.selectedQuote,
    required this.estimatedCost,
    required this.addOns,
    required this.declaredValue,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_type_id': productTypeId,
      'packaging_type_id': packagingTypeId,
      'total_weight_kg': totalWeightKg,
      'item_quantity': itemQuantity,
      'pickup_contact_name': pickupContactName,
      'pickup_contact_phone': pickupContactPhone,
      'pickup_address': pickupAddress,
      'pickup_city': pickupCity,
      'pickup_state': pickupState,
      'pickup_postal_code': pickupPostalCode,
      'delivery_contact_name': deliveryContactName,
      'delivery_contact_phone': deliveryContactPhone,
      'delivery_address': deliveryAddress,
      'delivery_city': deliveryCity,
      'delivery_state': deliveryState,
      'delivery_postal_code': deliveryPostalCode,
      'service_type': serviceType,
      'special_instructions': specialInstructions,
      'selected_quote': selectedQuote.toJson(),
      'estimated_cost': estimatedCost,
      'add_ons': addOns,
      'declared_value': declaredValue,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class SelectedQuote {
  final int vehicleId;
  final int driverId;
  final double matchingScore;
  final double depotScore;
  final double distanceScore;
  final double priceScore;
  final double suitabilityScore;
  final double driverScore;
  final int depotId;

  SelectedQuote({
    required this.vehicleId,
    required this.driverId,
    required this.matchingScore,
    required this.depotScore,
    required this.distanceScore,
    required this.priceScore,
    required this.suitabilityScore,
    required this.driverScore,
    required this.depotId,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'driver_id': driverId,
      'matching_score': matchingScore,
      'depot_score': depotScore,
      'distance_score': distanceScore,
      'price_score': priceScore,
      'suitability_score': suitabilityScore,
      'driver_score': driverScore,
      'depot_id': depotId,
    };
  }
}

class OrderItemRequest {
  final String name;
  final int quantity;
  final double weight;
  final double value;
  final String? description;
  final String? shopifyProductId;
  final String? productSku;

  OrderItemRequest({
    required this.name,
    required this.quantity,
    required this.weight,
    required this.value,
    this.description,
    this.shopifyProductId,
    this.productSku,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'weight': weight,
      'value': value,
      'description': description ?? 'No description',
      'shopify_product_id': shopifyProductId,
      'product_sku': productSku ?? 'N/A',
    };
  }
}

// Order Response Models
class OrderResponse {
  final bool success;
  final String message;
  final OrderResponseData data;

  OrderResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class OrderResponseData {
  final Order order;
  final Vehicle vehicle;
  final Driver driver;
  final Depot depot;

  OrderResponseData({
    required this.order,
    required this.vehicle,
    required this.driver,
    required this.depot,
  });

  factory OrderResponseData.fromJson(Map<String, dynamic> json) {
    return OrderResponseData(
      order: Order.fromJson(json['order'] as Map<String, dynamic>),
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
      depot: Depot.fromJson(json['depot'] as Map<String, dynamic>),
    );
  }

  // Convenience getters
  String get orderNumber => order.orderNumber;
  String get trackingCode => order.trackingCode;
  double get finalCost => order.finalCost;
}

class Order {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final int customerId;
  final int driverId;
  final int vehicleId;
  final int depotId;
  final int productTypeId;
  final int packagingTypeId;
  final double totalWeightKg;
  final int itemQuantity;
  final String status;
  final String paymentStatus;
  final String serviceType;
  final double? distanceKm;
  final double estimatedCost;
  final double finalCost;
  final double taxAmount;
  final double systemServiceFee;
  final double ssfPercentage;
  final double matchingScore;
  final double vehicleScore;
  final bool autoMatched;
  final String? specialInstructions;
  final List<String> addOns;
  final double addOnsCost;
  final bool isMultiStop;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String pickupCity;
  final String pickupState;
  final String deliveryCity;
  final String deliveryState;

  Order({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.customerId,
    required this.driverId,
    required this.vehicleId,
    required this.depotId,
    required this.productTypeId,
    required this.packagingTypeId,
    required this.totalWeightKg,
    required this.itemQuantity,
    required this.status,
    required this.paymentStatus,
    required this.serviceType,
    this.distanceKm,
    required this.estimatedCost,
    required this.finalCost,
    required this.taxAmount,
    required this.systemServiceFee,
    required this.ssfPercentage,
    required this.matchingScore,
    required this.vehicleScore,
    required this.autoMatched,
    this.specialInstructions,
    required this.addOns,
    required this.addOnsCost,
    required this.isMultiStop,
    required this.createdAt,
    required this.updatedAt,
    required this.pickupCity,
    required this.pickupState,
    required this.deliveryCity,
    required this.deliveryState,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      trackingCode: json['tracking_code'] as String,
      customerId: json['customer_id'] as int,
      driverId: json['driver_id'] as int,
      vehicleId: json['vehicle_id'] as int,
      depotId: json['depot_id'] as int,
      productTypeId: json['product_type_id'] as int,
      packagingTypeId: json['packaging_type_id'] as int,
      totalWeightKg: double.parse(json['total_weight_kg'].toString()),
      itemQuantity: json['item_quantity'] as int,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      serviceType: json['service_type'] as String,
      distanceKm: json['distance_km'] != null ? double.parse(json['distance_km'].toString()) : null,
      estimatedCost: double.parse(json['estimated_cost'].toString()),
      finalCost: double.parse(json['final_cost'].toString()),
      taxAmount: double.parse(json['tax_amount'].toString()),
      systemServiceFee: double.parse(json['system_service_fee'].toString()),
      ssfPercentage: double.parse(json['ssf_percentage'].toString()),
      matchingScore: double.parse(json['matching_score'].toString()),
      vehicleScore: double.parse(json['vehicle_score'].toString()),
      autoMatched: json['auto_matched'] as bool,
      specialInstructions: json['special_instructions'] as String?,
      addOns: List<String>.from(json['add_ons'] as List),
      addOnsCost: double.parse(json['add_ons_cost'].toString()),
      isMultiStop: json['is_multi_stop'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      pickupCity: json['pickup_city'] as String,
      pickupState: json['pickup_state'] as String,
      deliveryCity: json['delivery_city'] as String,
      deliveryState: json['delivery_state'] as String,
    );
  }
}

class Vehicle {
  final int id;
  final String registrationNumber;
  final String vehicleType;
  final String make;
  final String model;

  Vehicle({
    required this.id,
    required this.registrationNumber,
    required this.vehicleType,
    required this.make,
    required this.model,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      registrationNumber: json['registration_number'] as String,
      vehicleType: json['vehicle_type'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
    );
  }
}

class Driver {
  final int id;
  final String name;
  final String phone;
  final double rating;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      rating: double.parse(json['rating'].toString()),
    );
  }
}

class Depot {
  final int id;
  final String name;
  final String city;

  Depot({
    required this.id,
    required this.name,
    required this.city,
  });

  factory Depot.fromJson(Map<String, dynamic> json) {
    return Depot(
      id: json['id'] as int,
      name: json['name'] as String,
      city: json['city'] as String,
    );
  }
}
