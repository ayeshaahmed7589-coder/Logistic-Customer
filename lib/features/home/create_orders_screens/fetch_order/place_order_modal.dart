// ✅ STANDARD ORDER REQUEST BODY
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/common_modal.dart';

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


// // ✅ VEHICLE PRICING CLASS (UPDATE THIS)
// class VehiclePricing {
//   final double baseFare;
//   final double distanceKm;
//   final double distanceCost;
//   final double weightCharge;
//   final double addOnsTotal;
//   final double subtotalA;
//   final double systemServiceFee;
//   final double ssfPercentage;
//   final double subtotalB;
//   final double serviceFee;
//   final double serviceFeePercentage;
//   final double tax;
//   final double total;
//   final double vehicleMultiplier;
//   final double productMultiplier;
//   final double packagingMultiplier;

//   VehiclePricing({
//     required this.baseFare,
//     required this.distanceKm,
//     required this.distanceCost,
//     required this.weightCharge,
//     required this.addOnsTotal,
//     required this.subtotalA,
//     required this.systemServiceFee,
//     required this.ssfPercentage,
//     required this.subtotalB,
//     required this.serviceFee,
//     required this.serviceFeePercentage,
//     required this.tax,
//     required this.total,
//     required this.vehicleMultiplier,
//     required this.productMultiplier,
//     required this.packagingMultiplier,
//   });

//   factory VehiclePricing.fromJson(Map<String, dynamic> json) {
//     return VehiclePricing(
//       baseFare: (json['base_fare'] ?? 0).toDouble(),
//       distanceKm: (json['distance_km'] ?? 0).toDouble(),
//       distanceCost: (json['distance_cost'] ?? 0).toDouble(),
//       weightCharge: (json['weight_charge'] ?? 0).toDouble(),
//       addOnsTotal: (json['add_ons_total'] ?? 0).toDouble(),
//       subtotalA: (json['subtotal_a'] ?? 0).toDouble(),
//       systemServiceFee: (json['system_service_fee'] ?? 0).toDouble(),
//       ssfPercentage: (json['ssf_percentage'] ?? 0).toDouble(),
//       subtotalB: (json['subtotal_b'] ?? 0).toDouble(),
//       serviceFee: (json['service_fee'] ?? 0).toDouble(),
//       serviceFeePercentage: (json['service_fee_percentage'] ?? 0).toDouble(),
//       tax: (json['tax'] ?? 0).toDouble(),
//       total: (json['total'] ?? 0).toDouble(),
//       vehicleMultiplier: double.parse(json['vehicle_multiplier'].toString()),
//       productMultiplier: double.parse(json['product_multiplier'].toString()),
//       packagingMultiplier: double.parse(json['packaging_multiplier'].toString()),
//     );
//   }

//   // ✅ ADD THIS toJson() METHOD
//   Map<String, dynamic> toJson() {
//     return {
//       'base_fare': baseFare,
//       'distance_km': distanceKm,
//       'distance_cost': distanceCost,
//       'weight_charge': weightCharge,
//       'add_ons_total': addOnsTotal,
//       'subtotal_a': subtotalA,
//       'system_service_fee': systemServiceFee,
//       'ssf_percentage': ssfPercentage,
//       'subtotal_b': subtotalB,
//       'service_fee': serviceFee,
//       'service_fee_percentage': serviceFeePercentage,
//       'tax': tax,
//       'total': total,
//       'vehicle_multiplier': vehicleMultiplier,
//       'product_multiplier': productMultiplier,
//       'packaging_multiplier': packagingMultiplier,
//     };
//   }
// }


// class VehicleCompany {
//   final int id;
//   final String name;

//   VehicleCompany({
//     required this.id,
//     required this.name,
//   });

//   factory VehicleCompany.fromJson(Map<String, dynamic> json) {
//     return VehicleCompany(
//       id: json['id'],
//       name: json['name'],
//     );
//   }

//   // ✅ ADD THIS
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }


// class VehicleDriver {
//   final int id;
//   final String name;
//   final double rating;

//   VehicleDriver({
//     required this.id,
//     required this.name,
//     required this.rating,
//   });

//   factory VehicleDriver.fromJson(Map<String, dynamic> json) {
//     return VehicleDriver(
//       id: json['id'],
//       name: json['name'],
//       rating: double.parse(json['rating'].toString()),
//     );
//   }

//   // ✅ ADD THIS
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'rating': rating,
//     };
//   }
// }