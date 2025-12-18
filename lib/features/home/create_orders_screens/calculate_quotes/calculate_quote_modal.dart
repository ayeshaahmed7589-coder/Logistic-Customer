// Standard Quote Request Model
class StandardQuoteRequest {
  final int productTypeId;
  final int packagingTypeId;
  final double totalWeightKg;
  final String pickupCity;
  final String pickupState;
  final String deliveryCity;
  final String deliveryState;
  final String serviceType;
  final double declaredValue;
  final List<String> addOns;
  final double? length;
  final double? width;
  final double? height;

  StandardQuoteRequest({
    required this.productTypeId,
    required this.packagingTypeId,
    required this.totalWeightKg,
    required this.pickupCity,
    required this.pickupState,
    required this.deliveryCity,
    required this.deliveryState,
    required this.serviceType,
    required this.declaredValue,
    required this.addOns,
    this.length,
    this.width,
    this.height,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_type_id'] = productTypeId;
    data['packaging_type_id'] = packagingTypeId;
    data['total_weight_kg'] = totalWeightKg;
    data['pickup_city'] = pickupCity;
    data['pickup_state'] = pickupState;
    data['delivery_city'] = deliveryCity;
    data['delivery_state'] = deliveryState;
    data['service_type'] = serviceType;
    data['declared_value'] = declaredValue;
    data['add_ons'] = addOns;
    
    if (length != null) data['length'] = length;
    if (width != null) data['width'] = width;
    if (height != null) data['height'] = height;
    
    return data;
  }
}

// Multi-Stop Quote Request Model
class MultiStopQuoteRequest {
  final int productTypeId;
  final int packagingTypeId;
  final double totalWeightKg;
  final bool isMultiStop;
  final List<StopRequest> stops;
  final String serviceType;
  final double declaredValue;
  final List<String> addOns;

  MultiStopQuoteRequest({
    required this.productTypeId,
    required this.packagingTypeId,
    required this.totalWeightKg,
    required this.isMultiStop,
    required this.stops,
    required this.serviceType,
    required this.declaredValue,
    required this.addOns,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_type_id'] = productTypeId;
    data['packaging_type_id'] = packagingTypeId;
    data['total_weight_kg'] = totalWeightKg;
    data['is_multi_stop'] = isMultiStop;
    data['stops'] = stops.map((stop) => stop.toJson()).toList();
    data['service_type'] = serviceType;
    data['declared_value'] = declaredValue;
    data['add_ons'] = addOns;
    
    return data;
  }
}

// Stop Request Model (for multi-stop)
class StopRequest {
  final String stopType;
  final String city;
  final String state;
  final String? contactName;
  final String? contactPhone;
  final String? address;

  StopRequest({
    required this.stopType,
    required this.city,
    required this.state,
    this.contactName,
    this.contactPhone,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'stop_type': stopType,
      'city': city,
      'state': state,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'address': address,
    };
  }
}

// Quote Response Models
class QuoteResponse {
  final bool success;
  final String message;
  final QuoteData? data;

  QuoteResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QuoteResponse.fromJson(Map<String, dynamic> json) {
    return QuoteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? QuoteData.fromJson(json['data']) : null,
    );
  }
}

class QuoteData {
  final List<Quote> quotes;
  final double? distanceKm;
  final ProductType? productType;
  final PackagingType? packagingType;
  final List<Depot> nearbyDepots;

  QuoteData({
    required this.quotes,
    this.distanceKm,
    this.productType,
    this.packagingType,
    this.nearbyDepots = const [],
  });

  factory QuoteData.fromJson(Map<String, dynamic> json) {
    final quotesList = json['quotes'] as List<dynamic>? ?? [];
    final depotsList = json['nearby_depots'] as List<dynamic>? ?? [];
    
    return QuoteData(
      quotes: quotesList.map((item) => Quote.fromJson(item)).toList(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      productType: json['product_type'] != null 
          ? ProductType.fromJson(json['product_type'])
          : null,
      packagingType: json['packaging_type'] != null
          ? PackagingType.fromJson(json['packaging_type'])
          : null,
      nearbyDepots: depotsList.map((item) => Depot.fromJson(item)).toList(),
    );
  }
}

class Quote {
  final int vehicleId;
  final String vehicleType;
  final String registrationNumber;
  final String make;
  final String model;
  final double capacityWeightKg;
  final double? capacityVolumeM3;
  final bool isExclusive;
  final String vehicleRating;
  final int depotId;
  final String depotName;
  final String depotCity;
  final double depotDistanceKm;
  final double totalScore;
  final double depotScore;
  final double distanceScore;
  final double priceScore;
  final double suitabilityScore;
  final double driverScore;
  final double matchingScore;
  final bool isPreferred;
  final double utilizationPercent;
  final Pricing pricing;
  final Company company;
  final Driver driver;

  Quote({
    required this.vehicleId,
    required this.vehicleType,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.capacityWeightKg,
    this.capacityVolumeM3,
    required this.isExclusive,
    required this.vehicleRating,
    required this.depotId,
    required this.depotName,
    required this.depotCity,
    required this.depotDistanceKm,
    required this.totalScore,
    required this.depotScore,
    required this.distanceScore,
    required this.priceScore,
    required this.suitabilityScore,
    required this.driverScore,
    required this.matchingScore,
    required this.isPreferred,
    required this.utilizationPercent,
    required this.pricing,
    required this.company,
    required this.driver,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      vehicleId: json['vehicle_id'] ?? 0,
      vehicleType: json['vehicle_type'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      capacityWeightKg: (json['capacity_weight_kg'] as num?)?.toDouble() ?? 0.0,
      capacityVolumeM3: (json['capacity_volume_m3'] as num?)?.toDouble(),
      isExclusive: json['is_exclusive'] ?? false,
      vehicleRating: json['vehicle_rating']?.toString() ?? '0.00',
      depotId: json['depot_id'] ?? 0,
      depotName: json['depot_name'] ?? '',
      depotCity: json['depot_city'] ?? '',
      depotDistanceKm: (json['depot_distance_km'] as num?)?.toDouble() ?? 0.0,
      totalScore: (json['total_score'] as num?)?.toDouble() ?? 0.0,
      depotScore: (json['depot_score'] as num?)?.toDouble() ?? 0.0,
      distanceScore: (json['distance_score'] as num?)?.toDouble() ?? 0.0,
      priceScore: (json['price_score'] as num?)?.toDouble() ?? 0.0,
      suitabilityScore: (json['suitability_score'] as num?)?.toDouble() ?? 0.0,
      driverScore: (json['driver_score'] as num?)?.toDouble() ?? 0.0,
      matchingScore: (json['matching_score'] as num?)?.toDouble() ?? 0.0,
      isPreferred: json['is_preferred'] ?? false,
      utilizationPercent: (json['utilization_percent'] as num?)?.toDouble() ?? 0.0,
      pricing: Pricing.fromJson(json['pricing'] ?? {}),
      company: Company.fromJson(json['company'] ?? {}),
      driver: Driver.fromJson(json['driver'] ?? {}),
    );
  }
}

class Pricing {
  final double baseFare;
  final double distanceKm;
  final double distanceCost;
  final double weightCharge;
  final double addOnsTotal;
  final double subtotalA;
  final double systemServiceFee;
  final double ssfPercentage;
  final double subtotalB;
  final double serviceFee;
  final double serviceFeePercentage;
  final double tax;
  final double total;
  final double vehicleMultiplier;
  final String productMultiplier;
  final String packagingMultiplier;
  final String currencySymbol;
  final Map<String, dynamic>? breakdown;

  Pricing({
    required this.baseFare,
    required this.distanceKm,
    required this.distanceCost,
    required this.weightCharge,
    required this.addOnsTotal,
    required this.subtotalA,
    required this.systemServiceFee,
    required this.ssfPercentage,
    required this.subtotalB,
    required this.serviceFee,
    required this.serviceFeePercentage,
    required this.tax,
    required this.total,
    required this.vehicleMultiplier,
    required this.productMultiplier,
    required this.packagingMultiplier,
    this.currencySymbol = 'R',
    this.breakdown,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      baseFare: (json['base_fare'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      distanceCost: (json['distance_cost'] as num?)?.toDouble() ?? 0.0,
      weightCharge: (json['weight_charge'] as num?)?.toDouble() ?? 0.0,
      addOnsTotal: (json['add_ons_total'] as num?)?.toDouble() ?? 0.0,
      subtotalA: (json['subtotal_a'] as num?)?.toDouble() ?? 0.0,
      systemServiceFee: (json['system_service_fee'] as num?)?.toDouble() ?? 0.0,
      ssfPercentage: (json['ssf_percentage'] as num?)?.toDouble() ?? 0.0,
      subtotalB: (json['subtotal_b'] as num?)?.toDouble() ?? 0.0,
      serviceFee: (json['service_fee'] as num?)?.toDouble() ?? 0.0,
      serviceFeePercentage: (json['service_fee_percentage'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      vehicleMultiplier: (json['vehicle_multiplier'] as num?)?.toDouble() ?? 1.0,
      productMultiplier: json['product_multiplier']?.toString() ?? '1.0',
      packagingMultiplier: json['packaging_multiplier']?.toString() ?? '1.0',
      breakdown: json['breakdown'] as Map<String, dynamic>?,
    );
  }

  // Helper getters
  double get subtotalBeforeService => subtotalA;
  double get taxPercentage => (tax > 0 && subtotalB > 0) ? (tax / subtotalB * 100) : 0.0;
}

class Company {
  final int id;
  final String name;

  Company({
    required this.id,
    required this.name,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Driver {
  final int id;
  final String name;
  final String rating;

  Driver({
    required this.id,
    required this.name,
    required this.rating,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      rating: json['rating']?.toString() ?? '0.0',
    );
  }
}

class ProductType {
  final int id;
  final String name;
  final String category;
  final double? valueMultiplier;

  ProductType({
    required this.id,
    required this.name,
    required this.category,
    this.valueMultiplier,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      valueMultiplier: (json['value_multiplier'] as num?)?.toDouble(),
    );
  }
}

class PackagingType {
  final int id;
  final String name;
  final String handlingMultiplier;

  PackagingType({
    required this.id,
    required this.name,
    required this.handlingMultiplier,
  });

  factory PackagingType.fromJson(Map<String, dynamic> json) {
    return PackagingType(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      handlingMultiplier: json['handling_multiplier']?.toString() ?? '1.0',
    );
  }
}

class Depot {
  final int id;
  final String name;
  final String city;
  final double distanceKm;
  final int vehicleCount;

  Depot({
    required this.id,
    required this.name,
    required this.city,
    required this.distanceKm,
    required this.vehicleCount,
  });

  factory Depot.fromJson(Map<String, dynamic> json) {
    return Depot(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 0.0,
      vehicleCount: json['vehicle_count'] ?? 0,
    );
  }
}