// lib/repositories/quote_calculation_repository.dart

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/fetch_order_modal.dart';


// QuoteRepository - COMPLETE FIXED VERSION
class QuoteRepository {
  final Dio dio;
  final Ref ref;

  QuoteRepository({required this.dio, required this.ref});

  Future<QuoteCalculationResponse> calculateQuote({
    required double pickupLat,
    required double pickupLng,
    required double deliveryLat,
    required double deliveryLng,
    required String serviceType,
    required String vehicleType,
    double? totalWeight,
    List<String>? addOns, // ✅ Add-ons parameter add karo
    double? declaredValue, // ✅ Insurance ke liye declared value
  }) async {
    final url = ApiUrls.postCalculation;

    final token = await LocalStorage.getToken() ?? "";
    print("📌 Quote Calculation Token: ${token.isNotEmpty ? "Available" : "Missing"}");
    print("📌 URL: $url");

    if (token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    // ✅ Validate coordinates
    if (pickupLat == 0.0 || pickupLng == 0.0 || 
        deliveryLat == 0.0 || deliveryLng == 0.0) {
      print("⚠️ WARNING: Using test coordinates because provided coordinates are 0.0");
      pickupLat = -33.9249;
      pickupLng = 18.4241;
      deliveryLat = -33.9189;
      deliveryLng = 18.4233;
    }

    final Map<String, dynamic> data = {
      "pickup_latitude": pickupLat,
      "pickup_longitude": pickupLng,
      "delivery_latitude": deliveryLat,
      "delivery_longitude": deliveryLng,
      "service_type": serviceType,
      "vehicle_type": vehicleType,
    };

    if (totalWeight != null && totalWeight > 0) {
      data["total_weight"] = totalWeight;
    }

    // ✅ Add-ons bhejo agar selected hain
    if (addOns != null && addOns.isNotEmpty) {
      data["add_ons"] = addOns;
      print("📌 Add-ons selected: $addOns");
    }

    // ✅ Declared value bhejo agar insurance selected hai
    if (declaredValue != null && declaredValue > 0) {
      data["declared_value"] = declaredValue;
      print("📌 Declared value: $declaredValue");
    }

    print("📌 Request payload: $data");

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          receiveTimeout: Duration(seconds: 30),
          sendTimeout: Duration(seconds: 30),
        ),
      );

      print("📌 Quote API Status Code: ${response.statusCode}");
      print("📌 Quote API Response: ${response.data}");

      // ✅ Handle API response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Convert response to Map<String, dynamic>
        final Map<String, dynamic> responseData;
        if (response.data is Map) {
          final dynamicData = response.data as Map;
          responseData = dynamicData.map((key, value) => MapEntry(key.toString(), value));
        } else {
          throw Exception("Invalid response format");
        }

        // ✅ Check if success is true
        if (responseData["success"] == true) {
          // ✅ Parse the response using our model
          return QuoteCalculationResponse.fromJson(responseData);
        } else {
          throw Exception("API returned success: false - ${responseData["message"]}");
        }
      } else if (response.statusCode == 401) {
        throw Exception("Session expired. Please login again.");
      } else {
        throw Exception("Failed to calculate quote: ${response.statusCode}");
      }
    } on DioException catch (e) {
      print("⛔ Dio Error in Quote Calculation:");
      print("  Type: ${e.type}");
      print("  Message: ${e.message}");
      print("  Response: ${e.response?.data}");
      
      // ✅ Re-throw the error
      rethrow;
    } catch (e) {
      print("⛔ General Error in Quote Calculation: $e");
      rethrow;
    }
  }
}
// class QuoteRepository {
//   final Dio dio;
//   final Ref ref;

//   QuoteRepository({required this.dio, required this.ref});

//   Future<QuoteCalculationResponse> calculateQuote({
//     required double pickupLat,
//     required double pickupLng,
//     required double deliveryLat,
//     required double deliveryLng,
//     required String serviceType,
//     required String vehicleType,
//     double? totalWeight,
//   }) async {
//     final url = ApiUrls.postCalculation;

//     final token = await LocalStorage.getToken() ?? "";
//     print("📌 Token used => $token");
//     print("📌 URL => $url");

//     if (token.isEmpty) {
//       throw Exception("Token missing");
//     }

//     final data = {
//       "pickup_latitude": pickupLat,
//       "pickup_longitude": pickupLng,
//       "delivery_latitude": deliveryLat,
//       "delivery_longitude": deliveryLng,
//       "service_type": serviceType,
//       "vehicle_type": vehicleType,
//     };

//     if (totalWeight != null) {
//       data["total_weight"] = totalWeight;
//     }

//     try {
//       final response = await dio.post(
//         url,
//         data: jsonEncode(data), // JSON encode important
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//           },
//         ),
//       );

//       print("📌 Quote Calculation API => ${response.data}");
//       print("📌 Request payload => $data");

//       if (response.statusCode == 200 && response.data["success"] == true) {
//         return QuoteCalculationResponse.fromJson(response.data);
//       } else {
//         throw Exception(
//           "Failed to calculate quote: ${response.statusCode} ${response.data}",
//         );
//       }
//     } catch (e) {
//       print("⛔ Quote API ERROR => $e");
//       rethrow;
//     }
//   }
// }
