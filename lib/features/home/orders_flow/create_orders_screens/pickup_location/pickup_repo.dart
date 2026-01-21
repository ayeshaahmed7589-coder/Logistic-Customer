import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/pickup_location/pickup_modal.dart';

class DefaultAddressRepository {
  final Dio dio;
  final Ref ref;

  DefaultAddressRepository({required this.dio, required this.ref});

  Future<DefaultAddressModel> getDefaultAddress() async {
    final url = ApiUrls.getDefaultAddress;

    final token = await LocalStorage.getToken() ?? "";
    print("📌 Saved Token => $token");

    if (token.isEmpty) {
      throw Exception("Token missing");
    }

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("📌 Default Address API => ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return DefaultAddressModel.fromJson(response.data);
      }

      throw Exception("Failed to fetch default address");
    } catch (e) {
      print("⛔ API ERROR => $e");
      rethrow;
    }
  }
}

final defaultAddressRepositoryProvider = Provider((ref) {
  return DefaultAddressRepository(dio: ref.watch(dioProvider), ref: ref);
});

// All Address
// all_address_repository.dart
class AllAddressRepository {
  final Dio dio;
  final Ref ref;

  AllAddressRepository({required this.dio, required this.ref});

  Future<AllAddressModel> getAllAddress() async {
    final url = ApiUrls.getAllAddress;

    final token = await LocalStorage.getToken() ?? "";
    print("📌 Saved Token => $token");

    if (token.isEmpty) {
      throw Exception("Token missing");
    }

    try {
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
        ),
      );

      print("📌 All Address API => ${response.data}");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return AllAddressModel.fromJson(response.data);
      }

      throw Exception("Failed to fetch all addresses");
    } catch (e) {
      print("⛔ API ERROR => $e");
      rethrow;
    }
  }
}

final allAddressRepositoryProvider = Provider((ref) {
  return AllAddressRepository(dio: ref.watch(dioProvider), ref: ref);
});
