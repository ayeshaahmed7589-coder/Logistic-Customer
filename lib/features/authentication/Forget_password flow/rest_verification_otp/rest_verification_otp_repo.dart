import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import 'rest_verification_otp_model.dart';

final verifyResetOtpRepositoryProvider =
    Provider<VerifyResetOtpRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return VerifyResetOtpRepository(dio: dio);
});

class VerifyResetOtpRepository {
  final Dio dio;

  VerifyResetOtpRepository({required this.dio});

  Future<VerifyResetOtpModel> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await dio.post(
      ApiUrls.verifyResetOtp,
      data: {
        "email": email,
        "otp": otp,
      },
    );

    print("Verify Reset OTP => ${response.data}");

    if (response.statusCode == 200 && response.data["success"] == true) {
      return VerifyResetOtpModel.fromJson(response.data);
    } else {
      throw Exception(response.data["message"] ?? "Invalid OTP");
    }
  }
}

final resendResetOtpRepositoryProvider =
    Provider<ResendResetOtpRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ResendResetOtpRepository(dio: dio);
});

class ResendResetOtpRepository {
  final Dio dio;

  ResendResetOtpRepository({required this.dio});

  Future<ResendResetOtpModel> resendResetOtp(String email) async {
    final response = await dio.post(
      ApiUrls.resendResetOtp,
      data: {"email": email},
    );

    print("Resend Reset OTP => ${response.data}");

    if (response.statusCode == 200 && response.data["success"] == true) {
      return ResendResetOtpModel.fromJson(response.data);
    } else {
      throw Exception(response.data["message"] ?? "Resend OTP failed");
    }
  }
}
