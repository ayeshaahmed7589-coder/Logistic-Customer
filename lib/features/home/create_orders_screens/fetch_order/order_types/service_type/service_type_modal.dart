import 'package:flutter/material.dart';

class ServiceTypeResponse {
  final bool success;
  final String message;
  final ServiceTypeData data;

  ServiceTypeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceTypeResponse.fromJson(Map<String, dynamic> json) {
    return ServiceTypeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ServiceTypeData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ServiceTypeData {
  final List<ServiceTypeItem> serviceTypes;

  ServiceTypeData({
    required this.serviceTypes,
  });

  factory ServiceTypeData.fromJson(Map<String, dynamic> json) {
    final serviceTypesList = json['service_types'] as List<dynamic>? ?? [];
    return ServiceTypeData(
      serviceTypes: serviceTypesList
          .map((item) => ServiceTypeItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_types': serviceTypes.map((item) => item.toJson()).toList(),
    };
  }

  // Helper method to get all items
  List<ServiceTypeItem> getAllItems() {
    return serviceTypes;
  }

  // Helper to get item by ID
  ServiceTypeItem? getItemById(String id) {
    try {
      return serviceTypes.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}

class ServiceTypeItem {
  final String id;
  final String name;
  final String description;
  final String? icon;
  final double multiplier;

  ServiceTypeItem({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
    required this.multiplier,
  });

  factory ServiceTypeItem.fromJson(Map<String, dynamic> json) {
    return ServiceTypeItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'multiplier': multiplier,
    };
  }

  // Helper to get icon widget
  IconData getIconData() {
    switch (icon) {
      case 'truck':
        return Icons.local_shipping;
      case 'zap':
        return Icons.flash_on;
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
  String toString() => name;
}