import 'dart:io';
import 'package:dio/dio.dart';
import '../../../constants/api_url.dart';
import 'set_up_profile_modal.dart';

class SetUpProfileRepository {
  final Dio _dio = Dio();

  Future<SetUpProfileModel> completeProfile({
    required String verificationToken,
    required String name,
    required String phone,
    required String dob,
    File? profilePhoto,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "verification_token": verificationToken,
        "name": name,
        "phone": phone,
        "date_of_birth": dob,
        if (profilePhoto != null)
          "profile_photo": await MultipartFile.fromFile(profilePhoto.path,
              filename: profilePhoto.path.split("/").last),
      });

      final response = await _dio.post(
        ApiUrls.baseurl + ApiUrls.postSetUpProfile,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SetUpProfileModel.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ??
            "Failed to complete profile. Please try again.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
