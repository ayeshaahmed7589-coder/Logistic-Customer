// ✅ STANDARD QUOTE REQUEST
// ✅ STANDARD QUOTE REQUEST
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/common_modal.dart';

// ✅ STANDARD QUOTE REQUEST
// ✅ MULTI-STOP STOP REQUEST
// ✅ MULTI-STOP QUOTE REQUEST
// ✅ QUOTE RESPONSE MODELS


// ✅ STANDARD QUOTE REQUEST
class StandardQuoteRequest {
  final int productTypeId;
  final int packagingTypeId;
  final int? quantity;
  final double? weight;
  final bool isMultiStop;
  final String pickupAddress;
  final double pickupLatitude;
  final double pickupLongitude;
  final String pickupCity;
  final String pickupState;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String deliveryCity;
  final String deliveryState;
  final String serviceType;
  final List<String>? addOns;
  final double? declaredValue;
  final double? length;
  final double? width;
  final double? height;

  StandardQuoteRequest({
    required this.productTypeId,
    required this.packagingTypeId,
    this.quantity,
    this.weight,
    this.isMultiStop = false,
    required this.pickupAddress,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupCity,
    required this.pickupState,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    required this.deliveryCity,
    required this.deliveryState,
    required this.serviceType,
    this.addOns,
    this.declaredValue,
    this.length,
    this.width,
    this.height,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'product_type_id': productTypeId,
      'packaging_type_id': packagingTypeId,
      'quantity': quantity,
      'weight': weight,
      'is_multi_stop': isMultiStop,
      'pickup_address': pickupAddress,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'pickup_city': pickupCity,
      'pickup_state': pickupState,
      'delivery_address': deliveryAddress,
      'delivery_latitude': deliveryLatitude,
      'delivery_longitude': deliveryLongitude,
      'delivery_city': deliveryCity,
      'delivery_state': deliveryState,
      'service_type': serviceType,
    };

    if (addOns != null && addOns!.isNotEmpty) {
      map['add_ons'] = addOns;
    }
    
    if (declaredValue != null && declaredValue! > 0) {
      map['declared_value'] = declaredValue;
    }
    
    if (length != null) map['length'] = length;
    if (width != null) map['width'] = width;
    if (height != null) map['height'] = height;

    return map;
  }
}

// ✅ MULTI-STOP STOP REQUEST
class StopRequest {
  final int sequenceNumber;
  final String stopType;
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

  StopRequest({
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

// ✅ MULTI-STOP QUOTE REQUEST
class MultiStopQuoteRequest {
  final int productTypeId;
  final int packagingTypeId;
  final bool isMultiStop;
  final List<StopRequest> stops;
  final String serviceType;
  final List<String>? addOns;
  final double? declaredValue;
  final int? quantity;
  final double? weight;

  MultiStopQuoteRequest({
    required this.productTypeId,
    required this.packagingTypeId,
    this.isMultiStop = true,
    required this.stops,
    required this.serviceType,
    this.addOns,
    this.declaredValue,
    this.quantity,
    this.weight,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'product_type_id': productTypeId,
      'packaging_type_id': packagingTypeId,
      'is_multi_stop': isMultiStop,
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'service_type': serviceType,
    };

    if (addOns != null && addOns!.isNotEmpty) {
      map['add_ons'] = addOns;
    }
    
    if (declaredValue != null && declaredValue! > 0) {
      map['declared_value'] = declaredValue;
    }
    
    if (quantity != null && quantity! > 0) {
      map['quantity'] = quantity;
    }
    
    if (weight != null && weight! > 0) {
      map['weight'] = weight;
    }

    return map;
  }
}

// ✅ QUOTE RESPONSE MODELS
class QuoteData {
  final ProductType? productType;
  final PackagingType? packagingType;
  final bool isMultiStop;
  final int? stopsCount;
  final int? quantity;
  final double baseWeightKg;
  final double stopsWeightKg;
  final double totalWeightKg;
  final double? distanceKm;
  final String serviceType;
  final List<CompatibleVehicle> compatibleVehicles;
  final List<NearbyDepot> nearbyDepots;

  QuoteData({
    this.productType,
    this.packagingType,
    required this.isMultiStop,
    this.stopsCount,
    this.quantity,
    required this.baseWeightKg,
    required this.stopsWeightKg,
    required this.totalWeightKg,
    this.distanceKm,
    required this.serviceType,
    required this.compatibleVehicles,
    required this.nearbyDepots,
  });

  // Get quotes list
  List<Quote> get quotes {
    return compatibleVehicles
        .map((vehicle) => Quote.fromCompatibleVehicle(vehicle))
        .toList();
  }

  factory QuoteData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    
    return QuoteData(
      productType: data['product_type'] != null 
          ? ProductType.fromJson(data['product_type'])
          : null,
      packagingType: data['packaging_type'] != null 
          ? PackagingType.fromJson(data['packaging_type'])
          : null,
      isMultiStop: data['is_multi_stop'] ?? false,
      stopsCount: data['stops_count'],
      quantity: data['quantity'],
      baseWeightKg: (data['base_weight_kg'] ?? 0).toDouble(),
      stopsWeightKg: (data['stops_weight_kg'] ?? 0).toDouble(),
      totalWeightKg: (data['total_weight_kg'] ?? 0).toDouble(),
      distanceKm: data['distance_km'] != null ? data['distance_km'].toDouble() : null,
      serviceType: data['service_type'] ?? 'standard',
      compatibleVehicles: (data['compatible_vehicles'] as List)
          .map((vehicle) => CompatibleVehicle.fromJson(vehicle))
          .toList(),
      nearbyDepots: (data['nearby_depots'] as List)
          .map((depot) => NearbyDepot.fromJson(depot))
          .toList(),
    );
  }
}

class ProductType {
  final int id;
  final String name;
  final String category;

  ProductType({
    required this.id,
    required this.name,
    required this.category,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'],
      name: json['name'],
      category: json['category'],
    );
  }
}

class PackagingType {
  final int id;
  final String name;
  final double fixedWeightKg;

  PackagingType({
    required this.id,
    required this.name,
    required this.fixedWeightKg,
  });

  factory PackagingType.fromJson(Map<String, dynamic> json) {
    return PackagingType(
      id: json['id'],
      name: json['name'],
      fixedWeightKg: double.parse(json['fixed_weight_kg'].toString()),
    );
  }
}

class NearbyDepot {
  final int id;
  final String name;
  final String city;
  final double distanceKm;
  final int vehicleCount;

  NearbyDepot({
    required this.id,
    required this.name,
    required this.city,
    required this.distanceKm,
    required this.vehicleCount,
  });

  factory NearbyDepot.fromJson(Map<String, dynamic> json) {
    return NearbyDepot(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      distanceKm: (json['distance_km'] ?? 0).toDouble(),
      vehicleCount: json['vehicle_count'] ?? 0,
    );
  }
}


// class CompatibleVehicle {
//   final int vehicleId;
//   final int vehicleTypeId;
//   final String vehicleTypeName;
//   final String registrationNumber;
//   final String make;
//   final String model;
//   final double capacityKg;
//   final double capacityVolumeM3;
//   final double totalScore;
//   final double matchingScore;
//   final int depotScore;
//   final int distanceScore;
//   final int priceScore;
//   final int suitabilityScore;
//   final int driverScore;
//   final int depotId;
//   final String depotName;
//   final String depotCity;
//   final double depotDistanceKm;
//   final bool isExclusive;
//   final double utilizationPercent;
//   final VehiclePricing pricing;
//   final VehicleCompany company;
//   final VehicleDriver driver;

//   CompatibleVehicle({
//     required this.vehicleId,
//     required this.vehicleTypeId,
//     required this.vehicleTypeName,
//     required this.registrationNumber,
//     required this.make,
//     required this.model,
//     required this.capacityKg,
//     required this.capacityVolumeM3,
//     required this.totalScore,
//     required this.matchingScore,
//     required this.depotScore,
//     required this.distanceScore,
//     required this.priceScore,
//     required this.suitabilityScore,
//     required this.driverScore,
//     required this.depotId,
//     required this.depotName,
//     required this.depotCity,
//     required this.depotDistanceKm,
//     required this.isExclusive,
//     required this.utilizationPercent,
//     required this.pricing,
//     required this.company,
//     required this.driver,
//   });

//   factory CompatibleVehicle.fromJson(Map<String, dynamic> json) {
//     return CompatibleVehicle(
//       vehicleId: json['vehicle_id'],
//       vehicleTypeId: json['vehicle_type_id'],
//       vehicleTypeName: json['vehicle_type_name'],
//       registrationNumber: json['registration_number'],
//       make: json['make'],
//       model: json['model'],
//       capacityKg: double.parse(json['capacity_kg'].toString()),
//       capacityVolumeM3: double.parse(json['capacity_volume_m3'].toString()),
//       totalScore: (json['total_score'] ?? 0).toDouble(),
//       matchingScore: (json['matching_score'] ?? 0).toDouble(),
//       depotScore: json['depot_score'] ?? 0,
//       distanceScore: json['distance_score'] ?? 0,
//       priceScore: json['price_score'] ?? 0,
//       suitabilityScore: json['suitability_score'] ?? 0,
//       driverScore: json['driver_score'] ?? 0,
//       depotId: json['depot_id'],
//       depotName: json['depot_name'],
//       depotCity: json['depot_city'],
//       depotDistanceKm: (json['depot_distance_km'] ?? 0).toDouble(),
//       isExclusive: json['is_exclusive'] ?? false,
//       utilizationPercent: (json['utilization_percent'] ?? 0).toDouble(),
//       pricing: VehiclePricing.fromJson(json['pricing']),
//       company: VehicleCompany.fromJson(json['company']),
//       driver: VehicleDriver.fromJson(json['driver']),
//     );
//   }
// }



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
// }




// ✅ Simplified Quote model for UI
// class Quote {
//   final int vehicleId;
//   final int vehicleTypeId; // ✅ ADD THIS FIELD
//   final String vehicleType;
//   final String registrationNumber;
//   final String make;
//   final String model;
//   final double capacityWeightKg;
//   final double totalScore;
//   final double matchingScore;
//   final int depotScore;
//   final int distanceScore;
//   final int priceScore;
//   final int suitabilityScore;
//   final int driverScore;
//   final int depotId;
//   final String depotName;
//   final String depotCity;
//   final double depotDistanceKm;
//   final bool isExclusive;
//   final double utilizationPercent;
//   final VehiclePricing pricing;
//   final VehicleCompany company;
//   final VehicleDriver driver;

//   Quote({
//     required this.vehicleId,
//     required this.vehicleTypeId, // ✅ ADD THIS PARAMETER
//     required this.vehicleType,
//     required this.registrationNumber,
//     required this.make,
//     required this.model,
//     required this.capacityWeightKg,
//     required this.totalScore,
//     required this.matchingScore,
//     required this.depotScore,
//     required this.distanceScore,
//     required this.priceScore,
//     required this.suitabilityScore,
//     required this.driverScore,
//     required this.depotId,
//     required this.depotName,
//     required this.depotCity,
//     required this.depotDistanceKm,
//     required this.isExclusive,
//     required this.utilizationPercent,
//     required this.pricing,
//     required this.company,
//     required this.driver,
//   });

//   factory Quote.fromCompatibleVehicle(CompatibleVehicle vehicle) {
//     return Quote(
//       vehicleId: vehicle.vehicleId,
//       vehicleTypeId: vehicle.vehicleTypeId, // ✅ ADD THIS
//       vehicleType: vehicle.vehicleTypeName,
//       registrationNumber: vehicle.registrationNumber,
//       make: vehicle.make,
//       model: vehicle.model,
//       capacityWeightKg: vehicle.capacityKg,
//       totalScore: vehicle.totalScore,
//       matchingScore: vehicle.matchingScore,
//       depotScore: vehicle.depotScore,
//       distanceScore: vehicle.distanceScore,
//       priceScore: vehicle.priceScore,
//       suitabilityScore: vehicle.suitabilityScore,
//       driverScore: vehicle.driverScore,
//       depotId: vehicle.depotId,
//       depotName: vehicle.depotName,
//       depotCity: vehicle.depotCity,
//       depotDistanceKm: vehicle.depotDistanceKm,
//       isExclusive: vehicle.isExclusive,
//       utilizationPercent: vehicle.utilizationPercent,
//       pricing: vehicle.pricing,
//       company: vehicle.company,
//       driver: vehicle.driver,
//     );
//   }
// }

