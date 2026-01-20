import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';

class RefreshRepository {
  final Dio dio;
  final Ref ref;

  RefreshRepository({required this.dio, required this.ref});

  Future<Map<String, dynamic>> refreshToken() async {
    final response = await dio.post(
      "/api/v1/customer/auth/refresh",
      options: Options(
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data["data"];
    }

    throw Exception("Refresh failed");
  }
}

final refreshRepositoryProvider = Provider<RefreshRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RefreshRepository(dio: dio, ref: ref);
});

class RefreshController extends StateNotifier<AsyncValue<bool>> {
  final RefreshRepository repository;

  RefreshController(this.repository) : super(const AsyncValue.data(false));

  Future<bool> refreshToken() async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.refreshToken();

      // Save new token
      final newAccessToken = result["access_token"];
      await LocalStorage.saveToken(newAccessToken);

      print("✅ New token saved: $newAccessToken");

      state = const AsyncValue.data(true);
      return true;
    } catch (e, st) {
      print("❌ Token refresh failed: $e");
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final refreshControllerProvider =
    StateNotifierProvider<RefreshController, AsyncValue<bool>>((ref) {
      final repo = ref.watch(refreshRepositoryProvider);
      return RefreshController(repo);
    });
