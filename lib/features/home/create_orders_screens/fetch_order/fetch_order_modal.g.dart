// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'fetch_order_modal.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// QuoteCalculationResponse _$QuoteCalculationResponseFromJson(
//   Map<String, dynamic> json,
// ) => QuoteCalculationResponse(
//   success: json['success'] as bool,
//   data: json['data'] == null
//       ? null
//       : QuoteData.fromJson(json['data'] as Map<String, dynamic>),
// );

// Map<String, dynamic> _$QuoteCalculationResponseToJson(
//   QuoteCalculationResponse instance,
// ) => <String, dynamic>{'success': instance.success, 'data': instance.data};

// QuoteData _$QuoteDataFromJson(Map<String, dynamic> json) => QuoteData(
//   distanceKm: (json['distance_km'] as num?)?.toDouble(),
//   pricing: json['pricing'] == null
//       ? null
//       : Pricing.fromJson(json['pricing'] as Map<String, dynamic>),
//   breakdown: json['breakdown'] == null
//       ? null
//       : Breakdown.fromJson(json['breakdown'] as Map<String, dynamic>),
//   addOnsAvailable: json['add_ons_available'] as Map<String, dynamic>?,
// );

// Map<String, dynamic> _$QuoteDataToJson(QuoteData instance) => <String, dynamic>{
//   'distance_km': instance.distanceKm,
//   'pricing': instance.pricing,
//   'breakdown': instance.breakdown,
//   'add_ons_available': instance.addOnsAvailable,
// };

// Pricing _$PricingFromJson(Map<String, dynamic> json) => Pricing(
//   baseFare: (json['base_fare'] as num).toDouble(),
//   distanceCost: (json['distance_cost'] as num).toDouble(),
//   weightCharge: (json['weight_charge'] as num).toDouble(),
//   addOnsTotal: (json['add_ons_total'] as num).toDouble(),
//   subtotalBeforeService: (json['subtotal_before_service'] as num).toDouble(),
//   serviceFee: (json['service_fee'] as num).toDouble(),
//   serviceFeePercentage: (json['service_fee_percentage'] as num).toDouble(),
//   subtotalBeforeTax: (json['subtotal_before_tax'] as num).toDouble(),
//   tax: (json['tax'] as num).toDouble(),
//   taxPercentage: (json['tax_percentage'] as num).toDouble(),
//   total: (json['total'] as num).toDouble(),
//   currency: json['currency'] as String,
//   currencySymbol: json['currency_symbol'] as String,
// );

// Map<String, dynamic> _$PricingToJson(Pricing instance) => <String, dynamic>{
//   'base_fare': instance.baseFare,
//   'distance_cost': instance.distanceCost,
//   'weight_charge': instance.weightCharge,
//   'add_ons_total': instance.addOnsTotal,
//   'subtotal_before_service': instance.subtotalBeforeService,
//   'service_fee': instance.serviceFee,
//   'service_fee_percentage': instance.serviceFeePercentage,
//   'subtotal_before_tax': instance.subtotalBeforeTax,
//   'tax': instance.tax,
//   'tax_percentage': instance.taxPercentage,
//   'total': instance.total,
//   'currency': instance.currency,
//   'currency_symbol': instance.currencySymbol,
// };

// Breakdown _$BreakdownFromJson(Map<String, dynamic> json) => Breakdown(
//   baseFare: json['base_fare'] as String,
//   distance: json['distance'] as String,
//   weight: json['weight'] as String?,
//   addOns: json['addOns'] as Map<String, dynamic>?,
//   service: json['service'] as String?,
//   tax: json['tax'] as String?,
// );

// Map<String, dynamic> _$BreakdownToJson(Breakdown instance) => <String, dynamic>{
//   'base_fare': instance.baseFare,
//   'distance': instance.distance,
//   'weight': instance.weight,
//   'addOns': instance.addOns,
//   'service': instance.service,
//   'tax': instance.tax,
// };
