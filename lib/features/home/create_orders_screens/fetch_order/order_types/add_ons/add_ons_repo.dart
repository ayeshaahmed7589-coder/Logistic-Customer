import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/add_ons/add_ons_modal.dart';

class AddOnsRepository {
  final Dio dio;
  final Ref ref;

  AddOnsRepository({required this.dio, required this.ref});

  Future<AddOnsResponse> getAddOns() async {
    try {
      final url = ApiUrls.getAddOns;
      final token = await LocalStorage.getToken() ?? "";

      print("Fetching add-ons with token: ${token.isNotEmpty ? "Yes" : "No"}");

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("Add-ons API Response Status: ${response.statusCode}");
      print("Add-ons API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return AddOnsResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load add-ons: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      print("Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("Error loading add-ons: $e");
      throw Exception("Failed to load add-ons");
    }
  }

  // Get add-on by ID
  Future<AddOnItem?> getAddOnById(String id) async {
    try {
      final response = await getAddOns();
      return response.data.addOns.firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception("Add-on not found"),
      );
    } catch (e) {
      print("Error getting add-on by ID: $e");
      return null;
    }
  }
}

final addOnsRepositoryProvider = Provider<AddOnsRepository>((ref) {
  return AddOnsRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});