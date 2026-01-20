import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_repo.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/common_modal.dart';



// ✅ PROVIDERS
final quoteControllerProvider = StateNotifierProvider<QuoteController, AsyncValue<QuoteData?>>(
  (ref) => QuoteController(ref: ref),
);

final bestQuoteProvider = StateProvider<Quote?>((ref) => null);

final calculateQuoteRepositoryProvider = Provider<CalculateQuoteRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return CalculateQuoteRepository(dio: dio, ref: ref);
  },
);

// ✅ CONTROLLER
class QuoteController extends StateNotifier<AsyncValue<QuoteData?>> {
  final Ref ref;

  QuoteController({required this.ref}) : super(const AsyncData(null));

  // ✅ CALCULATE STANDARD QUOTE
// ✅ CALCULATE STANDARD QUOTE
Future<void> calculateStandardQuote({
  required int productTypeId,
  required int packagingTypeId,
  required int quantity, // ✅ ADD THIS PARAMETER
  required double totalWeightKg,
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
      quantity: quantity, // ✅ ADD THIS
      weight: totalWeightKg,
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
      // Set the best quote (highest score)
      ref.read(bestQuoteProvider.notifier).state = result.quotes.first;
    }

    state = AsyncData(result);
  } catch (e, st) {
    print("❌ Error in calculateStandardQuote: $e");
    state = AsyncError(e, st);
    rethrow;
  }
}
  // ✅ CALCULATE MULTI-STOP QUOTE
// ✅ CALCULATE MULTI-STOP QUOTE
Future<void> calculateMultiStopQuote({
  required int productTypeId,
  required int packagingTypeId,
  required List<StopRequest> stops,
  required String serviceType,
  int? quantity, // ✅ ADD THIS PARAMETER
  double? weight, // ✅ ADD THIS PARAMETER
  double? declaredValue,
  List<String>? addOns,
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
      quantity: quantity, // ✅ ADD THIS
      weight: weight, // ✅ ADD THIS
    );

    final repository = ref.read(calculateQuoteRepositoryProvider);
    final result = await repository.calculateMultiStopQuote(request: request);

    // Sort quotes by total score (descending)
    if (result.quotes.isNotEmpty) {
      result.quotes.sort((a, b) => b.totalScore.compareTo(a.totalScore));
      // Set the best quote (highest score)
      ref.read(bestQuoteProvider.notifier).state = result.quotes.first;
    }

    state = AsyncData(result);
  } catch (e, st) {
    print("❌ Error in calculateMultiStopQuote: $e");
    state = AsyncError(e, st);
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

