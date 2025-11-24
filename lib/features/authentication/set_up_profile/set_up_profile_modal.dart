class SetUpProfileModel {
  final bool success;
  final String message;
  final ProfileData? data;

  SetUpProfileModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory SetUpProfileModel.fromJson(Map<String, dynamic> json) {
    return SetUpProfileModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "",
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final User user;
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  ProfileData({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: User.fromJson(json['user']),
      accessToken: json['access_token'] ?? "",
      tokenType: json['token_type'] ?? "",
      expiresIn: json['expires_in'] ?? 0,
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
  final String? profilePhoto;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    this.profilePhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      role: json['role'] ?? "",
      status: json['status'] ?? "",
      profilePhoto: json['profile_photo'],
    );
  }
}
