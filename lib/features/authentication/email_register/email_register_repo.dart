import 'package:dio/dio.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/authentication/email_register/email_register_modal.dart';
// ignore: depend_on_referenced_packages
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio: dio, ref: ref);
});

class AuthRepository {
  final Dio dio;
  final Ref ref;

  AuthRepository({required this.dio, required this.ref});

  Future<EmailRegisterModal> sendOtp(String email) async {
    final url = ApiUrls.postEmailRegister;
    print("FINAL URL => ${dio.options.baseUrl + url}");

    try {
      final response = await dio.post(url, data: {"email": email});
      print("EmailPayload${response}");
      print("EmailPayload${url}");
      print("EmailPayload${dio}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return EmailRegisterModal.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Something went wrong");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data["message"] ?? "Server error occurred");
      }
      throw Exception("Network error occurred");
    }
  }
}
