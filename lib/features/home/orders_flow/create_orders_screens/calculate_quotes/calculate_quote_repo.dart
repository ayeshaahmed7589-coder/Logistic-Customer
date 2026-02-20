import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'calculate_quote_modal.dart';


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

  // ✅ COMMON CALCULATION METHOD - SIRF BACKEND MESSAGE
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
          // ✅ Sab status codes accept karo (200, 400, 422 sab)
          validateStatus: (status) {
            return true; // Sab status codes accept karo
          },
        ),
      );

      print("📌 $type API Status: ${response.statusCode}");
      print("📌 $type API Response: ${jsonEncode(response.data)}");

      // Parse response data
      final Map<String, dynamic> responseData;
      if (response.data is Map) {
        responseData = (response.data as Map).cast<String, dynamic>();
      } else {
        throw Exception("Invalid response format from server");
      }

      // ✅ Agar success true hai to data return karo
      if (responseData["success"] == true) {
        return QuoteData.fromJson(responseData);
      } 
      
      // ✅ Agar success false hai to message throw karo
      else {
        final message = responseData["message"] ?? "Unknown error occurred";
        throw Exception(message); // 👈 SIRF BACKEND MESSAGE
      }
      
    } on DioException catch (e) {
      print("⛔ $type Dio Error: ${e.type}");
      print("Message: ${e.message}");
      
      // ✅ Agar response mein koi message hai to wo do
      if (e.response?.data != null) {
        try {
          final data = e.response!.data as Map<String, dynamic>;
          if (data["message"] != null) {
            throw Exception(data["message"]); // 👈 SIRF BACKEND MESSAGE
          }
        } catch (_) {
          // Ignore parsing errors
        }
      }

      // Handle connection errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Connection timeout. Please check your internet.");
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception("No internet connection. Please check your network.");
      }

      throw Exception("Failed to connect to server. Please try again.");
    } catch (e) {
      print("⛔ $type General Error: $e");
      rethrow;
    }
  }
}
// CalculateQuoteRepository update karo:

// class CalculateQuoteRepository {
//   final Dio dio;
//   final Ref ref;

//   CalculateQuoteRepository({required this.dio, required this.ref});

//   // ✅ STANDARD QUOTE CALCULATION
//   Future<QuoteData> calculateStandardQuote({
//     required StandardQuoteRequest request,
//   }) async {
//     final url = ApiUrls.postCalculationStandard;
//     // Debug print
//     print("📤 REQUEST BODY:");
//     print("product_type_id: ${request.productTypeId}");
//     print("packaging_type_id: ${request.packagingTypeId}");
//     print("quantity: ${request.quantity}");
//     print("weight_per_item: ${request.weightPerItem}"); // ✅ Yahan check karo
//     print("length: ${request.length}");
//     print("width: ${request.width}");
//     print("height: ${request.height}");
//     return await _calculateQuote(url, request.toJson(), "STANDARD");
//   }

//   // ✅ MULTI-STOP QUOTE CALCULATION
//   Future<QuoteData> calculateMultiStopQuote({
//     required MultiStopQuoteRequest request,
//   }) async {
//     final url = ApiUrls.postCalculationMultiStop;
//     return await _calculateQuote(url, request.toJson(), "MULTI-STOP");
//   }

//   // ✅ COMMON CALCULATION METHOD
//   // In CalculateQuoteRepository
//   Future<QuoteData> _calculateQuote(
//     String url,
//     Map<String, dynamic> requestData,
//     String type,
//   ) async {
//     final token = await LocalStorage.getToken() ?? "";
//     if (token.isEmpty) {
//       throw Exception("Token missing. Please login again.");
//     }

//     try {
//       print("📤 Calculating $type Quote...");
//       print("Request URL: $url");
//       print("Request Body: ${jsonEncode(requestData)}");

//       final response = await dio.post(
//         url,
//         data: requestData,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//           },
//         ),
//       );

//       print("📌 $type API Status: ${response.statusCode}");

//       final Map<String, dynamic> responseData;
//       if (response.data is Map) {
//         responseData = (response.data as Map).cast<String, dynamic>();
//       } else {
//         throw Exception("Invalid response format from server");
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (responseData["success"] == true) {
//           return QuoteData.fromJson(responseData);
//         } else {
//           // ✅ Return a meaningful error message
//           final message = responseData["message"] ?? "Unknown error";

//           // Special handling for compatibility errors
//           if (message.contains("No vehicle types compatible with")) {
//             throw Exception(message); // Don't wrap, show as is
//           }

//           throw Exception("Quote calculation failed: $message");
//         }
//       } else if (response.statusCode == 422) {
//         final errors = responseData["errors"] ?? {};
//         String errorMsg = "Validation failed: ";
//         if (errors is Map) {
//           errors.forEach((key, value) {
//             if (value is List) {
//               errorMsg += "$key: ${value.join(", ")}. ";
//             } else {
//               errorMsg += "$key: $value. ";
//             }
//           });
//         }
//         throw Exception(errorMsg.trim());
//       } else {
//         throw Exception("Failed to calculate quote: ${response.statusCode}");
//       }
//     } on DioException catch (e) {
//       print("⛔ $type Dio Error: ${e.type}");
//       print("Message: ${e.message}");
//       print("Response: ${e.response?.data}");

//       // ✅ Check if response contains compatibility error
//       if (e.response?.data is Map) {
//         final data = e.response!.data as Map;
//         if (data["message"] != null &&
//             data["message"].toString().contains(
//               "No vehicle types compatible with",
//             )) {
//           throw Exception(data["message"]);
//         }
//       }

//       if (e.type == DioExceptionType.connectionTimeout) {
//         throw Exception("Connection timeout. Please check your internet.");
//       } else if (e.type == DioExceptionType.receiveTimeout) {
//         throw Exception("Server response timeout. Please try again.");
//       } else if (e.type == DioExceptionType.connectionError) {
//         throw Exception("No internet connection. Please check your network.");
//       }

//       rethrow;
//     } catch (e) {
//       print("⛔ $type General Error: $e");
//       rethrow;
//     }
//   }

// }
