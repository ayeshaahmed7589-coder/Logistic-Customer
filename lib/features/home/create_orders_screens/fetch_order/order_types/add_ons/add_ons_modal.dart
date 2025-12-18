import 'package:flutter/material.dart';

class AddOnsResponse {
  final bool success;
  final String message;
  final AddOnsData data;

  AddOnsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddOnsResponse.fromJson(Map<String, dynamic> json) {
    return AddOnsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AddOnsData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class AddOnsData {
  final List<AddOnItem> addOns;

  AddOnsData({required this.addOns});

  factory AddOnsData.fromJson(Map<String, dynamic> json) {
    final addOnsList = json['add_ons'] as List<dynamic>? ?? [];
    return AddOnsData(
      addOns: addOnsList.map((item) => AddOnItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'add_ons': addOns.map((item) => item.toJson()).toList()};
  }

  // Helper method to get all items
  List<AddOnItem> getAllItems() {
    return addOns;
  }

  // Helper to get item by ID
  AddOnItem? getItemById(String id) {
    try {
      return addOns.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}

class AddOnItem {
  final String id;
  final String name;
  final String description;
  final String type; // "percentage" or "fixed"
  final double rate; // percentage (e.g., 0.02 for 2%)
  final double? cost; // fixed cost
  final String? icon;

  AddOnItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.rate,
    this.cost,
    this.icon,
  });

  factory AddOnItem.fromJson(Map<String, dynamic> json) {
    return AddOnItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'fixed',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      cost: (json['cost'] as num?)?.toDouble(),
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'rate': rate,
      'cost': cost,
      'icon': icon,
    };
  }

  // Calculate cost based on declared value (for percentage type)
  double calculateCost(double declaredValue) {
    if (type == 'percentage') {
      return declaredValue * rate;
    } else {
      return cost ?? 0.0;
    }
  }

  // Get display cost text
  String getCostText() {
    if (type == 'percentage') {
      return '${(rate * 100).toStringAsFixed(1)}% of declared value';
    } else {
      return 'R${cost?.toStringAsFixed(0) ?? '0'}';
    }
  }

  // Get display price
  String getDisplayPrice() {
    if (type == 'percentage') {
      return '${(rate * 100).toStringAsFixed(0)}%';
    } else {
      return 'R${cost?.toStringAsFixed(0) ?? '0'}';
    }
  }

  // Helper to get icon widget
  IconData getIconData() {
    switch (icon) {
      case 'shield':
        return Icons.security;
      case 'edit':
        return Icons.edit;
      case 'alert-triangle':
        return Icons.warning;
      case 'thermometer':
        return Icons.thermostat;
      case 'package':
        return Icons.inventory;
      case 'truck':
        return Icons.local_shipping;
      case 'star':
        return Icons.star;
      case 'calendar':
        return Icons.calendar_today;
      case 'moon':
        return Icons.nightlight_round;
      case 'home':
        return Icons.home;
      case 'photo':
        return Icons.photo_camera;
      case 'priority':
        return Icons.priority_high;
      default:
        return Icons.add_circle_outline;
    }
  }

  // For display
  @override
  String toString() => name;
}
