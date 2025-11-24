// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:logisticscustomer/constants/api_url.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:dio/dio.dart';

// part 'dio.g.dart';

// @riverpod
// Dio dio(Ref ref) {
//   return Dio(
//     BaseOptions(
//       baseUrl: ApiUrls.baseurl,
//       headers: {"Content-Type": "application/json"},
//       connectTimeout: Duration(seconds: 20),
//       receiveTimeout: Duration(seconds: 20),
//     ),
//   );
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
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

  /// 🔥 Token Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await LocalStorage.getToken();

        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
          print("📌 Token added => $token");
        } else {
          print("❌ No token found — request WITHOUT token");
        }

        return handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) {
          print("⛔ Unauthorized: Token missing or expired");
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}
