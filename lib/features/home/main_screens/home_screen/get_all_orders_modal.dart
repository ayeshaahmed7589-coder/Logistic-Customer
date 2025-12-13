// lib/features/orders/models/get_all_orders_modal.dart

class GetOrderResponse {
  final bool success;
  final String message;
  final OrderData data;
  final Meta meta;

  GetOrderResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory GetOrderResponse.fromJson(Map<String, dynamic> json) {
    return GetOrderResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderData.fromJson(json['data'] as Map<String, dynamic>),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'meta': meta.toJson(),
    };
  }
}

class OrderData {
  final List<Order> orders;

  OrderData({
    required this.orders,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    final ordersList = json['orders'] as List<dynamic>;
    return OrderData(
      orders: ordersList.map((order) => Order.fromJson(order)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }
}

class Order {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final String status;
  final int isMultiStop;
  final String? productType;
  final String? packagingType;
  final String? totalWeightKg;
  final String pickupCity;
  final String deliveryCity;
  final String? distanceKm;
  final String? finalCost;
  final int? matchingScore;
  final Vehicle vehicle;
  final Driver driver;
  final String createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.isMultiStop,
    this.productType,
    this.packagingType,
    this.totalWeightKg,
    required this.pickupCity,
    required this.deliveryCity,
    this.distanceKm,
    this.finalCost,
    this.matchingScore,
    required this.vehicle,
    required this.driver,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      trackingCode: json['tracking_code'] as String,
      status: json['status'] as String,
      isMultiStop: json['is_multi_stop'] as int,
      productType: json['product_type'] as String?,
      packagingType: json['packaging_type'] as String?,
      totalWeightKg: json['total_weight_kg'] as String?,
      pickupCity: json['pickup_city'] as String,
      deliveryCity: json['delivery_city'] as String,
      distanceKm: json['distance_km'] as String?,
      finalCost: json['final_cost'] as String?,
      matchingScore: json['matching_score'] as int?,
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      driver: Driver.fromJson(json['driver'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'tracking_code': trackingCode,
      'status': status,
      'is_multi_stop': isMultiStop,
      'product_type': productType,
      'packaging_type': packagingType,
      'total_weight_kg': totalWeightKg,
      'pickup_city': pickupCity,
      'delivery_city': deliveryCity,
      'distance_km': distanceKm,
      'final_cost': finalCost,
      'matching_score': matchingScore,
      'vehicle': vehicle.toJson(),
      'driver': driver.toJson(),
      'created_at': createdAt,
    };
  }

  // Helper method for status color
  String get statusColor {
    switch (status) {
      case 'completed':
        return 'green';
      case 'assigned':
        return 'blue';
      case 'pending':
        return 'orange';
      case 'in_transit':
        return 'purple';
      default:
        return 'gray';
    }
  }

  // Helper method for status text
  String get statusText {
    switch (status) {
      case 'completed':
        return 'Delivered';
      case 'assigned':
        return 'Assigned';
      case 'pending':
        return 'Pending';
      case 'in_transit':
        return 'In Transit';
      default:
        return status;
    }
  }

  // Check if order is active
  bool get isActive => status != 'completed';
}

class Vehicle {
  final String registrationNumber;
  final String vehicleType;

  Vehicle({
    required this.registrationNumber,
    required this.vehicleType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      registrationNumber: json['registration_number'] as String,
      vehicleType: json['vehicle_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_number': registrationNumber,
      'vehicle_type': vehicleType,
    };
  }
}

class Driver {
  final String name;
  final String? phone;
  final String rating;

  Driver({
    required this.name,
    this.phone,
    required this.rating,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json['name'] as String,
      phone: json['phone'] as String?,
      rating: json['rating'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'rating': rating,
    };
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}