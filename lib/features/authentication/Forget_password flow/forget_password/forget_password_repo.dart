import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';

import 'forget_password_model.dart';

final forgotPasswordRepositoryProvider =
    Provider<ForgotPasswordRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ForgotPasswordRepository(dio: dio, ref: ref);
});

class ForgotPasswordRepository {
  final Dio dio;
  final Ref ref;

  ForgotPasswordRepository({
    required this.dio,
    required this.ref,
  });

  Future<ForgotPasswordModel> forgotPassword({
    required String email,
  }) async {
    final url = ApiUrls.forgotPassword;
    // example:
    // static const postForgotPassword = "/api/v1/customer/auth/forgot-password";

    try {
      final response = await dio.post(
        url,
        data: {
          "email": email,
        },
      );

      /// 🔥 FULL RESPONSE PRINT
      print("Forgot Password Status Code => ${response.statusCode}");
      print("Forgot Password Response => ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return ForgotPasswordModel.fromJson(response.data);
      } else {
        throw Exception(
            response.data["message"] ?? "Forgot password failed");
      }
    } on DioException catch (e) {
      print("Forgot Password Error => ${e.response?.data}");
      throw Exception(
        e.response?.data["message"] ?? "Forgot password request failed",
      );
    }
  }
}
