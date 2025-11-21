class CreatePasswordModel {
  final bool success;
  final String message;
  final CreatePasswordData data;

  CreatePasswordModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreatePasswordModel.fromJson(Map<String, dynamic> json) {
    return CreatePasswordModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: CreatePasswordData.fromJson(json["data"] ?? {}),
    );
  }
}

class CreatePasswordData {
  final String email;
  final String verificationToken;
  final String nextStep;

  CreatePasswordData({
    required this.email,
    required this.verificationToken,
    required this.nextStep,
  });

  factory CreatePasswordData.fromJson(Map<String, dynamic> json) {
    return CreatePasswordData(
      email: json["email"] ?? "",
      verificationToken: json["verification_token"] ?? "",
      nextStep: json["next_step"] ?? "",
    );
  }
}
