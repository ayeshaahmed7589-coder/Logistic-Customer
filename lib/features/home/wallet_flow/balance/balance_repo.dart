import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../../../../constants/local_storage.dart';
import 'balance_model.dart';

final walletBalanceRepositoryProvider =
    Provider<WalletBalanceRepository>((ref) {
  return WalletBalanceRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});

class WalletBalanceRepository {
  final Dio dio;
  final Ref ref;

  WalletBalanceRepository({
    required this.dio,
    required this.ref,
  });

  Future<WalletBalanceModel> fetchWalletBalance() async {
    final token = await LocalStorage.getToken() ?? "";

    final response = await dio.get(
      ApiUrls.walletbalance, // 👉 yahan URL constant use karein
      options: Options(
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );

    // ✅ API RESPONSE PRINT
    print("Wallet Balance API Response => ${response.data}");

    if (response.statusCode == 200) {
      return WalletBalanceModel.fromJson(response.data);
    }

    throw Exception("Failed to load wallet balance");
  }
}
