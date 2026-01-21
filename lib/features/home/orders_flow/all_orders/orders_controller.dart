// lib/features/orders/controllers/order_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/orders_flow/all_orders/get_all_orders_modal.dart';
import 'package:logisticscustomer/features/home/orders_flow/all_orders/orders_repo.dart';


class OrderController extends StateNotifier<OrderState> {
  final OrderRepository repository;
  OrderController(this.repository) : super(OrderState());

  // Load initial orders
  Future<void> loadOrders() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await repository.getAllOrders();
      state = state.copyWith(
        orders: response.data.orders,
        isLoading: false,
        meta: response.meta,
        currentPage: 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Load more orders (pagination)
  Future<void> loadMoreOrders() async {
    try {
      // Check if we have more pages
      if (state.isLoadingMore || state.currentPage >= state.meta.lastPage) {
        return;
      }

      state = state.copyWith(isLoadingMore: true);
      
      final nextPage = state.currentPage + 1;
      final response = await repository.getAllOrders(page: nextPage);
      
      state = state.copyWith(
        orders: [...state.orders, ...response.data.orders],
        isLoadingMore: false,
        meta: response.meta,
        currentPage: nextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  // Filter orders by status
  Future<void> filterByStatus(String status) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await repository.getOrdersByStatus(status);
      state = state.copyWith(
        orders: response.data.orders,
        isLoading: false,
        meta: response.meta,
        currentPage: 1,
        currentFilter: status,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    return loadOrders();
  }
}

// Order State for better state management
class OrderState {
  final List<AlOrder> orders;
  final AlMeta meta;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final String currentFilter;

  OrderState({
    this.orders = const [],
    this.meta = const AlMeta(
      currentPage: 1,
      lastPage: 1,
      perPage: 10,
      total: 0,
    ),
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.currentFilter = 'All',
  });

  OrderState copyWith({
    List<AlOrder>? orders,
    AlMeta? meta,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    String? currentFilter,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      meta: meta ?? this.meta,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

final orderControllerProvider = StateNotifierProvider<OrderController, OrderState>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderController(repo);
});