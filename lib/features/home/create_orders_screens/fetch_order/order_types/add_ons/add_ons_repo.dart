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

      print("🔍 Fetching add-ons...");

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("✅ Add-ons API Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("✅ Add-ons loaded successfully");
        return AddOnsResponse.fromJson(response.data);
      } else {
        print("❌ Failed to load add-ons: ${response.statusCode}");
        throw Exception("Failed to load add-ons: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("❌ Error loading add-ons: $e");
      throw Exception("Failed to load add-ons");
    }
  }

  // ✅ Get add-on by value
  Future<AddOnItem?> getAddOnByValue(String value) async {
    try {
      final response = await getAddOns();
      try {
        return response.data.firstWhere((item) => item.value == value);
      } catch (e) {
        return null;
      }
    } catch (e) {
      print("❌ Error getting add-on by value: $e");
      return null;
    }
  }
}

final addOnsRepositoryProvider = Provider<AddOnsRepository>((ref) {
  return AddOnsRepository(dio: ref.watch(dioProvider), ref: ref);
});
