import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/add_ons/add_ons_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/add_ons/add_ons_repo.dart';

class AddOnsController extends StateNotifier<AsyncValue<AddOnsData>> {
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

  // Get item by ID
  AddOnItem? getItemById(String id) {
    return state.when(
      data: (data) => data.addOns.firstWhere(
        (item) => item.id == id,
        orElse: () => throw Exception("Item not found"),
      ),
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Get add-ons by category (optional filtering)
  List<AddOnItem> getAddOnsByType(String type) {
    return state.when(
      data: (data) => data.addOns.where((item) => item.type == type).toList(),
      loading: () => [],
      error: (error, stackTrace) => [],
    );
  }

  // Refresh
  Future<void> refresh() async {
    return loadAddOns();
  }
}

// Providers
final addOnsControllerProvider = 
    StateNotifierProvider<AddOnsController, AsyncValue<AddOnsData>>((ref) {
  final repo = ref.watch(addOnsRepositoryProvider);
  return AddOnsController(repo);
});

// Provider for add-ons items
final addOnsItemsProvider = Provider<List<AddOnItem>>((ref) {
  final state = ref.watch(addOnsControllerProvider);
  return state.when(
    data: (data) => data.addOns,
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

// Provider for selected add-ons with calculated costs
final selectedAddOnsWithCostProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final addOnsState = ref.watch(addOnsControllerProvider);
  final selectedAddons = ref.watch(selectedAddonsProvider);
  final declaredValue = ref.watch(declaredValueProvider);
  
  return addOnsState.when(
    data: (data) {
      List<Map<String, dynamic>> result = [];
      
      for (var addonId in selectedAddons) {
        final addon = data.addOns.firstWhere(
          (item) => item.id == addonId,
          orElse: () => AddOnItem(
            id: '',
            name: '',
            description: '',
            type: 'fixed',
            rate: 0.0,
          ),
        );
        
        if (addon.id.isNotEmpty) {
          final cost = addon.calculateCost(declaredValue);
          result.add({
            'id': addon.id,
            'name': addon.name,
            'cost': cost,
            'type': addon.type,
            'displayText': addon.getCostText(),
          });
        }
      }
      
      return result;
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

// Helper providers
final selectedAddonsProvider = StateProvider<List<String>>((ref) => []);
final declaredValueProvider = StateProvider<double>((ref) => 0.0);