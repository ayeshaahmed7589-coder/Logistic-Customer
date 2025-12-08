// place_order_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/place_order_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/place_order_repo.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_controller.dart';
import 'package:logisticscustomer/features/home/order_successful.dart';

// ✅ REMOVE DUPLICATE PROVIDER DECLARATION FROM HERE

class OrderController extends StateNotifier<AsyncValue<OrderResponse?>> {
  final OrderRepository repo;
  final Ref ref;

  OrderController(this.repo, this.ref) : super(const AsyncValue.data(null));

  Future<void> placeOrder(BuildContext context) async {
    state = const AsyncValue.loading();

    try {
      print("🔄 Starting order placement process...");

      // ✅ OrderRequestBody prepare karo
      final orderRequestBody = await repo.prepareOrderData();

      // ✅ API call karo
      final result = await repo.placeOrder(orderRequestBody: orderRequestBody);

      state = AsyncValue.data(result);

      // ✅ CACHE CLEAR KARO
      _clearOrderCache();

      print("✅ Order placed successfully! Order #: ${result.data.orderNumber}");

      // ✅ SUCCESS MESSAGE AUR NAVIGATION
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Order placed successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // ✅ Order successful screen pe navigate karo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderSuccessful(
              orderNumber: result.data.orderNumber,
              totalAmount: result.data.finalCost,
            ),
          ),
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      print("⛔ Order Controller Error: $e");
      print("Stack trace: $st");

      // ✅ SPECIFIC ERROR HANDLING
      String errorMessage = "Order failed";

      if (e.toString().contains("Validation failed")) {
        errorMessage = "Please check your information and try again.";
      } else if (e.toString().contains("Insufficient wallet balance")) {
        errorMessage =
            "Insufficient wallet balance. Please select another payment method.";
      } else if (e.toString().contains("Customer profile not found")) {
        errorMessage = "Customer profile not found. Please login again.";
      } else if (e.toString().contains("Server error")) {
        errorMessage = "Server error. Please try again later.";
      } else {
        errorMessage = e.toString();
      }

      // Show error to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  // ✅ CACHE CLEAR METHOD
  void _clearOrderCache() {
    try {
      // Clear order cache
      ref.read(orderCacheProvider.notifier).clearAll();

      // Clear package items
      ref.read(packageItemsProvider.notifier).state = [];

      print("✅ Order cache and items cleared successfully");
    } catch (cacheError) {
      print("⚠️ Cache clearing error: $cacheError");
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// ✅ PROVIDER DECLARATION
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(dio: ref.watch(dioProvider), ref: ref);
});

final orderControllerProvider =
    StateNotifierProvider.autoDispose<
      OrderController,
      AsyncValue<OrderResponse?>
    >((ref) {
      final repo = ref.watch(orderRepositoryProvider);
      return OrderController(repo, ref);
    });

// class OrderController extends StateNotifier<AsyncValue<OrderResponse?>> {
//   final OrderRepository repo;
//   final Ref ref;

//   OrderController(this.repo, this.ref) : super(const AsyncValue.data(null));

//   Future<void> placeOrder(BuildContext context) async {
//     state = const AsyncValue.loading();

//     try {
//       print("🔄 Starting order placement process...");

//       // Prepare order data
//       final orderData = await repo.prepareOrderData();

//       // Call API
//       print("📤 Sending order to API...");
//       final result = await repo.placeOrder(orderData: orderData);

//       state = AsyncValue.data(result);

//       // ✅ CLEAR CACHE AFTER SUCCESS
//       _clearOrderCache();

//       print("✅ Order placed successfully! Order #: ${result.data.orderNumber}");
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       print("⛔ Order Controller Error: $e");
//       print("Stack trace: $st");

//       // Show error to user
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Order failed: ${e.toString()}"),
//             backgroundColor: Colors.red,
//             duration: Duration(seconds: 3),
//           ),
//         );
//       }
//     }
//   }

//   // ✅ HELPER METHOD TO CLEAR CACHE
//   void _clearOrderCache() {
//     try {
//       // Clear order cache
//       ref.read(orderCacheProvider.notifier).clearAll();

//       // Clear package items
//       ref.read(packageItemsProvider.notifier).state = [];

//       print("✅ Order cache and items cleared successfully");
//     } catch (cacheError) {
//       print("⚠️ Cache clearing error: $cacheError");
//     }
//   }

//   void reset() {
//     state = const AsyncValue.data(null);
//   }
// }

// // ✅ SINGLE PROVIDER DECLARATION
// final orderRepositoryProvider = Provider<OrderRepository>((ref) {
//   return OrderRepository(dio: ref.watch(dioProvider), ref: ref);
// });

// final orderControllerProvider =
//     StateNotifierProvider.autoDispose<
//       OrderController,
//       AsyncValue<OrderResponse?>
//     >((ref) {
//       final repo = ref.watch(
//         orderRepositoryProvider,
//       ); // ✅ Use existing provider
//       return OrderController(repo, ref); // ✅ BOTH parameters passed
//     });
