import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import '../../../constants/api_url.dart';
import 'set_up_profile_modal.dart';

final setUpProfileRepositoryProvider = Provider<SetUpProfileRepository>((ref) {
  final dio = ref.watch(dioProvider); 
  return SetUpProfileRepository(dio: dio);
});
class SetUpProfileRepository {
  final Dio dio;

  SetUpProfileRepository({required this.dio});

  Future<SetUpProfileModel> completeProfile({
    required String verificationToken,
    required String name,
    required String phone,
    required String dob,
    File? profilePhoto,
  }) async {
    final url = ApiUrls.baseurl + ApiUrls.postSetUpProfile;

    try {
      FormData formData = FormData.fromMap({
        "verification_token": verificationToken,
        "name": name,
        "phone": phone,
        "date_of_birth": dob,
        if (profilePhoto != null)
          "profile_photo": await MultipartFile.fromFile(
            profilePhoto.path,
            filename: profilePhoto.path.split("/").last,
          ),
      });

      final response = await dio.post(url, data: formData);

      print("SetUpProfile Response => ${response.data}");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data["success"] == true) {
        return SetUpProfileModel.fromJson(response.data);
      } else {
        throw Exception(response.data["message"] ??
            "Profile setup failed. Please try again.");
      }
    } on DioException catch (e) {
      print("Setup Profile Dio Error => ${e.response?.data}");
      throw Exception(
          e.response?.data["message"] ?? "Profile request failed.");
    }
  }
}
