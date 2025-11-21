import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/authentication/login/login_modal.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LoginRepository(dio: dio, ref: ref);
});

class LoginRepository {
  final Dio dio;
  final Ref ref;

  LoginRepository({required this.dio, required this.ref});

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final url = ApiUrls.postLogin;

    try {
      final response = await dio.post(
        url,
        data: {
          "email": email,
          "password": password,
        },
      );

      print("Login Response => ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return LoginModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Login failed");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "Login request failed");
    }
  }
}
