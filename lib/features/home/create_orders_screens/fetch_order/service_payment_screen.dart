import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';

import 'package:logisticscustomer/constants/gap.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/calculate_quotes/calculate_quote_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/add_ons/add_ons_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/add_ons/add_ons_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/order_types/service_type/service_type_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/place_order_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
// Update StopRequest model to include contact info

class ServicePaymentScreen extends ConsumerStatefulWidget {
  const ServicePaymentScreen({super.key});

  @override
  ConsumerState<ServicePaymentScreen> createState() =>
      _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends ConsumerState<ServicePaymentScreen> {
  String? selectedServiceTypeId;
  String? selectedServiceTypeName;
  String serviceType = "standard";
  String paymentMethod = "wallet";
  String vehicleMethod = "bike";
  String priority = "normal";
  String specialInstructions = "";
  double declaredValue = 0.0;

  // New variable for quotes
  bool hasCalculatedQuotes = false;
  bool isLoadingQuotes = false;
  String? quoteError;
  // MULTI-STOP STORAGE VARIABLES
  List<Map<String, String>> multiStopLocations = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serviceTypeControllerProvider.notifier).loadServiceTypes();
      ref.read(addOnsControllerProvider.notifier).loadAddOns();
      _loadCachedData();
      _loadMultiStopData(); // NEW: Load multi-stop data
    });
  }

  // NEW: Load multi-stop data from cache
  void _loadMultiStopData() {
    final cache = ref.read(orderCacheProvider);
    final isMultiStop = cache["is_multi_stop_enabled"] == "true";

    if (!isMultiStop) return;

    final stopsCount =
        int.tryParse(cache["route_stops_count"]?.toString() ?? "0") ?? 0;

    print("🔍 Loading multi-stop data...");
    print("Stops count: $stopsCount");
    print(
      "Cache keys: ${cache.keys.where((key) => key.contains('stop')).toList()}",
    );

    List<Map<String, String>> loadedStops = [];

    for (int i = 1; i <= stopsCount; i++) {
      final name = cache["stop_${i}_contact_name"]?.toString() ?? "Name N/A";
      final phone = cache["stop_${i}_contact_phone"]?.toString() ?? "Phone N/A";
      final address = cache["stop_${i}_address"]?.toString() ?? "Address N/A";
      final city = cache["stop_${i}_city"]?.toString() ?? "City N/A";
      final state = cache["stop_${i}_state"]?.toString() ?? "State N/A";
      final stopTypeStr = cache["stop_${i}_type"]?.toString() ?? "";

      String stopType = "Waypoint";
      Color color = Colors.grey;

      if (stopTypeStr.contains("pickup")) {
        stopType = "Pickup";
        color = AppColors.electricTeal;
      } else if (stopTypeStr.contains("dropOff")) {
        stopType = "Delivery";
        color = Colors.orange;
      } else {
        stopType = "Waypoint ${i - 1}";
        color = Colors.blue;
      }

      loadedStops.add({
        'index': i.toString(),
        'name': name,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'stopType': stopType,
        'color': color.value.toString(),
      });

      print("📍 Stop $i: $name, $address, $city, $state");
    }

    if (loadedStops.isNotEmpty) {
      setState(() {
        multiStopLocations = loadedStops;
      });
      print("✅ Loaded ${multiStopLocations.length} multi-stop locations");
    }
  }

  void _loadCachedData() {
    final cache = ref.read(orderCacheProvider);
    final savedServiceTypeId = cache["service_type_id"];

    if (savedServiceTypeId != null) {
      selectedServiceTypeId = savedServiceTypeId;
    } else {
      final defaultServiceType = ref.read(defaultServiceTypeProvider);
      if (defaultServiceType != null) {
        selectedServiceTypeId = defaultServiceType.id;
        selectedServiceTypeName = defaultServiceType.name;
      }
    }

    // Load existing data...
    vehicleMethod = cache["vehicle_type"] ?? "bike";
    paymentMethod = cache["payment_method"] ?? "wallet";
    priority = cache["priority"] ?? "normal";
    specialInstructions = cache["special_instructions"] ?? "";

    if (cache["selected_addons"] != null) {
      final savedAddons = List<String>.from(cache["selected_addons"]);
      ref.read(selectedAddonsProvider.notifier).state = savedAddons;
    }

    if (cache["declared_value"] != null) {
      declaredValue =
          double.tryParse(cache["declared_value"].toString()) ?? 0.0;
    }

    setState(() {});
  }

  // Get Smart Quotes Function
  Future<void> _getSmartQuotes() async {
    if (isLoadingQuotes) return;

    setState(() {
      isLoadingQuotes = true;
      quoteError = null;
    });

    try {
      final cache = ref.read(orderCacheProvider);

      // Check if multi-stop is enabled
      final isMultiStop = cache["is_multi_stop_enabled"] == "true";

      // Get product and packaging data
      final productTypeId = cache["selected_product_type_id"];
      final packagingTypeId = cache["selected_packaging_type_id"];
      final totalWeight = cache["total_weight"];

      if (productTypeId == null || packagingTypeId == null) {
        throw Exception("Please select product and packaging type");
      }

      if (totalWeight == null || double.tryParse(totalWeight) == null) {
        throw Exception("Please enter valid total weight");
      }

      // Get add-ons
      final selectedAddons = ref.read(selectedAddonsProvider);

      if (isMultiStop) {
        // Multi-stop calculation
        await _calculateMultiStopQuotes(
          productTypeId: int.parse(productTypeId),
          packagingTypeId: int.parse(packagingTypeId),
          totalWeightKg: double.parse(totalWeight),
          selectedAddons: selectedAddons,
        );
      } else {
        // Standard calculation
        await _calculateStandardQuotes(
          productTypeId: int.parse(productTypeId),
          packagingTypeId: int.parse(packagingTypeId),
          totalWeightKg: double.parse(totalWeight),
          selectedAddons: selectedAddons,
        );
      }

      setState(() {
        hasCalculatedQuotes = true;
        isLoadingQuotes = false;
      });
    } catch (e) {
      setState(() {
        quoteError = e.toString();
        isLoadingQuotes = false;
      });
      print("❌ Error getting quotes: $e");
    }
  }

  // FIXED: ServicePaymentScreen mein calculate function
  Future<void> _calculateStandardQuotes({
    required int productTypeId,
    required int packagingTypeId,
    required double totalWeightKg,
    required List<String> selectedAddons,
  }) async {
    final cache = ref.read(orderCacheProvider);

    // ✅ PROPER VALIDATION
    final pickupCity = cache["pickup_city"]?.toString().trim();
    final pickupState = cache["pickup_state"]?.toString().trim();
    final deliveryCity = cache["delivery_city"]?.toString().trim();
    final deliveryState = cache["delivery_state"]?.toString().trim();

    // ✅ Service Type get karo (yeh IMPORTANT hai)
    final serviceType = selectedServiceTypeId ?? "standard";

    // ✅ Declared value get karo
    final declaredValueStr = cache["declared_value"]?.toString() ?? "0";
    final declaredValue = double.tryParse(declaredValueStr) ?? 0.0;

    // ✅ DEBUG LOGS - DETAILED
    print("📍📍📍 CALCULATING STANDARD QUOTES:");
    print("📌 Pickup: $pickupCity, $pickupState");
    print("📌 Delivery: $deliveryCity, $deliveryState");
    print("📌 Product Type ID: $productTypeId");
    print("📌 Packaging Type ID: $packagingTypeId");
    print("📌 Weight: ${totalWeightKg}kg");
    print("📌 Declared Value: R$declaredValue");
    print("📌 Service Type: $serviceType");
    print("📌 Add-ons: $selectedAddons");

    // ✅ Check COMPLETE cache data
    print("🔍 COMPLETE CACHE CHECK:");
    print("   pickup_name: ${cache["pickup_name"]}");
    print("   pickup_phone: ${cache["pickup_phone"]}");
    print("   pickup_address1: ${cache["pickup_address1"]}");
    print("   pickup_city: ${cache["pickup_city"]}");
    print("   pickup_state: ${cache["pickup_state"]}");
    print("   delivery_name: ${cache["delivery_name"]}");
    print("   delivery_phone: ${cache["delivery_phone"]}");
    print("   delivery_address1: ${cache["delivery_address1"]}");
    print("   delivery_city: ${cache["delivery_city"]}");
    print("   delivery_state: ${cache["delivery_state"]}");

    // ✅ Validation
    if (pickupCity == null ||
        pickupCity.isEmpty ||
        pickupState == null ||
        pickupState.isEmpty ||
        deliveryCity == null ||
        deliveryCity.isEmpty ||
        deliveryState == null ||
        deliveryState.isEmpty) {
      throw Exception(
        "Please complete pickup and delivery information in Step 2",
      );
    }

    final dimensions = _getDimensionsFromCache(cache);

    try {
      await ref
          .read(quoteControllerProvider.notifier)
          .calculateStandardQuote(
            productTypeId: productTypeId,
            packagingTypeId: packagingTypeId,
            totalWeightKg: totalWeightKg,
            pickupCity: pickupCity,
            pickupState: pickupState,
            deliveryCity: deliveryCity,
            deliveryState: deliveryState,
            serviceType: serviceType,
            declaredValue: declaredValue,
            addOns: selectedAddons,
            length: dimensions['length'],
            width: dimensions['width'],
            height: dimensions['height'],
          );

      // ✅ Force state update
      setState(() {
        hasCalculatedQuotes = true;
        isLoadingQuotes = false;
      });

      print("✅✅✅ Quotes calculation completed!");
    } catch (e) {
      print("❌❌❌ Error in calculateStandardQuotes: $e");
      rethrow;
    }
  }

  Future<void> _calculateMultiStopQuotes({
    required int productTypeId,
    required int packagingTypeId,
    required double totalWeightKg,
    required List<String> selectedAddons,
  }) async {
    final cache = ref.read(orderCacheProvider);
    final stopsCount =
        int.tryParse(cache["route_stops_count"]?.toString() ?? "0") ?? 0;

    if (stopsCount < 2) {
      throw Exception("Multi-stop route requires at least 2 stops");
    }

    final stops = <StopRequest>[];

    for (int i = 1; i <= stopsCount; i++) {
      final stopTypeStr = cache["stop_${i}_type"]?.toString() ?? "";
      final city = cache["stop_${i}_city"]?.toString().trim() ?? "";
      final state = cache["stop_${i}_state"]?.toString().trim() ?? "";
      final contactName = cache["stop_${i}_contact_name"]?.toString() ?? "";
      final contactPhone = cache["stop_${i}_contact_phone"]?.toString() ?? "";
      final address = cache["stop_${i}_address"]?.toString() ?? "";

      if (city.isEmpty || state.isEmpty) {
        throw Exception("Stop $i: City and State are required");
      }

      // ✅ Convert UI StopType to API format
      String apiStopType;
      if (stopTypeStr.contains("pickup")) {
        apiStopType = "pickup";
      } else if (stopTypeStr.contains("waypoint")) {
        apiStopType = "waypoint";
      } else if (stopTypeStr.contains("dropOff")) {
        apiStopType = "drop_off";
      } else {
        // Default: first is pickup, last is drop_off, others waypoint
        if (i == 1)
          apiStopType = "pickup";
        else if (i == stopsCount)
          apiStopType = "drop_off";
        else
          apiStopType = "waypoint";
      }

      stops.add(
        StopRequest(
          stopType: apiStopType,
          city: city,
          state: state,
          contactName: contactName.isNotEmpty ? contactName : null,
          contactPhone: contactPhone.isNotEmpty ? contactPhone : null,
          address: address.isNotEmpty ? address : null,
        ),
      );
    }

    await ref
        .read(quoteControllerProvider.notifier)
        .calculateMultiStopQuote(
          productTypeId: productTypeId,
          packagingTypeId: packagingTypeId,
          totalWeightKg: totalWeightKg,
          stops: stops,
          serviceType: selectedServiceTypeId ?? "standard",
          declaredValue: declaredValue,
          addOns: selectedAddons,
        );
  }

  Map<String, double?> _getDimensionsFromCache(Map<String, dynamic> cache) {
    final length = cache["package_length"]?.toString();
    final width = cache["package_width"]?.toString();
    final height = cache["package_height"]?.toString();

    return {
      'length': length != null ? double.tryParse(length) : null,
      'width': width != null ? double.tryParse(width) : null,
      'height': height != null ? double.tryParse(height) : null,
    };
  }

  void _onServiceTypeChanged(String newType, String? name, double multiplier) {
    setState(() {
      selectedServiceTypeId = newType;
      selectedServiceTypeName = name;
    });

    ref.read(orderCacheProvider.notifier).saveValue("service_type_id", newType);
    if (name != null) {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("service_type_name", name);
    }
    ref
        .read(orderCacheProvider.notifier)
        .saveValue("service_multiplier", multiplier.toString());

    serviceType = newType;

    // Recalculate quotes if already calculated
    if (hasCalculatedQuotes) {
      _getSmartQuotes();
    }
  }

  // Add-on toggle function
  void _toggleAddOn(String addOnId, double cost) {
    final selectedAddons = ref.read(selectedAddonsProvider);

    setState(() {
      if (selectedAddons.contains(addOnId)) {
        ref.read(selectedAddonsProvider.notifier).state = selectedAddons
            .where((id) => id != addOnId)
            .toList();
      } else {
        ref.read(selectedAddonsProvider.notifier).state = [
          ...selectedAddons,
          addOnId,
        ];
      }
    });

    ref
        .read(orderCacheProvider.notifier)
        .saveValue("selected_addons", ref.read(selectedAddonsProvider));

    // Recalculate quotes if already calculated
    if (hasCalculatedQuotes) {
      _getSmartQuotes();
    }
  }

  // addons
  void _openAddOnsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 80,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final addOnsState = ref.watch(addOnsControllerProvider);

              return addOnsState.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),

                error: (e, _) => const SizedBox(
                  height: 200,
                  child: Center(child: Text("Failed to load add-ons")),
                ),

                data: (data) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------- Header --------
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Select Add-ons",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      // -------- Grid --------
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            itemCount: data.addOns.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // ✅ 2 per row
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.80,
                                ),
                            itemBuilder: (context, index) {
                              return _addonModalCard(item: data.addOns[index]);
                            },
                          ),
                        ),
                      ),

                      // -------- Bottom Action (optional but recommended) --------
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.electricTeal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Done",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Check if all required data is available for quote calculation
  bool _isDataReadyForQuotes() {
    final cache = ref.read(orderCacheProvider);

    // Check basic requirements
    if (cache["selected_product_type_id"] == null ||
        cache["selected_packaging_type_id"] == null ||
        cache["total_weight"] == null) {
      return false;
    }

    // Check if multi-stop or single-stop data is available
    final isMultiStop = cache["is_multi_stop_enabled"] == "true";

    if (isMultiStop) {
      // Check multi-stop data
      final stopsCount =
          int.tryParse(cache["route_stops_count"]?.toString() ?? "0") ?? 0;
      if (stopsCount < 2) return false;

      for (int i = 1; i <= stopsCount; i++) {
        if (cache["stop_${i}_city"] == null ||
            cache["stop_${i}_state"] == null) {
          return false;
        }
      }
    } else {
      // Check single-stop data
      if (cache["pickup_city"] == null ||
          cache["pickup_state"] == null ||
          cache["delivery_city"] == null ||
          cache["delivery_state"] == null) {
        return false;
      }
    }

    return true;
  }

  // Validate before calculating quotes
  String? _validateBeforeQuotes() {
    if (!_isDataReadyForQuotes()) {
      return "Please complete all previous steps before calculating quotes";
    }

    if (selectedServiceTypeId == null) {
      return "Please select a service type";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final quoteState = ref.watch(quoteControllerProvider);
    final bestQuote = ref.watch(bestQuoteProvider);

    ref.listen<AsyncValue<QuoteData?>>(quoteControllerProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (data) {
          if (data != null && data.quotes.isNotEmpty) {
            print("📊 Quotes data updated: ${data.quotes.length} quotes");
            // Force UI refresh
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {});
              }
            });
          }
        },
        loading: () => print("🔄 Quotes loading..."),
        error: (error, stackTrace) => print("❌ Quotes error: $error"),
      );
    });

    // Debug print for console
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("\n🔍 DEBUG ORDER STATUS:");
      print("hasCalculatedQuotes: $hasCalculatedQuotes");
      print("bestQuote is null: ${bestQuote == null}");
      print("Quote count: ${quoteState.value?.quotes.length ?? 0}");
      if (bestQuote != null) {
        print(
          "Best Quote: ${bestQuote.vehicleType} - R${bestQuote.pricing.total}",
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        backgroundColor: AppColors.electricTeal,
        elevation: 0,
        leading: RotatedBox(
          quarterTurns: 2,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_forward_rounded, color: AppColors.pureWhite),
          ),
        ),
        title: CustomText(
          txt: "New Order",
          color: AppColors.pureWhite,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapH4,
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Pickup Section
                  // Row(
                  //   children: [
                  //     Icon(Icons.bar_chart, color: AppColors.electricTeal),
                  //     SizedBox(width: 8),
                  //     CustomText(
                  //       txt: "Pick Up",
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ],
                  // ),
                  // gapH8,
                  // _buildPickupSection(),
                  // gapH16,

                  // // Delivery Section
                  // Row(
                  //   children: [
                  //     Icon(Icons.bar_chart, color: AppColors.electricTeal),
                  //     SizedBox(width: 8),
                  //     CustomText(
                  //       txt: "Delivery",
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ],
                  // ),
                  // gapH8,
                  // _buildDeliverySection(),
                  Consumer(
                    builder: (context, ref, child) {
                      final cache = ref.watch(orderCacheProvider);
                      final isMultiStop =
                          cache["is_multi_stop_enabled"] == "true";

                      if (isMultiStop) {
                        return _buildMultiStopRouteOverview();
                      } else {
                        return _buildStandardRouteOverview();
                      }
                    },
                  ),

                  gapH16,

                  // Service Options Section
                  Column(
                    children: [
                      _sectionTitle(Icons.local_shipping, "Service Options"),
                      const SizedBox(height: 10),
                      Consumer(
                        builder: (context, ref, child) {
                          final serviceTypeState = ref.watch(
                            serviceTypeControllerProvider,
                          );
                          return serviceTypeState.when(
                            data: (data) {
                              final serviceItems = data.serviceTypes;
                              return Column(
                                children: serviceItems.map((service) {
                                  final basePrice = 100.0;
                                  final calculatedPrice =
                                      basePrice * service.multiplier;
                                  final priceText = service.multiplier > 1.0
                                      ? "(+R${(calculatedPrice - basePrice).toStringAsFixed(0)})"
                                      : "(R${calculatedPrice.toStringAsFixed(0)})";
                                  return _serviceOption(
                                    selected:
                                        selectedServiceTypeId == service.id,
                                    title: service.name,
                                    subtitle:
                                        "${service.description} $priceText",
                                    value: service.id,
                                    icon: service.getIconData(),
                                    multiplier: service.multiplier,
                                  );
                                }).toList(),
                              );
                            },
                            loading: () => _buildLoadingContainer(
                              "Loading service options...",
                            ),
                            error: (error, stackTrace) => _buildErrorContainer(
                              "Failed to load service options",
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  gapH16,

                  // Add-ons Section
                  Consumer(
                    builder: (context, ref, child) {
                      final addOnsState = ref.watch(addOnsControllerProvider);
                      return addOnsState.when(
                        data: (data) => _buildAddOnsSection(data.addOns),
                        loading: () => _buildAddOnsLoading(),
                        error: (error, stackTrace) => _buildAddOnsError(),
                      );
                    },
                  ),

                  gapH16,

                  // GET SMART QUOTES BUTTON
                  _buildGetQuotesButton(),

                  // Quote Error Display
                  if (quoteError != null) _buildQuoteError(),

                  gapH16,

                  // PAYMENT SUMMARY SECTION
                  if (hasCalculatedQuotes) _buildPaymentSummary(quoteState),

                  // DEBUG INFORMATION SECTION
                  // _buildDebugInfoSection(),
                  gapH16,

                  // Place Order Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final orderState = ref.watch(orderControllerProvider);
                        final isOrderLoading = orderState.isLoading;
                        final bestQuote = ref.watch(bestQuoteProvider);
                        final quoteState = ref.watch(quoteControllerProvider);

                        // ✅ FIXED: SIMPLE VALIDATION - If quotes exist, allow order
                        bool canPlaceOrder = false;
                        bool hasQuotes = false;
                        Quote? quoteToUse = bestQuote;

                        if (hasCalculatedQuotes &&
                            quoteState.value != null &&
                            quoteState.value!.quotes.isNotEmpty) {
                          hasQuotes = true;

                          // ✅ If bestQuote is null but we have quotes, use first quote
                          if (bestQuote == null) {
                            print("⚠️ Best quote is null, using first quote");
                            quoteToUse = quoteState.value!.quotes.first;
                            canPlaceOrder = true;
                            print(
                              "✅✅✅ CAN PLACE ORDER: Using first quote as default",
                            );
                          } else {
                            quoteToUse = bestQuote;
                            canPlaceOrder = true;
                            print("✅✅✅ CAN PLACE ORDER: Best quote selected");
                          }
                        }

                        print("🔄 Button Status:");
                        print("hasCalculatedQuotes: $hasCalculatedQuotes");
                        print("hasQuotes: $hasQuotes");
                        print(
                          "quoteToUse: ${quoteToUse?.vehicleType ?? 'null'}",
                        );
                        print("canPlaceOrder: $canPlaceOrder");

                        return CustomButton(
                          text: isOrderLoading
                              ? "Placing Order..."
                              : "Place Order",

                          backgroundColor: canPlaceOrder
                              ? AppColors.electricTeal
                              : AppColors.lightGrayBackground,
                          borderColor: canPlaceOrder
                              ? AppColors.electricTeal
                              : AppColors.electricTeal,
                          textColor: canPlaceOrder
                              ? AppColors.pureWhite
                              : AppColors.electricTeal,
                          onPressed: canPlaceOrder && quoteToUse != null
                              ? () async {
                                  print("🎯 Place Order Button Pressed");
                                  print("📋 Selected Quote Details:");
                                  print("Vehicle ID: ${quoteToUse!.vehicleId}");
                                  print(
                                    "Vehicle Type: ${quoteToUse.vehicleType}",
                                  );
                                  print("Driver ID: ${quoteToUse.driver.id}");
                                  print("Price: R${quoteToUse.pricing.total}");

                                  try {
                                    // ✅ Temporary: Update bestQuoteProvider manually
                                    // Agar aap provider update nahi kar sakte
                                    if (bestQuote == null) {
                                      print(
                                        "ℹ️ Manually setting quote for order placement",
                                      );
                                    }

                                    // ✅ Place order
                                    await ref
                                        .read(orderControllerProvider.notifier)
                                        .placeOrder(context);
                                  } catch (e) {
                                    print("❌ Error placing order: $e");
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Error: ${e.toString()}"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              : null,
                        );
                      },
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Consumer(
                  //     builder: (context, ref, child) {
                  //       final orderState = ref.watch(orderControllerProvider);
                  //       final isOrderLoading = orderState.isLoading;
                  //       final bestQuote = ref.watch(bestQuoteProvider);
                  //       final quoteState = ref.watch(quoteControllerProvider);

                  //       // ✅ FIXED VALIDATION: Check if quotes exist AND bestQuote is selected
                  //       bool canPlaceOrder = false;

                  //       if (hasCalculatedQuotes &&
                  //           quoteState.value != null &&
                  //           quoteState.value!.quotes.isNotEmpty) {
                  //         if (bestQuote != null) {
                  //           canPlaceOrder = true;
                  //           print("✅✅✅ CAN PLACE ORDER: Best quote selected!");
                  //         } else {
                  //           print(
                  //             "⚠️⚠️⚠️ Cannot place order: Best quote is null",
                  //           );
                  //         }
                  //       }

                  //       print("🔄 Button Status:");
                  //       print("hasCalculatedQuotes: $hasCalculatedQuotes");
                  //       print(
                  //         "quoteState has data: ${quoteState.value != null}",
                  //       );
                  //       print(
                  //         "quotes exist: ${quoteState.value?.quotes.isNotEmpty ?? false}",
                  //       );
                  //       print("bestQuote is null: ${bestQuote == null}");
                  //       print("isOrderLoading: $isOrderLoading");
                  //       print("canPlaceOrder: $canPlaceOrder");

                  //       return CustomButton(
                  //         text: isOrderLoading
                  //             ? "Placing Order..."
                  //             : "Place Order",
                  //         backgroundColor: canPlaceOrder
                  //             ? AppColors.electricTeal
                  //             : AppColors.mediumGray.withOpacity(0.3),
                  //         borderColor: canPlaceOrder
                  //             ? AppColors.electricTeal
                  //             : AppColors.mediumGray.withOpacity(0.5),
                  //         textColor: canPlaceOrder
                  //             ? AppColors.pureWhite
                  //             : AppColors.darkText.withOpacity(0.5),
                  //         onPressed: canPlaceOrder
                  //             ? () async {
                  //                 print("🎯 Place Order Button Pressed");
                  //                 print("📋 Selected Quote Details:");
                  //                 print("Vehicle ID: ${bestQuote!.vehicleId}");
                  //                 print(
                  //                   "Vehicle Type: ${bestQuote.vehicleType}",
                  //                 );
                  //                 print("Driver ID: ${bestQuote.driver.id}");
                  //                 print("Price: R${bestQuote.pricing.total}");

                  //                 try {
                  //                   // ✅ Final validation
                  //                   if (bestQuote == null) {
                  //                     ScaffoldMessenger.of(
                  //                       context,
                  //                     ).showSnackBar(
                  //                       SnackBar(
                  //                         content: Text(
                  //                           "Please select a quote first",
                  //                         ),
                  //                         backgroundColor: Colors.orange,
                  //                       ),
                  //                     );
                  //                     return;
                  //                   }

                  //                   // ✅ Place order
                  //                   await ref
                  //                       .read(orderControllerProvider.notifier)
                  //                       .placeOrder(context);
                  //                 } catch (e) {
                  //                   print("❌ Error placing order: $e");
                  //                   ScaffoldMessenger.of(context).showSnackBar(
                  //                     SnackBar(
                  //                       content: Text("Error: ${e.toString()}"),
                  //                       backgroundColor: Colors.red,
                  //                     ),
                  //                   );
                  //                 }
                  //               }
                  //             : null,
                  //       );
                  //     },
                  //   ),
                  // ),
                  gapH12,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NEW: Multi-Stop Route Overview Widget
  Widget _buildMultiStopRouteOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.route, color: AppColors.electricTeal),
            SizedBox(width: 8),
            CustomText(
              txt: "Multi-Stop Route",
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.electricTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${multiStopLocations.length} Stops",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.electricTeal,
                ),
              ),
            ),
          ],
        ),
        gapH8,

        // Route Timeline
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricTeal.withOpacity(0.12),
                      AppColors.electricTeal.withOpacity(0.04),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.map_outlined,
                      size: 18,
                      color: AppColors.electricTeal,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Route Overview",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // BODY - Timeline
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Timeline with all stops
                    for (int i = 0; i < multiStopLocations.length; i++)
                      _buildTimelineStop(
                        index: i,
                        total: multiStopLocations.length,
                        stop: multiStopLocations[i],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // NEW: Build individual timeline stop
  Widget _buildTimelineStop({
    required int index,
    required int total,
    required Map<String, String> stop,
  }) {
    final isFirst = index == 0;
    final isLast = index == total - 1;
    final stopType = stop['stopType'] ?? 'Stop';
    final color = Color(
      int.tryParse(stop['color'] ?? '0xFF000000') ?? 0xFF000000,
    );

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line and dot
            Column(
              children: [
                // Top connector (not for first)
                if (!isFirst)
                  Container(
                    width: 2,
                    height: 20,
                    color: AppColors.mediumGray.withOpacity(0.3),
                  ),

                // Dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Bottom connector (not for last)
                if (!isLast)
                  Container(
                    width: 2,
                    height: 20,
                    color: AppColors.mediumGray.withOpacity(0.3),
                  ),
              ],
            ),

            SizedBox(width: 12),

            // Stop details
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stop header with number
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            stopType,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "Stop ${index + 1}",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mediumGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Address
                    Text(
                      stop['address'] ?? 'No Address',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),

                    SizedBox(height: 4),

                    // City/State
                    Text(
                      "${stop['city'] ?? 'City'} • ${stop['state'] ?? 'State'}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                      ),
                    ),

                    SizedBox(height: 8),

                    // Contact info
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: AppColors.mediumGray,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "${stop['name']} • ${stop['phone']}",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Existing standard route overview (for single stop)
  Widget _buildStandardRouteOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pickup Section
        Row(
          children: [
            Icon(Icons.bar_chart, color: AppColors.electricTeal),
            SizedBox(width: 8),
            CustomText(
              txt: "Pick Up",
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        gapH8,
        _buildPickupSection(),
        gapH16,

        // Delivery Section
        Row(
          children: [
            Icon(Icons.bar_chart, color: AppColors.electricTeal),
            SizedBox(width: 8),
            CustomText(
              txt: "Delivery",
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        gapH8,
        _buildDeliverySection(),
      ],
    );
  }

  // Your existing _buildPickupSection() and _buildDeliverySection() methods remain same
  Widget _buildPickupSection() {
    return Consumer(
      builder: (context, ref, child) {
        final cache = ref.watch(orderCacheProvider);
        final isMultiStop = cache["is_multi_stop_enabled"] == "true";

        String pickupName;
        String pickupPhone;
        String pickupAddress;
        String pickupCity;
        String pickupState;

        if (isMultiStop) {
          pickupName =
              cache["stop_1_contact_name"] ??
              cache["pickup_name"] ??
              "Name N/A";
          pickupPhone =
              cache["stop_1_contact_phone"] ??
              cache["pickup_phone"] ??
              "Phone N/A";
          pickupAddress =
              cache["stop_1_address"] ??
              cache["pickup_address1"] ??
              "No Address";
          pickupCity =
              cache["stop_1_city"] ?? cache["pickup_city"] ?? "City N/A";
          pickupState =
              cache["stop_1_state"] ?? cache["pickup_state"] ?? "State N/A";
        } else {
          pickupName = cache["pickup_name"] ?? "Name N/A";
          pickupPhone = cache["pickup_phone"] ?? "Phone N/A";
          pickupAddress = cache["pickup_address1"] ?? "No Address";
          pickupCity = cache["pickup_city"] ?? "City N/A";
          pickupState = cache["pickup_state"] ?? "State N/A";
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.electricTeal.withOpacity(0.12),
                      AppColors.electricTeal.withOpacity(0.04),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.store_mall_directory,
                      size: 18,
                      color: AppColors.electricTeal,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Pickup Location",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // BODY
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TIMELINE
                    Column(
                      children: [
                        _dot(AppColors.electricTeal),
                        Container(
                          width: 2,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.electricTeal.withOpacity(0.4),
                                AppColors.mediumGray.withOpacity(0.2),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    // CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            txt: pickupAddress,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            txt: "$pickupCity • $pickupState",
                            fontSize: 12,
                            color: AppColors.mediumGray,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              CustomText(
                                txt: "$pickupName • $pickupPhone",
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mediumGray,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliverySection() {
    return Consumer(
      builder: (context, ref, child) {
        final cache = ref.watch(orderCacheProvider);

        final isMultiStop = cache["is_multi_stop_enabled"] == "true";
        final stopsCount =
            int.tryParse(cache["route_stops_count"]?.toString() ?? "0") ?? 0;

        String deliveryName;
        String deliveryPhone;
        String deliveryAddress;
        String deliveryCity;
        String deliveryState;

        if (isMultiStop && stopsCount > 0) {
          final lastStopIndex = stopsCount;
          deliveryName =
              cache["stop_${lastStopIndex}_contact_name"] ??
              cache["delivery_name"] ??
              "Name N/A";
          deliveryPhone =
              cache["stop_${lastStopIndex}_contact_phone"] ??
              cache["delivery_phone"] ??
              "Phone N/A";
          deliveryAddress =
              cache["stop_${lastStopIndex}_address"] ??
              cache["delivery_address1"] ??
              "No Address";
          deliveryCity =
              cache["stop_${lastStopIndex}_city"] ??
              cache["delivery_city"] ??
              "City N/A";
          deliveryState =
              cache["stop_${lastStopIndex}_state"] ??
              cache["delivery_state"] ??
              "State N/A";
        } else {
          deliveryName = cache["delivery_name"] ?? "Name N/A";
          deliveryPhone = cache["delivery_phone"] ?? "Phone N/A";
          deliveryAddress = cache["delivery_address1"] ?? "No Address";
          deliveryCity = cache["delivery_city"] ?? "City N/A";
          deliveryState = cache["delivery_state"] ?? "State N/A";
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.withOpacity(0.14),
                      Colors.orange.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.flag_outlined, size: 18, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      "Delivery Location",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // BODY
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 2,
                          height: 46,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.mediumGray.withOpacity(0.25),
                                AppColors.limeGreen.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                        _dot(AppColors.limeGreen),
                      ],
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            txt: deliveryAddress,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            txt: "$deliveryCity • $deliveryState",
                            fontSize: 12,
                            color: AppColors.mediumGray,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              CustomText(
                                txt: "$deliveryName • $deliveryPhone",
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.mediumGray,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  /////////////////////////

  // DEBUG INFORMATION WIDGET
  Widget _buildDebugInfoSection() {
    return Consumer(
      builder: (context, ref, child) {
        final bestQuote = ref.watch(bestQuoteProvider);
        final quoteState = ref.watch(quoteControllerProvider);

        return Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bug_report, size: 18, color: Colors.orange[800]),
                  SizedBox(width: 8),
                  Text(
                    "Debug Information",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildDebugRow("Quotes Calculated", hasCalculatedQuotes),
              _buildDebugRow("Best Quote Selected", bestQuote != null),
              _buildDebugRow(
                "Quotes Available",
                quoteState.value?.quotes.length ?? 0,
              ),
              SizedBox(height: 8),
              if (bestQuote != null)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selected Quote Details:",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Vehicle: ${bestQuote.vehicleType}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        "Price: R${bestQuote.pricing.total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[800],
                        ),
                      ),
                      Text(
                        "Driver: ${bestQuote.driver.name}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                )
              else if (hasCalculatedQuotes)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    "⚠️ Quotes calculated but no best quote selected",
                    style: TextStyle(fontSize: 12, color: Colors.red[800]),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    "ℹ️ Click 'Get Smart Quotes' to calculate",
                    style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDebugRow(String label, dynamic value) {
    bool isBoolTrue = (value is bool && value);
    bool isNumPositive = (value is num && value > 0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isBoolTrue || isNumPositive
                  ? Colors.green[100]
                  : Colors.red[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isBoolTrue || isNumPositive
                    ? Colors.green[800]
                    : Colors.red[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Get Smart Quotes Button
  Widget _buildGetQuotesButton() {
    final validationError = _validateBeforeQuotes();
    final isDisabled = validationError != null || isLoadingQuotes;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: isDisabled ? null : _getSmartQuotes,
            icon: isLoadingQuotes
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(Icons.calculate, size: 24),
            label: Text(
              isLoadingQuotes
                  ? "Calculating Quotes..."
                  : hasCalculatedQuotes
                  ? "Recalculate Quotes"
                  : "Get Smart Quotes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDisabled
                  ? Colors.grey[400]
                  : AppColors.electricTeal,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
          ),

          if (validationError != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                validationError,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange[700],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  // Quote Error Display
  Widget _buildQuoteError() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Quote Calculation Failed",
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  quoteError ?? "Unknown error",
                  style: TextStyle(color: Colors.red[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: Payment Summary Widget
  Widget _buildPaymentSummary(AsyncValue<QuoteData?> quoteState) {
    return Consumer(
      builder: (context, ref, child) {
        final bestQuote = ref.watch(bestQuoteProvider);
        final quoteState = ref.watch(quoteControllerProvider);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            children: [
              // Header with Icon
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.electricTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  border: Border.all(
                    color: AppColors.electricTeal.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: AppColors.electricTeal,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Payment Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),

              // Summary Content
              Container(
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: AppColors.mediumGray.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: quoteState.when(
                  data: (quoteData) {
                    // ✅ Check if we have quotes
                    if (quoteData == null) {
                      print("❌ No quote data available");
                      return _buildNoQuotesState("No quote data received");
                    }

                    if (quoteData.quotes.isEmpty) {
                      print("❌ No quotes available from API");
                      return _buildNoQuotesState(
                        "No quotes available for your request",
                      );
                    }

                    // ✅ CHECK IF BEST QUOTE IS NULL
                    if (bestQuote == null) {
                      print("⚠️ Quotes available but bestQuote is null");
                      print("Total quotes count: ${quoteData.quotes.length}");

                      // ✅ AUTO-SELECT THE FIRST QUOTE AS BEST QUOTE
                      // Yeh temporary fix hai taki UI show kare
                      final firstQuote = quoteData.quotes.first;
                      print(
                        "Auto-selecting first quote: ${firstQuote.vehicleType}",
                      );

                      return _buildQuoteDetails(firstQuote, quoteData);
                    }

                    print("✅ Showing best quote: ${bestQuote.vehicleType}");
                    return _buildQuoteDetails(bestQuote, quoteData);
                  },
                  loading: () => _buildLoadingState(),
                  error: (e, st) => _buildErrorState(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // Widget _buildPaymentSummary(AsyncValue<QuoteData?> quoteState) {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final bestQuote = ref.watch(bestQuoteProvider);
  //       final quoteState = ref.watch(quoteControllerProvider);

  //       return Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 1),
  //         child: Column(
  //           children: [
  //             // Header with Icon
  //             Container(
  //               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //               decoration: BoxDecoration(
  //                 color: AppColors.electricTeal.withOpacity(0.1),
  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  //                 border: Border.all(
  //                   color: AppColors.electricTeal.withOpacity(0.3),
  //                   width: 1,
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.receipt_long,
  //                     color: AppColors.electricTeal,
  //                     size: 22,
  //                   ),
  //                   const SizedBox(width: 8),
  //                   Text(
  //                     "Payment Summary",
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.w700,
  //                       color: AppColors.darkText,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             // Summary Content
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: AppColors.pureWhite,
  //                 borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
  //                 border: Border.all(
  //                   color: AppColors.mediumGray.withOpacity(0.2),
  //                   width: 1,
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.05),
  //                     blurRadius: 8,
  //                     offset: Offset(0, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: quoteState.when(
  //                 data: (quoteData) {
  //                   // ✅ Check if we have quotes
  //                   if (quoteData == null) {
  //                     print("❌ No quote data available");
  //                     return _buildNoQuotesState("No quote data received");
  //                   }

  //                   if (quoteData.quotes.isEmpty) {
  //                     print("❌ No quotes available from API");
  //                     return _buildNoQuotesState("No quotes available for your request");
  //                   }

  //                   if (bestQuote == null) {
  //                     print("⚠️ No best quote selected");
  //                     return _buildNoQuotesState("Please select a quote");
  //                   }

  //                   print("✅ Showing best quote: ${bestQuote.vehicleType}");
  //                   return _buildQuoteDetails(bestQuote, quoteData);
  //                 },
  //                 loading: () => _buildLoadingState(),
  //                 error: (e, st) => _buildErrorState(),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  //  FIXED: No Quotes State
  Widget _buildNoQuotesState(String message) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.receipt_long, size: 48, color: AppColors.mediumGray),
          SizedBox(height: 16),
          Text(
            "No Quotes Available",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mediumGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _getSmartQuotes,
            child: Text("Try Again"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricTeal,
            ),
          ),
        ],
      ),
    );
  }

  // Quote Details Widget
  Widget _buildQuoteDetails(Quote quote, QuoteData quoteData) {
    final pricing = quote.pricing;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Best Quote Selected",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${quote.company.name} • ${quote.vehicleType}",
                    style: TextStyle(fontSize: 12, color: AppColors.mediumGray),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.electricTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    SizedBox(width: 4),
                    Text(
                      "${quote.totalScore.toStringAsFixed(1)}% Match",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.electricTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Vehicle Details
          _buildQuoteDetailCard(
            icon: Icons.directions_car,
            title: "Vehicle Details",
            children: [
              _buildDetailRow("Type", quote.vehicleType),
              _buildDetailRow("Capacity", "${quote.capacityWeightKg}kg"),
              _buildDetailRow("Registration", quote.registrationNumber),
              _buildDetailRow(
                "Driver",
                "${quote.driver.name} (⭐ ${quote.driver.rating})",
              ),
            ],
          ),

          SizedBox(height: 12),

          // Pricing Breakdown
          _buildQuoteDetailCard(
            icon: Icons.attach_money,
            title: "Pricing Breakdown",
            children: [
              _buildPriceRow("Base Fare", pricing.baseFare),
              _buildPriceRow("Distance Cost", pricing.distanceCost),
              if (pricing.weightCharge > 0)
                _buildPriceRow("Weight Charge", pricing.weightCharge),
              if (pricing.addOnsTotal > 0)
                _buildPriceRow("Add-ons Total", pricing.addOnsTotal),
              Divider(height: 20),
              _buildPriceRow("Service Fee", pricing.serviceFee, isBold: true),
              _buildPriceRow("Tax", pricing.tax, isBold: true),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.electricTeal.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.electricTeal.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    Text(
                      "R${pricing.total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.electricTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Distance Info
          if (quoteData.distanceKm != null && quoteData.distanceKm! > 0)
            Container(
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.map, size: 20, color: Colors.blue[700]),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Estimated Distance",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${quoteData.distanceKm!.toStringAsFixed(1)} km",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Product & Packaging Info
          if (quoteData.productType != null || quoteData.packagingType != null)
            Container(
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.inventory, size: 20, color: Colors.green[700]),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (quoteData.productType != null)
                          Text(
                            "Product: ${quoteData.productType!.name}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[800],
                            ),
                          ),
                        if (quoteData.packagingType != null)
                          Text(
                            "Packaging: ${quoteData.packagingType!.name}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[800],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // View All Quotes Button
          Container(
            margin: EdgeInsets.only(top: 16),
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                _showAllQuotes(quoteData);
              },
              icon: Icon(Icons.list_alt, size: 18),
              label: Text("View All Quotes (${quoteData.quotes.length})"),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.electricTeal),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllQuotes(QuoteData quoteData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.electricTeal,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "All Available Quotes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Quotes List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: quoteData.quotes.length,
                  itemBuilder: (context, index) {
                    final quote = quoteData.quotes[index];
                    final isBest =
                        ref.read(bestQuoteProvider)?.vehicleId ==
                        quote.vehicleId;

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isBest
                              ? AppColors.electricTeal
                              : Colors.grey[300]!,
                          width: isBest ? 2 : 1,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.electricTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.local_shipping,
                            size: 30,
                            color: AppColors.electricTeal,
                          ),
                        ),
                        title: Text(
                          quote.vehicleType,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              "${quote.company.name} • ${quote.driver.name}",
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, size: 12, color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  "${quote.totalScore.toStringAsFixed(1)}% Match",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "R${quote.pricing.total.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.electricTeal,
                              ),
                            ),
                            if (isBest)
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.electricTeal,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "BEST",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuoteDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.electricTeal),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkText,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "R${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.darkText,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildNoQuotesState() {
  //   return Container(
  //     padding: EdgeInsets.all(24),
  //     child: Column(
  //       children: [
  //         Icon(Icons.receipt_long, size: 48, color: AppColors.mediumGray),
  //         SizedBox(height: 16),
  //         Text(
  //           "No Quotes Available",
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: AppColors.mediumGray,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           "Click 'Get Smart Quotes' to calculate pricing",
  //           style: TextStyle(fontSize: 14, color: AppColors.mediumGray),
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.electricTeal,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Loading quotes...",
            style: TextStyle(fontSize: 16, color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            "Failed to load quotes",
            style: TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          TextButton(onPressed: _getSmartQuotes, child: Text("Try Again")),
        ],
      ),
    );
  }

  // pickup section
  // pickup section
  // Widget _buildPickupSection() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final cache = ref.watch(orderCacheProvider);
  //       final isMultiStop = cache["is_multi_stop_enabled"] == "true";

  //       String pickupName;
  //       String pickupPhone;
  //       String pickupAddress;
  //       String pickupCity;
  //       String pickupState;

  //       if (isMultiStop) {
  //         pickupName =
  //             cache["stop_1_contact_name"] ??
  //             cache["pickup_name"] ??
  //             "Name N/A";
  //         pickupPhone =
  //             cache["stop_1_contact_phone"] ??
  //             cache["pickup_phone"] ??
  //             "Phone N/A";
  //         pickupAddress =
  //             cache["stop_1_address"] ??
  //             cache["pickup_address1"] ??
  //             "No Address";
  //         pickupCity =
  //             cache["stop_1_city"] ?? cache["pickup_city"] ?? "City N/A";
  //         pickupState =
  //             cache["stop_1_state"] ?? cache["pickup_state"] ?? "State N/A";
  //       } else {
  //         pickupName = cache["pickup_name"] ?? "Name N/A";
  //         pickupPhone = cache["pickup_phone"] ?? "Phone N/A";
  //         pickupAddress = cache["pickup_address1"] ?? "No Address";
  //         pickupCity = cache["pickup_city"] ?? "City N/A";
  //         pickupState = cache["pickup_state"] ?? "State N/A";
  //       }

  //       return Container(
  //         margin: const EdgeInsets.only(bottom: 16),
  //         decoration: BoxDecoration(
  //           color: AppColors.pureWhite,
  //           borderRadius: BorderRadius.circular(18),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.07),
  //               blurRadius: 14,
  //               offset: const Offset(0, 6),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           children: [
  //             // HEADER
  //             Container(
  //               padding: const EdgeInsets.all(14),
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     AppColors.electricTeal.withOpacity(0.12),
  //                     AppColors.electricTeal.withOpacity(0.04),
  //                   ],
  //                 ),
  //                 borderRadius: const BorderRadius.vertical(
  //                   top: Radius.circular(18),
  //                 ),
  //               ),
  //               child: Row(
  //                 children: const [
  //                   Icon(
  //                     Icons.store_mall_directory,
  //                     size: 18,
  //                     color: AppColors.electricTeal,
  //                   ),
  //                   SizedBox(width: 8),
  //                   Text(
  //                     "Pickup Location",
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             // BODY
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // TIMELINE
  //                   Column(
  //                     children: [
  //                       _dot(AppColors.electricTeal),
  //                       Container(
  //                         width: 2,
  //                         height: 46,
  //                         decoration: BoxDecoration(
  //                           gradient: LinearGradient(
  //                             begin: Alignment.topCenter,
  //                             end: Alignment.bottomCenter,
  //                             colors: [
  //                               AppColors.electricTeal.withOpacity(0.4),
  //                               AppColors.mediumGray.withOpacity(0.2),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(width: 14),

  //                   // CONTENT
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         CustomText(
  //                           txt: pickupAddress,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                         const SizedBox(height: 4),
  //                         CustomText(
  //                           txt: "$pickupCity • $pickupState",
  //                           fontSize: 12,
  //                           color: AppColors.mediumGray,
  //                         ),
  //                         const SizedBox(height: 12),
  //                         Row(
  //                           children: [
  //                             const Icon(
  //                               Icons.person_outline,
  //                               size: 16,
  //                               color: Colors.grey,
  //                             ),
  //                             const SizedBox(width: 6),
  //                             CustomText(
  //                               txt: "$pickupName • $pickupPhone",
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w600,
  //                               color: AppColors.mediumGray,
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildPickupSection() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final cache = ref.watch(orderCacheProvider);

  //       // Check if multi-stop is enabled
  //       final isMultiStop = cache["is_multi_stop_enabled"] == "true";

  //       // Get pickup data based on mode
  //       String pickupName;
  //       String pickupPhone;
  //       String pickupAddress;
  //       String pickupCity;
  //       String pickupState;

  //       if (isMultiStop) {
  //         // For multi-stop, get from specific stop 1 (pickup)
  //         pickupName =
  //             cache["stop_1_contact_name"] ??
  //             cache["pickup_name"] ??
  //             "Name N/A";
  //         pickupPhone =
  //             cache["stop_1_contact_phone"] ??
  //             cache["pickup_phone"] ??
  //             "Phone N/A";
  //         pickupAddress =
  //             cache["stop_1_address"] ??
  //             cache["pickup_address1"] ??
  //             "No Address";
  //         pickupCity =
  //             cache["stop_1_city"] ?? cache["pickup_city"] ?? "City N/A";
  //         pickupState =
  //             cache["stop_1_state"] ?? cache["pickup_state"] ?? "State N/A";
  //       } else {
  //         // For single-stop, get from standard cache
  //         pickupName = cache["pickup_name"] ?? "Name N/A";
  //         pickupPhone = cache["pickup_phone"] ?? "Phone N/A";
  //         pickupAddress = cache["pickup_address1"] ?? "No Address";
  //         pickupCity = cache["pickup_city"] ?? "City N/A";
  //         pickupState = cache["pickup_state"] ?? "State N/A";
  //       }

  //       return Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: AppColors.pureWhite,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: AppColors.electricTeal),
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.mediumGray.withOpacity(0.10),
  //               blurRadius: 6,
  //               offset: Offset(0, 3),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(pickupAddress, style: _boldText),
  //             SizedBox(height: 4),
  //             Text("$pickupCity - $pickupState", style: _subText),
  //             SizedBox(height: 4),
  //             CustomText(
  //               txt: "$pickupName - $pickupPhone",
  //               fontSize: 15,
  //               color: AppColors.mediumGray,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // delivery section
  // Widget _buildDeliverySection() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final cache = ref.watch(orderCacheProvider);

  //       final isMultiStop = cache["is_multi_stop_enabled"] == "true";
  //       final stopsCount =
  //           int.tryParse(cache["route_stops_count"]?.toString() ?? "0") ?? 0;

  //       String deliveryName;
  //       String deliveryPhone;
  //       String deliveryAddress;
  //       String deliveryCity;
  //       String deliveryState;

  //       if (isMultiStop && stopsCount > 0) {
  //         final lastStopIndex = stopsCount;
  //         deliveryName =
  //             cache["stop_${lastStopIndex}_contact_name"] ??
  //             cache["delivery_name"] ??
  //             "Name N/A";
  //         deliveryPhone =
  //             cache["stop_${lastStopIndex}_contact_phone"] ??
  //             cache["delivery_phone"] ??
  //             "Phone N/A";
  //         deliveryAddress =
  //             cache["stop_${lastStopIndex}_address"] ??
  //             cache["delivery_address1"] ??
  //             "No Address";
  //         deliveryCity =
  //             cache["stop_${lastStopIndex}_city"] ??
  //             cache["delivery_city"] ??
  //             "City N/A";
  //         deliveryState =
  //             cache["stop_${lastStopIndex}_state"] ??
  //             cache["delivery_state"] ??
  //             "State N/A";
  //       } else {
  //         deliveryName = cache["delivery_name"] ?? "Name N/A";
  //         deliveryPhone = cache["delivery_phone"] ?? "Phone N/A";
  //         deliveryAddress = cache["delivery_address1"] ?? "No Address";
  //         deliveryCity = cache["delivery_city"] ?? "City N/A";
  //         deliveryState = cache["delivery_state"] ?? "State N/A";
  //       }

  //       return Container(
  //         margin: const EdgeInsets.only(bottom: 16),
  //         decoration: BoxDecoration(
  //           color: AppColors.pureWhite,
  //           borderRadius: BorderRadius.circular(18),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.07),
  //               blurRadius: 14,
  //               offset: const Offset(0, 6),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           children: [
  //             // HEADER
  //             Container(
  //               padding: const EdgeInsets.all(14),
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [
  //                     Colors.orange.withOpacity(0.14),
  //                     Colors.orange.withOpacity(0.05),
  //                   ],
  //                 ),
  //                 borderRadius: const BorderRadius.vertical(
  //                   top: Radius.circular(18),
  //                 ),
  //               ),
  //               child: Row(
  //                 children: const [
  //                   Icon(Icons.flag_outlined, size: 18, color: Colors.orange),
  //                   SizedBox(width: 8),
  //                   Text(
  //                     "Delivery Location",
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w700,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             // BODY
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Column(
  //                     children: [
  //                       Container(
  //                         width: 2,
  //                         height: 46,
  //                         decoration: BoxDecoration(
  //                           gradient: LinearGradient(
  //                             begin: Alignment.topCenter,
  //                             end: Alignment.bottomCenter,
  //                             colors: [
  //                               AppColors.mediumGray.withOpacity(0.25),
  //                               AppColors.limeGreen.withOpacity(0.5),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       _dot(AppColors.limeGreen),
  //                     ],
  //                   ),
  //                   const SizedBox(width: 14),

  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         CustomText(
  //                           txt: deliveryAddress,
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                         const SizedBox(height: 4),
  //                         CustomText(
  //                           txt: "$deliveryCity • $deliveryState",
  //                           fontSize: 12,
  //                           color: AppColors.mediumGray,
  //                         ),
  //                         const SizedBox(height: 12),
  //                         Row(
  //                           children: [
  //                             const Icon(
  //                               Icons.person_outline,
  //                               size: 16,
  //                               color: Colors.grey,
  //                             ),
  //                             const SizedBox(width: 6),
  //                             CustomText(
  //                               txt: "$deliveryName • $deliveryPhone",
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w600,
  //                               color: AppColors.mediumGray,
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildDeliverySection() {
  //   return Consumer(
  //     builder: (context, ref, child) {
  //       final cache = ref.watch(orderCacheProvider);

  //       // Check if multi-stop is enabled
  //       final isMultiStop = cache["is_multi_stop_enabled"] == "true";
  //       final stopsCount =
  //           int.tryParse(cache["route_stops_count"]?.toString() ?? "0") ?? 0;

  //       // Get delivery data based on mode
  //       String deliveryName;
  //       String deliveryPhone;
  //       String deliveryAddress;
  //       String deliveryCity;
  //       String deliveryState;

  //       if (isMultiStop && stopsCount > 0) {
  //         // For multi-stop, get from last stop (drop-off)
  //         final lastStopIndex = stopsCount;
  //         deliveryName =
  //             cache["stop_${lastStopIndex}_contact_name"] ??
  //             cache["delivery_name"] ??
  //             "Name N/A";
  //         deliveryPhone =
  //             cache["stop_${lastStopIndex}_contact_phone"] ??
  //             cache["delivery_phone"] ??
  //             "Phone N/A";
  //         deliveryAddress =
  //             cache["stop_${lastStopIndex}_address"] ??
  //             cache["delivery_address1"] ??
  //             "No Address";
  //         deliveryCity =
  //             cache["stop_${lastStopIndex}_city"] ??
  //             cache["delivery_city"] ??
  //             "City N/A";
  //         deliveryState =
  //             cache["stop_${lastStopIndex}_state"] ??
  //             cache["delivery_state"] ??
  //             "State N/A";
  //       } else {
  //         // For single-stop, get from standard cache
  //         deliveryName = cache["delivery_name"] ?? "Name N/A";
  //         deliveryPhone = cache["delivery_phone"] ?? "Phone N/A";
  //         deliveryAddress = cache["delivery_address1"] ?? "No Address";
  //         deliveryCity = cache["delivery_city"] ?? "City N/A";
  //         deliveryState = cache["delivery_state"] ?? "State N/A";
  //       }

  //       return Container(
  //         width: double.infinity,
  //         padding: const EdgeInsets.all(16),
  //         decoration: BoxDecoration(
  //           color: AppColors.pureWhite,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(color: AppColors.electricTeal),
  //           boxShadow: [
  //             BoxShadow(
  //               color: AppColors.mediumGray.withOpacity(0.10),
  //               blurRadius: 6,
  //               offset: Offset(0, 3),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(deliveryAddress, style: _boldText),
  //             SizedBox(height: 4),
  //             Text("$deliveryCity - $deliveryState", style: _subText),
  //             SizedBox(height: 4),
  //             CustomText(
  //               txt: "$deliveryName - $deliveryPhone",
  //               fontSize: 15,
  //               color: AppColors.mediumGray,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _dot(Color color) {
  //   return Container(
  //     width: 10,
  //     height: 10,
  //     decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  //   );
  // }

  Widget _serviceOption({
    required bool selected,
    required String title,
    required String subtitle,
    required String value,
    IconData? icon,
    double multiplier = 1.0,
  }) {
    return GestureDetector(
      onTap: () => _onServiceTypeChanged(value, title, multiplier),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.electricTeal
                : AppColors.mediumGray.withOpacity(0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? AppColors.electricTeal
                  : AppColors.mediumGray.withOpacity(0.4),
            ),
            const SizedBox(width: 12),
            if (icon != null)
              Icon(
                icon,
                color: selected ? AppColors.electricTeal : Colors.grey,
                size: 20,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          txt: title,
                          fontSize: 15,
                          color: AppColors.darkText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (multiplier > 1.0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.electricTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '×${multiplier.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.electricTeal,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  CustomText(
                    txt: subtitle,
                    fontSize: 13,
                    color: AppColors.mediumGray,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // add-ons section
  Widget _buildAddOnsSection(List<AddOnItem> addOnsItems) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _openAddOnsModal(context); // ✅ modal open on click
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.electricTeal, width: 1.2),
                  color: Colors.white, // optional
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.electricTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add_circle_outline,
                              color: AppColors.electricTeal,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add-ons",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkText,
                              ),
                            ),
                            Text(
                              "Optional extras",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Right side indicator
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.electricTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${addOnsItems.length} options",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.electricTeal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // -------- Selected Summary (same as before) --------
            Consumer(
              builder: (context, ref, child) {
                final selectedAddons = ref.watch(selectedAddonsProvider);
                final selectedWithCost = ref.watch(
                  selectedAddOnsWithCostProvider,
                );

                if (selectedAddons.isEmpty) {
                  return const SizedBox();
                }

                double totalAddonsCost = 0;
                for (var item in selectedWithCost) {
                  totalAddonsCost += item['cost'] ?? 0.0;
                }

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.electricTeal.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.electricTeal.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.electricTeal,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Selected (${selectedAddons.length})",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "R${totalAddonsCost.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.electricTeal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _addonModalCard({required AddOnItem item}) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedAddons = ref.watch(selectedAddonsProvider);
        final declaredValue = ref.watch(declaredValueProvider);

        final isSelected = selectedAddons.contains(item.id);
        final dynamicCost = item.calculateCost(declaredValue);
        final isPercentage = item.type == 'percentage';
        final basePrice = item.cost ?? 0.0;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              _toggleAddOn(item.id, dynamicCost);
            },
            splashColor: AppColors.electricTeal.withOpacity(0.2),
            highlightColor: AppColors.electricTeal.withOpacity(0.1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              // width: 90,
              // height: 20,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(
                  color: isSelected
                      ? AppColors.electricTeal
                      : Colors.grey.shade200,
                  width: isSelected ? 2 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.electricTeal.withOpacity(0.2)
                        : Colors.black.withOpacity(0.06),
                    blurRadius: isSelected ? 15 : 8,
                    offset: const Offset(0, 4),
                    spreadRadius: isSelected ? 0.5 : 0,
                  ),
                ],
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.electricTeal.withOpacity(0.03),
                          AppColors.electricTeal.withOpacity(0.01),
                        ],
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------- Icon + Selection Indicator --------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [
                                    AppColors.electricTeal.withOpacity(0.9),
                                    AppColors.electricTeal,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: isSelected ? null : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.electricTeal.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Icon(
                            item.getIconData(),
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.electricTeal
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.electricTeal
                                : Colors.grey.shade400,
                            width: isSelected ? 0 : 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.electricTeal.withOpacity(
                                      0.5,
                                    ),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ]
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // -------- Title --------
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.darkText,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // -------- Price Chip --------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                AppColors.electricTeal.withOpacity(0.9),
                                AppColors.electricTeal,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: isSelected
                          ? null
                          : AppColors.electricTeal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: AppColors.electricTeal.withOpacity(0.2),
                              width: 1,
                            ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "R${dynamicCost.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppColors.electricTeal,
                          ),
                        ),
                        if (isPercentage)
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              "(${(item.rate * 100).toStringAsFixed(0)}%)",
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? Colors.white.withOpacity(0.9)
                                    : AppColors.electricTeal.withOpacity(0.7),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // -------- Original Price (if different) --------
                  if (isPercentage && basePrice > 0 && dynamicCost != basePrice)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Base: R${basePrice.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddOnsLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.electricTeal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.electricTeal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add-ons",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkText,
                        ),
                      ),
                      Text(
                        "Loading options...",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 60,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddOnsError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.error_outline, color: Colors.red, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add-ons",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    "Failed to load",
                    style: TextStyle(fontSize: 11, color: Colors.red.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // add-ons section end

  // Service Options Section
  Widget _buildLoadingContainer(String text) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.mediumGray.withOpacity(0.4)),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Service Options Section
  Widget _buildErrorContainer(String text) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 12),
                Text(text, style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              ref
                  .read(serviceTypeControllerProvider.notifier)
                  .loadServiceTypes();
            },
            child: const Text('Retry'),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.electricTeal, size: 22),
        const SizedBox(width: 8),
        CustomText(
          txt: title,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ],
    );
  }
}
