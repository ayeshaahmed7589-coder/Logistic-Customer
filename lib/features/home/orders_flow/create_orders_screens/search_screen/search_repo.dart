import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/search_screen/search_modal.dart';

class ShopifySearchRepo {
  final Dio dio;

  ShopifySearchRepo({required this.dio});

  Future<ShopifySearchModel> searchProducts(String query) async {
    // final url = "${ApiUrls.getShopifySearch}?q=$query";
    final url = "${ApiUrls.getShopifySearch}?q=$query";

    final token = await LocalStorage.getToken() ?? "";

    final res = await dio.get(
      url,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );
    print("URL => $url");
    print("RESPONSE => ${res.data}");

    if (res.statusCode == 200 && res.data["success"] == true) {
      return ShopifySearchModel.fromJson(res.data);
    } else {
      throw Exception("Search failed");
    }
  }
}

final shopifySearchRepoProvider = Provider(
  (ref) => ShopifySearchRepo(dio: ref.watch(dioProvider)),
);
