import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/pickup_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/pickup_repo.dart';

class DefaultAddressController
    extends StateNotifier<AsyncValue<DefaultAddressModel>> {
  final DefaultAddressRepository repository;

  DefaultAddressController(this.repository)
      : super(const AsyncValue.loading());

  Future<void> loadDefaultAddress() async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.getDefaultAddress();
      state = AsyncValue.data(result);
    } catch (e, st) {
      print("⛔ Controller Error => $e");
      state = AsyncValue.error(e, st);
    }
  }
}

final defaultAddressControllerProvider =
    StateNotifierProvider<DefaultAddressController,
        AsyncValue<DefaultAddressModel>>((ref) {
  return DefaultAddressController(
    ref.watch(defaultAddressRepositoryProvider),
  );
});



//All Address

// all_address_controller.dart
class AllAddressController
    extends StateNotifier<AsyncValue<AllAddressModel?>> {
  final AllAddressRepository repo;

  AllAddressController(this.repo) : super(const AsyncValue.loading());

  Future<void> loadAllAddress() async {
    state = const AsyncValue.loading();

    try {
      final result = await repo.getAllAddress();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final allAddressControllerProvider =
    StateNotifierProvider<AllAddressController, AsyncValue<AllAddressModel?>>(
        (ref) {
  final repo = ref.watch(allAddressRepositoryProvider);
  return AllAddressController(repo);
});
