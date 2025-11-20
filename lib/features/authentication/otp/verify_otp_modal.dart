class VerifyOtpModel {
  final bool success;
  final String message;
  final String email;
  final String verificationToken;
  final int tokenExpiresIn;

  VerifyOtpModel({
    required this.success,
    required this.message,
    required this.email,
    required this.verificationToken,
    required this.tokenExpiresIn,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      email: json["data"]["email"] ?? "",
      verificationToken: json["data"]["verification_token"] ?? "",
      tokenExpiresIn: json["data"]["token_expires_in"] ?? 0,
    );
  }
}
