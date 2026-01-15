import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/api_url.dart';
import '../../../constants/dio.dart';
import 'get_profile_model.dart';

final getProfileRepositoryProvider = Provider<GetProfileRepository>((ref) {
  return GetProfileRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});

class GetProfileRepository {
  final Dio dio;
  final Ref ref;

  GetProfileRepository({
    required this.dio,
    required this.ref,
  });

  Future<GetProfileModel> getProfile() async {
    // final url = ApiUrls.getprofile;

    // Token load from SharedPreferences / LocalStorage
    // final token = await LocalStorage.getToken() ?? "";

    // print("Bearer Token ==> $token");

    try {
      final response = await dio.get(ApiUrls.getprofile);
      // final response = await dio.get(
      //   url,
      //   options: Options(
      //     headers: {
      //       "Authorization": "Bearer $token",
      //       "Accept": "application/json",
      //     },
      //   ),
      // );

      print("GET PROFILE RESPONSE => ${response.data}");

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        return GetProfileModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ?? "Unable to load profile");
      }
    } on DioException catch (e) {
      print("PROFILE API ERROR => ${e.response?.data}");

      throw Exception(
        e.response?.data["message"] ?? "Profile request failed",
      );
    }
  }
}
