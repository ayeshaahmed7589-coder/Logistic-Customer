class OrderDetailsModel {
  final bool success;
  final String message;
  final OrderDetails order;

  OrderDetailsModel({
    required this.success,
    required this.message,
    required this.order,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      order: OrderDetails.fromJson(json["data"]["order"]),
    );
  }
}

class OrderDetails {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final String status;
  final String paymentStatus;
  final ProductType productType;
  final PackagingType packagingType;
  final Vehicle vehicle;
  final Driver driver;
  final Pricing pricing;
  final List<OrderItem> items;
  final List<String> addOns;
  final String? specialInstructions;
  final Depot depot;
  final Pickup pickup;
  final Delivery delivery;
  final String createdAt;
  final String updatedAt;
  final bool isMultiStop;

  OrderDetails({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.paymentStatus,
    required this.productType,
    required this.packagingType,
    required this.vehicle,
    required this.driver,
    required this.pricing,
    required this.items,
    required this.addOns,
    required this.specialInstructions,
    required this.depot,
    required this.pickup,
    required this.delivery,
    required this.createdAt,
    required this.updatedAt,
    required this.isMultiStop,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      id: json["id"] ?? 0,
      orderNumber: json["order_number"] ?? "",
      trackingCode: json["tracking_code"] ?? "",
      status: json["status"] ?? "",
      paymentStatus: json["payment_status"] ?? "",
      productType: ProductType.fromJson(json["product_type"] ?? {}),
      packagingType: PackagingType.fromJson(json["packaging_type"] ?? {}),
      vehicle: Vehicle.fromJson(json["vehicle"] ?? {}),
      driver: Driver.fromJson(json["driver"] ?? {}),
      pricing: Pricing.fromJson(json["pricing"] ?? {}),
      items: (json["items"] as List? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      addOns: List<String>.from(json["add_ons"] ?? []),
      specialInstructions: json["special_instructions"],
      depot: Depot.fromJson(json["depot"] ?? {}),
      pickup: Pickup.fromJson(json["pickup"] ?? {}),
      delivery: Delivery.fromJson(json["delivery"] ?? {}),
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      isMultiStop: json["is_multi_stop"] ?? false,
    );
  }
}

/// Sub Models

class ProductType {
  final String name;
  final String category;
  ProductType({required this.name, required this.category});
  factory ProductType.fromJson(Map<String, dynamic> json) =>
      ProductType(name: json["name"] ?? "", category: json["category"] ?? "");
}

class PackagingType {
  final String name;
  PackagingType({required this.name});
  factory PackagingType.fromJson(Map<String, dynamic> json) =>
      PackagingType(name: json["name"] ?? "");
}

class Vehicle {
  final String vehicleType;
  final String registration;
  final String make;
  final String model;
  final String? currentLatitude;
  final String? currentLongitude;

  Vehicle({
    required this.vehicleType,
    required this.registration,
    required this.make,
    required this.model,
    this.currentLatitude,
    this.currentLongitude,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
    vehicleType: json["vehicle_type"] ?? "",
    registration: json["registration_number"] ?? "",
    make: json["make"] ?? "",
    model: json["model"] ?? "",
    currentLatitude: json["current_latitude"]?.toString(),
    currentLongitude: json["current_longitude"]?.toString(),
  );
}

class Driver {
  final String name;
  final String phone;
  final String rating;

  Driver({required this.name, required this.phone, required this.rating});

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
    name: json["name"] ?? "",
    phone: json["phone"] ?? "",
    rating: json["rating"] ?? "",
  );
}

class Pricing {
  final String distanceKm;
  final String estimatedCost;
  final String finalCost;
  final String taxAmount;
  final String systemServiceFee;
  final String addOnsCost;
  final int discount;

  Pricing({
    required this.distanceKm,
    required this.estimatedCost,
    required this.finalCost,
    required this.taxAmount,
    required this.systemServiceFee,
    required this.addOnsCost,
    required this.discount,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
    distanceKm: json["distance_km"]?.toString() ?? "0",
    estimatedCost: json["estimated_cost"] ?? "0",
    finalCost: json["final_cost"] ?? "0",
    taxAmount: json["tax_amount"] ?? "0",
    systemServiceFee: json["system_service_fee"] ?? "0",
    addOnsCost: json["add_ons_cost"] ?? "0",
    discount: json["discount"] ?? 0,
  );
}

class OrderItem {
  final String productName;
  final String description;
  final String weight;
  final String declaredValue;
  final int quantity;

  OrderItem({
    required this.productName,
    required this.description,
    required this.weight,
    required this.declaredValue,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    productName: json["product_name"] ?? "",
    description: json["description"] ?? "",
    weight: json["weight_kg"] ?? "",
    declaredValue: json["declared_value"] ?? "",
    quantity: json["quantity"] ?? 0,
  );
}

class Depot {
  final String name;
  final String city;
  final String address;

  Depot({required this.name, required this.city, required this.address});

  factory Depot.fromJson(Map<String, dynamic> json) => Depot(
    name: json["name"] ?? "",
    city: json["city"] ?? "",
    address: json["address"] ?? "",
  );
}

class Pickup {
  final String contactName;
  final String contactPhone;
  final String address;
  final String city;
  final String state;
  final String? latitude;
  final String? longitude;

  Pickup({
    required this.contactName,
    required this.contactPhone,
    required this.address,
    required this.city,
    required this.state,
    this.latitude,
    this.longitude,
  });

  factory Pickup.fromJson(Map<String, dynamic> json) => Pickup(
    contactName: json["contact_name"] ?? "",
    contactPhone: json["contact_phone"] ?? "",
    address: json["address"] ?? "",
    city: json["city"] ?? "",
    state: json["state"] ?? "",
    latitude: json["latitude"]?.toString(),
    longitude: json["longitude"]?.toString(),
  );
}

class Delivery {
  final String contactName;
  final String contactPhone;
  final String address;
  final String city;
  final String state;
  final String? latitude;
  final String? longitude;

  Delivery({
    required this.contactName,
    required this.contactPhone,
    required this.address,
    required this.city,
    required this.state,
    this.latitude,
    this.longitude,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    contactName: json["contact_name"] ?? "",
    contactPhone: json["contact_phone"] ?? "",
    address: json["address"] ?? "",
    city: json["city"] ?? "",
    state: json["state"] ?? "",
    latitude: json["latitude"]?.toString(),
    longitude: json["longitude"]?.toString(),
  );
}
