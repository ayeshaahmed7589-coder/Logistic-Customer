// payment_check_model.dart
class PaymentCheckModel {
  final bool success;
  final PaymentData data;

  PaymentCheckModel({
    required this.success,
    required this.data,
  });

  factory PaymentCheckModel.fromJson(Map<String, dynamic> json) {
    return PaymentCheckModel(
      success: json["success"] ?? false,
      data: PaymentData.fromJson(json["data"]),
    );
  }
}

class PaymentData {
    final String selectedMethod;
  final double amountRequired;
  final Wallet wallet;
  final CardOption card;
  final PayLater payLater;

  PaymentData({
      this.selectedMethod = 'wallet',
    required this.amountRequired,
    required this.wallet,
    required this.card,
    required this.payLater,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      amountRequired: (json["amount_required"] ?? 0).toDouble(),
      wallet: Wallet.fromJson(json["wallet"]),
      card: CardOption.fromJson(json["card"]),
      payLater: PayLater.fromJson(json["pay_later"]),
    );
  }
}

class Wallet {
  final bool available;
  final double balance;
  final bool sufficient;
  final double shortfall;

  Wallet({
    required this.available,
    required this.balance,
    required this.sufficient,
    required this.shortfall,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      available: json["available"] ?? false,
      balance: (json["balance"] ?? 0).toDouble(),
      sufficient: json["sufficient"],
      shortfall: (json["shortfall"] ?? 0).toDouble(),
    );
  }
}

class CardOption {
  final bool available;
  final String gateway;

  CardOption({
    required this.available,
    required this.gateway,
  });

  factory CardOption.fromJson(Map<String, dynamic> json) {
    return CardOption(
      available: json["available"] ?? false,
      gateway: json["gateway"] ?? "",
    );
  }
}

class PayLater {
  final bool available;

  PayLater({required this.available});

  factory PayLater.fromJson(Map<String, dynamic> json) {
    return PayLater(
      available: json["available"] ?? false,
    );
  }
}
