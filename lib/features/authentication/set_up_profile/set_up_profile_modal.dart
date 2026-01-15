class SetUpProfileModel {
  final bool success;
  final String message;
  final ProfileData? data;

  SetUpProfileModel({required this.success, required this.message, this.data});

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

// dropdown
// company_model.dart
class CompanyResponse {
  final bool success;
  final String message;
  final CompanyData data;

  CompanyResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CompanyResponse.fromJson(Map<String, dynamic> json) {
    return CompanyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CompanyData.fromJson(json['data']),
    );
  }
}

class CompanyData {
  final List<CompanyItem> companies;
  final int total;

  CompanyData({required this.companies, required this.total});

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    final companiesList = (json['companies'] as List)
        .map((item) => CompanyItem.fromJson(item))
        .toList();

    return CompanyData(
      companies: companiesList,
      total: json['total'] ?? companiesList.length,
    );
  }

  List<CompanyItem> getAllItems() => companies;

  // Optional: Filter companies by type
  List<CompanyItem> getCompaniesByType(String type) {
    return companies.where((company) => company.type == type).toList();
  }

  // Optional: Search companies
  List<CompanyItem> searchCompanies(String query) {
    if (query.isEmpty) return companies;

    return companies
        .where(
          (company) =>
              company.name.toLowerCase().contains(query.toLowerCase()) ||
              company.type.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}

class CompanyItem {
  final int id;
  final String name;
  final String type;

  CompanyItem({required this.id, required this.name, required this.type});

  factory CompanyItem.fromJson(Map<String, dynamic> json) {
    return CompanyItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }

  bool matchesSearch(String query) {
    return name.toLowerCase().contains(query.toLowerCase()) ||
        type.toLowerCase().contains(query.toLowerCase());
  }

  @override
  String toString() => name;
}
