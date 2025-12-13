import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/get_all_orders_modal.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_modal.dart';
// lib/features/orders/repository/order_repository.dart

class OrderRepository {
  final Dio dio;
  final Ref ref;

  OrderRepository({required this.dio, required this.ref});

  Future<GetOrderResponse> getOrders() async {
    final url = ApiUrls.getOrders; // Apne API URL ko yahan set karen

    final token = await LocalStorage.getToken() ?? "";

    print("Bearer Token ==> $token");

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    print("Orders Response => ${response.data}");

    if (response.statusCode == 200) {
      return GetOrderResponse.fromJson(response.data);
    }

    throw Exception("Orders load failed");
  }
}

final orderRepositoryProvider = Provider((ref) {
  return OrderRepository(dio: ref.watch(dioProvider), ref: ref);
});

///////

class DashboardRepository {
  final Dio dio;
  final Ref ref;

  DashboardRepository({required this.dio, required this.ref});

  Future<DashboardModel> getDashboard() async {
    final url = ApiUrls.getHome;

    // Token SharedPreferences se load hoga
    final token = await LocalStorage.getToken() ?? "";

    print("Bearer Token ==> $token");

    final response = await dio.get(
      url,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ),
    );

    print("Dashboard Response => ${response.data}");

    if (response.statusCode == 200) {
      return DashboardModel.fromJson(response.data);
    }

    throw Exception("Dashboard load failed");
  }
}

final dashboardRepositoryProvider = Provider((ref) {
  return DashboardRepository(dio: ref.watch(dioProvider), ref: ref);
});
