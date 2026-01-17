class ForgotPasswordModel {
  final bool success;
  final String message;
  final ForgotPasswordData data;

  ForgotPasswordModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: ForgotPasswordData.fromJson(json["data"] ?? {}),
    );
  }
}

class ForgotPasswordData {
  final String email;
  final int otpExpiresIn;
  final int demoOtp;

  ForgotPasswordData({
    required this.email,
    required this.otpExpiresIn,
    required this.demoOtp,
  });

  factory ForgotPasswordData.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordData(
      email: json["email"] ?? "",
      otpExpiresIn: json["otp_expires_in"] ?? 0,
      demoOtp: json["demo_otp"] ?? 0,
    );
  }
}
