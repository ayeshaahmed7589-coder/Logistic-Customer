class RestPasswordModel {
  final bool success;
  final String message;

  RestPasswordModel({required this.success, required this.message});

  factory RestPasswordModel.fromJson(Map<String, dynamic> json) {
    return RestPasswordModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "message": message};
  }
}
