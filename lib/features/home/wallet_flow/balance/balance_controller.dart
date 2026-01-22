import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'balance_model.dart';
import 'balance_repo.dart';

final walletBalanceControllerProvider =
    StateNotifierProvider<WalletBalanceController,
        AsyncValue<WalletBalanceModel?>>((ref) {
  final repo = ref.watch(walletBalanceRepositoryProvider);
  return WalletBalanceController(repo);
});

class WalletBalanceController
    extends StateNotifier<AsyncValue<WalletBalanceModel?>> {
  final WalletBalanceRepository repo;

  WalletBalanceController(this.repo)
      : super(const AsyncValue.loading()) {
    fetchBalance();
  }

  Future<void> fetchBalance() async {
    state = const AsyncValue.loading();
    try {
      final data = await repo.fetchWalletBalance();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
