bool parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    return value == '1' || value.toLowerCase() == 'true';
  }
  return false;
}

class WalletTransactionResponse {
  final bool success;
  final List<WalletTransaction> data;
  final Pagination pagination;

  WalletTransactionResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory WalletTransactionResponse.fromJson(Map<String, dynamic> json) {
    return WalletTransactionResponse(
      success: parseBool(json["success"]),
      data: (json["data"] as List? ?? [])
          .map((e) => WalletTransaction.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json["pagination"] ?? {}),
    );
  }
}

class WalletTransaction {
  final int id;
  final String transactionType;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String referenceNumber;
  final int? orderId;
  final String description;
  final String status;
  final String createdAt;

  WalletTransaction({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.referenceNumber,
    this.orderId,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json["id"] ?? 0,
      transactionType: json["transaction_type"] ?? "",
      amount: (json["amount"] ?? 0).toDouble(),
      balanceBefore: (json["balance_before"] ?? 0).toDouble(),
      balanceAfter: (json["balance_after"] ?? 0).toDouble(),
      referenceNumber: json["reference_number"] ?? "",
      orderId: json["order_id"],
      description: json["description"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
    );
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json["current_page"] ?? 1,
      lastPage: json["last_page"] ?? 1,
      perPage: json["per_page"] ?? 10,
      total: json["total"] ?? 0,
    );
  }
}
