import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/gap.dart';

import '../../constants/colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //appbar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.electricTeal,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black26,
                //     blurRadius: 6,
                //     offset: Offset(0, 3),
                //   )
                // ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // --- LEFT SIDE (Close Icon) ---
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: IconButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     icon: Icon(Icons.arrow_back, color: AppColors.pureWhite),
                  //   ),
                  // ),

                  // --- CENTER TITLE ---
                  CustomText(
                    txt: "Wallet",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),

                  // --- RIGHT SIDE (Step indicator) ---
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: CustomText(
                  //     txt: "[1/4]",
                  //     fontSize: 14,
                  //     color: AppColors.pureWhite,
                  //   ),
                  // ),
                ],
              ),
            ),
            //appbar end
            // ---------------- AVAILABLE BALANCE ----------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mediumGray.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              txt: "Available Balance",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.electricTeal,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  CustomText(
                                    txt: "Add Money",
                                    fontSize: 15,
                                    color: AppColors.darkText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: _boxStyle,
                          child: Row(
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                color: AppColors.electricTeal,
                                size: 26,
                              ),
                              SizedBox(width: 12),
                              CustomText(
                                txt: "\$150.00",
                                color: AppColors.darkText,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  gapH12,

                  // ---------------- PAYMENT METHODS ----------------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mediumGray.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              txt: "Payment Methods",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.electricTeal,
                                    size: 20,
                                  ),
                                  SizedBox(width: 4),
                                  CustomText(
                                    txt: "Add Card",
                                    fontSize: 15,
                                    color: AppColors.darkText,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: _boxStyle,
                          child: Row(
                            children: [
                              const Icon(Icons.credit_card, size: 26),
                              gapW12,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    txt: "Visa **** 1234",
                                    fontSize: 15,
                                    color: AppColors.darkText,
                                  ),
                                  CustomText(
                                    txt: "[Primary]",

                                    fontSize: 13,
                                    color: AppColors.electricTeal,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  gapH24,

                  // ---------------- TRANSACTION HISTORY ----------------
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: AppColors.electricTeal),
                      SizedBox(width: 8),
                      CustomText(
                        txt: "Transaction History",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // --- Transaction 1 ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.electricTeal),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mediumGray.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Order #12345", style: _boldText),
                        SizedBox(height: 4),
                        Text("Jan 15, 3:00 PM", style: _subText),
                        SizedBox(height: 4),
                        Text(
                          "- \$70.00",
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- Transaction 2 ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.electricTeal),
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mediumGray.withValues(alpha: 0.10),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Wallet Top-up", style: _boldText),
                        SizedBox(height: 4),
                        Text("Jan 14, 10:20 AM", style: _subText),
                        SizedBox(height: 4),
                        Text(
                          "+ \$100.00",
                          style: TextStyle(fontSize: 15, color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                  gapH12,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: CustomButton(
                      onPressed: () {},
                      text: "View All",
                      backgroundColor: AppColors.pureWhite,
                      borderColor: AppColors.electricTeal,
                      textColor: AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- STYLES ----------------

const _boxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.electricTeal)),
);

const _boldText = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

const _subText = TextStyle(fontSize: 13, color: Colors.black54);
