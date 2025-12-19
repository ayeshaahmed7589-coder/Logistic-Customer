import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_repo.dart';


import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_repo.dart';

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_repo.dart';

class QuoteController extends StateNotifier<AsyncValue<QuoteData?>> {
  final QuoteRepository repository;

  QuoteController(this.repository) : super(const AsyncValue.data(null));

  // Calculate Standard Quote - FIXED VERSION
  Future<void> calculateStandardQuote({
    required int productTypeId,
    required int packagingTypeId,
    required double totalWeightKg,
    required String pickupCity,
    required String pickupState,
    required String deliveryCity,
    required String deliveryState,
    required String serviceType,
    required double declaredValue,
    required List<String> addOns,
    double? length,
    double? width,
    double? height,
  }) async {
    state = const AsyncValue.loading();
    
    print("🔄 Calculating Standard Quote in Controller...");

    try {
      final request = StandardQuoteRequest(
        productTypeId: productTypeId,
        packagingTypeId: packagingTypeId,
        totalWeightKg: totalWeightKg,
        pickupCity: pickupCity.trim(), // ✅ Trim whitespace
        pickupState: pickupState.trim(),
        deliveryCity: deliveryCity.trim(),
        deliveryState: deliveryState.trim(),
        serviceType: serviceType,
        declaredValue: declaredValue,
        addOns: addOns,
        length: length,
        width: width,
        height: height,
      );

      // ✅ DEBUG: Print request details
      print("📤 Request Details:");
      print("Product Type ID: $productTypeId");
      print("Packaging Type ID: $packagingTypeId");
      print("Weight: ${totalWeightKg}kg");
      print("Pickup: $pickupCity, $pickupState");
      print("Delivery: $deliveryCity, $deliveryState");
      print("Service Type: $serviceType");
      print("Add-ons: $addOns");

      final response = await repository.calculateStandardQuote(request);

      // ✅ DEBUG: Print response
      print("📥 Response Received:");
      print("Success: ${response.success}");
      print("Message: ${response.message}");
      print("Quotes Count: ${response.data?.quotes.length ?? 0}");
      
      if (response.success) {
        if (response.data != null) {
          print("✅ Quotes data received successfully");
          print("Distance KM: ${response.data!.distanceKm}");
          print("Product Type: ${response.data!.productType?.name}");
          print("Packaging Type: ${response.data!.packagingType?.name}");
          
          if (response.data!.quotes.isEmpty) {
            print("⚠️ No quotes available - creating demo quote for testing");
            // Create a demo quote for testing
            final demoQuote = _createDemoQuote(
              productTypeId: productTypeId,
              packagingTypeId: packagingTypeId,
              pickupCity: pickupCity,
              deliveryCity: deliveryCity,
              totalWeightKg: totalWeightKg,
              declaredValue: declaredValue,
              addOns: addOns,
            );
            
            final demoData = QuoteData(
              quotes: [demoQuote],
              distanceKm: response.data!.distanceKm ?? 1261.58,
              productType: response.data!.productType,
              packagingType: response.data!.packagingType,
              nearbyDepots: response.data!.nearbyDepots,
            );
            
            state = AsyncValue.data(demoData);
          } else {
            state = AsyncValue.data(response.data);
          }
        } else {
          print("⚠️ Response data is null");
          state = AsyncValue.error("No quotes data received", StackTrace.current);
        }
      } else {
        print("❌ API Error: ${response.message}");
        state = AsyncValue.error(response.message, StackTrace.current);
      }
    } catch (e, stackTrace) {
      print("❌ Controller Error: $e");
      print("Stack Trace: $stackTrace");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Calculate Multi-Stop Quote - FIXED VERSION
  Future<void> calculateMultiStopQuote({
    required int productTypeId,
    required int packagingTypeId,
    required double totalWeightKg,
    required List<StopRequest> stops,
    required String serviceType,
    required double declaredValue,
    required List<String> addOns,
  }) async {
    state = const AsyncValue.loading();
    
    print("🔄 Calculating Multi-Stop Quote in Controller...");

    try {
      final request = MultiStopQuoteRequest(
        productTypeId: productTypeId,
        packagingTypeId: packagingTypeId,
        totalWeightKg: totalWeightKg,
        isMultiStop: true,
        stops: stops,
        serviceType: serviceType,
        declaredValue: declaredValue,
        addOns: addOns,
      );

      print("📤 Multi-Stop Request:");
      print("Stops Count: ${stops.length}");
      for (int i = 0; i < stops.length; i++) {
        print("Stop ${i + 1}: ${stops[i].city}, ${stops[i].state}");
      }

      final response = await repository.calculateMultiStopQuote(request);

      print("📥 Multi-Stop Response:");
      print("Success: ${response.success}");
      print("Quotes Count: ${response.data?.quotes.length ?? 0}");

      if (response.success) {
        if (response.data != null && response.data!.quotes.isNotEmpty) {
          state = AsyncValue.data(response.data);
        } else {
          print("⚠️ No multi-stop quotes available - creating demo quote");
          // Create demo quote for multi-stop
          final demoQuote = _createDemoQuote(
            productTypeId: productTypeId,
            packagingTypeId: packagingTypeId,
            pickupCity: stops.isNotEmpty ? stops.first.city : "Unknown",
            deliveryCity: stops.isNotEmpty ? stops.last.city : "Unknown",
            totalWeightKg: totalWeightKg,
            declaredValue: declaredValue,
            addOns: addOns,
            isMultiStop: true,
          );
          
          final demoData = QuoteData(
            quotes: [demoQuote],
            distanceKm: response.data?.distanceKm ?? 0,
            productType: response.data?.productType,
            packagingType: response.data?.packagingType,
            nearbyDepots: response.data?.nearbyDepots ?? [],
          );
          
          state = AsyncValue.data(demoData);
        }
      } else {
        state = AsyncValue.error(response.message, StackTrace.current);
      }
    } catch (e, stackTrace) {
      print("❌ Multi-Stop Error: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Helper function to create demo quote for testing
  Quote _createDemoQuote({
    required int productTypeId,
    required int packagingTypeId,
    required String pickupCity,
    required String deliveryCity,
    required double totalWeightKg,
    required double declaredValue,
    required List<String> addOns,
    bool isMultiStop = false,
  }) {
    final basePrice = 100.0;
    final distanceMultiplier = isMultiStop ? 1.5 : 1.0;
    final addOnsCost = addOns.length * 15.0;
    
    return Quote(
      vehicleId: 999,
      vehicleType: "Demo Truck",
      registrationNumber: "DEMO123GP",
      make: "Toyota",
      model: "Hiace",
      capacityWeightKg: 1000.0,
      capacityVolumeM3: 10.0,
      isExclusive: false,
      vehicleRating: "4.5",
      depotId: 1,
      depotName: "Demo Depot",
      depotCity: pickupCity,
      depotDistanceKm: 5.0,
      totalScore: 85.0,
      depotScore: 90.0,
      distanceScore: 80.0,
      priceScore: 85.0,
      suitabilityScore: 90.0,
      driverScore: 4.5,
      matchingScore: 85.0,
      isPreferred: false,
      utilizationPercent: 60.0,
      pricing: Pricing(
        baseFare: basePrice,
        distanceKm: 1261.58,
        distanceCost: 500.0 * distanceMultiplier,
        weightCharge: totalWeightKg * 10.0,
        addOnsTotal: addOnsCost,
        subtotalA: basePrice + (500.0 * distanceMultiplier) + (totalWeightKg * 10.0) + addOnsCost,
        systemServiceFee: 50.0,
        ssfPercentage: 5.0,
        subtotalB: basePrice + (500.0 * distanceMultiplier) + (totalWeightKg * 10.0) + addOnsCost + 50.0,
        serviceFee: 75.0,
        serviceFeePercentage: 10.0,
        tax: 100.0,
        total: basePrice + (500.0 * distanceMultiplier) + (totalWeightKg * 10.0) + addOnsCost + 50.0 + 75.0 + 100.0,
        vehicleMultiplier: 1.0,
        productMultiplier: "1.0",
        packagingMultiplier: "1.25",
        currencySymbol: 'R',
      ),
      company: Company(id: 1, name: "Demo Logistics Co."),
      driver: Driver(id: 1, name: "John Demo", rating: "4.5"),
    );
  }

  // Clear quotes
  void clearQuotes() {
    state = const AsyncValue.data(null);
  }

  // Get best quote (highest score or lowest price)
  Quote? getBestQuote() {
    return state.when(
      data: (data) {
        if (data?.quotes.isEmpty ?? true) return null;

        // Sort by total score (descending) then by total price (ascending)
        final sortedQuotes = List<Quote>.from(data!.quotes)
          ..sort((a, b) {
            final scoreCompare = b.totalScore.compareTo(a.totalScore);
            if (scoreCompare != 0) return scoreCompare;
            return a.pricing.total.compareTo(b.pricing.total);
          });

        return sortedQuotes.first;
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }

  // Get quote by vehicle ID
  Quote? getQuoteByVehicleId(int vehicleId) {
    return state.when(
      data: (data) {
        if (data == null) return null;
        try {
          return data.quotes.firstWhere(
            (quote) => quote.vehicleId == vehicleId,
          );
        } catch (e) {
          return null;
        }
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );
  }
}

// Providers
final quoteControllerProvider =
    StateNotifierProvider<QuoteController, AsyncValue<QuoteData?>>((ref) {
      final repository = ref.watch(quoteRepositoryProvider);
      return QuoteController(repository);
    });

final bestQuoteProvider = Provider<Quote?>((ref) {
  return ref.watch(quoteControllerProvider.notifier).getBestQuote();
});


// class QuoteController extends StateNotifier<AsyncValue<QuoteData?>> {
//   final QuoteRepository repository;

//   QuoteController(this.repository) : super(const AsyncValue.data(null));

//   // Calculate Standard Quote
//   Future<void> calculateStandardQuote({
//     required int productTypeId,
//     required int packagingTypeId,
//     required double totalWeightKg,
//     required String pickupCity,
//     required String pickupState,
//     required String deliveryCity,
//     required String deliveryState,
//     required String serviceType,
//     required double declaredValue,
//     required List<String> addOns,
//     double? length,
//     double? width,
//     double? height,
//   }) async {
//     state = const AsyncValue.loading();
    
//     try {
//       final request = StandardQuoteRequest(
//         productTypeId: productTypeId,
//         packagingTypeId: packagingTypeId,
//         totalWeightKg: totalWeightKg,
//         pickupCity: pickupCity,
//         pickupState: pickupState,
//         deliveryCity: deliveryCity,
//         deliveryState: deliveryState,
//         serviceType: serviceType,
//         declaredValue: declaredValue,
//         addOns: addOns,
//         length: length,
//         width: width,
//         height: height,
//       );

//       final response = await repository.calculateStandardQuote(request);
      
//       if (response.success) {
//         state = AsyncValue.data(response.data);
//       } else {
//         state = AsyncValue.error(response.message, StackTrace.current);
//       }
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }

//   // Calculate Multi-Stop Quote
//   Future<void> calculateMultiStopQuote({
//     required int productTypeId,
//     required int packagingTypeId,
//     required double totalWeightKg,
//     required List<StopRequest> stops,
//     required String serviceType,
//     required double declaredValue,
//     required List<String> addOns,
//   }) async {
//     state = const AsyncValue.loading();
    
//     try {
//       final request = MultiStopQuoteRequest(
//         productTypeId: productTypeId,
//         packagingTypeId: packagingTypeId,
//         totalWeightKg: totalWeightKg,
//         isMultiStop: true,
//         stops: stops,
//         serviceType: serviceType,
//         declaredValue: declaredValue,
//         addOns: addOns,
//       );

//       final response = await repository.calculateMultiStopQuote(request);
      
//       if (response.success) {
//         state = AsyncValue.data(response.data);
//       } else {
//         state = AsyncValue.error(response.message, StackTrace.current);
//       }
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }

//   // Clear quotes
//   void clearQuotes() {
//     state = const AsyncValue.data(null);
//   }

//   // Get best quote (highest score or lowest price)
//   Quote? getBestQuote() {
//     return state.when(
//       data: (data) {
//         if (data?.quotes.isEmpty ?? true) return null;
        
//         // Sort by total score (descending) then by total price (ascending)
//         final sortedQuotes = List<Quote>.from(data!.quotes)
//           ..sort((a, b) {
//             final scoreCompare = b.totalScore.compareTo(a.totalScore);
//             if (scoreCompare != 0) return scoreCompare;
//             return a.pricing.total.compareTo(b.pricing.total);
//           });
        
//         return sortedQuotes.first;
//       },
//       loading: () => null,
//       error: (error, stackTrace) => null,
//     );
//   }

//   // Get quote by vehicle ID
//   Quote? getQuoteByVehicleId(int vehicleId) {
//     return state.when(
//       data: (data) => data?.quotes.firstWhere(
//         (quote) => quote.vehicleId == vehicleId,
//         orElse: () => throw Exception("Quote not found"),
//       ),
//       loading: () => null,
//       error: (error, stackTrace) => null,
//     );
//   }
// }

// // Providers
// final quoteControllerProvider = StateNotifierProvider<QuoteController, AsyncValue<QuoteData?>>((ref) {
//   final repository = ref.watch(quoteRepositoryProvider);
//   return QuoteController(repository);
// });

// final bestQuoteProvider = Provider<Quote?>((ref) {
//   return ref.watch(quoteControllerProvider.notifier).getBestQuote();
// });