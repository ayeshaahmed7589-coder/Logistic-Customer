import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import 'rest_password_model.dart';

final restPasswordRepositoryProvider =
    Provider<RestPasswordRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RestPasswordRepository(dio: dio, ref: ref);
});

class RestPasswordRepository {
  final Dio dio;
  final Ref ref;

  RestPasswordRepository({required this.dio, required this.ref});

  Future<RestPasswordModel> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    final url = ApiUrls.resetpassword; // your API URL

    try {
      final response = await dio.post(
        url,
        data: {
          "reset_token": token,
          "password": password,
          "password_confirmation": confirmPassword,
        },
      );

      print("✅ Reset Password Response: ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return RestPasswordModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ??
            "Password reset failed. Please try again.");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          "Reset password request failed");
    }
  }
}
