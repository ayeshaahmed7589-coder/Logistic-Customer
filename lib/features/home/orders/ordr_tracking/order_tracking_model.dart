bool parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    return value == '1' || value.toLowerCase() == 'true';
  }
  return false;
}

class OrderTrackingModel {
  final bool success;
  final OrderTrackingData data;

  OrderTrackingModel({
    required this.success,
    required this.data,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      success: parseBool(json["success"]),
      data: OrderTrackingData.fromJson(json["data"] ?? {}),
    );
  }
}

class OrderTrackingData {
  final String orderNumber;
  final String trackingCode;
  final String status;
  final String statusLabel;
  final bool isMultiStop;
  final int progressPercent;
  final int? currentStop;
  final int totalStops;
  final List<TrackOrderStop> stops;
  final String pickupAddress;
  final String deliveryAddress;
  final Driver driver;
  final TrackingVehicle vehicle;
  final String? scheduledPickupTime;
  final String? scheduledDeliveryTime;
  final String? estimatedArrival;
  final String createdAt;
  final String updatedAt;

  OrderTrackingData({
    required this.orderNumber,
    required this.trackingCode,
    required this.status,
    required this.statusLabel,
    required this.isMultiStop,
    required this.progressPercent,
    required this.currentStop,
    required this.totalStops,
    required this.stops,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.driver,
    required this.vehicle,
    this.scheduledPickupTime,
    this.scheduledDeliveryTime,
    this.estimatedArrival,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderTrackingData.fromJson(Map<String, dynamic> json) {
    return OrderTrackingData(
      orderNumber: json["order_number"] ?? "",
      trackingCode: json["tracking_code"] ?? "",
      status: json["status"] ?? "",
      statusLabel: json["status_label"] ?? "",
      isMultiStop: parseBool(json["is_multi_stop"]),
      progressPercent: json["progress_percent"] ?? 0,
      currentStop: json["current_stop"],
      totalStops: json["total_stops"] ?? 0,
      stops: (json["stops"] as List? ?? [])
          .map((e) => TrackOrderStop.fromJson(e))
          .toList(),
      pickupAddress: json["pickup_address"] ?? "",
      deliveryAddress: json["delivery_address"] ?? "",
      driver: Driver.fromJson(json["driver"]),
      vehicle: TrackingVehicle.fromJson(json["vehicle"] ?? {}),
      scheduledPickupTime: json["scheduled_pickup_time"],
      scheduledDeliveryTime: json["scheduled_delivery_time"],
      estimatedArrival: json["estimated_arrival"],
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}

class TrackOrderStop {
  final int sequence;
  final String type;
  final String address;
  final String city;
  final String contactName;
  final String contactPhone;
  final String status;
  final String statusLabel;
  final String? arrivalTime;
  final String? departureTime;
  final bool isCurrent;

  TrackOrderStop({
    required this.sequence,
    required this.type,
    required this.address,
    required this.city,
    required this.contactName,
    required this.contactPhone,
    required this.status,
    required this.statusLabel,
    this.arrivalTime,
    this.departureTime,
    required this.isCurrent,
  });

  factory TrackOrderStop.fromJson(Map<String, dynamic> json) {
    return TrackOrderStop(
      sequence: json["sequence_number"] ?? 0,
      type: json["stop_type"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      contactName: json["contact_name"] ?? "",
      contactPhone: json["contact_phone"] ?? "",
      status: json["status"] ?? "",
      statusLabel: json["status_label"] ?? "",
      arrivalTime: json["arrival_time"],
      departureTime: json["departure_time"],
      isCurrent: parseBool(json["is_current"]),
    );
  }
}


class Driver {
  final String name;
  final String phone;
  final String rating;

  Driver({
    required this.name,
    required this.phone,
    required this.rating,
  });

  factory Driver.fromJson(dynamic json) {
    if (json == null || json is! Map<String, dynamic>) {
      return Driver(name: "", phone: "", rating: "");
    }
    return Driver(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      rating: json["rating"]?.toString() ?? "",
    );
  }
}

class TrackingVehicle {
  final String registration;
  final String make;
  final String model;
  final String type;
  final String? latitude;
  final String? longitude;

  TrackingVehicle({
    required this.registration,
    required this.make,
    required this.model,
    required this.type,
    this.latitude,
    this.longitude,
  });

  factory TrackingVehicle.fromJson(Map<String, dynamic> json) {
    return TrackingVehicle(
      registration: json["registration_number"] ?? "",
      make: json["make"] ?? "",
      model: json["model"] ?? "",
      type: json["type"] ?? "",
      latitude: json["current_latitude"]?.toString(),
      longitude: json["current_longitude"]?.toString(),
    );
  }
}
