import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/fetch_order/common_modal.dart';

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
      distanceKm: data['distance_km'] != null
          ? data['distance_km'].toDouble()
          : null,
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

  ProductType({required this.id, required this.name, required this.category});

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
