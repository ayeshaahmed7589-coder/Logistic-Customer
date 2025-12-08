import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/place_order_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_controller.dart';



class OrderRepository {
  final Dio dio;
  final Ref ref;

  OrderRepository({required this.dio, required this.ref});

  // ✅ NEW: placeOrder method jo OrderRequestBody leta hai
    Future<OrderResponse> placeOrder({
    required OrderRequestBody orderRequestBody,
  }) async {
    final url = ApiUrls.postPlaceOrder;

    final token = await LocalStorage.getToken() ?? "";
    if (token.isEmpty) {
      throw Exception("Token missing. Please login again.");
    }

    try {
      print("📤 Sending order to API...");
      print("Request Body: ${jsonEncode(orderRequestBody.toJson())}");

      final response = await dio.post(
        url,
        data: orderRequestBody.toJson(),
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

      print("📌 API Status: ${response.statusCode}");
      
      // ✅ BETTER ERROR HANDLING
      final Map<String, dynamic> responseData;
      if (response.data is Map) {
        responseData = (response.data as Map).cast<String, dynamic>();
      } else {
        throw Exception("Invalid response format from server");
      }

      // ✅ SPECIFIC ERROR RESPONSES HANDLE KARO
      switch (response.statusCode) {
        case 422:
          // Validation error
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

        case 400:
          // Insufficient balance or bad request
          final message = responseData["message"] ?? "Bad request";
          final required = responseData["required"] ?? 0;
          final available = responseData["available"] ?? 0;
          
          if (message.contains("insufficient", caseSensitive: false)) {
            throw Exception("Insufficient wallet balance. Required: R$required, Available: R$available");
          }
          throw Exception(message);

        case 404:
          // Not found
          throw Exception("Customer profile not found. Please contact support.");

        case 500:
          // Server error
          throw Exception("Server error: ${responseData["message"] ?? "Internal server error"}");

        case 200:
        case 201:
          // Success
          if (responseData["success"] == true) {
            return OrderResponse.fromJson(responseData);
          } else {
            throw Exception("Order failed: ${responseData["message"]}");
          }

        default:
          throw Exception("Failed to place order: ${response.statusCode}");
      }

    } on DioException catch (e) {
      print("⛔ Dio Error: ${e.type}");
      print("Message: ${e.message}");
      print("Response: ${e.response?.data}");

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection timeout. Please check your internet.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception("Server response timeout. Please try again.");
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception("No internet connection. Please check your network.");
      }
      
      // Re-throw for controller to handle
      rethrow;
    } catch (e) {
      print("⛔ General Error: $e");
      rethrow;
    }
  }
  // Future<OrderResponse> placeOrder({
  //   required OrderRequestBody orderRequestBody,
  // }) async {
  //   final url = ApiUrls.postPlaceOrder;

  //   final token = await LocalStorage.getToken() ?? "";
  //   print("📌 Placing Order - Token used => $token");
  //   print("📌 Order API URL => $url");

  //   if (token.isEmpty) {
  //     throw Exception("Token missing. Please login again.");
  //   }

  //   try {
  //     print("📤 Sending order request body...");
  //     print("Body: ${jsonEncode(orderRequestBody.toJson())}");

  //     final response = await dio.post(
  //       url,
  //       data: orderRequestBody.toJson(), // ✅ Auto JSON conversion
  //       options: Options(
  //         headers: {
  //           "Authorization": "Bearer $token",
  //           "Accept": "application/json",
  //           "Content-Type": "application/json",
  //         },
  //       ),
  //     );

  //     print("📌 Order Placement API Status => ${response.statusCode}");
  //     print("📌 Order API Response => ${response.data}");

  //     // ✅ Fix Map type issue
  //     final Map<String, dynamic> jsonResponse;
      
  //     if (response.data is Map) {
  //       final dynamicData = response.data as Map;
  //       jsonResponse = dynamicData.map((key, value) => MapEntry(key.toString(), value));
  //     } else {
  //       throw Exception("Invalid response format");
  //     }

  //     // ✅ Check for specific error responses
  //     if (response.statusCode == 422) {
  //       // Validation error
  //       throw Exception("Validation failed: ${jsonResponse["message"]}");
  //     } else if (response.statusCode == 400) {
  //       // Insufficient balance
  //       throw Exception("Insufficient wallet balance");
  //     } else if (response.statusCode == 404) {
  //       // Customer not found
  //       throw Exception("Customer profile not found");
  //     } else if (response.statusCode == 500) {
  //       // Server error
  //       throw Exception("Server error: ${jsonResponse["message"]}");
  //     }

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       if (jsonResponse["success"] == true) {
  //         return OrderResponse.fromJson(jsonResponse);
  //       } else {
  //         throw Exception("Order failed: ${jsonResponse["message"]}");
  //       }
  //     } else {
  //       throw Exception(
  //         "Failed to place order: ${response.statusCode} ${response.data}",
  //       );
  //     }
  //   } on DioException catch (e) {
  //     print("⛔ Dio Error in Order Placement => ${e.type}");
  //     print("  Message: ${e.message}");
  //     print("  Response: ${e.response?.data}");
      
  //     // More specific error messages
  //     if (e.response?.statusCode == 422) {
  //       final errorData = e.response?.data;
  //       if (errorData is Map && errorData["errors"] != null) {
  //         final errors = errorData["errors"];
  //         String errorMsg = "Validation error: ";
  //         errors.forEach((key, value) {
  //           errorMsg += "$key: ${value is List ? value.join(", ") : value}. ";
  //         });
  //         throw Exception(errorMsg.trim());
  //       }
  //     }
  //     rethrow;
  //   } catch (e) {
  //     print("⛔ General Error in Order Placement => $e");
  //     rethrow;
  //   }
  // }

  // ✅ UPDATED: prepareOrderData jo OrderRequestBody return karega
  Future<OrderRequestBody> prepareOrderData() async {
    final cache = ref.read(orderCacheProvider);
    final items = ref.read(packageItemsProvider);

    // Step 1: Items ko OrderItemRequest format mein convert karna
    List<OrderItemRequest> orderItems = items.map((item) {
      return OrderItemRequest(
        name: item.name,
        quantity: int.tryParse(item.qty) ?? 1,
        weight: double.tryParse(item.weight) ?? 0.0,
        description: item.note.isNotEmpty ? item.note : "No description",
        shopifyProductId: item.isFromShopify ? "gid://shopify/Product/${item.sku}" : null,
        productSku: item.sku.isNotEmpty ? item.sku : "N/A",
        value: double.tryParse(item.value) ?? 0.0,
      );
    }).toList();

    // Step 2: Payment method mapping
    String paymentMethod = cache["payment_method"] ?? "cod";
    String apiPaymentMethod;
    
    switch (paymentMethod) {
      case "wallet":
        apiPaymentMethod = "wallet";
        break;
      case "card":
        apiPaymentMethod = "card";
        break;
      case "cod":
      default:
        apiPaymentMethod = "cash";
    }

    // Step 3: Add-ons get karna
    List<String> addOns = [];
    
    // UI add-ons ko API add-ons mein convert karo
    final selectedAddons = cache["selected_addons"] as List<dynamic>?;
    if (selectedAddons != null) {
      for (var addon in selectedAddons) {
        if (addon == "insurance") {
          addOns.add("insurance");
        } else if (addon == "signature") {
          addOns.add("signature_required");
        } else if (addon == "fragile") {
          addOns.add("fragile_handling");
        } else if (addon == "photo") {
          addOns.add("photo_proof");
        } else if (addon == "priority") {
          addOns.add("priority_pickup");
        } else if (addon == "weekend") {
          addOns.add("weekend_delivery");
        }
      }
    }

    // Step 4: Address combine karna
    String pickupAddress = cache["pickup_address1"]?.toString() ?? "";
    if (pickupAddress.isEmpty) {
      pickupAddress = cache["pickup_city"]?.toString() ?? "Unknown Location";
    }
    
    String deliveryAddress = cache["delivery_address1"]?.toString() ?? "";
    if (deliveryAddress.isEmpty) {
      deliveryAddress = cache["delivery_city"]?.toString() ?? "Unknown Location";
    }

    // Step 5: Coordinates get karna
    double pickupLat = double.tryParse(cache["pickup_latitude"]?.toString() ?? "0") ?? 0.0;
    double pickupLng = double.tryParse(cache["pickup_longitude"]?.toString() ?? "0") ?? 0.0;
    double deliveryLat = double.tryParse(cache["delivery_latitude"]?.toString() ?? "0") ?? 0.0;
    double deliveryLng = double.tryParse(cache["delivery_longitude"]?.toString() ?? "0") ?? 0.0;

    // Step 6: Special instructions get karna
    String specialInstructions = cache["special_instructions"]?.toString() ?? 
        "Please handle with care";

    // Step 7: Complete order request body banate hain
    final orderRequestBody = OrderRequestBody(
      pickupAddress: pickupAddress,
      pickupLatitude: pickupLat,
      pickupLongitude: pickupLng,
      pickupContactName: cache["pickup_name"]?.toString() ?? "Unknown",
      pickupContactPhone: cache["pickup_phone"]?.toString() ?? "",
      pickupCity: cache["pickup_city"]?.toString() ?? "",
      pickupState: cache["pickup_state"]?.toString() ?? "",
      pickupPostalCode: cache["pickup_postal"]?.toString() ?? "",
      deliveryAddress: deliveryAddress,
      deliveryLatitude: deliveryLat,
      deliveryLongitude: deliveryLng,
      deliveryContactName: cache["delivery_name"]?.toString() ?? "Unknown",
      deliveryContactPhone: cache["delivery_phone"]?.toString() ?? "",
      deliveryCity: cache["delivery_city"]?.toString() ?? "",
      deliveryState: cache["delivery_state"]?.toString() ?? "",
      deliveryPostalCode: cache["delivery_postal"]?.toString() ?? "",
      serviceType: cache["service_type"]?.toString() ?? "standard",
      vehicleType: cache["vehicle_type"]?.toString() ?? "bike",
      priority: cache["priority"]?.toString() ?? "normal",
      paymentMethod: apiPaymentMethod,
      addOns: addOns.isNotEmpty ? addOns : null,
      specialInstructions: specialInstructions.isNotEmpty ? specialInstructions : null,
      items: orderItems,
    );

    // Step 8: Debug print
    print("\n📋 PREPARED ORDER REQUEST BODY:");
    print("📍 Pickup: ${orderRequestBody.pickupAddress}");
    print("📍 Pickup Lat/Lng: ${orderRequestBody.pickupLatitude}, ${orderRequestBody.pickupLongitude}");
    print("📍 Delivery: ${orderRequestBody.deliveryAddress}");
    print("📍 Delivery Lat/Lng: ${orderRequestBody.deliveryLatitude}, ${orderRequestBody.deliveryLongitude}");
    print("👤 Pickup Contact: ${orderRequestBody.pickupContactName} - ${orderRequestBody.pickupContactPhone}");
    print("👤 Delivery Contact: ${orderRequestBody.deliveryContactName} - ${orderRequestBody.deliveryContactPhone}");
    print("🚚 Service: ${orderRequestBody.serviceType}");
    print("🚗 Vehicle: ${orderRequestBody.vehicleType}");
    print("⚡ Priority: ${orderRequestBody.priority}");
    print("💳 Payment: ${orderRequestBody.paymentMethod}");
    print("➕ Add-ons: ${orderRequestBody.addOns?.join(", ") ?? "None"}");
    print("📦 Items: ${orderRequestBody.items.length} items");
    print("📝 Special Instructions: ${orderRequestBody.specialInstructions ?? "None"}");
    
    return orderRequestBody;
  }
}

// class OrderRepository {
//   final Dio dio;
//   final Ref ref;

//   OrderRepository({required this.dio, required this.ref});

//   Future<OrderResponse> placeOrder({
//     required Map<String, dynamic> orderData,
//   }) async {
//     final url = ApiUrls.postPlaceOrder;

//     final token = await LocalStorage.getToken() ?? "";
//     print("📌 Placing Order - Token used => $token");
//     print("📌 Order API URL => $url");

//     if (token.isEmpty) {
//       throw Exception("Token missing. Please login again.");
//     }

//     try {
//       final response = await dio.post(
//         url,
//         data: jsonEncode(orderData),
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//           },
//         ),
//       );

//       print("📌 Order Placement API Response => ${response.data}");
//       print("📌 Order Request payload => $orderData");

//       // ✅ Fix Map type issue
//       final Map<String, dynamic> jsonResponse;
      
//       if (response.data is Map) {
//         final dynamicData = response.data as Map;
//         jsonResponse = dynamicData.map((key, value) => MapEntry(key.toString(), value));
//       } else {
//         throw Exception("Invalid response format");
//       }

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (jsonResponse["success"] == true) {
//           return OrderResponse.fromJson(jsonResponse);
//         } else {
//           throw Exception("Order failed: ${jsonResponse["message"]}");
//         }
//       } else {
//         throw Exception(
//           "Failed to place order: ${response.statusCode} ${response.data}",
//         );
//       }
//     } catch (e) {
//       print("⛔ Order Placement API ERROR => $e");
//       rethrow;
//     }
//   }

//   // ✅ FIXED: NULL SAFE prepareOrderData
//   Future<Map<String, dynamic>> prepareOrderData() async {
//     final cache = ref.read(orderCacheProvider);
//     final items = ref.read(packageItemsProvider);
//     final quoteState = ref.read(quoteCalculationControllerProvider);

//     // Convert PackageItem to API format
//     List<Map<String, dynamic>> orderItems = items.map((item) {
//       return {
//         "name": item.name,
//         "quantity": int.tryParse(item.qty) ?? 1,
//         "weight": double.tryParse(item.weight) ?? 0.0,
//         "description": item.note,
//         "product_sku": item.sku,
//         "shopify_product_id": item.isFromShopify ? item.sku : null,
//         "value": double.tryParse(item.value) ?? 0.0,
//       };
//     }).toList();

//     // ✅ FIXED: Get final total from quote (NULL SAFE)
//     double finalTotal = 0.0;
//     final quote = quoteState.value;
    
//     if (quote != null && quote.data != null && quote.data!.pricing != null) {
//       finalTotal = quote.data!.pricing!.total;
//     } else {
//       // Calculate fallback total
//       double totalWeight = 0;
//       for (var item in items) {
//         totalWeight += double.tryParse(item.weight) ?? 0;
//       }
//       finalTotal = 50.0 + (totalWeight * 5.0) + (50.0 * 0.05); // Base + weight + tax
//     }

//     // 🔥 PAYMENT METHOD MAPPING
//     String paymentMethod = cache["payment_method"] ?? "cod";
//     String apiPaymentMethod;
    
//     switch (paymentMethod) {
//       case "wallet":
//         apiPaymentMethod = "wallet";
//         break;
//       case "card":
//         apiPaymentMethod = "card";
//         break;
//       case "cod":
//       default:
//         apiPaymentMethod = "cash";
//     }

//     // ✅ FIXED: Prepare order data with null safety
//     final orderData = <String, dynamic>{
//       "pickup_address": cache["pickup_address1"]?.toString() ?? "",
//       "pickup_latitude": double.tryParse(cache["pickup_latitude"]?.toString() ?? "0") ?? 0.0,
//       "pickup_longitude": double.tryParse(cache["pickup_longitude"]?.toString() ?? "0") ?? 0.0,
//       "pickup_contact_name": cache["pickup_name"]?.toString() ?? "",
//       "pickup_contact_phone": cache["pickup_phone"]?.toString() ?? "",
//       "pickup_city": cache["pickup_city"]?.toString() ?? "",
//       "pickup_state": cache["pickup_state"]?.toString() ?? "",
//       "pickup_postal_code": cache["pickup_postal"]?.toString() ?? "",
      
//       "delivery_address": cache["delivery_address1"]?.toString() ?? "",
//       "delivery_latitude": double.tryParse(cache["delivery_latitude"]?.toString() ?? "0") ?? 0.0,
//       "delivery_longitude": double.tryParse(cache["delivery_longitude"]?.toString() ?? "0") ?? 0.0,
//       "delivery_contact_name": cache["delivery_name"]?.toString() ?? "",
//       "delivery_contact_phone": cache["delivery_phone"]?.toString() ?? "",
//       "delivery_city": cache["delivery_city"]?.toString() ?? "",
//       "delivery_state": cache["delivery_state"]?.toString() ?? "",
//       "delivery_postal_code": cache["delivery_postal"]?.toString() ?? "",
      
//       "service_type": cache["service_type"]?.toString() ?? "standard",
//       "vehicle_type": cache["vehicle_type"]?.toString() ?? "bike",
//       "priority": "normal",
//       "special_instructions": "Please handle with care",
//       "payment_method": apiPaymentMethod,
//       "items": orderItems,
//     };

//     print("📋 Prepared Order Data:");
//     print("📍 Payment Method (UI): $paymentMethod");
//     print("📍 Payment Method (API): $apiPaymentMethod");
//     print("💰 Final Total: R$finalTotal");
//     print(orderData);
    
//     return orderData;
//   }
// }