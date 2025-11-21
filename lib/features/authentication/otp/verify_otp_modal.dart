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


// Resent OTP

class ResendOtpModel {
  final bool success;
  final String message;
  final ResendOtpData data;

  ResendOtpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResendOtpModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: ResendOtpData.fromJson(json["data"] ?? {}),
    );
  }
}

class ResendOtpData {
  final String email;
  final int otpExpiresIn;
  final int demoOtp;

  ResendOtpData({
    required this.email,
    required this.otpExpiresIn,
    required this.demoOtp,
  });

  factory ResendOtpData.fromJson(Map<String, dynamic> json) {
    return ResendOtpData(
      email: json["email"] ?? "",
      otpExpiresIn: json["otp_expires_in"] ?? 0,
      demoOtp: json["demo_otp"] ?? 0,
    );
  }
}
