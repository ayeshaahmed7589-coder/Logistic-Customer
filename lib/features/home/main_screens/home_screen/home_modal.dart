class DashboardModel {
  final bool success;
  final DashboardData? data;

  DashboardModel({required this.success, required this.data});

factory DashboardModel.fromJson(Map<String, dynamic> json) {
  final rawData = json["data"];

  return DashboardModel(
    success: json["success"] ?? false,
    data: rawData is Map<String, dynamic>
        ? DashboardData.fromJson(rawData)
        : DashboardData.fromJson({}), // prevent crash
  );
}

}

class DashboardData {
  final CustomerInfo customerInfo;
  final num walletBalance;
  final DashboardStats stats;
  final List<dynamic> activeOrders;
  final List<dynamic> recentOrders;

  DashboardData({
    required this.customerInfo,
    required this.walletBalance,
    required this.stats,
    required this.activeOrders,
    required this.recentOrders,
  });

factory DashboardData.fromJson(Map<String, dynamic> json) {
  return DashboardData(
    customerInfo: json["customer_info"] is Map<String, dynamic>
        ? CustomerInfo.fromJson(json["customer_info"])
        : CustomerInfo.fromJson({}),

    walletBalance: json["wallet_balance"] ?? 0,

    stats: json["stats"] is Map<String, dynamic>
        ? DashboardStats.fromJson(json["stats"])
        : DashboardStats.fromJson({}),

    activeOrders: json["active_orders"] is List
        ? json["active_orders"]
        : [],

    recentOrders: json["recent_orders"] is List
        ? json["recent_orders"]
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
  final num totalSpent;

  DashboardStats({
    required this.totalOrders,
    required this.activeOrders,
    required this.completedOrders,
    required this.totalSpent,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalOrders: json["total_orders"] ?? 0,
      activeOrders: json["active_orders"] ?? 0,
      completedOrders: json["completed_orders"] ?? 0,
      totalSpent: json["total_spent"] ?? 0,
    );
  }
}
