class SetUpProfileModel {
  final String message;
  final bool success;

  SetUpProfileModel({required this.message, required this.success});

  factory SetUpProfileModel.fromJson(Map<String, dynamic> json) {
    return SetUpProfileModel(
      message: json['message'] ?? "",
      success: json['success'] ?? false,
    );
  }
}
