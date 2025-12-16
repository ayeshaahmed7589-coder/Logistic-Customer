import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_modal.dart';

class ProductTypeRepository {
  final Dio dio;
  final Ref ref;

  ProductTypeRepository({required this.dio, required this.ref});

  Future<ProductTypeResponse> getProductTypes() async {
    try {
      final url = ApiUrls.getProductType;
      final token = await LocalStorage.getToken() ?? "";

      print(
        "Fetching product types with token: ${token.isNotEmpty ? "Yes" : "No"}",
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

      print("Product Types API Response Status: ${response.statusCode}");
      print("Product Types API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return ProductTypeResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load product types: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      print("Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("Error loading product types: $e");
      throw Exception("Failed to load product types");
    }
  }

  // Get filtered product types (by search query)
  Future<List<ProductTypeItem>> searchProductTypes(String query) async {
    try {
      final response = await getProductTypes();
      final allItems = response.data.getAllItems();

      if (query.isEmpty) {
        return allItems;
      }

      return allItems.where((item) => item.matchesSearch(query)).toList();
    } catch (e) {
      print("Error searching product types: $e");
      return [];
    }
  }

  // Get product types by category
  Future<List<ProductTypeItem>> getProductTypesByCategory(
    String category,
  ) async {
    try {
      final response = await getProductTypes();
      return response.data.getItemsByCategory(category);
    } catch (e) {
      print("Error getting product types by category: $e");
      return [];
    }
  }
}

final productTypeRepositoryProvider = Provider<ProductTypeRepository>((ref) {
  return ProductTypeRepository(dio: ref.watch(dioProvider), ref: ref);
});

// Product Type Repository 
class PackagingTypeRepository {
  final Dio dio;
  final Ref ref;

  PackagingTypeRepository({required this.dio, required this.ref});

  Future<PackagingTypeResponse> getPackagingTypes() async {
    try {
      final url = ApiUrls.getPackageingType;
      final token = await LocalStorage.getToken() ?? "";

      print(
        "Fetching packaging types with token: ${token.isNotEmpty ? "Yes" : "No"}",
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

      print("Packaging Types API Response Status: ${response.statusCode}");
      print("Packaging Types API Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return PackagingTypeResponse.fromJson(response.data);
      } else {
        throw Exception(
          "Failed to load packaging types: ${response.statusCode}",
        );
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.message}");
      print("Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("Error loading packaging types: $e");
      throw Exception("Failed to load packaging types");
    }
  }

  // Search packaging types
  Future<List<PackagingTypeItem>> searchPackagingTypes(String query) async {
    try {
      final response = await getPackagingTypes();
      final allItems = response.data.packagingTypes;

      if (query.isEmpty) {
        return allItems;
      }

      return allItems.where((item) => item.matchesSearch(query)).toList();
    } catch (e) {
      print("Error searching packaging types: $e");
      return [];
    }
  }
}

final packagingTypeRepositoryProvider = Provider<PackagingTypeRepository>((
  ref,
) {
  return PackagingTypeRepository(dio: ref.watch(dioProvider), ref: ref);
});
