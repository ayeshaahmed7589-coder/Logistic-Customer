import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/dio.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';

class QuoteRepository {
  final Dio dio;
  final Ref ref;

  QuoteRepository({required this.dio, required this.ref});

  // Standard Quote Calculation
  Future<QuoteResponse> calculateStandardQuote(StandardQuoteRequest request) async {
    try {
      final url = ApiUrls.postCalculationStandard;
      final token = await LocalStorage.getToken() ?? "";

      print("📊 Calculating Standard Quote...");
      print("📦 Request Body: ${request.toJson()}");

      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      print("✅ Standard Quote Response Status: ${response.statusCode}");
      print("✅ Standard Quote Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return QuoteResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to calculate standard quote: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("❌ Error calculating standard quote: $e");
      throw Exception("Failed to calculate quote");
    }
  }

  // Multi-Stop Quote Calculation
  Future<QuoteResponse> calculateMultiStopQuote(MultiStopQuoteRequest request) async {
    try {
      final url = ApiUrls.postCalculationMultiStop;
      final token = await LocalStorage.getToken() ?? "";

      print("📊 Calculating Multi-Stop Quote...");
      print("📍 Request Body: ${request.toJson()}");

      final response = await dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      print("✅ Multi-Stop Quote Response Status: ${response.statusCode}");
      print("✅ Multi-Stop Quote Response Data: ${response.data}");

      if (response.statusCode == 200) {
        return QuoteResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to calculate multi-stop quote: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      throw Exception("Network error: ${e.message}");
    } catch (e) {
      print("❌ Error calculating multi-stop quote: $e");
      throw Exception("Failed to calculate quote");
    }
  }
}

// Provider
final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  return QuoteRepository(dio: ref.watch(dioProvider), ref: ref);
});