import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
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
        throw Exception(
          response.data["message"] ?? "Profile setup failed. Please try again.",
        );
      }
    } on DioException catch (e) {
      print("Setup Profile Dio Error => ${e.response?.data}");
      throw Exception(e.response?.data["message"] ?? "Profile request failed.");
    }
  }
}

// dropdown

// company_repository.dart
class CompanyRepository {
  final Dio dio;
  final Ref ref;

  CompanyRepository({required this.dio, required this.ref});

  Future<CompanyResponse> getCompanies() async {
    try {
      final url = ApiUrls.getCompany;
      final token = await LocalStorage.getToken() ?? "";

      print(
        "Fetching companies with token: ${token.isNotEmpty ? "Yes" : "No"}",
      );

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("Companies API Response Status: ${response.statusCode}");
      print("Companies API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return CompanyResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load companies: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      print("Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("Error loading companies: $e");
      throw Exception("Failed to load companies");
    }
  }

  // Get filtered companies (by search query)
  Future<List<CompanyItem>> searchCompanies(String query) async {
    try {
      final response = await getCompanies();
      final allItems = response.data.getAllItems();

      if (query.isEmpty) {
        return allItems;
      }

      return allItems.where((item) => item.matchesSearch(query)).toList();
    } catch (e) {
      print("Error searching companies: $e");
      return [];
    }
  }

  // Get companies by type
  Future<List<CompanyItem>> getCompaniesByType(String type) async {
    try {
      final response = await getCompanies();
      return response.data.getCompaniesByType(type);
    } catch (e) {
      print("Error getting companies by type: $e");
      return [];
    }
  }
}

final companyRepositoryProvider = Provider<CompanyRepository>((ref) {
  return CompanyRepository(dio: ref.watch(dioProvider), ref: ref);
});
