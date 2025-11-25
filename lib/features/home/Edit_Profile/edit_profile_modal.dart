class UpdateProfileModel {
  final User user;
  final Customer customer;
  final bool success;
  final String? message;

  UpdateProfileModel({
    required this.success,
    required this.user,
    required this.customer,
    this.message,
  });

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileModel(
      success: json["success"] ?? false,
      message: json["message"],
      user: User.fromJson(json["data"]["user"]),
      customer: Customer.fromJson(json["data"]["customer"]),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    phone: json["phone"] ?? "",
    role: json["role"] ?? "",
  );
}

class Customer {
  final String? dateOfBirth;
  final String? profilePhoto;
  final String? city;
  final String? state;

  Customer({this.dateOfBirth, this.profilePhoto, this.city, this.state});

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    dateOfBirth: json["date_of_birth"],
    profilePhoto: json["profile_photo"],
    city: json["city"],
    state: json["state"],
  );
}
