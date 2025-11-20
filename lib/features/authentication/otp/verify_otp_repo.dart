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

  VerifyOtpRepository({
    required this.dio,
    required this.ref,
  });

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
        throw Exception(response.data["message"] ?? "OTP verification failed");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data["message"] ?? "Server error occurred");
      }
      throw Exception("Network error occurred");
    }
  }
}
