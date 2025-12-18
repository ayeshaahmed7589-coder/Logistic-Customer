import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // ✅ FIXED: Calculate Standard Quote with better error handling
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
    
    print("🚀 CALCULATING STANDARD QUOTE");
    print("📍 Pickup: $pickupCity, $pickupState");
    print("📍 Delivery: $deliveryCity, $deliveryState");
    print("📦 Product ID: $productTypeId, Packaging ID: $packagingTypeId");
    print("⚖️ Weight: ${totalWeightKg}kg");
    print("💰 Declared Value: $declaredValue");
    print("➕ Add-ons: $addOns");
    print("📏 Dimensions: ${length ?? 'N/A'}x${width ?? 'N/A'}x${height ?? 'N/A'}");

    try {
      final request = StandardQuoteRequest(
        productTypeId: productTypeId,
        packagingTypeId: packagingTypeId,
        totalWeightKg: totalWeightKg,
        pickupCity: pickupCity,
        pickupState: pickupState,
        deliveryCity: deliveryCity,
        deliveryState: deliveryState,
        serviceType: serviceType,
        declaredValue: declaredValue,
        addOns: addOns,
        length: length,
        width: width,
        height: height,
      );

      print("📤 SENDING REQUEST TO: ${ApiUrls.postCalculationStandard}");
      print("📦 Request Body: ${jsonEncode(request.toJson())}");

      final response = await repository.calculateStandardQuote(request);

      print("📥 API Response Status: SUCCESS");
      print("📥 API Message: ${response.message}");
      print("📥 Quotes Count: ${response.data?.quotes.length ?? 0}");

      if (response.success) {
        if ((response.data?.quotes.isEmpty ?? true)) {
          print("⚠️ WARNING: No quotes available from API");
          print("ℹ️ API returned empty quotes array");
          print("ℹ️ This could be due to:");
          print("   1. No vehicles available for this route");
          print("   2. Product/packaging type not supported");
          print("   3. Weight exceeds available capacity");
          print("   4. Distance too far for available vehicles");
          
          // Create empty but valid QuoteData
          final emptyQuoteData = QuoteData(
            quotes: [],
            distanceKm: 0,
            productType: null,
            packagingType: null,
            nearbyDepots: [],
          );
          
          state = AsyncValue.data(emptyQuoteData);
        } else {
          state = AsyncValue.data(response.data);
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

  // ✅ FIXED: Calculate Multi-Stop Quote
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

    print("🚀 CALCULATING MULTI-STOP QUOTE");
    print("📍 Stops Count: ${stops.length}");
    for (var i = 0; i < stops.length; i++) {
      print("   Stop ${i + 1}: ${stops[i].city}, ${stops[i].state} (${stops[i].stopType})");
    }

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

      print("📤 SENDING REQUEST TO: ${ApiUrls.postCalculationMultiStop}");
      print("📦 Request Body: ${jsonEncode(request.toJson())}");

      final response = await repository.calculateMultiStopQuote(request);

      print("📥 API Response Status: SUCCESS");
      print("📥 API Message: ${response.message}");
      print("📥 Quotes Count: ${response.data?.quotes.length ?? 0}");

      if (response.success) {
        if ((response.data?.quotes.isEmpty ?? true)) {
          print("⚠️ WARNING: No quotes available for multi-stop route");
          
          // Create empty but valid QuoteData
          final emptyQuoteData = QuoteData(
            quotes: [],
            distanceKm: 0,
            productType: null,
            packagingType: null,
            nearbyDepots: [],
          );
          
          state = AsyncValue.data(emptyQuoteData);
        } else {
          state = AsyncValue.data(response.data);
        }
      } else {
        state = AsyncValue.error(response.message, StackTrace.current);
      }
    } catch (e, stackTrace) {
      print("❌ Multi-Stop Controller Error: $e");
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Clear quotes
  void clearQuotes() {
    state = const AsyncValue.data(null);
  }

  // ✅ IMPROVED: Get best quote 
  Quote? getBestQuote() {
    return state.when(
      data: (data) {
        if (data == null || data.quotes.isEmpty) {
          print("ℹ️ No quotes available in getBestQuote()");
          return null;
        }

        // Sort by total score (descending) then by total price (ascending)
        final sortedQuotes = List<Quote>.from(data.quotes)
          ..sort((a, b) {
            final scoreCompare = b.totalScore.compareTo(a.totalScore);
            if (scoreCompare != 0) return scoreCompare;
            return a.pricing.total.compareTo(b.pricing.total);
          });

        final best = sortedQuotes.first;
        print("✅ Best Quote Selected:");
        print("   Vehicle: ${best.vehicleType}");
        print("   Price: R${best.pricing.total}");
        print("   Score: ${best.totalScore}%");
        
        return best;
      },
      loading: () {
        print("⏳ Loading quotes...");
        return null;
      },
      error: (error, stackTrace) {
        print("❌ Error in getBestQuote: $error");
        return null;
      },
    );
  }

  // Get quote by vehicle ID
  Quote? getQuoteByVehicleId(int vehicleId) {
    return state.when(
      data: (data) => data?.quotes.firstWhere(
        (quote) => quote.vehicleId == vehicleId,
        orElse: () => throw Exception("Quote not found for vehicle ID: $vehicleId"),
      ),
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