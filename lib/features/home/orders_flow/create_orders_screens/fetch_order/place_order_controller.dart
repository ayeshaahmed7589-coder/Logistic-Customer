// place_order_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/fetch_order/place_order_modal.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/fetch_order/place_order_repo.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/order_cache_provider.dart';

// ✅ PROVIDERS
// ✅ PROVIDERS
final orderControllerProvider = StateNotifierProvider<OrderController, AsyncValue<OrderResponse?>>(
  (ref) => OrderController(ref: ref),
);

final placeOrderRepositoryProvider = Provider<PlaceOrderRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return PlaceOrderRepository(dio: dio, ref: ref);
  },
);

// ✅ CONTROLLER
class OrderController extends StateNotifier<AsyncValue<OrderResponse?>> {
  final Ref ref;

  OrderController({required this.ref}) : super(const AsyncData(null));

  // ✅ PLACE STANDARD ORDER
  Future<void> placeStandardOrder() async {
    try {
      state = const AsyncLoading();

      final repository = ref.read(placeOrderRepositoryProvider);
      final request = await repository.prepareStandardOrderData();
      final response = await repository.placeStandardOrder(request: request);
      
      // Clear cache after successful order
      ref.read(orderCacheProvider.notifier).clearCache();
      
      state = AsyncData(response);
    } catch (e, st) {
      print("❌ Error placing standard order: $e");
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // ✅ PLACE MULTI-STOP ORDER
  Future<void> placeMultiStopOrder() async {
    try {
      state = const AsyncLoading();

      final repository = ref.read(placeOrderRepositoryProvider);
      final request = await repository.prepareMultiStopOrderData();
      final response = await repository.placeMultiStopOrder(request: request);
      
      // Clear cache after successful order
      ref.read(orderCacheProvider.notifier).clearCache();
      
      state = AsyncData(response);
    } catch (e, st) {
      print("❌ Error placing multi-stop order: $e");
      state = AsyncError(e, st);
      rethrow;
    }
  }

  // ✅ CLEAR ORDER STATE
  void clearOrderState() {
    state = const AsyncData(null);
  }
}