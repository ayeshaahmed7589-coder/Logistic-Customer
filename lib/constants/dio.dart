import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

part 'dio.g.dart';

@riverpod
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseurl,
      headers: {"Content-Type": "application/json"},
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 20),
    ),
  );
}

// @riverpod
// Dio dio(Ref ref) {
//   return Dio();
// }
