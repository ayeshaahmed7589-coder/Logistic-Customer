import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/api_url.dart';
import '../../../../constants/dio.dart';
import '../../../../constants/local_storage.dart';
import 'wallet_topup_model.dart';

final walletTopUpRepositoryProvider =
    Provider<WalletTopUpRepository>((ref) {
  return WalletTopUpRepository(
    dio: ref.watch(dioProvider),
    ref: ref,
  );
});

class WalletTopUpRepository {
  final Dio dio;
  final Ref ref;

  WalletTopUpRepository({required this.dio, required this.ref});

  Future<WalletTopUpModel> topUpWallet({required double amount}) async {
    final token = await LocalStorage.getToken() ?? "";
    print("Top-Up Amount: $amount");

    try {
      final response = await dio.post(
        ApiUrls.walletTopup,
        data: {"amount": amount},
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        }),
      );

      print("Wallet Top-Up Response => ${response.data}");

      if (response.statusCode == 200) {
        return WalletTopUpModel.fromJson(response.data);
      }

      throw Exception("Wallet Top-Up Failed");
    } catch (e) {
      print("Wallet Top-Up API Error => $e");
      rethrow;
    }
  }
}
