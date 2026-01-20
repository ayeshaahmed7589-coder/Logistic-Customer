import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'order_tracking_model.dart';
import 'order_tracking_repo.dart';

final orderTrackingControllerProvider =
    StateNotifierProvider.family<
        OrderTrackingController,
        AsyncValue<OrderTrackingModel?>,
        String>((ref, trackingCode) {
  final repo = ref.watch(orderTrackingRepositoryProvider);
  return OrderTrackingController(repo, trackingCode);
});

class OrderTrackingController
    extends StateNotifier<AsyncValue<OrderTrackingModel?>> {
  final OrderTrackingRepository repo;
  final String trackingCode;

  OrderTrackingController(this.repo, this.trackingCode)
      : super(const AsyncValue.loading()) {
    fetchTracking();
  }

  Future<void> fetchTracking() async {
    state = const AsyncValue.loading();
    try {
      final data = await repo.trackOrder(trackingCode);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
