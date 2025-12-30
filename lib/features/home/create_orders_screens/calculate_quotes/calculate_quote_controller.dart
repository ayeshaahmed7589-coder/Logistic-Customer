import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_repo.dart';

// ✅ FIXED QUOTE CONTROLLER - DEMO QUOTE REMOVED
class QuoteController extends StateNotifier<AsyncValue<QuoteData?>> {
  final QuoteRepository repository;
   Quote? _cachedBestQuote; // ✅ Cache the best quote

  QuoteController(this.repository) : super(const AsyncValue.data(null));

  // ✅ FIXED: Calculate Standard Quote WITHOUT DEMO
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
        pickupCity: pickupCity.trim(),
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

          // ❌❌❌ DEMO QUOTE CODE HATA DO YAHAN SE ❌❌❌
          // if (response.data!.quotes.isEmpty) {
          //   print("⚠️ No quotes available - creating demo quote for testing");
          //   // Create a demo quote for testing
          //   final demoQuote = _createDemoQuote(
          //     productTypeId: productTypeId,
          //     packagingTypeId: packagingTypeId,
          //     pickupCity: pickupCity,
          //     deliveryCity: deliveryCity,
          //     totalWeightKg: totalWeightKg,
          //     declaredValue: declaredValue,
          //     addOns: addOns,
          //   );
          //
          //   final demoData = QuoteData(
          //     quotes: [demoQuote],
          //     distanceKm: response.data!.distanceKm ?? 1261.58,
          //     productType: response.data!.productType,
          //     packagingType: response.data!.packagingType,
          //     nearbyDepots: response.data!.nearbyDepots,
          //   );
          //
          //   state = AsyncValue.data(demoData);
          // } else {
          //   state = AsyncValue.data(response.data);
          // }

          // ✅✅✅ SIRF ACTUAL API DATA USE KARO:
          state = AsyncValue.data(response.data);
        } else {
          print("⚠️ Response data is null");
          state = AsyncValue.error(
            "No quotes data received",
            StackTrace.current,
          );
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

  // ✅ FIXED: Calculate Multi-Stop Quote WITHOUT DEMO
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
        if (response.data != null) {
          // ❌❌❌ DEMO QUOTE CODE HATA DO YAHAN SE ❌❌❌
          // if (response.data!.quotes.isNotEmpty) {
          //   state = AsyncValue.data(response.data);
          // } else {
          //   print("⚠️ No multi-stop quotes available - creating demo quote");
          //   // Create demo quote for multi-stop
          //   final demoQuote = _createDemoQuote(
          //     productTypeId: productTypeId,
          //     packagingTypeId: packagingTypeId,
          //     pickupCity: stops.isNotEmpty ? stops.first.city : "Unknown",
          //     deliveryCity: stops.isNotEmpty ? stops.last.city : "Unknown",
          //     totalWeightKg: totalWeightKg,
          //     declaredValue: declaredValue,
          //     addOns: addOns,
          //     isMultiStop: true,
          //   );
          //
          //   final demoData = QuoteData(
          //     quotes: [demoQuote],
          //     distanceKm: response.data?.distanceKm ?? 0,
          //     productType: response.data?.productType,
          //     packagingType: response.data?.packagingType,
          //     nearbyDepots: response.data?.nearbyDepots ?? [],
          //   );
          //
          //   state = AsyncValue.data(demoData);
          // }

          // ✅✅✅ SIRF ACTUAL API DATA USE KARO:
          state = AsyncValue.data(response.data);
        } else {
          print("⚠️ Response data is null");
          state = AsyncValue.error(
            "No quotes data received",
            StackTrace.current,
          );
        }
      } else {
        state = AsyncValue.error(response.message, StackTrace.current);
      }
    } catch (e, stackTrace) {
      print("❌ Multi-Stop Error: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // ❌❌❌ YE PURA FUNCTION DELETE KAR DO (DEMO QUOTE CREATION)
  // Quote _createDemoQuote({
  //   required int productTypeId,
  //   required int packagingTypeId,
  //   required String pickupCity,
  //   required String deliveryCity,
  //   required double totalWeightKg,
  //   required double declaredValue,
  //   required List<String> addOns,
  //   bool isMultiStop = false,
  // }) {
  //   ...
  // }

  // Clear quotes
  void clearQuotes() {
    state = const AsyncValue.data(null);
  }

  // Get best quote (highest score or lowest price)
  // ✅ FIXED: Get best quote automatically
  // ✅ FIXED: Get best quote automatically
  Quote? getBestQuote() {
    return state.when(
      data: (data) {
        if (data == null || data.quotes.isEmpty) {
          print("❌ No quotes available in getBestQuote");
          return null;
        }

        print("📊 Getting best quote from ${data.quotes.length} quotes");

        // ✅ Sort by total score (descending)
        final sortedQuotes = List<Quote>.from(data.quotes)
          ..sort((a, b) {
            final scoreCompare = b.totalScore.compareTo(a.totalScore);
            if (scoreCompare != 0) {
              print("🔀 Sorting by score: ${b.totalScore} vs ${a.totalScore}");
              return scoreCompare;
            }
            
            // ✅ If scores equal, sort by price (ascending)
            final priceCompare = a.pricing.total.compareTo(b.pricing.total);
            if (priceCompare != 0) {
              print("🔀 Sorting by price: ${a.pricing.total} vs ${b.pricing.total}");
              return priceCompare;
            }
            
            return 0;
          });

        final bestQuote = sortedQuotes.first;
        
        // ✅ FORCE UPDATE TO BEST QUOTE PROVIDER
        print("🏆 Best Quote Selected: ${bestQuote.vehicleType} - Score: ${bestQuote.totalScore}");
        print("💰 Price: R${bestQuote.pricing.total}");
        
        // ✅ IMPORTANT: Print all quotes for debugging
        print("\n📋 ALL QUOTES AVAILABLE:");
        for (int i = 0; i < data.quotes.length; i++) {
          final quote = data.quotes[i];
          print("${i + 1}. ${quote.vehicleType} - Score: ${quote.totalScore} - Price: R${quote.pricing.total}");
        }
        
        return bestQuote;
      },
      loading: () {
        print("🔄 Quotes loading...");
        return null;
      },
      error: (error, stackTrace) {
        print("❌ Error getting best quote: $error");
        return null;
      },
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
// ✅ FIXED: Best Quote Provider

final quoteControllerProvider =
    StateNotifierProvider<QuoteController, AsyncValue<QuoteData?>>((ref) {
      final repository = ref.watch(quoteRepositoryProvider);
      return QuoteController(repository);
    });

    // ✅ FIXED: Best Quote Provider with auto-selection
final bestQuoteProvider = Provider<Quote?>((ref) {
  final quoteState = ref.watch(quoteControllerProvider);
  
  print("🔍 bestQuoteProvider called - State: ${quoteState.value?.quotes.length ?? 0} quotes");
  
  return quoteState.when(
    data: (data) {
      if (data == null) {
        print("❌ bestQuoteProvider: QuoteData is null");
        return null;
      }
      
      if (data.quotes.isEmpty) {
        print("❌ bestQuoteProvider: No quotes in data");
        return null;
      }
      
      print("📊 bestQuoteProvider: Found ${data.quotes.length} quotes");
      
      // ✅ Simple auto-selection: First quote is best quote
      final bestQuote = data.quotes.first;
      print("🏆 bestQuoteProvider Auto-Selected: ${bestQuote.vehicleType}");
      print("💰 Price: R${bestQuote.pricing.total}");
      print("⭐ Score: ${bestQuote.totalScore}");
      
      return bestQuote;
    },
    loading: () {
      print("🔄 bestQuoteProvider: Loading...");
      return null;
    },
    error: (error, stackTrace) {
      print("❌ bestQuoteProvider Error: $error");
      return null;
    },
  );
});

// final bestQuoteProvider = Provider<Quote?>((ref) {
//   return ref.watch(quoteControllerProvider.notifier).getBestQuote();
// });
