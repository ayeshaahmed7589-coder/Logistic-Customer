import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../../../../constants/local_storage.dart';
import 'transaction_history_model.dart';

final walletTransactionRepositoryProvider =
    Provider<WalletTransactionRepository>((ref) {
  return WalletTransactionRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});

class WalletTransactionRepository {
  final Dio dio;
  final Ref ref;

  WalletTransactionRepository({
    required this.dio,
    required this.ref,
  });

  Future<WalletTransactionResponse> fetchTransactions({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final token = await LocalStorage.getToken() ?? "";

      final response = await dio.get(
        ApiUrls.walletTransactions,
        queryParameters: {
          "page": page,
          "per_page": perPage,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      // ✅ PRINT RESPONSE
      print("Wallet Transaction API Response => ${response.data}");

      if (response.statusCode == 200) {
        return WalletTransactionResponse.fromJson(response.data);
      }

      throw Exception("Failed to load transactions");
    } catch (e) {
      // ❌ PRINT ERROR
      print("Wallet Transaction API Error => $e");
      rethrow;
    }
  }
}
