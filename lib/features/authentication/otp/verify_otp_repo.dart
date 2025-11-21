import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/authentication/otp/verify_otp_modal.dart';
import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';

final verifyOtpRepositoryProvider = Provider<VerifyOtpRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return VerifyOtpRepository(dio: dio, ref: ref);
});

class VerifyOtpRepository {
  final Dio dio;
  final Ref ref;

  VerifyOtpRepository({required this.dio, required this.ref});

  Future<VerifyOtpModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = ApiUrls.postVerifyOTP;

    try {
      final response = await dio.post(
        url,
        data: {
          "email": email,
          "otp": otp,
        },
      );

      print("Verify OTP Response => ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return VerifyOtpModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Invalid OTP");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "OTP verify request failed");
    }
  }
}


// Rsent OTP

final resendOtpRepositoryProvider = Provider<ResendOtpRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ResendOtpRepository(dio: dio, ref: ref);
});

class ResendOtpRepository {
  final Dio dio;
  final Ref ref;

  ResendOtpRepository({required this.dio, required this.ref});

  Future<ResendOtpModel> resendOtp(String email) async {
    final url = ApiUrls.postResentOTP;

    try {
      final response = await dio.post(
        url,
        data: {"email": email},
      );

      print("Resend OTP => ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return ResendOtpModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "OTP resend failed");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "Resend OTP request failed");
    }
  }
}
