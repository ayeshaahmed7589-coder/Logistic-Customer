import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/add_ons/add_ons_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/add_ons/add_ons_repo.dart';

class AddOnsController extends StateNotifier<AsyncValue<List<AddOnItem>>> {
  final AddOnsRepository repository;

  AddOnsController(this.repository) : super(const AsyncValue.loading());

  // Load add-ons
  Future<void> loadAddOns() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.getAddOns();
      state = AsyncValue.data(response.data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // ✅ Get item by value
  AddOnItem? getItemByValue(String value) {
    return state.when(
      data: (items) {
        try {
          return items.firstWhere((item) => item.value == value);
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // ✅ Get add-ons by price type
  List<AddOnItem> getAddOnsByPriceType(String priceType) {
    return state.when(
      data: (items) =>
          items.where((item) => item.priceType == priceType).toList(),
      loading: () => [],
      error: (error, stackTrace) => [],
    );
  }

  // ✅ Get all fixed price add-ons
  List<AddOnItem> getFixedPriceAddOns() {
    return state.when(
      data: (items) =>
          items.where((item) => item.priceType == 'fixed').toList(),
      loading: () => [],
      error: (error, stackTrace) => [],
    );
  }

  // ✅ Get all percentage add-ons
  List<AddOnItem> getPercentageAddOns() {
    return state.when(
      data: (items) =>
          items.where((item) => item.priceType == 'percentage').toList(),
      loading: () => [],
      error: (error, stackTrace) => [],
    );
  }

  // ✅ Refresh
  Future<void> refresh() async {
    return loadAddOns();
  }
}

// ✅ Providers
final addOnsControllerProvider =
    StateNotifierProvider<AddOnsController, AsyncValue<List<AddOnItem>>>((ref) {
      final repo = ref.watch(addOnsRepositoryProvider);
      return AddOnsController(repo);
    });

// ✅ Provider for add-ons items
final addOnsItemsProvider = Provider<List<AddOnItem>>((ref) {
  final state = ref.watch(addOnsControllerProvider);
  return state.when(
    data: (items) => items,
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

// ✅ Provider for selected add-ons with calculated costs
final selectedAddOnsWithCostProvider = Provider<List<Map<String, dynamic>>>((
  ref,
) {
  final addOnsState = ref.watch(addOnsControllerProvider);
  final selectedAddons = ref.watch(selectedAddonsProvider);
  final declaredValue = ref.watch(declaredValueProvider);

  return addOnsState.when(
    data: (items) {
      List<Map<String, dynamic>> result = [];

      for (var addonValue in selectedAddons) {
        try {
          final addon = items.firstWhere((item) => item.value == addonValue);
          final cost = addon.calculateCost(declaredValue);
          result.add({
            'value': addon.value,
            'label': addon.label,
            'cost': cost,
            'priceType': addon.priceType,
            'displayText': addon.getCostText(),
            'icon': addon.icon,
          });
        } catch (e) {
          // Skip if add-on not found
        }
      }

      return result;
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

// ✅ Helper providers
final selectedAddonsProvider = StateProvider<List<String>>((ref) => []);
final declaredValueProvider = StateProvider<double>((ref) => 0.0);
