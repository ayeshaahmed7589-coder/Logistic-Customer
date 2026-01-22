class PaymentResult {
  final String method; // wallet | card | pay_later
  final String? token;

  PaymentResult({
    required this.method,
    this.token,
  });
}