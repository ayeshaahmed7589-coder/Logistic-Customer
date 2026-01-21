// payment_check_repo.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../../../../constants/local_storage.dart';
import 'payment_method_model.dart';

final paymentCheckRepositoryProvider =
    Provider<PaymentCheckRepository>((ref) {
  return PaymentCheckRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});

class PaymentCheckRepository {
  final Dio dio;
  final Ref ref;

  PaymentCheckRepository({required this.dio, required this.ref});

Future<PaymentCheckModel> checkPaymentOptions({
  required double amount,
}) async {
  final token = await LocalStorage.getToken() ?? "";

  final response = await dio.post(
    ApiUrls.paymentmethod,
    data: {
      "amount": amount,
    },
    options: Options(
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    ),
  );

  // 🔥 PRINT FULL API RESPONSE
  print("PAYMENT CHECK API RESPONSE:");
  print(response.data);

  if (response.statusCode == 200) {
    return PaymentCheckModel.fromJson(response.data);
  }

  throw Exception("Payment option check failed");
}
}
