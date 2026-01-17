class VerifyResetOtpModel {
  final bool success;
  final String message;
  final VerifyResetOtpData data;

  VerifyResetOtpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VerifyResetOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyResetOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: VerifyResetOtpData.fromJson(json["data"] ?? {}),
    );
  }
}

class VerifyResetOtpData {
  final String email;
  final String resetToken;
  final int tokenExpiresIn;

  VerifyResetOtpData({
    required this.email,
    required this.resetToken,
    required this.tokenExpiresIn,
  });

  factory VerifyResetOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyResetOtpData(
      email: json["email"] ?? "",
      resetToken: json["reset_token"] ?? "",
      tokenExpiresIn: json["token_expires_in"] ?? 0,
    );
  }
}

class ResendResetOtpModel {
  final bool success;
  final String message;
  final ResendResetOtpData data;

  ResendResetOtpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ResendResetOtpModel.fromJson(Map<String, dynamic> json) {
    return ResendResetOtpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: ResendResetOtpData.fromJson(json["data"] ?? {}),
    );
  }
}

class ResendResetOtpData {
  final String email;
  final int otpExpiresIn;
  final int demoOtp;

  ResendResetOtpData({
    required this.email,
    required this.otpExpiresIn,
    required this.demoOtp,
  });

  factory ResendResetOtpData.fromJson(Map<String, dynamic> json) {
    return ResendResetOtpData(
      email: json["email"] ?? "",
      otpExpiresIn: json["otp_expires_in"] ?? 0,
      demoOtp: json["demo_otp"] ?? 0,
    );
  }
}
