class DefaultAddressModel {
  final bool success;
  final AddressData data;

  DefaultAddressModel({required this.success, required this.data});

  factory DefaultAddressModel.fromJson(Map<String, dynamic> json) {
    return DefaultAddressModel(
      success: json["success"] ?? false,
      data: AddressData.fromJson(json["data"] ?? {}),
    );
  }
}

class AddressData {
  final int id;
  final String label;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String latitude;
  final String longitude;
  final String contactName;
  final String contactPhone;
  final bool isDefault;

  AddressData({
    required this.id,
    required this.label,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
    required this.isDefault,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) {
    return AddressData(
      id: json["id"] ?? 0,
      label: json["label"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      postalCode: json["postal_code"] ?? "",
      latitude: json["latitude"] ?? "",
      longitude: json["longitude"] ?? "",
      contactName: json["contact_name"] ?? "",
      contactPhone: json["contact_phone"] ?? "",
      isDefault: json["is_default"] ?? false,
    );
  }
}

// All Address
// all_address_model.dart
class AllAddressModel {
  final bool success;
  final List<AllAddressData> data;

  AllAddressModel({required this.success, required this.data});

  factory AllAddressModel.fromJson(Map<String, dynamic> json) {
    return AllAddressModel(
      success: json["success"] ?? false,
      data: (json["data"] as List<dynamic>)
          .map((e) => AllAddressData.fromJson(e))
          .toList(),
    );
  }
}

class AllAddressData {
  final int id;
  final int customerId;
  final String label;
  final String address;
  final String addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String latitude;
  final String longitude;
  final String contactName;
  final String contactPhone;
  final bool isDefault;

  AllAddressData({
    required this.id,
    required this.customerId,
    required this.label,
    required this.address,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.contactName,
    required this.contactPhone,
    required this.isDefault,
  });

  factory AllAddressData.fromJson(Map<String, dynamic> json) {
    return AllAddressData(
      id: json["id"],
      customerId: json["customer_id"],
      label: json["label"],
      address: json["address"],
      addressLine2: json["address_line_2"],
      city: json["city"],
      state: json["state"],
      postalCode: json["postal_code"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      contactName: json["contact_name"],
      contactPhone: json["contact_phone"],
      isDefault: json["is_default"],
    );
  }
}
