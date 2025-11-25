import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/main_screens/home_screen/home_modal.dart';

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
