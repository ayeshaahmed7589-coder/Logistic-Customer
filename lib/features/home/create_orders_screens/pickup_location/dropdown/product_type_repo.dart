import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_modal.dart';

// product Type Repository
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

  Future<List<ProductTypeItem>> searchProductTypes(String query) async {
    try {
      final response = await getProductTypes();
      final allItems = response.data
          .expand((category) => category.products)
          .toList();

      if (query.isEmpty) {
        return allItems;
      }

      return allItems.where((item) => item.matchesSearch(query)).toList();
    } catch (e) {
      print("Error searching product types: $e");
      return [];
    }
  }

  Future<List<ProductTypeItem>> getProductTypesByCategory(
    String category,
  ) async {
    try {
      final response = await getProductTypes();
      final categoryData = response.data.firstWhere(
        (cat) => cat.category == category,
        orElse: () =>
            ProductTypeCategory(category: '', categoryLabel: '', products: []),
      );
      return categoryData.products;
    } catch (e) {
      print("Error getting product types by category: $e");
      return [];
    }
  }
}

final productTypeRepositoryProvider = Provider<ProductTypeRepository>((ref) {
  return ProductTypeRepository(dio: ref.watch(dioProvider), ref: ref);
});

//PACKAGEINF Type Repository
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

  Future<List<PackagingTypeItem>> searchPackagingTypes(String query) async {
    try {
      final response = await getPackagingTypes();
      final allItems = response.data;

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

final packagingTypeRepositoryProvider = Provider<PackagingTypeRepository>((ref) {
  return PackagingTypeRepository(dio: ref.watch(dioProvider), ref: ref);
});