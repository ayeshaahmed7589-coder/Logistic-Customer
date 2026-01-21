import 'package:flutter/material.dart';


class AddOnsResponse {
  final bool success;
  final String message;
  final List<AddOnItem> data; // ✅ Changed from AddOnsData to List<AddOnItem>

  AddOnsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddOnsResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    return AddOnsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: dataList.map((item) => AddOnItem.fromJson(item)).toList(),
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

class AddOnItem {
  final String value; // ✅ Changed from id to value
  final String label; // ✅ Changed from name to label
  final String description;
  final String icon;
  final double price;
  final String priceType; // ✅ Changed from type to priceType

  AddOnItem({
    required this.value,
    required this.label,
    required this.description,
    required this.icon,
    required this.price,
    required this.priceType,
  });

  factory AddOnItem.fromJson(Map<String, dynamic> json) {
    return AddOnItem(
      value: json['value']?.toString() ?? '',
      label: json['label'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon']?.toString() ?? 'add_circle',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceType: json['price_type']?.toString() ?? 'fixed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'description': description,
      'icon': icon,
      'price': price,
      'price_type': priceType,
    };
  }

  // ✅ Calculate cost based on declared value (for percentage type)
  double calculateCost(double declaredValue) {
    if (priceType == 'percentage') {
      return declaredValue * (price / 100);
    } else {
      return price;
    }
  }

  // ✅ Get display cost text
  String getCostText() {
    if (priceType == 'percentage') {
      return '${price.toStringAsFixed(0)}% of declared value';
    } else {
      return 'R${price.toStringAsFixed(0)}';
    }
  }

  // ✅ Get display price
  String getDisplayPrice() {
    if (priceType == 'percentage') {
      return '${price.toStringAsFixed(0)}%';
    } else {
      return 'R${price.toStringAsFixed(0)}';
    }
  }

  // ✅ Helper to get icon widget
  IconData getIconData() {
    switch (icon) {
      case 'shield':
        return Icons.security;
      case 'package':
        return Icons.inventory;
      case 'edit':
        return Icons.edit;
      case 'camera':
        return Icons.photo_camera;
      case 'users':
        return Icons.people;
      case 'star':
        return Icons.star;
      case 'clock':
        return Icons.access_time;
      case 'calendar':
        return Icons.calendar_today;
      case 'thermometer':
        return Icons.thermostat;
      case 'truck':
        return Icons.local_shipping;
      case 'home':
        return Icons.home;
      case 'moon':
        return Icons.nightlight_round;
      case 'priority':
        return Icons.priority_high;
      case 'alert-triangle':
        return Icons.warning;
      default:
        return Icons.add_circle_outline;
    }
  }

  // ✅ For display
  @override
  String toString() => label;

  // ✅ Backward compatibility getters
  String get id => value;
  String get name => label;
  String get type => priceType;
  double get cost => price;
  double get rate => priceType == 'percentage' ? price / 100 : 0.0;
}
