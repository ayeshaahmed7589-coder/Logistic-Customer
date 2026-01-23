bool parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1' || value.toLowerCase() == 'true';
  return false;
}

class WalletTopUpModel {
  final bool success;
  final String message;
  final WalletTopUpData data;

  WalletTopUpModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletTopUpModel.fromJson(Map<String, dynamic> json) {
    print("Wallet Top-Up API Response => $json");
    return WalletTopUpModel(
      success: parseBool(json["success"]),
      message: json["message"] ?? "",
      data: WalletTopUpData.fromJson(json["data"] ?? {}),
    );
  }
}

class WalletTopUpData {
  final String checkoutUrl;
  final String checkoutId;
  final String reference;
  final double amount;
  final int transactionId;
  final String expiresAt;

  WalletTopUpData({
    required this.checkoutUrl,
    required this.checkoutId,
    required this.reference,
    required this.amount,
    required this.transactionId,
    required this.expiresAt,
  });

  factory WalletTopUpData.fromJson(Map<String, dynamic> json) {
    return WalletTopUpData(
      checkoutUrl: json["checkout_url"] ?? "",
      checkoutId: json["checkout_id"] ?? "",
      reference: json["reference"] ?? "",
      amount: (json["amount"] ?? 0).toDouble(),
      transactionId: json["transaction_id"] ?? 0,
      expiresAt: json["expires_at"] ?? "",
    );
  }
}
