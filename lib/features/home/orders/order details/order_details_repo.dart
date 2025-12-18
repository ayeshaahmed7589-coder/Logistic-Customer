import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../../../../constants/local_storage.dart';
import 'order_details_modal.dart';
final orderDetailsRepositoryProvider =
    Provider<OrderDetailsRepository>((ref) {
  return OrderDetailsRepository(dio: ref.watch(dioProvider), ref: ref);
});

class OrderDetailsRepository {
  final Dio dio;
  final Ref ref;

  OrderDetailsRepository({required this.dio, required this.ref});

  Future<OrderDetailsModel> getOrderDetails(int orderId) async {
    final token = await LocalStorage.getToken() ?? "";
    final url = "${ApiUrls.orderDetails}/$orderId";

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
      return OrderDetailsModel.fromJson(response.data);
    }

    throw Exception("Failed to load order details");
  }
}
