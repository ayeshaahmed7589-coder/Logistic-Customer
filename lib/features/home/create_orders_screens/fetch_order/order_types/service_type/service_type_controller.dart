import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/service_type/service_type_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/service_type/service_type_repo.dart';

class ServiceTypeController
    extends StateNotifier<AsyncValue<List<ServiceTypeItem>>> {
  final ServiceTypeRepository repository;

  ServiceTypeController(this.repository) : super(const AsyncValue.loading());

  // Load service types
  Future<void> loadServiceTypes() async {
    state = const AsyncValue.loading();
    try {
      final response = await repository.getServiceTypes();
      state = AsyncValue.data(response.data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Get item by ID (value)
  ServiceTypeItem? getItemById(String id) {
    return state.when(
      data: (items) {
        try {
          return items.firstWhere((item) => item.value == id);
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Get default service type (first one)
  ServiceTypeItem? getDefaultServiceType() {
    return state.when(
      data: (items) => items.isNotEmpty ? items[0] : null,
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Get item by value
  ServiceTypeItem? getItemByValue(String value) {
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

  // Refresh
  Future<void> refresh() async {
    return loadServiceTypes();
  }
}

// Providers
final serviceTypeControllerProvider =
    StateNotifierProvider<
      ServiceTypeController,
      AsyncValue<List<ServiceTypeItem>>
    >((ref) {
      final repo = ref.watch(serviceTypeRepositoryProvider);
      return ServiceTypeController(repo);
    });

// Provider for service type items
final serviceTypeItemsProvider = Provider<List<ServiceTypeItem>>((ref) {
  final state = ref.watch(serviceTypeControllerProvider);
  return state.when(
    data: (items) => items,
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

// Provider for default service type
final defaultServiceTypeProvider = Provider<ServiceTypeItem?>((ref) {
  final state = ref.watch(serviceTypeControllerProvider);
  return state.when(
    data: (items) => items.isNotEmpty ? items[0] : null,
    loading: () => null,
    error: (error, stackTrace) => null,
  );
});
