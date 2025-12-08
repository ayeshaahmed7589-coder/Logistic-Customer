import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';

import 'package:logisticscustomer/constants/gap.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/fetch_order_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/fetch_order_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/place_order_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/search_screen/search_controller.dart';

class ServicePaymentScreen extends ConsumerStatefulWidget {
  const ServicePaymentScreen({super.key});

  @override
  ConsumerState<ServicePaymentScreen> createState() =>
      _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends ConsumerState<ServicePaymentScreen> {
  List<String> selectedAddons = [];
  Map<String, String> addonMapping = {
    'insurance': 'insurance',
    'signature': 'signature_required',
    'fragile': 'fragile_handling',
    'photo': 'photo_proof',
    'priority': 'priority_pickup',
    'weekend': 'weekend_delivery',
  };

  String serviceType = "standard";
  String paymentMethod = "wallet";
  String vehicleMethod = "bike";
  String priority = "normal";
  String specialInstructions = "";
  double declaredValue = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCachedData();
    });
  }

  void _loadCachedData() {
    final cache = ref.read(orderCacheProvider);

    serviceType = cache["service_type"] ?? "standard";
    vehicleMethod = cache["vehicle_type"] ?? "bike";
    paymentMethod = cache["payment_method"] ?? "wallet";
    priority = cache["priority"] ?? "normal";
    specialInstructions = cache["special_instructions"] ?? "";

    if (cache["selected_addons"] != null) {
      selectedAddons = List<String>.from(cache["selected_addons"]);
    }

    if (cache["declared_value"] != null) {
      declaredValue =
          double.tryParse(cache["declared_value"].toString()) ?? 0.0;
    }

    setState(() {});
    _calculateQuote();
  }

  Map<String, dynamic>? cache;
  double pickupLatitude = 0;
  double pickupLongitude = 0;
  double deliveryLatitude = 0;
  double deliveryLongitude = 0;

  void _calculateQuote() {
    final items = ref.read(packageItemsProvider);
    double totalWeight = 0;
    double totalDeclaredValue = 0;

    for (var item in items) {
      totalWeight += double.tryParse(item.weight) ?? 0;
      totalDeclaredValue += double.tryParse(item.value) ?? 0;
    }

    if (totalDeclaredValue > 0) {
      declaredValue = totalDeclaredValue;
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("declared_value", declaredValue.toString());
    }

    List<String> apiAddons = [];
    for (var addon in selectedAddons) {
      if (addonMapping.containsKey(addon)) {
        apiAddons.add(addonMapping[addon]!);
      }
    }

    print("📊 _calculateQuote Called:");
    print("  Service Type: $serviceType");
    print("  Vehicle Type: $vehicleMethod");
    print("  Priority: $priority");
    print("  Total Weight: $totalWeight");
    print("  Add-ons: $apiAddons");

    ref
        .read(quoteCalculationControllerProvider.notifier)
        .calculateQuote(
          pickupLatitude: pickupLatitude,
          pickupLongitude: pickupLongitude,
          deliveryLatitude: deliveryLatitude,
          deliveryLongitude: deliveryLongitude,
          serviceType: serviceType,
          vehicleType: vehicleMethod,
          totalWeight: totalWeight > 0 ? totalWeight : null,
          addOns: apiAddons.isNotEmpty ? apiAddons : null,
          declaredValue: declaredValue > 0 ? declaredValue : null,
        );
  }

  void _onServiceTypeChanged(String newType) {
    setState(() => serviceType = newType);
    ref.read(orderCacheProvider.notifier).saveValue("service_type", newType);
    _calculateQuote();
  }

  void _onVehicleTypeChanged(String newType) {
    setState(() => vehicleMethod = newType);
    ref.read(orderCacheProvider.notifier).saveValue("vehicle_type", newType);
    _calculateQuote();
  }

  //  NEW: Priority change handler
  void _onPriorityChanged(String newPriority) {
    setState(() => priority = newPriority);
    ref.read(orderCacheProvider.notifier).saveValue("priority", newPriority);
    _calculateQuote();
  }

  void _onPaymentMethodChanged(String newMethod) {
    setState(() => paymentMethod = newMethod);
    ref
        .read(orderCacheProvider.notifier)
        .saveValue("payment_method", newMethod);
    print("✅ Payment method saved: $newMethod");
  }

  //  NEW: Special instructions handler
  void _onSpecialInstructionsChanged(String instructions) {
    setState(() => specialInstructions = instructions);
    ref
        .read(orderCacheProvider.notifier)
        .saveValue("special_instructions", instructions);
  }

  void toggleAddon(String value) {
    setState(() {
      if (selectedAddons.contains(value)) {
        selectedAddons.remove(value);
      } else {
        selectedAddons.add(value);
      }
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("selected_addons", selectedAddons);
      _calculateQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quoteState = ref.watch(quoteCalculationControllerProvider);
    // ignore: unused_local_variable
    final orderState = ref.watch(orderControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      // AppBar
      appBar: AppBar(
        backgroundColor: AppColors.electricTeal,
        elevation: 0,
        leading: RotatedBox(
          quarterTurns: 2,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
      // AppBar end
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Content
            gapH4,
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
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
                  gapH16,

                  // Items Section
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: AppColors.electricTeal),
                      SizedBox(width: 8),
                      CustomText(
                        txt: "Items",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  gapH8,
                  _buildItemsSection(),
                  gapH20,

                  //  NEW: Priority Section
                  Column(
                    children: [
                      _sectionTitle(Icons.bolt, "Delivery Priority"),
                      const SizedBox(height: 10),
                      _priorityOption(
                        selected: priority == "normal",
                        title: "Normal",
                        subtitle: "Standard delivery time",
                        value: "normal",
                      ),
                      _priorityOption(
                        selected: priority == "urgent",
                        title: "Urgent",
                        subtitle: "Faster delivery (+R30)",
                        value: "urgent",
                      ),
                      _priorityOption(
                        selected: priority == "express",
                        title: "Express",
                        subtitle: "Fastest delivery (+R60)",
                        value: "express",
                      ),
                    ],
                  ),
                  gapH16,

                  // Service Options
                  Column(
                    children: [
                      _sectionTitle(Icons.local_shipping, "Service Options"),
                      const SizedBox(height: 10),
                      _serviceOption(
                        selected: serviceType == "standard",
                        title: "Standard",
                        subtitle: "(R0)",
                        value: "standard",
                      ),
                      _serviceOption(
                        selected: serviceType == "express",
                        title: "Express",
                        subtitle: "(+R20)",
                        value: "express",
                      ),
                      _serviceOption(
                        selected: serviceType == "sameday",
                        title: "Same Day",
                        subtitle: "(+R50)",
                        value: "sameday",
                      ),
                    ],
                  ),
                  gapH16,

                  // Vehicle Type
                  Column(
                    children: [
                      _sectionTitle(Icons.local_shipping, "Vehicle Type"),
                      const SizedBox(height: 10),
                      _serviceOption2(
                        selected: vehicleMethod == "bike",
                        title: "Bike (Small Packages)",
                        value: "bike",
                      ),
                      _serviceOption2(
                        selected: vehicleMethod == "van",
                        title: "Van (Medium Load)",
                        value: "van",
                      ),
                      _serviceOption2(
                        selected: vehicleMethod == "truck",
                        title: "Truck (Heavy/Bulk)",
                        value: "truck",
                      ),
                    ],
                  ),
                  gapH16,

                  //  NEW: Special Instructions
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        Icons.note,
                        "Special Instructions (Optional)",
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.electricTeal.withOpacity(0.3),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: AppColors.electricTeal,
                              fontSize: 14,
                            ),
                            hintText:
                                "E.g., Fragile items, gate code, call before arrival...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          maxLines: 3,
                          onChanged: _onSpecialInstructionsChanged,
                        ),
                      ),
                    ],
                  ),
                  gapH16,

                  // Add-ons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(Icons.local_shipping, "Add-Ons (Optional)"),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _addons(
                              selected: selectedAddons.contains("insurance"),
                              title: "Insurance Cover",
                              subtitle: "2% of declared Value",
                              value: "insurance",
                              onTap: () => toggleAddon("insurance"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _addons(
                              selected: selectedAddons.contains("signature"),
                              title: "Signature Required",
                              subtitle: "Recipient must sign",
                              value: "signature",
                              onTap: () => toggleAddon("signature"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _addons(
                              selected: selectedAddons.contains("fragile"),
                              title: "Fragile Handling",
                              subtitle: "Extra care for Items",
                              value: "fragile",
                              onTap: () => toggleAddon("fragile"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _addons(
                              selected: selectedAddons.contains("photo"),
                              title: "Photo Proof",
                              subtitle: "Delivery documentation",
                              value: "photo",
                              onTap: () => toggleAddon("photo"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  gapH16,

                  // Payment Summary
                  // Payment Summary Section - UPDATED WITH BETTER UI
                  Padding(
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
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
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
                            data: (quote) {
                              final pricing = quote?.data?.pricing;
                              final breakdown = quote?.data?.breakdown;

                              if (pricing == null) {
                                return _buildNoDataState();
                              }

                              return Column(
                                children: [
                                  // Summary Items
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        // Base Fare
                                        _buildSummaryItem(
                                          icon: Icons.price_check,
                                          title: "Base Fare",
                                          amount:
                                              "${pricing.currencySymbol}${pricing.baseFare.toStringAsFixed(2)}",
                                          color: AppColors.mediumGray,
                                        ),

                                        // Distance
                                        if (breakdown?.distance != null)
                                          _buildSummaryItem(
                                            icon: Icons.directions_car,
                                            title: "Distance",
                                            amount: breakdown!.distance,
                                            color: Colors.blue[700],
                                          )
                                        else if (pricing.distanceCost > 0)
                                          _buildSummaryItem(
                                            icon: Icons.directions_car,
                                            title: "Distance",
                                            amount:
                                                "${pricing.currencySymbol}${pricing.distanceCost.toStringAsFixed(2)}",
                                            color: Colors.blue[700],
                                          ),

                                        // Weight Charge
                                        if (pricing.weightCharge > 0)
                                          _buildSummaryItem(
                                            icon: Icons.scale,
                                            title: "Weight Charge",
                                            amount:
                                                "${pricing.currencySymbol}${pricing.weightCharge.toStringAsFixed(2)}",
                                            color: Colors.orange[700],
                                          ),

                                        // Add-ons Breakdown
                                        if (breakdown?.addOns != null &&
                                            breakdown!.addOns!.isNotEmpty)
                                          ..._buildAddonsBreakdownUI(
                                            breakdown.addOns!,
                                            pricing,
                                          ),

                                        // Add-ons Total
                                        if (pricing.addOnsTotal > 0)
                                          _buildSummaryItem(
                                            icon: Icons.add_circle_outline,
                                            title: "Add-ons Total",
                                            amount:
                                                "${pricing.currencySymbol}${pricing.addOnsTotal.toStringAsFixed(2)}",
                                            color: Colors.purple[700],
                                          ),

                                        // Subtotal
                                        if (pricing.subtotalBeforeService > 0)
                                          _buildSummaryItem(
                                            icon: Icons.calculate,
                                            title: "Subtotal",
                                            amount:
                                                "${pricing.currencySymbol}${pricing.subtotalBeforeService.toStringAsFixed(2)}",
                                            color: AppColors.darkText,
                                            showDivider: true,
                                          ),

                                        // Service Fee
                                        if (breakdown?.service != null &&
                                            breakdown!.service!.isNotEmpty)
                                          _buildSummaryItem(
                                            icon: Icons.miscellaneous_services,
                                            title: "Service Fee",
                                            amount: breakdown.service!,
                                            color: Colors.teal[700],
                                          )
                                        else if (pricing.serviceFee > 0)
                                          _buildSummaryItem(
                                            icon: Icons.miscellaneous_services,
                                            title:
                                                "Service Fee (${pricing.serviceFeePercentage}%)",
                                            amount:
                                                "${pricing.currencySymbol}${pricing.serviceFee.toStringAsFixed(2)}",
                                            color: Colors.teal[700],
                                          ),

                                        // Tax
                                        if (breakdown?.tax != null &&
                                            breakdown!.tax!.isNotEmpty)
                                          _buildSummaryItem(
                                            icon: Icons.request_quote,
                                            title: "Tax",
                                            amount: breakdown.tax!,
                                            color: Colors.red[700],
                                          )
                                        else if (pricing.tax > 0)
                                          _buildSummaryItem(
                                            icon: Icons.request_quote,
                                            title:
                                                "Tax (${pricing.taxPercentage}%)",
                                            amount:
                                                "${pricing.currencySymbol}${pricing.tax.toStringAsFixed(2)}",
                                            color: Colors.red[700],
                                          ),

                                        const SizedBox(height: 8),

                                        // Divider
                                        Container(
                                          height: 1,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.electricTeal
                                                    .withOpacity(0.1),
                                                AppColors.electricTeal,
                                                AppColors.electricTeal
                                                    .withOpacity(0.1),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Total - HIGHLIGHTED
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: AppColors.electricTeal
                                                .withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              color: AppColors.electricTeal
                                                  .withOpacity(0.3),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.payments,
                                                    color:
                                                        AppColors.electricTeal,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Total Amount",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: AppColors.darkText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${pricing.currencySymbol}${pricing.total.toStringAsFixed(2)}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.electricTeal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Distance Info (if available)
                                        if (quote?.data?.distanceKm != null &&
                                            quote!.data!.distanceKm! > 0)
                                          Container(
                                            margin: EdgeInsets.only(top: 12),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Colors.blue[100]!,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.map,
                                                  size: 16,
                                                  color: Colors.blue[700],
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Total Distance: ${quote.data!.distanceKm!.toStringAsFixed(2)} km",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.blue[800],
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "EST.",
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.blue[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            loading: () => _buildLoadingState(),
                            error: (e, st) => _buildErrorState(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Column(
                  //     children: [
                  //       _sectionTitle(Icons.payments, "Payment Summary"),
                  //       const SizedBox(height: 10),
                  //       quoteState.when(
                  //         data: (quote) {
                  //           final pricing = quote?.data?.pricing;
                  //           final breakdown = quote?.data?.breakdown;

                  //           if (pricing == null) {
                  //             return Text("No pricing data available");
                  //           }

                  //           return Column(
                  //             children: [
                  //               _summaryRow(
                  //                 "Base Fare",
                  //                 "${pricing.currencySymbol}${pricing.baseFare.toStringAsFixed(2)}",
                  //               ),
                  //               if (breakdown?.distance != null)
                  //                 _summaryRow("Distance", breakdown!.distance)
                  //               else if (pricing.distanceCost > 0)
                  //                 _summaryRow(
                  //                   "Distance",
                  //                   "${pricing.currencySymbol}${pricing.distanceCost.toStringAsFixed(2)}",
                  //                 )
                  //               else
                  //                 _summaryRow(
                  //                   "Distance",
                  //                   "${pricing.currencySymbol}0.00",
                  //                 ),

                  //               if (pricing.weightCharge > 0)
                  //                 _summaryRow(
                  //                   "Weight",
                  //                   "${pricing.currencySymbol}${pricing.weightCharge.toStringAsFixed(2)}",
                  //                 ),

                  //               if (breakdown?.addOns != null &&
                  //                   breakdown!.addOns!.isNotEmpty)
                  //                 ..._buildAddonsBreakdown(
                  //                   breakdown.addOns!,
                  //                   pricing,
                  //                 ),

                  //               if (pricing.addOnsTotal > 0)
                  //                 _summaryRow(
                  //                   "Add-ons Total",
                  //                   "${pricing.currencySymbol}${pricing.addOnsTotal.toStringAsFixed(2)}",
                  //                 ),

                  //               if (pricing.subtotalBeforeService > 0)
                  //                 _summaryRow(
                  //                   "Subtotal",
                  //                   "${pricing.currencySymbol}${pricing.subtotalBeforeService.toStringAsFixed(2)}",
                  //                 ),

                  //               if (breakdown?.service != null &&
                  //                   breakdown!.service!.isNotEmpty)
                  //                 _summaryRow("Service Fee", breakdown.service!)
                  //               else if (pricing.serviceFee > 0)
                  //                 _summaryRow(
                  //                   "Service Fee (${pricing.serviceFeePercentage}%)",
                  //                   "${pricing.currencySymbol}${pricing.serviceFee.toStringAsFixed(2)}",
                  //                 ),

                  //               if (breakdown?.tax != null &&
                  //                   breakdown!.tax!.isNotEmpty)
                  //                 _summaryRow("Tax", breakdown.tax!)
                  //               else if (pricing.tax > 0)
                  //                 _summaryRow(
                  //                   "Tax (${pricing.taxPercentage}%)",
                  //                   "${pricing.currencySymbol}${pricing.tax.toStringAsFixed(2)}",
                  //                 ),

                  //               const Divider(thickness: 1),
                  //               _summaryRow(
                  //                 "Total",
                  //                 "${pricing.currencySymbol}${pricing.total.toStringAsFixed(2)}",
                  //                 bold: true,
                  //               ),
                  //             ],
                  //           );
                  //         },
                  //         loading: () => Center(
                  //           child: Padding(
                  //             padding: EdgeInsets.all(20),
                  //             child: CircularProgressIndicator(),
                  //           ),
                  //         ),
                  //         error: (e, st) => Container(
                  //           padding: EdgeInsets.all(16),
                  //           child: Text(
                  //             "Unable to calculate quote. Please check your internet connection.",
                  //             style: TextStyle(color: Colors.red),
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 25),

                  // Payment Method
                  Column(
                    children: [
                      _sectionTitle(
                        Icons.account_balance_wallet,
                        "Payment Method",
                      ),
                      const SizedBox(height: 10),
                      _paymentOption(
                        selected: paymentMethod == "wallet",
                        title: "Wallet (Balance R500.0)",
                        value: "wallet",
                      ),
                      _paymentOption(
                        selected: paymentMethod == "cod",
                        title: "Cash on Delivery",
                        value: "cod",
                      ),
                      _paymentOption(
                        selected: paymentMethod == "card",
                        title: "Card Payment",
                        value: "card",
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  //  FIXED: Place Order Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Consumer(
                      builder: (context, ref, child) {
                        final orderState = ref.watch(orderControllerProvider);
                        final isOrderLoading = orderState.isLoading;

                        return CustomButton(
                          text: isOrderLoading
                              ? "Placing Order..."
                              : "Place Order",
                          backgroundColor: AppColors.pureWhite,
                          borderColor: AppColors.electricTeal,
                          textColor: AppColors.darkText,
                          onPressed: () async {
                            if (isOrderLoading) return;

                            try {
                              // ✅ Check if all required data is present
                              final cache = ref.read(orderCacheProvider);
                              if (cache["pickup_address1"] == null ||
                                  cache["delivery_address1"] == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please add pickup and delivery addresses",
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              final items = ref.read(packageItemsProvider);
                              if (items.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please add at least one item",
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              // ✅ Place order call
                              await ref
                                  .read(orderControllerProvider.notifier)
                                  .placeOrder(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  gapH12,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  // List<Widget> _buildAddonsBreakdown(
  //   Map<String, dynamic> addonsMap,
  //   Pricing pricing,
  // ) {
  //   List<Widget> widgets = [];
  //   addonsMap.forEach((key, value) {
  //     if (value is Map) {
  //       final name = value['name']?.toString() ?? key;
  //       final cost = value['cost']?.toString() ?? '0';
  //       widgets.add(_summaryRow(name, "${pricing.currencySymbol}$cost"));
  //     }
  //   });
  //   return widgets;
  // }

  Widget _addons({
    required bool selected,
    required String title,
    required String subtitle,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.electricTeal : Colors.grey.shade300,
            width: 2,
          ),
          color: selected
              ? AppColors.electricTeal.withOpacity(0.08)
              : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: selected ? AppColors.electricTeal : Colors.white,
                border: Border.all(
                  color: selected
                      ? AppColors.electricTeal
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            gapW8,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? AppColors.darkText
                          : AppColors.electricTeal,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupSection() {
    final cache = ref.watch(orderCacheProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.electricTeal),
        boxShadow: [
          BoxShadow(
            color: AppColors.mediumGray.withOpacity(0.10),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cache["pickup_address1"] ?? "No Address", style: _boldText),
          SizedBox(height: 4),
          Text(
            "${cache["pickup_city"] ?? "City N/A"} - ${cache["pickup_state"] ?? "State N/A"}",
            style: _subText,
          ),
          SizedBox(height: 4),
          CustomText(
            txt:
                "${cache["pickup_name"] ?? "Name N/A"} - ${cache["pickup_phone"] ?? "Phone N/A"}",
            fontSize: 15,
            color: AppColors.mediumGray,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySection() {
    final cache = ref.watch(orderCacheProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.electricTeal),
        boxShadow: [
          BoxShadow(
            color: AppColors.mediumGray.withOpacity(0.10),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cache["delivery_address1"] ?? "No Address", style: _boldText),
          SizedBox(height: 4),
          Text(
            "${cache["delivery_city"] ?? "City N/A"} - ${cache["delivery_state"] ?? "State N/A"}",
            style: _subText,
          ),
          SizedBox(height: 4),
          CustomText(
            txt:
                "${cache["delivery_name"] ?? "Name N/A"} - ${cache["delivery_phone"] ?? "Phone N/A"}",
            fontSize: 15,
            color: AppColors.mediumGray,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    final items = ref.watch(packageItemsProvider);
    double totalWeight = 0;
    int totalItems = 0;

    for (var item in items) {
      totalWeight += double.tryParse(item.weight) ?? 0;
      totalItems += int.tryParse(item.qty) ?? 1;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.electricTeal),
        boxShadow: [
          BoxShadow(
            color: AppColors.mediumGray.withOpacity(0.10),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (items.isEmpty) Text("No Items Added", style: _boldText),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${index + 1}. ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                        ),

                        Text("${item.name}", style: _boldText),
                      ],
                    ),

                    SizedBox(width: 8),
                    if (item.isFromShopify)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Text(
                          "Shopify",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Qty: ",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.darkText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("${item.qty}", style: _subText),
                      ],
                    ),
                    gapW8,
                    Text("Weight: ${item.weight}kg", style: _subText),
                    SizedBox(width: 16),
                    Text("Value: R${item.value}", style: _subText),
                  ],
                ),
                SizedBox(height: 8),
              ],
            );
          }),
          Divider(color: AppColors.electricTeal),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                txt: "Total Items:",
                fontSize: 15,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                txt: "$totalItems items",
                fontSize: 15,
                color: AppColors.electricTeal,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                txt: "Total Weight:",
                fontSize: 15,
                color: AppColors.mediumGray,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                txt: "${totalWeight.toStringAsFixed(1)} kg",
                fontSize: 15,
                color: AppColors.electricTeal,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  NEW: Priority Option Widget
  Widget _priorityOption({
    required bool selected,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => _onPriorityChanged(value),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(txt: title, fontSize: 15, color: AppColors.darkText),
                CustomText(
                  txt: subtitle,
                  fontSize: 13,
                  color: AppColors.mediumGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceOption({
    required bool selected,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => _onServiceTypeChanged(value),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(txt: title, fontSize: 15, color: AppColors.darkText),
                CustomText(
                  txt: subtitle,
                  fontSize: 13,
                  color: AppColors.mediumGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceOption2({
    required bool selected,
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => _onVehicleTypeChanged(value),
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
            CustomText(txt: title, fontSize: 15, color: AppColors.darkText),
          ],
        ),
      ),
    );
  }

  // Payment Summary
  // Helper method for summary items
  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String amount,
    Color? color,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 18, color: color ?? AppColors.mediumGray),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: color ?? AppColors.mediumGray,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: AppColors.mediumGray.withOpacity(0.1),
          ),
      ],
    );
  }

  // Add-ons breakdown with better UI
  List<Widget> _buildAddonsBreakdownUI(
    Map<String, dynamic> addonsMap,
    Pricing pricing,
  ) {
    List<Widget> widgets = [];

    addonsMap.forEach((key, value) {
      if (value is Map) {
        final name = value['name']?.toString() ?? key;
        final cost = value['cost']?.toString() ?? '0';

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: _buildSummaryItem(
              icon: Icons.add,
              title: name,
              amount: "${pricing.currencySymbol}$cost",
              color: Colors.grey[600],
            ),
          ),
        );
      }
    });

    return widgets;
  }

  // Loading State
  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          SizedBox(height: 20),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.electricTeal),
            strokeWidth: 2,
          ),
          SizedBox(height: 12),
          Text(
            "Calculating your quote...",
            style: TextStyle(color: AppColors.mediumGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Error State
  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40),
          SizedBox(height: 12),
          Text(
            "Unable to calculate quote",
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            "Please check your internet connection and try again.",
            style: TextStyle(color: AppColors.mediumGray, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              // Retry logic here if needed
            },
            icon: Icon(Icons.refresh, size: 16),
            label: Text("Try Again"),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.electricTeal),
            ),
          ),
        ],
      ),
    );
  }

  // No Data State
  Widget _buildNoDataState() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.receipt_long, color: AppColors.mediumGray, size: 40),
          SizedBox(height: 12),
          Text(
            "No pricing data available",
            style: TextStyle(color: AppColors.mediumGray, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required bool selected,
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => _onPaymentMethodChanged(value),
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
              color: selected ? AppColors.electricTeal : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                txt: title,
                fontSize: 15,
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
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

const _boldText = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: AppColors.mediumGray,
);
const _subText = TextStyle(
  fontSize: 13,
  color: AppColors.mediumGray,
  fontWeight: FontWeight.w600,
);
