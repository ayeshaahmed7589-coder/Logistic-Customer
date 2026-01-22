bool parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    return value == '1' || value.toLowerCase() == 'true';
  }
  return false;
}

class WalletBalanceModel {
  final bool success;
  final WalletBalanceData data;

  WalletBalanceModel({
    required this.success,
    required this.data,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      success: parseBool(json["success"]),
      data: WalletBalanceData.fromJson(json["data"] ?? {}),
    );
  }
}

class WalletBalanceData {
  final double balance;
  final String currency;
  final String walletType;
  final bool isActive;

  WalletBalanceData({
    required this.balance,
    required this.currency,
    required this.walletType,
    required this.isActive,
  });

  factory WalletBalanceData.fromJson(Map<String, dynamic> json) {
    return WalletBalanceData(
      balance: (json["balance"] ?? 0).toDouble(),
      currency: json["currency"] ?? "",
      walletType: json["wallet_type"] ?? "",
      isActive: parseBool(json["is_active"]),
    );
  }
}
