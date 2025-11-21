class LoginModel {
  final bool success;
  final String message;
  final LoginData data;

  LoginModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: LoginData.fromJson(json["data"] ?? {}),
    );
  }
}

class LoginData {
  final User user;
  final Customer customer;
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  LoginData({
    required this.user,
    required this.customer,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json["user"] ?? {}),
      customer: Customer.fromJson(json["customer"] ?? {}),
      accessToken: json["access_token"] ?? "",
      tokenType: json["token_type"] ?? "",
      expiresIn: json["expires_in"] ?? 0,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String lastLoginAt;
  final String? profilePhoto;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.lastLoginAt,
    required this.profilePhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",
      status: json["status"] ?? "",
      lastLoginAt: json["last_login_at"] ?? "",
      profilePhoto: json["profile_photo"],
    );
  }
}

class Customer {
  final int id;
  final String customerType;
  final int totalOrders;
  final String city;
  final String state;

  Customer({
    required this.id,
    required this.customerType,
    required this.totalOrders,
    required this.city,
    required this.state,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"] ?? 0,
      customerType: json["customer_type"] ?? "",
      totalOrders: json["total_orders"] ?? 0,
      city: json["city"] ?? "",
      state: json["state"] ?? "",
    );
  }
}
