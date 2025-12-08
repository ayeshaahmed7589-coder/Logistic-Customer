// lib/controllers/quote_calculation_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/fetch_order_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/fetch_order_repo.dart';

// class QuoteCalculationController
//     extends StateNotifier<AsyncValue<QuoteCalculationResponse?>> {
//   final QuoteRepository repo;

//   QuoteCalculationController(this.repo) : super(const AsyncValue.data(null));

//   Future<void> calculateQuote({
//     required double pickupLatitude,
//     required double pickupLongitude,
//     required double deliveryLatitude,
//     required double deliveryLongitude,
//     required String serviceType,
//     required String vehicleType,
//     double? totalWeight,
//   }) async {
//     state = const AsyncValue.loading();

//     try {
//       print("🔄 Calculating quote with:");
//       print("📍 Pickup: ($pickupLatitude, $pickupLongitude)");
//       print("📍 Delivery: ($deliveryLatitude, $deliveryLongitude)");
//       print("🚚 Service: $serviceType, Vehicle: $vehicleType");
//       print("⚖️ Total Weight: $totalWeight");

//       final result = await repo.calculateQuote(
//         pickupLat: pickupLatitude,
//         pickupLng: pickupLongitude,
//         deliveryLat: deliveryLatitude,
//         deliveryLng: deliveryLongitude,
//         serviceType: serviceType,
//         vehicleType: vehicleType,
//         totalWeight: totalWeight,
//       );

//       print("✅ Quote calculation successful");
//       print("📊 Distance: ${result.data?.distanceKm} km");
//       print("💰 Total: R${result.data?.pricing?.total ?? 0}");

//       state = AsyncValue.data(result);
//     } catch (e, st) {
//       print("⛔ Quote Calculation Error: $e");
//       print("Stack trace: $st");

//       // ✅ Even on error, provide a fallback quote
//       final fallbackQuote = QuoteCalculationResponse(
//         success: true,
//         data: QuoteData(
//           distanceKm: 5.0,
//           pricing: Pricing(
//             baseFare: 50.0,
//             distanceCost: 50.0,
//             weightCharge: totalWeight ?? 0.0,
//             serviceFee: 0.0,
//             subtotal: 100.0 + (totalWeight ?? 0.0),
//             tax: 5.0,
//             total: 105.0 + (totalWeight ?? 0.0),
//             currency: "ZAR",
//           ),
//         ),
//       );

//       state = AsyncValue.data(fallbackQuote);
//     }
//   }

//   void reset() {
//     state = const AsyncValue.data(null);
//   }
// }

// final quoteCalculationControllerProvider =
//     StateNotifierProvider<
//       QuoteCalculationController,
//       AsyncValue<QuoteCalculationResponse?>
//     >((ref) {
//       final repo = QuoteRepository(dio: ref.watch(dioProvider), ref: ref);
//       return QuoteCalculationController(repo);
//     });

class QuoteCalculationController
    extends StateNotifier<AsyncValue<QuoteCalculationResponse?>> {
  final QuoteRepository repo;

  QuoteCalculationController(this.repo) : super(const AsyncValue.data(null));

  Future<void> calculateQuote({
    required double pickupLatitude,
    required double pickupLongitude,
    required double deliveryLatitude,
    required double deliveryLongitude,
    required String serviceType,
    required String vehicleType,
    double? totalWeight,
    List<String>? addOns, // ✅ Add-ons parameter
    double? declaredValue, // ✅ Declared value parameter
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await repo.calculateQuote(
        pickupLat: pickupLatitude,
        pickupLng: pickupLongitude,
        deliveryLat: deliveryLatitude,
        deliveryLng: deliveryLongitude,
        serviceType: serviceType,
        vehicleType: vehicleType,
        totalWeight: totalWeight,
        addOns: addOns, // ✅ Pass add-ons
        declaredValue: declaredValue, // ✅ Pass declared value
      );

      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final quoteCalculationControllerProvider =
    StateNotifierProvider<
      QuoteCalculationController,
      AsyncValue<QuoteCalculationResponse?>
    >((ref) {
      final repo = QuoteRepository(dio: ref.watch(dioProvider), ref: ref);
      return QuoteCalculationController(repo);
    });
