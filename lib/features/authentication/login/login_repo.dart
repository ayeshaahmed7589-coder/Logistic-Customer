import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
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
        data: {"email": email, "password": password},
      );

      print("Login Response => ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return LoginModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Login failed");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data["message"] ?? "Login request failed");
    }
  }
}

// Logout
final logoutRepositoryProvider = Provider<LogoutRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LogoutRepository(dio: dio, ref: ref);
});

class LogoutRepository {
  final Dio dio;
  final Ref ref;

  LogoutRepository({required this.dio, required this.ref});

  Future<String> logout() async {
    final url = ApiUrls.postLogOut;

    try {
      /// GET TOKEN FROM SECURE STORAGE / SHARED PREF
      final token = await LocalStorage.getToken();

      print("Logout Token => $token");

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      print("Logout Response => ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return response.data["message"];
      } else {
        throw Exception(response.data["message"] ?? "Logout failed");
      }
    } on DioException catch (e) {
      print("Logout Error => ${e.response?.data}");
      throw Exception(
          e.response?.data["message"] ?? "Logout request failed");
    }
  }
}
