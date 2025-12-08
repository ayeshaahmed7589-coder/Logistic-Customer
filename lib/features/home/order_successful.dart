import 'package:flutter/material.dart';
import 'package:logisticscustomer/features/bottom_navbar/bottom_navbar_screen.dart';
import 'package:lottie/lottie.dart';
import '../../constants/colors.dart';



class OrderSuccessful extends StatelessWidget {
  final String orderNumber;
  final String totalAmount;
  
  const OrderSuccessful({
    super.key, 
    required this.totalAmount, 
    required this.orderNumber
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
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
              SizedBox(height: 10),
              Text(
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

                    const SizedBox(height: 20),

                    // STATUS
                    Text(
                      "Status: Pending",
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

                    const SizedBox(height: 20),

                    // AMOUNT + PAYMENT
                    Text(
                      "Total Amount: R$totalAmount",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                      ),
                    ),
                    Text(
                      "Payment: Wallet (Paid)",
                      style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                    ),

                    const SizedBox(height: 20),

                    // MESSAGE
                    Text(
                      "You'll be notified when a driver accepts your order.",
                      style: TextStyle(fontSize: 14, color: AppColors.darkGray),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // BUTTONS
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TripsBottomNavBarScreen(initialIndex: 1),
                          ),
                        );
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

// class OrderSuccessful extends StatelessWidget {
//   const OrderSuccessful({super.key, required String totalAmount, required String orderNumber});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGrayBackground,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 30),
//               Center(
//                 child: Lottie.asset(
//                   "assets/Success.json",
//                   width: 130,
//                   height: 130,
//                   fit: BoxFit.contain,
//                   repeat: false,
//                   animate: true,
//                   options: LottieOptions(enableMergePaths: true),
//                   delegates: LottieDelegates(),
//                   frameRate: FrameRate(30),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Order Placed Successfully!",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.darkText,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // ------------------- MAIN CARD -------------------
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: AppColors.pureWhite,
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: AppColors.electricTeal, width: 1),
//                   boxShadow: [
//                     BoxShadow(
//                       color: AppColors.mediumGray.withOpacity(0.25),
//                       blurRadius: 10,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ORDER NUMBER
//                     Text(
//                       "Order Number",
//                       style: TextStyle(fontSize: 14, color: AppColors.darkGray),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "ORD-20251125-ABC123",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.darkText,
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // STATUS
//                     Text(
//                       "Status: Pending",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.electricTeal,
//                       ),
//                     ),
//                     Text(
//                       "Waiting for driver assignment",
//                       style: TextStyle(fontSize: 14, color: AppColors.darkGray),
//                     ),

//                     const SizedBox(height: 20),

//                     // AMOUNT + PAYMENT
//                     Text(
//                       "Total Amount: R134.40",
//                       style: TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.darkText,
//                       ),
//                     ),
//                     Text(
//                       "Payment: Wallet (Paid)",
//                       style: TextStyle(fontSize: 14, color: AppColors.darkGray),
//                     ),

//                     const SizedBox(height: 20),

//                     // DISTANCE + DELIVERY
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, size: 18, color: Colors.red),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             "Estimated Distance: 5.2 km",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.darkText,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 8),

//                     Row(
//                       children: [
//                         Icon(Icons.timer, size: 18, color: Colors.orange),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             "Expected Delivery: 30–45 mins",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: AppColors.darkText,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // NOTIFICATION INFO
//                     Text(
//                       "You'll be notified when a driver accepts your order.",
//                       style: TextStyle(fontSize: 14, color: AppColors.darkGray),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 25),

//               // ------------------ BOTTOM BUTTONS ------------------
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.electricTeal,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 TripsBottomNavBarScreen(initialIndex: 1),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Track Order",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(
//                           color: AppColors.electricTeal,
//                           width: 1,
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 TripsBottomNavBarScreen(initialIndex: 0),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "Back to Home",
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: AppColors.electricTeal,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
