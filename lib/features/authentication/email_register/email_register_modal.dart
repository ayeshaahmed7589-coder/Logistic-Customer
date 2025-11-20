
class EmailRegisterModal {
  final bool success;
  final String message;
  final String email;
  final int otpExpiresIn;
  final int demoOtp;

  EmailRegisterModal({
    required this.success,
    required this.message,
    required this.email,
    required this.otpExpiresIn,
    required this.demoOtp,
  });

  factory EmailRegisterModal.fromJson(Map<String, dynamic> json) {
    return EmailRegisterModal(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      email: json["data"]["email"] ?? "",
      otpExpiresIn: json["data"]["otp_expires_in"] ?? 0,
      demoOtp: json["data"]["demo_otp"] ?? 0,
    );
  }
}
