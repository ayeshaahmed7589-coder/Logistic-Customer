class DashboardModel {
  final bool success;
  final String message;
  final DashboardData data;

  DashboardModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] is Map<String, dynamic>
          ? DashboardData.fromJson(json["data"])
          : DashboardData.fromJson({}),
    );
  }
}

class DashboardData {
  final CustomerInfo customerInfo;
  final DashboardStats stats;
  final List<ActiveOrder> activeOrders;
  final List<RecentOrder> recentOrders;

  DashboardData({
    required this.customerInfo,
    required this.stats,
    required this.activeOrders,
    required this.recentOrders,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      customerInfo: json["customer_info"] is Map<String, dynamic>
          ? CustomerInfo.fromJson(json["customer_info"])
          : CustomerInfo.fromJson({}),
      stats: json["stats"] is Map<String, dynamic>
          ? DashboardStats.fromJson(json["stats"])
          : DashboardStats.fromJson({}),
      activeOrders: json["active_orders"] is List
          ? List<ActiveOrder>.from(
              json["active_orders"].map((x) => ActiveOrder.fromJson(x)),
            )
          : [],
      recentOrders: json["recent_orders"] is List
          ? List<RecentOrder>.from(
              json["recent_orders"].map((x) => RecentOrder.fromJson(x)),
            )
          : [],
    );
  }
}

class CustomerInfo {
  final String name;
  final String email;
  final String phone;
  final String city;
  final String state;
  final String profilePhoto;

  CustomerInfo({
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.state,
    required this.profilePhoto,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      profilePhoto: json["profile_photo"] ?? "",
    );
  }
}

class DashboardStats {
  final num totalOrders;
  final num activeOrders;
  final num completedOrders;
  final num cancelledOrders;
  final num totalSpent;
  final dynamic averageRating;

  DashboardStats({
    required this.totalOrders,
    required this.activeOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.totalSpent,
    required this.averageRating,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalOrders: json["total_orders"] ?? 0,
      activeOrders: json["active_orders"] ?? 0,
      completedOrders: json["completed_orders"] ?? 0,
      cancelledOrders: json["cancelled_orders"] ?? 0,
      totalSpent: json["total_spent"] ?? 0,
      averageRating: json["average_rating"],
    );
  }
}

class ActiveOrder {
  final int id;
  final String orderNumber;
  final String trackingCode;
  final String status;
  final String pickupCity;
  final String deliveryCity;
  final String finalCost;
  final DateTime createdAt;

  ActiveOrder({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.pickupCity,
    required this.deliveryCity,
    required this.finalCost,
    required this.createdAt,
  });

  factory ActiveOrder.fromJson(Map<String, dynamic> json) {
    return ActiveOrder(
      id: json["id"] ?? 0,
      orderNumber: json["order_number"] ?? "",
      trackingCode: json["tracking_code"] ?? "",
      status: json["status"] ?? "",
      pickupCity: json["pickup_city"] ?? "",
      deliveryCity: json["delivery_city"] ?? "",
      finalCost: json["final_cost"] ?? "0.00",
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
    );
  }
}

class RecentOrder {
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
  final DateTime createdAt;

  RecentOrder({
    required this.id,
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.isMultiStop,
    required this.productType,
    required this.packagingType,
    required this.totalWeightKg,
    required this.pickupCity,
    required this.deliveryCity,
    required this.distanceKm,
    required this.finalCost,
    required this.matchingScore,
    required this.vehicle,
    required this.driver,
    required this.createdAt,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: json["id"] ?? 0,
      orderNumber: json["order_number"] ?? "",
      trackingCode: json["tracking_code"] ?? "",
      status: json["status"] ?? "",
      isMultiStop: json["is_multi_stop"] ?? 0,
      productType: json["product_type"],
      packagingType: json["packaging_type"],
      totalWeightKg: json["total_weight_kg"],
      pickupCity: json["pickup_city"] ?? "",
      deliveryCity: json["delivery_city"] ?? "",
      distanceKm: json["distance_km"],
      finalCost: json["final_cost"],
      matchingScore: json["matching_score"],
      vehicle: json["vehicle"] is Map<String, dynamic>
          ? Vehicle.fromJson(json["vehicle"])
          : Vehicle.fromJson({}),
      driver: json["driver"] is Map<String, dynamic>
          ? Driver.fromJson(json["driver"])
          : Driver.fromJson({}),
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
    );
  }
}

class Vehicle {
  final String registrationNumber;
  final String vehicleType;

  Vehicle({required this.registrationNumber, required this.vehicleType});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      registrationNumber: json["registration_number"] ?? "",
      vehicleType: json["vehicle_type"] ?? "",
    );
  }
}

class Driver {
  final String name;
  final String? phone;
  final String rating;

  Driver({required this.name, required this.phone, required this.rating});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json["name"] ?? "",
      phone: json["phone"],
      rating: json["rating"] ?? "0.00",
    );
  }
}



// class DashboardModel {
//   final bool success;
//   final DashboardData data;

//   DashboardModel({required this.success, required this.data});

// factory DashboardModel.fromJson(Map<String, dynamic> json) {
//   final rawData = json["data"];

//   return DashboardModel(
//     success: json["success"] ?? false,
//     data: rawData is Map<String, dynamic>
//         ? DashboardData.fromJson(rawData)
//         : DashboardData.fromJson({}), // prevent crash
//   );
// }

// }

// class DashboardData {
//   final CustomerInfo customerInfo;
//   final num walletBalance;
//   final DashboardStats stats;
//   final List<dynamic> activeOrders;
//   final List<dynamic> recentOrders;

//   DashboardData({
//     required this.customerInfo,
//     required this.walletBalance,
//     required this.stats,
//     required this.activeOrders,
//     required this.recentOrders,
//   });

// factory DashboardData.fromJson(Map<String, dynamic> json) {
//   return DashboardData(
//     customerInfo: json["customer_info"] is Map<String, dynamic>
//         ? CustomerInfo.fromJson(json["customer_info"])
//         : CustomerInfo.fromJson({}),

//     walletBalance: json["wallet_balance"] ?? 0,

//     stats: json["stats"] is Map<String, dynamic>
//         ? DashboardStats.fromJson(json["stats"])
//         : DashboardStats.fromJson({}),

//     activeOrders: json["active_orders"] is List
//         ? json["active_orders"]
//         : [],

//     recentOrders: json["recent_orders"] is List
//         ? json["recent_orders"]
//         : [],
//   );
// }

// }

// class CustomerInfo {
//   final String name;
//   final String email;
//   final String phone;
//   final String city;
//   final String state;
//   final String profilePhoto;

//   CustomerInfo({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.city,
//     required this.state,
//     required this.profilePhoto,
//   });

//   factory CustomerInfo.fromJson(Map<String, dynamic> json) {
//     return CustomerInfo(
//       name: json["name"] ?? "",
//       email: json["email"] ?? "",
//       phone: json["phone"] ?? "",
//       city: json["city"] ?? "",
//       state: json["state"] ?? "",
//       profilePhoto: json["profile_photo"] ?? "",
//     );
//   }
// }

// class DashboardStats {
//   final num totalOrders;
//   final num activeOrders;
//   final num completedOrders;
//   final num totalSpent;

//   DashboardStats({
//     required this.totalOrders,
//     required this.activeOrders,
//     required this.completedOrders,
//     required this.totalSpent,
//   });

//   factory DashboardStats.fromJson(Map<String, dynamic> json) {
//     return DashboardStats(
//       totalOrders: json["total_orders"] ?? 0,
//       activeOrders: json["active_orders"] ?? 0,
//       completedOrders: json["completed_orders"] ?? 0,
//       totalSpent: json["total_spent"] ?? 0,
//     );
//   }
// }
