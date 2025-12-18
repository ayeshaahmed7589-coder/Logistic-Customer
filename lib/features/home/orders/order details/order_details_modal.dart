class OrderDetailsModel {
  final bool success;
  final String message;
  final Order order;

  OrderDetailsModel({
    required this.success,
    required this.message,
    required this.order,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      order: Order.fromJson(json["data"]["order"]),
    );
  }
}

class Order {
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
  final List<Stop> stops;
  final String createdAt;
  final bool isMultiStop;

  Order({
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
    required this.stops,
    required this.createdAt,
    required this.isMultiStop,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      orderNumber: json["order_number"] ?? "",
      trackingCode: json["tracking_code"] ?? "",
      status: json["status"] ?? "",
      paymentStatus: json["payment_status"] ?? "",
      productType: ProductType.fromJson(json["product_type"]),
      packagingType: PackagingType.fromJson(json["packaging_type"]),
      vehicle: Vehicle.fromJson(json["vehicle"]),
      driver: Driver.fromJson(json["driver"]),
      pricing: Pricing.fromJson(json["pricing"]),
      items: (json["items"] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      addOns: List<String>.from(json["add_ons"] ?? []),
      stops:
          (json["stops"] as List).map((e) => Stop.fromJson(e)).toList(),
      createdAt: json["created_at"] ?? "",
      isMultiStop: json["is_multi_stop"] ?? false,
    );
  }
}

/// SUB MODELS

class ProductType {
  final String name;
  ProductType({required this.name});
  factory ProductType.fromJson(Map<String, dynamic> json) =>
      ProductType(name: json["name"] ?? "");
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
  Vehicle({required this.vehicleType, required this.registration});
  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        vehicleType: json["vehicle_type"] ?? "",
        registration: json["registration_number"] ?? "",
      );
}

class Driver {
  final String name;
  final String phone;
  Driver({required this.name, required this.phone});
  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
        name: json["name"] ?? "",
        phone: json["phone"] ?? "",
      );
}

class Pricing {
  final String finalCost;
  final String tax;
  Pricing({required this.finalCost, required this.tax});
  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        finalCost: json["final_cost"] ?? "",
        tax: json["tax_amount"] ?? "",
      );
}

class OrderItem {
  final String productName;
  final String weight;
  OrderItem({required this.productName, required this.weight});
  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json["product_name"] ?? "",
        weight: json["weight_kg"] ?? "",
      );
}

class Stop {
  final String type;
  final String city;
  final String address;
  Stop({required this.type, required this.city, required this.address});
  factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        type: json["stop_type"] ?? "",
        city: json["city"] ?? "",
        address: json["address"] ?? "",
      );
}
