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

  // API jin par token nahi lagana
  final noAuthPaths = [
    "/register/send-otp",
    "/register/verify-otp",
    "/register/create-password",
    "/register/complete-profile",
    "/login",
  ];

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip auth-free APIs
        if (noAuthPaths.any((p) => options.path.contains(p))) {
          print("🚫 Skipping token for → ${options.path}");
          return handler.next(options);
        }

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
