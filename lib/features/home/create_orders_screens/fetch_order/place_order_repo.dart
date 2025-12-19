import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/constants/api_url.dart';
import 'package:logisticscustomer/constants/local_storage.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/place_order_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_controller.dart';

class OrderRepository {
  final Dio dio;
  final Ref ref;

  OrderRepository({required this.dio, required this.ref});

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

      final Map<String, dynamic> responseData;
      if (response.data is Map) {
        responseData = (response.data as Map).cast<String, dynamic>();
      } else {
        throw Exception("Invalid response format from server");
      }

      switch (response.statusCode) {
        case 422:
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
          final message = responseData["message"] ?? "Bad request";
          final required = responseData["required"] ?? 0;
          final available = responseData["available"] ?? 0;

          if (message.contains("insufficient", caseSensitive: false)) {
            throw Exception(
              "Insufficient wallet balance. Required: R$required, Available: R$available",
            );
          }
          throw Exception(message);

        case 404:
          throw Exception(
            "Customer profile not found. Please contact support.",
          );

        case 500:
          throw Exception(
            "Server error: ${responseData["message"] ?? "Internal server error"}",
          );

        case 200:
        case 201:
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

      rethrow;
    } catch (e) {
      print("⛔ General Error: $e");
      rethrow;
    }
  }

Future<OrderRequestBody> prepareOrderData() async {
  final cache = ref.read(orderCacheProvider);
  final items = ref.read(packageItemsProvider);

  // ✅ Step 1: Get selected quote data
  final selectedQuote = ref.read(bestQuoteProvider);

  if (selectedQuote == null) {
    throw Exception("Please calculate and select a quote first");
  }

  // ✅ Step 2: Check if we have package items
  if (items.isEmpty) {
    throw Exception("Please add at least one item to the order");
  }

  // ✅ Step 3: Calculate total weight and item quantity
  double totalWeight = 0.0;
  int totalQuantity = 0;

  List<OrderItemRequest> orderItems = items.map((item) {
    final weight = double.tryParse(item.weight) ?? 0.0;
    final quantity = int.tryParse(item.qty) ?? 1;
    final value = double.tryParse(item.value) ?? 0.0;

    totalWeight += weight * quantity;
    totalQuantity += quantity;

    return OrderItemRequest(
      name: item.name,
      quantity: quantity,
      weight: weight,
      value: value,
      description: item.note.isNotEmpty ? item.note : "No description",
      shopifyProductId: item.isFromShopify
          ? "gid://shopify/Product/${item.sku}"
          : null,
      productSku: item.sku.isNotEmpty ? item.sku : "N/A",
    );
  }).toList();

  // ✅ Step 4: Get product and packaging type IDs
  final productTypeIdStr = cache["selected_product_type_id"]?.toString() ?? "0";
  final packagingTypeIdStr = cache["selected_packaging_type_id"]?.toString() ?? "0";
  
  final productTypeId = int.tryParse(productTypeIdStr) ?? 0;
  final packagingTypeId = int.tryParse(packagingTypeIdStr) ?? 0;

  if (productTypeId == 0 || packagingTypeId == 0) {
    throw Exception("Product or packaging type not selected. Please go back to Step 1.");
  }

  // ✅ Step 5: Get declared value
  double declaredValue = 0.0;
  final declaredValueStr = cache["declared_value"]?.toString() ?? "0";
  declaredValue = double.tryParse(declaredValueStr) ?? 0.0;

  // ✅ Step 6: Get add-ons
  List<String> addOns = [];
  final selectedAddons = cache["selected_addons"];
  
  if (selectedAddons != null && selectedAddons is List) {
    for (var addon in selectedAddons) {
      if (addon is String) {
        if (addon == "insurance") {
          addOns.add("insurance");
        } else if (addon == "signature_required") {
          addOns.add("signature_required");
        } else if (addon == "fragile_handling") {
          addOns.add("fragile_handling");
        } else if (addon == "photo_proof") {
          addOns.add("photo_proof");
        } else if (addon == "priority_pickup") {
          addOns.add("priority_pickup");
        } else if (addon == "weekend_delivery") {
          addOns.add("weekend_delivery");
        } else {
          addOns.add(addon); // Add as-is if not mapped
        }
      }
    }
  }

  // ✅ Step 7: Get addresses - Use city if address1 is empty
  String pickupAddress = cache["pickup_address1"]?.toString() ?? "";
  if (pickupAddress.isEmpty) {
    pickupAddress = cache["pickup_city"]?.toString() ?? "Unknown Location";
  }

  String deliveryAddress = cache["delivery_address1"]?.toString() ?? "";
  if (deliveryAddress.isEmpty) {
    deliveryAddress = cache["delivery_city"]?.toString() ?? "Unknown Location";
  }

  // ✅ Step 8: Get contact information
  final pickupContactName = cache["pickup_name"]?.toString() ?? "Unknown";
  final pickupContactPhone = cache["pickup_phone"]?.toString() ?? "";
  final deliveryContactName = cache["delivery_name"]?.toString() ?? "Unknown";
  final deliveryContactPhone = cache["delivery_phone"]?.toString() ?? "";

  // ✅ Step 9: Get city/state/postal code
  final pickupCity = cache["pickup_city"]?.toString() ?? "";
  final pickupState = cache["pickup_state"]?.toString() ?? "";
  final pickupPostalCode = cache["pickup_postal"]?.toString() ?? "";

  final deliveryCity = cache["delivery_city"]?.toString() ?? "";
  final deliveryState = cache["delivery_state"]?.toString() ?? "";
  final deliveryPostalCode = cache["delivery_postal"]?.toString() ?? "";

  // ✅ Step 10: Get service type
  final serviceType = cache["service_type_id"]?.toString() ?? "standard";

  // ✅ Step 11: Get special instructions
  final specialInstructions = cache["special_instructions"]?.toString();

  // ✅ Step 12: Get estimated cost from quote
  double estimatedCost = selectedQuote.pricing.total;

  // ✅ Step 13: Create SelectedQuote object
  final quoteSelected = SelectedQuote(
    vehicleId: selectedQuote.vehicleId,
    driverId: selectedQuote.driver.id,
    matchingScore: selectedQuote.totalScore,
    depotScore: selectedQuote.depotScore ?? 100.0,
    distanceScore: selectedQuote.distanceScore ?? 70.0,
    priceScore: selectedQuote.priceScore ?? 100.0,
    suitabilityScore: selectedQuote.suitabilityScore ?? 85.0,
    driverScore: double.tryParse(selectedQuote.driver.rating) ?? 5.0,
    depotId: selectedQuote.depotId ?? 0,
  );

  // ✅ Step 14: Create final order request body
  final orderRequestBody = OrderRequestBody(
    productTypeId: productTypeId,
    packagingTypeId: packagingTypeId,
    totalWeightKg: totalWeight,
    itemQuantity: totalQuantity,
    pickupContactName: pickupContactName,
    pickupContactPhone: pickupContactPhone,
    pickupAddress: pickupAddress,
    pickupCity: pickupCity,
    pickupState: pickupState,
    pickupPostalCode: pickupPostalCode,
    deliveryContactName: deliveryContactName,
    deliveryContactPhone: deliveryContactPhone,
    deliveryAddress: deliveryAddress,
    deliveryCity: deliveryCity,
    deliveryState: deliveryState,
    deliveryPostalCode: deliveryPostalCode,
    serviceType: serviceType,
    specialInstructions: specialInstructions,
    selectedQuote: quoteSelected,
    estimatedCost: estimatedCost,
    addOns: addOns,
    declaredValue: declaredValue,
    items: orderItems,
  );

  // ✅ Step 15: Debug print
  print("\n📋 FINAL ORDER REQUEST BODY:");
  print("📦 Product Type ID: $productTypeId");
  print("📦 Packaging Type ID: $packagingTypeId");
  print("⚖️ Total Weight: ${totalWeight}kg");
  print("🔢 Total Quantity: $totalQuantity");
  print("📍 Pickup: $pickupAddress, $pickupCity, $pickupState");
  print("👤 Pickup Contact: $pickupContactName - $pickupContactPhone");
  print("📍 Delivery: $deliveryAddress, $deliveryCity, $deliveryState");
  print("👤 Delivery Contact: $deliveryContactName - $deliveryContactPhone");
  print("🚚 Service Type: $serviceType");
  print("💰 Estimated Cost: R$estimatedCost");
  print("➕ Add-ons: ${addOns.join(", ") ?? "None"}");
  print("💎 Declared Value: R$declaredValue");
  print("🚗 Selected Vehicle ID: ${selectedQuote.vehicleId}");
  print("👨‍✈️ Selected Driver ID: ${selectedQuote.driver.id}");
  print("📊 Matching Score: ${selectedQuote.totalScore}%");
  print("📦 Items: ${orderItems.length} items");
  print("📝 Special Instructions: ${specialInstructions ?? "None"}");

  return orderRequestBody;
}
}
