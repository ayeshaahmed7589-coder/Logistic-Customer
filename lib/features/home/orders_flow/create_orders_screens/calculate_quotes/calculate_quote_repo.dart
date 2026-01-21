import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'calculate_quote_modal.dart';

// CalculateQuoteRepository update karo:

class CalculateQuoteRepository {
  final Dio dio;
  final Ref ref;

  CalculateQuoteRepository({required this.dio, required this.ref});

  // ✅ STANDARD QUOTE CALCULATION
  Future<QuoteData> calculateStandardQuote({
    required StandardQuoteRequest request,
  }) async {
    final url = ApiUrls.postCalculationStandard;
    return await _calculateQuote(url, request.toJson(), "STANDARD");
  }

  // ✅ MULTI-STOP QUOTE CALCULATION
  Future<QuoteData> calculateMultiStopQuote({
    required MultiStopQuoteRequest request,
  }) async {
    final url = ApiUrls.postCalculationMultiStop;
    return await _calculateQuote(url, request.toJson(), "MULTI-STOP");
  }

  // ✅ COMMON CALCULATION METHOD
  Future<QuoteData> _calculateQuote(
    String url,
    Map<String, dynamic> requestData,
    String type,
  ) async {
    final token = await LocalStorage.getToken() ?? "";
    if (token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    try {
      print("📤 Calculating $type Quote...");
      print("Request URL: $url");
      print("Request Body: ${jsonEncode(requestData)}");

      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ),
      );

      print("📌 $type API Status: ${response.statusCode}");

      final Map<String, dynamic> responseData;
      if (response.data is Map) {
        responseData = (response.data as Map).cast<String, dynamic>();
      } else {
        throw Exception("Invalid response format from server");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData["success"] == true) {
          return QuoteData.fromJson(responseData);
        } else {
          throw Exception(
            "Quote calculation failed: ${responseData["message"]}",
          );
        }
      } else if (response.statusCode == 422) {
        final errors = responseData["errors"] ?? {};
        String errorMsg = "Validation failed: ";
        if (errors is Map) {
          errors.forEach((key, value) {
            if (value is List) {
              errorMsg += "$key: ${value.join(", ")}. ";
            } else {
              errorMsg += "$key: $value. ";
            }
          });
        }
        throw Exception(errorMsg.trim());
      } else {
        throw Exception("Failed to calculate quote: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("⛔ $type Dio Error: ${e.type}");
      print("Message: ${e.message}");
      print("Response: ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timeout. Please check your internet.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Server response timeout. Please try again.");
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception("No internet connection. Please check your network.");
      }

      rethrow;
    } catch (e) {
      print("⛔ $type General Error: $e");
      rethrow;
    }
  }
}
