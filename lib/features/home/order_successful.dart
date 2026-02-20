import 'package:flutter/material.dart';
import 'package:logisticscustomer/features/bottom_navbar/bottom_navbar_screen.dart';
import 'package:logisticscustomer/features/home/orders_flow/ordr_tracking/order_tracking_screen.dart';
import '../../constants/colors.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessful extends StatelessWidget {
  
  final String orderNumber;
  final double totalAmount;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double totalWeightKg;
  final String trackingCode;
  final double distanceKm;
  final double finalCost;
  final String createedAt;

  const OrderSuccessful({
    super.key,
    required this.totalAmount,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.totalWeightKg,
    required this.trackingCode,
    required this.distanceKm,
    required this.finalCost,
    required this.createedAt,
  });

  @override
  Widget build(BuildContext context) {
    final bool showShipmentDetails = paymentMethod != "card";
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Lottie.asset(
                  "assets/Success.json",
                  width: 130,
                  height: 130,
                  fit: BoxFit.contain,
                  repeat: false,
                  animate: true,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Order Placed Successfully!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 20),

              // Order Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.electricTeal, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.mediumGray.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ORDER NUMBER
                    Text(
                      "Order Number",
                      style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderNumber,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      "Tracking",
                      style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trackingCode,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkText,
                      ),
                    ),

                    const SizedBox(height: 10),
                    if (showShipmentDetails) ...[
                      const SizedBox(height: 10),
                      Text(
                        "Weight: ${totalWeightKg.toStringAsFixed(2)} kg",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.electricTeal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Distance: ${distanceKm.toStringAsFixed(2)} km",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.electricTeal,
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),
                    Text(
                      "Status: $status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.electricTeal,
                      ),
                    ),
                    Text(
                      "Waiting for driver assignment",
                      style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Payment Status: $paymentStatus",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.electricTeal,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      "Total Amount: R${totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Payment Method: $paymentMethod",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Created At: $createedAt",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.electricTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderTrackingScreen(
                                  trackingCode: trackingCode ,
                                ),
                              ),
                            );
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         TripsBottomNavBarScreen(initialIndex: 1),
                        //   ),
                        // );
                      },
                      child: const Text(
                        "Track Order",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.electricTeal,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TripsBottomNavBarScreen(initialIndex: 0),
                          ),
                        );
                      },
                      child: Text(
                        "Back to Home",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.electricTeal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
