// payment_check_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'payment_method_model.dart';
import 'payment_method_repo.dart';

final paymentCheckControllerProvider =
    StateNotifierProvider<
      PaymentCheckController,
      AsyncValue<PaymentCheckModel?>
    >((ref) {
      final repo = ref.watch(paymentCheckRepositoryProvider);
      return PaymentCheckController(repo);
    });

class PaymentCheckController
    extends StateNotifier<AsyncValue<PaymentCheckModel?>> {
  final PaymentCheckRepository repo;

  PaymentCheckController(this.repo) : super(const AsyncValue.data(null));

  Future<void> checkPayment({
    required double amount,
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await repo.checkPaymentOptions(amount: amount);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
