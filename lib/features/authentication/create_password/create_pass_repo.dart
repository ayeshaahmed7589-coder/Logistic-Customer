import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/authentication/create_password/create_pass_modal.dart';

final createPasswordRepositoryProvider =
    Provider<CreatePasswordRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CreatePasswordRepository(dio: dio, ref: ref);
});

class CreatePasswordRepository {
  final Dio dio;
  final Ref ref;

  CreatePasswordRepository({required this.dio, required this.ref});

  Future<CreatePasswordModel> createPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    final url = ApiUrls.postCreatePassword;

    try {
      final response = await dio.post(
        url,
        data: {
          "verification_token": token,
          "password": password,
          "password_confirmation": confirmPassword,
        },
      );

      print("Create Password Response => ${response.data}");

      if (response.statusCode == 200 && response.data['success'] == true) {
        return CreatePasswordModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Password creation failed");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data["message"] ?? "Create password request failed");
    }
  }
}
