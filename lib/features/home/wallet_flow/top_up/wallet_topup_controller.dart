import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wallet_topup_model.dart';
import 'wallet_topup_repo.dart';

final walletTopUpControllerProvider =
    StateNotifierProvider<WalletTopUpController, AsyncValue<WalletTopUpModel?>>(
        (ref) {
  final repo = ref.watch(walletTopUpRepositoryProvider);
  return WalletTopUpController(repo);
});

class WalletTopUpController
    extends StateNotifier<AsyncValue<WalletTopUpModel?>> {
  final WalletTopUpRepository repo;

  WalletTopUpController(this.repo) : super(const AsyncValue.data(null));

  Future<WalletTopUpModel?> topUp({required double amount}) async {
    state = const AsyncValue.loading();
    try {
      final data = await repo.topUpWallet(amount: amount);
      state = AsyncValue.data(data);
      print("Wallet Top-Up Successful: ${data.message}");
      return data;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      print("Wallet Top-Up Error: $e");
      return null;
    }
  }
}
