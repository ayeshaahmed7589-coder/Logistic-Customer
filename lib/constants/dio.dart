import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/authentication/refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

part 'dio.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseurl,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // final noAuthPaths = ["/login", "/register", "/api/v1/customer/auth/refresh"];

  bool isRefreshing = false;
  // final List<RequestOptions> failedRequests = [];
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.path.contains("login") ||
            options.path.contains("auth/refresh")) {
          return handler.next(options);
        }

        final token = await LocalStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }

        return handler.next(options);
      },

      onError: (e, handler) async {
        // 🔴 REFRESH API KO DOBARA REFRESH MAT KARO
        if (e.requestOptions.path.contains("auth/refresh")) {
          return handler.reject(e);
        }

        if (e.response?.statusCode == 401) {
          // 🟡 EK HI DAFA REFRESH
          if (!isRefreshing) {
            isRefreshing = true;

            final success = await ref
                .read(refreshControllerProvider.notifier)
                .refreshToken();

            isRefreshing = false;

            if (success) {
              final newToken = await LocalStorage.getToken();

              // 🔁 CURRENT REQUEST RETRY
              e.requestOptions.headers["Authorization"] = "Bearer $newToken";

              final response = await dio.fetch(e.requestOptions);
              return handler.resolve(response);
            } else {
              await LocalStorage.clearToken();

              return handler.reject(
                DioException(
                  requestOptions: e.requestOptions,
                  error: "SESSION_EXPIRED",
                ),
              );
            }
          }
        }

        return handler.reject(e);
      },
    ),
  );

  return dio;
}