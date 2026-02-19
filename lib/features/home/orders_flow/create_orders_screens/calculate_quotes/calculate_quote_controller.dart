import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/calculate_quotes/calculate_quote_repo.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';
import 'package:logisticscustomer/features/home/orders_flow/create_orders_screens/fetch_order/common_modal.dart';

// ✅ PROVIDERS
final quoteControllerProvider =
    StateNotifierProvider<QuoteController, AsyncValue<QuoteData?>>(
      (ref) => QuoteController(ref: ref),
    );

final bestQuoteProvider = StateProvider<Quote?>((ref) => null);

final calculateQuoteRepositoryProvider = Provider<CalculateQuoteRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return CalculateQuoteRepository(dio: dio, ref: ref);
});

// ✅ CONTROLLER
class QuoteController extends StateNotifier<AsyncValue<QuoteData?>> {
  final Ref ref;

  QuoteController({required this.ref}) : super(const AsyncData(null));

  // ✅ CALCULATE STANDARD QUOTE
  Future<void> calculateStandardQuote({
    required int productTypeId,
    required int packagingTypeId,
    required int quantity,
    required double weightPerItem,
    required String pickupAddress,
    required double pickupLatitude,
    required double pickupLongitude,
    required String pickupCity,
    required String pickupState,
    required String deliveryAddress,
    required double deliveryLatitude,
    required double deliveryLongitude,
    required String deliveryCity,
    required String deliveryState,
    required String serviceType,
    double? declaredValue,
    List<String>? addOns,
    double? length,
    double? width,
    double? height,
  }) async {
    try {
      state = const AsyncLoading();

      final request = StandardQuoteRequest(
        productTypeId: productTypeId,
        packagingTypeId: packagingTypeId,
        quantity: quantity,
        weightPerItem: weightPerItem,
        isMultiStop: false,
        pickupAddress: pickupAddress,
        pickupLatitude: pickupLatitude,
        pickupLongitude: pickupLongitude,
        pickupCity: pickupCity,
        pickupState: pickupState,
        deliveryAddress: deliveryAddress,
        deliveryLatitude: deliveryLatitude,
        deliveryLongitude: deliveryLongitude,
        deliveryCity: deliveryCity,
        deliveryState: deliveryState,
        serviceType: serviceType,
        addOns: addOns,
        declaredValue: declaredValue,
        length: length,
        width: width,
        height: height,
      );

      final repository = ref.read(calculateQuoteRepositoryProvider);
      final result = await repository.calculateStandardQuote(request: request);

      // Sort quotes by total score (descending)
      if (result.quotes.isNotEmpty) {
        result.quotes.sort((a, b) => b.totalScore.compareTo(a.totalScore));
        ref.read(bestQuoteProvider.notifier).state = result.quotes.first;
      }

      state = AsyncData(result);
    } catch (e, st) {
      print("❌ Error in calculateStandardQuote: $e");
      // Pass the exact error message from backend
      state = AsyncError(e.toString(), st);
      rethrow;
    }
  }

  // ✅ CALCULATE MULTI-STOP QUOTE
  Future<void> calculateMultiStopQuote({
    required int productTypeId,
    required int packagingTypeId,
    required List<StopRequest> stops,
    required String serviceType,
    int? quantity,
    // double? weightPerItem,
    required double weightPerItem,
    double? declaredValue,
    List<String>? addOns,
    double? length,
    double? width,
    double? height,
  }) async {
    try {
      state = const AsyncLoading();

      final request = MultiStopQuoteRequest(
        productTypeId: productTypeId,
        packagingTypeId: packagingTypeId,
        isMultiStop: true,
        stops: stops,
        serviceType: serviceType,
        addOns: addOns,
        declaredValue: declaredValue,
        quantity: quantity,
        weightPerItem: weightPerItem,
        length: length,
        width: width,
        height: height,
      );

      final repository = ref.read(calculateQuoteRepositoryProvider);
      final result = await repository.calculateMultiStopQuote(request: request);

      // Sort quotes by total score (descending)
      if (result.quotes.isNotEmpty) {
        result.quotes.sort((a, b) => b.totalScore.compareTo(a.totalScore));
        ref.read(bestQuoteProvider.notifier).state = result.quotes.first;
      }

      state = AsyncData(result);
    } catch (e, st) {
      print("❌ Error in calculateMultiStopQuote: $e");
      state = AsyncError(e.toString(), st);
      rethrow;
    }
  }

  // ✅ SELECT A QUOTE AS BEST QUOTE
  void selectQuote(Quote quote) {
    ref.read(bestQuoteProvider.notifier).state = quote;
  }

  // ✅ CLEAR QUOTES
  void clearQuotes() {
    state = const AsyncData(null);
    ref.read(bestQuoteProvider.notifier).state = null;
  }

  // ✅ GET BEST QUOTE
  Quote? getBestQuote() {
    return ref.read(bestQuoteProvider);
  }
}

// // ✅ PROVIDERS
// final quoteControllerProvider =
//     StateNotifierProvider<QuoteController, AsyncValue<QuoteData?>>(
//       (ref) => QuoteController(ref: ref),
//     );

// final bestQuoteProvider = StateProvider<Quote?>((ref) => null);

// final calculateQuoteRepositoryProvider = Provider<CalculateQuoteRepository>((
//   ref,
// ) {
//   final dio = ref.watch(dioProvider);
//   return CalculateQuoteRepository(dio: dio, ref: ref);
// });

// // ✅ CONTROLLER
// class QuoteController extends StateNotifier<AsyncValue<QuoteData?>> {
//   final Ref ref;

//   QuoteController({required this.ref}) : super(const AsyncData(null));

//   // ✅ CALCULATE STANDARD QUOTE
//   // ✅ CALCULATE STANDARD QUOTE

//   // ✅ CALCULATE STANDARD QUOTE - With better error handling
//   Future<void> calculateStandardQuote({
//     required int productTypeId,
//     required int packagingTypeId,
//     required int quantity,
//     required double weightPerItem,
//     required String pickupAddress,
//     required double pickupLatitude,
//     required double pickupLongitude,
//     required String pickupCity,
//     required String pickupState,
//     required String deliveryAddress,
//     required double deliveryLatitude,
//     required double deliveryLongitude,
//     required String deliveryCity,
//     required String deliveryState,
//     required String serviceType,
//     double? declaredValue,
//     List<String>? addOns,
//     double? length,
//     double? width,
//     double? height,
//   }) async {
//     try {
//       state = const AsyncLoading();

//       final request = StandardQuoteRequest(
//         productTypeId: productTypeId,
//         packagingTypeId: packagingTypeId,
//         quantity: quantity,
//         weightPerItem: weightPerItem,
//         isMultiStop: false,
//         pickupAddress: pickupAddress,
//         pickupLatitude: pickupLatitude,
//         pickupLongitude: pickupLongitude,
//         pickupCity: pickupCity,
//         pickupState: pickupState,
//         deliveryAddress: deliveryAddress,
//         deliveryLatitude: deliveryLatitude,
//         deliveryLongitude: deliveryLongitude,
//         deliveryCity: deliveryCity,
//         deliveryState: deliveryState,
//         serviceType: serviceType,
//         addOns: addOns,
//         declaredValue: declaredValue,
//         length: length,
//         width: width,
//         height: height,
//       );

//       final repository = ref.read(calculateQuoteRepositoryProvider);
//       final result = await repository.calculateStandardQuote(request: request);

//       // Sort quotes by total score (descending)
//       if (result.quotes.isNotEmpty) {
//         result.quotes.sort((a, b) => b.totalScore.compareTo(a.totalScore));
//         ref.read(bestQuoteProvider.notifier).state = result.quotes.first;
//       }

//       state = AsyncData(result);
//     } catch (e, st) {
//       print("❌ Error in calculateStandardQuote: $e");

//       // ✅ Extract meaningful error message
//       String errorMsg = e.toString();

//       // Check if it's a compatibility error
//       if (errorMsg.contains("No vehicle types compatible with")) {
//         // Clean up the message
//         errorMsg = errorMsg.replaceAll('Exception: ', '');
//         errorMsg = errorMsg.replaceAll('DioError: ', '');

//         // Log for debugging
//         print("📌 Compatibility Error: $errorMsg");
//       }

//       state = AsyncError(errorMsg, st);
//       rethrow;
//     }
//   }

//   //   // ✅ CALCULATE MULTI-STOP QUOTE
//   // ✅ CALCULATE MULTI-STOP QUOTE
//   Future<void> calculateMultiStopQuote({
//     required int productTypeId,
//     required int packagingTypeId,
//     required List<StopRequest> stops,
//     required String serviceType,
//     int? quantity, // ✅ ADD THIS PARAMETER
//     double? weightPerItem, // ✅ ADD THIS PARAMETER
//     double? declaredValue,
//     List<String>? addOns,
//     double? length, // ✅ ADD THIS
//     double? width, // ✅ ADD THIS
//     double? height, // ✅ ADD THIS
//   }) async {
//     try {
//       state = const AsyncLoading();

//       final request = MultiStopQuoteRequest(
//         productTypeId: productTypeId,
//         packagingTypeId: packagingTypeId,
//         isMultiStop: true,
//         stops: stops,
//         serviceType: serviceType,
//         addOns: addOns,
//         declaredValue: declaredValue,
//         quantity: quantity, // ✅ ADD THIS
//         weightPerItem: weightPerItem, // ✅ ADD THIS
//         length: length, // ✅ ADD THIS
//         width: width, // ✅ ADD THIS
//         height: height, // ✅ ADD THIS
//       );

//       final repository = ref.read(calculateQuoteRepositoryProvider);
//       final result = await repository.calculateMultiStopQuote(request: request);

//       // Sort quotes by total score (descending)
//       if (result.quotes.isNotEmpty) {
//         result.quotes.sort((a, b) => b.totalScore.compareTo(a.totalScore));
//         // Set the best quote (highest score)
//         ref.read(bestQuoteProvider.notifier).state = result.quotes.first;
//       }

//       state = AsyncData(result);
//     } catch (e, st) {
//       print("❌ Error in calculateMultiStopQuote: $e");
//       state = AsyncError(e, st);
//       rethrow;
//     }
//   }

//   // ✅ SELECT A QUOTE AS BEST QUOTE
//   void selectQuote(Quote quote) {
//     ref.read(bestQuoteProvider.notifier).state = quote;
//   }

//   // ✅ CLEAR QUOTES
//   void clearQuotes() {
//     state = const AsyncData(null);
//     ref.read(bestQuoteProvider.notifier).state = null;
//   }

//   // ✅ GET BEST QUOTE
//   Quote? getBestQuote() {
//     return ref.read(bestQuoteProvider);
//   }
// }
