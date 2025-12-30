// // lib/models/quote_calculation_model.dart

// import 'package:json_annotation/json_annotation.dart';

// part 'fetch_order_modal.g.dart';

// @JsonSerializable()
// class QuoteCalculationResponse {
//   final bool success;
//   final QuoteData? data;

//   QuoteCalculationResponse({required this.success, this.data});

//   factory QuoteCalculationResponse.fromJson(Map<String, dynamic> json) =>
//       _$QuoteCalculationResponseFromJson(json);
//   Map<String, dynamic> toJson() => _$QuoteCalculationResponseToJson(this);
// }

// @JsonSerializable()
// class QuoteData {
//   @JsonKey(name: "distance_km")
//   final double? distanceKm;
//   final Pricing? pricing;
//   final Breakdown? breakdown;

//   @JsonKey(name: "add_ons_available")
//   final Map<String, dynamic>? addOnsAvailable;

//   QuoteData({
//     this.distanceKm, // ✅ Nullable
//     this.pricing,
//     this.breakdown,
//     this.addOnsAvailable,
//   });

//   factory QuoteData.fromJson(Map<String, dynamic> json) =>
//       _$QuoteDataFromJson(json);
//   Map<String, dynamic> toJson() => _$QuoteDataToJson(this);
// }

// @JsonSerializable()
// class Pricing {
//   @JsonKey(name: "base_fare")
//   final double baseFare;

//   @JsonKey(name: "distance_cost")
//   final double distanceCost;

//   @JsonKey(name: "weight_charge")
//   final double weightCharge;

//   @JsonKey(name: "add_ons_total")
//   final double addOnsTotal;

//   @JsonKey(name: "subtotal_before_service")
//   final double subtotalBeforeService;

//   @JsonKey(name: "service_fee")
//   final double serviceFee;

//   @JsonKey(name: "service_fee_percentage")
//   final double serviceFeePercentage;

//   @JsonKey(name: "subtotal_before_tax")
//   final double subtotalBeforeTax;

//   final double tax;

//   @JsonKey(name: "tax_percentage")
//   final double taxPercentage;

//   final double total;
//   final String currency;

//   @JsonKey(name: "currency_symbol")
//   final String currencySymbol;

//   Pricing({
//     required this.baseFare,
//     required this.distanceCost,
//     required this.weightCharge,
//     required this.addOnsTotal,
//     required this.subtotalBeforeService,
//     required this.serviceFee,
//     required this.serviceFeePercentage,
//     required this.subtotalBeforeTax,
//     required this.tax,
//     required this.taxPercentage,
//     required this.total,
//     required this.currency,
//     required this.currencySymbol,
//   });

//   factory Pricing.fromJson(Map<String, dynamic> json) =>
//       _$PricingFromJson(json);
//   Map<String, dynamic> toJson() => _$PricingToJson(this);
// }

// // lib/models/quote_calculation_model.dart mein update karo

// @JsonSerializable()
// class Breakdown {
//   @JsonKey(name: "base_fare")
//   final String baseFare;
  
//   final String distance;
//   final String? weight;
  
//   final Map<String, dynamic>? addOns; // Add-ons ka Map
//   final String? service;
//   final String? tax;

//   Breakdown({
//     required this.baseFare,
//     required this.distance,
//     this.weight,
//     this.addOns,
//     this.service,
//     this.tax,
//   });

//   factory Breakdown.fromJson(Map<String, dynamic> json) =>
//       _$BreakdownFromJson(json);
//   Map<String, dynamic> toJson() => _$BreakdownToJson(this);
// }