import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/service_type/service_type_modal.dart';

class ServiceTypeRepository {
  final Dio dio;
  final Ref ref;

  ServiceTypeRepository({required this.dio, required this.ref});

  Future<ServiceTypeResponse> getServiceTypes() async {
    try {
      final url = ApiUrls.getServiceType;
      final token = await LocalStorage.getToken() ?? "";

      print("🔍 Fetching service types...");

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("✅ Service Types API Response Status: ${response.statusCode}");
      print("✅ Service Types API Response Status: ${response.data}");


      if (response.statusCode == 200) {
        print("✅ Service Types loaded successfully");
        return ServiceTypeResponse.fromJson(response.data);
      } else {
        print("❌ Failed to load service types: ${response.statusCode}");
        throw Exception("Failed to load service types: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("❌ Error loading service types: $e");
      throw Exception("Failed to load service types");
    }
  }

  // Get service type by value
  Future<ServiceTypeItem?> getServiceTypeByValue(String value) async {
    try {
      final response = await getServiceTypes();
      try {
        return response.data.firstWhere((item) => item.value == value);
      } catch (e) {
        return null;
      }
    } catch (e) {
      print("❌ Error getting service type by value: $e");
      return null;
    }
  }
}

final serviceTypeRepositoryProvider = Provider<ServiceTypeRepository>((ref) {
  return ServiceTypeRepository(dio: ref.watch(dioProvider), ref: ref);
});
