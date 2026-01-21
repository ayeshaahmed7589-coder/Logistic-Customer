import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'order_details_modal.dart';
import 'order_details_repo.dart';

final orderDetailsControllerProvider =
    StateNotifierProvider.family<
        OrderDetailsController,
        AsyncValue<OrderDetailsModel?>,
        int>((ref, orderId) {
  final repo = ref.watch(orderDetailsRepositoryProvider);
  return OrderDetailsController(repo, orderId);
});

class OrderDetailsController
    extends StateNotifier<AsyncValue<OrderDetailsModel?>> {
  final OrderDetailsRepository repo;
  final int orderId;

  OrderDetailsController(this.repo, this.orderId)
      : super(const AsyncValue.loading()) {
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    state = const AsyncValue.loading();
    try {
      final data = await repo.getOrderDetails(orderId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
