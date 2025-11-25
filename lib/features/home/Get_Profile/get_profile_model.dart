class GetProfileModel {
  final bool success;
  final ProfileData data;

  GetProfileModel({
    required this.success,
    required this.data,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) {
    return GetProfileModel(
      success: json["success"] ?? false,
      data: ProfileData.fromJson(json["data"]),
    );
  }
}

class ProfileData {
  final User user;
  final Customer customer;

  ProfileData({
    required this.user,
    required this.customer,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json["user"]),
      customer: Customer.fromJson(json["customer"]),
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
  final String? emailVerifiedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    this.emailVerifiedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",
      status: json["status"] ?? "",
      emailVerifiedAt: json["email_verified_at"],
    );
  }
}

class Customer {
  final int id;
  final String? customerType;
  final String? dateOfBirth;
  final String? profilePhoto;
  final int totalOrders;
  final String? city;
  final String? state;
  final String? country;

  Customer({
    required this.id,
    this.customerType,
    this.dateOfBirth,
    this.profilePhoto,
    required this.totalOrders,
    this.city,
    this.state,
    this.country,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"] ?? 0,
      customerType: json["customer_type"],
      dateOfBirth: json["date_of_birth"],
      profilePhoto: json["profile_photo"],
      totalOrders: json["total_orders"] ?? 0,
      city: json["city"],
      state: json["state"],
      country: json["country"],
    );
  }
}
