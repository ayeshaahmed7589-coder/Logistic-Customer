import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../../../../constants/local_storage.dart';
import 'order_tracking_model.dart';

final orderTrackingRepositoryProvider =
    Provider<OrderTrackingRepository>((ref) {
  return OrderTrackingRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});

class OrderTrackingRepository {
  final Dio dio;
  final Ref ref;

  OrderTrackingRepository({
    required this.dio,
    required this.ref,
  });

  Future<OrderTrackingModel> trackOrder(String trackingCode) async {
    final token = await LocalStorage.getToken() ?? "";

    final url = "${ApiUrls.trackOrder}/$trackingCode";

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
      return OrderTrackingModel.fromJson(response.data);
    }

    throw Exception("Failed to load order tracking");
  }
}