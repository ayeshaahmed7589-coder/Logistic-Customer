// ✅ STANDARD ORDER REQUEST BODY
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/fetch_order/common_modal.dart';

class StandardOrderRequestBody {
  final int productTypeId;
  final int packagingTypeId;
  final int quantity;
  final double weightPerItem;
  final SelectedQuote selectedQuote;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupCity;
  final String pickupState;
  final String? pickupPostalCode;
  final String pickupContactName;
  final String pickupContactPhone;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String deliveryCity;
  final String deliveryState;
  final String? deliveryPostalCode;
  final String deliveryContactName;
  final String deliveryContactPhone;
  final String serviceType;
  final String priority;
  final String paymentMethod;
  final List<String> addOns;
  final String? specialInstructions;
  final double declaredValue;
  final double? length;
  final double? width;
  final double? height;

  StandardOrderRequestBody({
    required this.productTypeId,
    required this.packagingTypeId,
    required this.quantity,
    required this.weightPerItem,
    required this.selectedQuote,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupCity,
    required this.pickupState,
    this.pickupPostalCode,
    required this.pickupContactName,
    required this.pickupContactPhone,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.deliveryCity,
    required this.deliveryState,
    this.deliveryPostalCode,
    required this.deliveryContactName,
    required this.deliveryContactPhone,
    this.serviceType = 'standard',
    this.priority = 'medium',
    this.paymentMethod = 'wallet',
    this.addOns = const [],
    this.specialInstructions,
    this.declaredValue = 0.0,
    this.length,
    this.width,
    this.height,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'product_type_id': productTypeId,
      'packaging_type_id': packagingTypeId,
      'quantity': quantity,
      'weight_per_item': weightPerItem,
      'selected_quote': selectedQuote.toJson(),
      'pickup_address': pickupAddress,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'pickup_city': pickupCity,
      'pickup_state': pickupState,
      'pickup_contact_name': pickupContactName,
      'pickup_contact_phone': pickupContactPhone,
      'delivery_address': deliveryAddress,
      'delivery_latitude': deliveryLatitude,
      'delivery_longitude': deliveryLongitude,
      'delivery_city': deliveryCity,
      'delivery_state': deliveryState,
      'delivery_contact_name': deliveryContactName,
      'delivery_contact_phone': deliveryContactPhone,
      'service_type': serviceType,
      'priority': priority,
      'payment_method': paymentMethod,
      'add_ons': addOns,
      'declared_value': declaredValue,
    };

    if (pickupPostalCode != null && pickupPostalCode!.isNotEmpty) {
      map['pickup_postal_code'] = pickupPostalCode;
    }
    
    if (deliveryPostalCode != null && deliveryPostalCode!.isNotEmpty) {
      map['delivery_postal_code'] = deliveryPostalCode;
    }
    
    if (specialInstructions != null && specialInstructions!.isNotEmpty) {
      map['special_instructions'] = specialInstructions;
    }
    
    if (length != null) map['length'] = length;
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;

    return map;
  }
}

// ✅ MULTI-STOP ORDER REQUEST BODY
class MultiStopOrderRequestBody {
  final int productTypeId;
  final int packagingTypeId;
  final int quantity;
  final double weightPerItem;
  final bool isMultiStop;
  final SelectedQuote selectedQuote;
  final List<OrderStop> stops;
  final String serviceType;
  final String priority;
  final String paymentMethod;
  final List<String> addOns;
  final String? specialInstructions;
  final double declaredValue;

  MultiStopOrderRequestBody({
    required this.productTypeId,
    required this.packagingTypeId,
    required this.quantity,
    required this.weightPerItem,
    this.isMultiStop = true,
    required this.selectedQuote,
    required this.stops,
    this.serviceType = 'standard',
    this.priority = 'medium',
    this.paymentMethod = 'wallet',
    this.addOns = const [],
    this.specialInstructions,
    this.declaredValue = 0.0,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'product_type_id': productTypeId,
      'packaging_type_id': packagingTypeId,
      'quantity': quantity,
      'weight_per_item': weightPerItem,
      'is_multi_stop': isMultiStop,
      'selected_quote': selectedQuote.toJson(),
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'service_type': serviceType,
      'priority': priority,
      'payment_method': paymentMethod,
      'add_ons': addOns,
      'declared_value': declaredValue,
    };

    if (specialInstructions != null && specialInstructions!.isNotEmpty) {
      map['special_instructions'] = specialInstructions;
    }

    return map;
  }
}

// ✅ ORDER STOP (for multi-stop)
class OrderStop {
  final int sequenceNumber;
  final String stopType; // 'pickup', 'waypoint', 'drop_off'
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final String contactName;
  final String contactPhone;
  final int quantity;
  final double weight;
  final String? notes;

  OrderStop({
    required this.sequenceNumber,
    required this.stopType,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
    required this.quantity,
    required this.weight,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'sequence_number': sequenceNumber,
      'stop_type': stopType,
      'address': address,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'quantity': quantity,
      'weight_kg': weight,
    };

    if (notes != null && notes!.isNotEmpty) {
      map['notes'] = notes;
    }

    return map;
  }
}

// ✅ SELECTED QUOTE
class SelectedQuote {
  final int vehicleId;
  final int vehicleTypeId;
  final String vehicleTypeName;
  final String registrationNumber;
  final String make;
  final String model;
  final double capacityKg;
  final double capacityVolumeM3;
  final double totalScore;
  final double matchingScore;
  final int depotScore;
  final int distanceScore;
  final int priceScore;
  final int suitabilityScore;
  final int driverScore;
  final int depotId;
  final String depotName;
  final String depotCity;
  final double depotDistanceKm;
  final bool isExclusive;
  final double utilizationPercent;
  final VehiclePricing pricing;
  final VehicleCompany company;
  final VehicleDriver? driver;

  SelectedQuote({
    required this.vehicleId,
    required this.vehicleTypeId,
    required this.vehicleTypeName,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.capacityKg,
    required this.capacityVolumeM3,
    required this.totalScore,
    required this.matchingScore,
    required this.depotScore,
    required this.distanceScore,
    required this.priceScore,
    required this.suitabilityScore,
    required this.driverScore,
    required this.depotId,
    required this.depotName,
    required this.depotCity,
    required this.depotDistanceKm,
    required this.isExclusive,
    required this.utilizationPercent,
    required this.pricing,
    required this.company,
    this.driver,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'vehicle_id': vehicleId,
      'vehicle_type_id': vehicleTypeId,
      'vehicle_type_name': vehicleTypeName,
      'registration_number': registrationNumber,
      'make': make,
      'model': model,
      'capacity_kg': capacityKg,
      'capacity_volume_m3': capacityVolumeM3,
      'total_score': totalScore,
      'matching_score': matchingScore,
      'depot_score': depotScore,
      'distance_score': distanceScore,
      'price_score': priceScore,
      'suitability_score': suitabilityScore,
      'driver_score': driverScore,
      'depot_id': depotId,
      'depot_name': depotName,
      'depot_city': depotCity,
      'depot_distance_km': depotDistanceKm,
      'is_exclusive': isExclusive,
      'utilization_percent': utilizationPercent,
      'pricing': pricing,
      'company': company,
    };

    if (driver != null) {
      map['driver'] = {
        'id': driver!.id,
        'name': driver!.name,
        'rating': driver!.rating,
      };
    } else {
      map['driver'] = null;
    }

    return map;
  }
}

// ✅ ORDER RESPONSE
class OrderResponse {
  final bool success;
  final String message;
  final OrderData data;

  OrderResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OrderData.fromJson(json['data']),
    );
  }
}

class OrderData {
  final Order order;

  OrderData({
    required this.order,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      order: Order.fromJson(json['order']),
    );
  }
}

class Order {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final String status;
  final String paymentStatus;
  final bool isMultiStop;
  final int? stopsCount;
  final double totalWeightKg;
  final double distanceKm;
  final double finalCost;
  final String createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.paymentStatus,
    required this.isMultiStop,
    this.stopsCount,
    required this.totalWeightKg,
    required this.distanceKm,
    required this.finalCost,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['order_number'],
      trackingCode: json['tracking_code'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      isMultiStop: json['is_multi_stop'] ?? false,
      stopsCount: json['stops_count'],
      totalWeightKg: (json['total_weight_kg'] ?? 0).toDouble(),
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      finalCost: double.parse(json['final_cost'].toString()),
      createdAt: json['created_at'],
    );
  }
}