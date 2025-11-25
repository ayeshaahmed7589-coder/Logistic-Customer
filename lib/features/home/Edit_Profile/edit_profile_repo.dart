import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/api_url.dart';
import '../../../constants/dio.dart';
import '../../../constants/local_storage.dart';
import 'edit_profile_modal.dart';

// Provider
final editProfileRepositoryProvider = Provider<EditProfileRepository>((ref) {
  return EditProfileRepository(dio: ref.watch(dioProvider), ref: ref);
});

class EditProfileRepository {
  final Dio dio;
  final Ref ref;

  EditProfileRepository({required this.dio, required this.ref});

  /// Fetch profile data
  Future<UpdateProfileModel> getProfile() async {
    final url = ApiUrls.getprofile;
    final token = await LocalStorage.getToken() ?? "";

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    if (response.statusCode == 200) {
      return UpdateProfileModel.fromJson(response.data);
    }
    throw Exception("Failed to load profile");
  }

  /// Update profile data (flat JSON)
  Future<UpdateProfileModel> updateProfile({
    required String name,
    required String phone,
    required String dob,
    File? image,
  }) async {
    final url = ApiUrls.editprofile;
    final token = await LocalStorage.getToken() ?? "";

    // Simple JSON (NO DateTime.parse, NO ISO!)
    Map<String, dynamic> data = {"name": name, "phone": phone};

    if (dob.isNotEmpty) {
      data["date_of_birth"] = dob; // <-- ONLY STRING
    }

    // Prepare multipart form
    FormData formData = FormData.fromMap({
      ...data,
      if (image != null)
        "profile_photo": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split("/").last,
        ),
    });

    final response = await dio.post(
      url,
      data: formData,
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    if (response.statusCode == 200) {
      print("Profile updated: ${response.data}");
      return UpdateProfileModel.fromJson(response.data);
    }

    throw Exception("Profile update failed: ${response.data}");
  }
}
