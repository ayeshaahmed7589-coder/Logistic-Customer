import 'package:flutter/material.dart';

class ServiceTypeResponse {
  final bool success;
  final String message;
  final List<ServiceTypeItem>
  data; // ✅ Changed from ServiceTypeData to List<ServiceTypeItem>

  ServiceTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceTypeResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    return ServiceTypeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataList.map((item) => ServiceTypeItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class ServiceTypeItem {
  final String value; // ✅ Changed from id to value
  final String label; // ✅ Changed from name to label
  final String description;
  final String? icon;
  final double priceMultiplier; // ✅ Changed from multiplier to priceMultiplier

  ServiceTypeItem({
    required this.value,
    required this.label,
    required this.description,
    this.icon,
    required this.priceMultiplier,
  });

  factory ServiceTypeItem.fromJson(Map<String, dynamic> json) {
    return ServiceTypeItem(
      value: json['value']?.toString() ?? '',
      label: json['label'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
      priceMultiplier: (json['price_multiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'description': description,
      'icon': icon,
      'price_multiplier': priceMultiplier,
    };
  }

  // Helper to get icon widget
  IconData getIconData() {
    switch (icon) {
      case 'truck':
        return Icons.local_shipping;
      case 'zap':
        return Icons.flash_on;
      case 'clock':
        return Icons.access_time;
      case 'calendar':
        return Icons.calendar_today;
      case 'rocket':
        return Icons.rocket_launch;
      default:
        return Icons.delivery_dining;
    }
  }

  // For display
  @override
  String toString() => label;

  // Backward compatibility getters
  String get id => value;
  String get name => label;
  double get multiplier => priceMultiplier;
}
