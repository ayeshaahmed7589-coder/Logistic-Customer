import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_history_model.dart';
import 'transaction_history_repo.dart';

final walletTransactionControllerProvider =
    StateNotifierProvider<WalletTransactionController,
        AsyncValue<List<WalletTransaction>>>((ref) {
  final repo = ref.watch(walletTransactionRepositoryProvider);
  return WalletTransactionController(repo);
});

class WalletTransactionController
    extends StateNotifier<AsyncValue<List<WalletTransaction>>> {
  final WalletTransactionRepository repo;

  int _page = 1;
  bool _hasMore = true;
  final List<WalletTransaction> _transactions = [];

  bool get hasMore => _hasMore;

  WalletTransactionController(this.repo)
      : super(const AsyncValue.loading()) {
    fetchTransactions();
  }

  Future<void> fetchTransactions({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        _page = 1;
        _transactions.clear();
        state = const AsyncValue.loading();
      }

      final response =
          await repo.fetchTransactions(page: _page, perPage: 10);

      _transactions.addAll(response.data);

      _hasMore = _page < response.pagination.lastPage;

      state = AsyncValue.data(List.from(_transactions));

      _page++;
    } catch (e, st) {
      print("Transaction Controller Error => $e");
      state = AsyncValue.error(e, st);
    }
  }
}
