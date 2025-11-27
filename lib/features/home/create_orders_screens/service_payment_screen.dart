import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';

import 'package:logisticscustomer/constants/gap.dart';
import 'package:logisticscustomer/features/home/order_successful.dart';

class ServicePaymentScreen extends StatefulWidget {
  const ServicePaymentScreen({super.key});

  @override
  State<ServicePaymentScreen> createState() => _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends State<ServicePaymentScreen> {
  String serviceType = "standard";
  String paymentMethod = "wallet";
  String vehicleMethod = "bike";

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
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 14),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: AppColors.pureWhite),
                    ),
                  ),

                  // --- CENTER TITLE ---
                  CustomText(
                    txt: "New Order",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureWhite,
                  ),

                  // --- RIGHT SIDE (Step indicator) ---
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomText(
                      txt: "[3/3]",
                      fontSize: 14,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ],
              ),
            ),

            //appbar end
            // ---------------- SERVICE TYPE ----------------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Pick up
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: AppColors.electricTeal),
                      SizedBox(width: 8),
                      CustomText(
                        txt: "Pick Up",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  gapH8,
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
                      children: [
                        Text("House 123, Street 5", style: _boldText),
                        SizedBox(height: 4),
                        Text("Karachi, Sindh", style: _subText),
                        SizedBox(height: 4),
                        CustomText(
                          txt: "John Doe - +92 308 1234567",
                          fontSize: 15,
                          color: AppColors.mediumGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  gapH16,

                  // Delivery
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: AppColors.electricTeal),
                      SizedBox(width: 8),
                      CustomText(
                        txt: "Delivery",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  gapH8,
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
                      children: [
                        Text("Office 301, Clifton Tower", style: _boldText),
                        SizedBox(height: 4),
                        Text("Karachi, Sindh", style: _subText),
                        SizedBox(height: 4),
                        CustomText(
                          txt: "Jane Smith - +92 311 9876543",
                          fontSize: 15,
                          color: AppColors.mediumGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  gapH16,

                  // Items
                  Row(
                    children: [
                      Icon(Icons.bar_chart, color: AppColors.electricTeal),
                      SizedBox(width: 8),
                      CustomText(
                        txt: "Items",
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  gapH8,
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
                      children: [
                        Text("-Electronics Package x2", style: _boldText),
                        SizedBox(height: 4),
                        Text("-Documents Package x1", style: _subText),
                        SizedBox(height: 4),
                        CustomText(
                          txt: "Total: 6.0 kg",
                          fontSize: 15,
                          color: AppColors.mediumGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  gapH20,
                  // Services
                  _sectionTitle(Icons.local_shipping, "Service Options"),
                  const SizedBox(height: 10),
                  _serviceOption(
                    selected: serviceType == "standard",
                    title: "Standard",
                    subtitle: "(R0)",
                    onTap: () => setState(() => serviceType = "standard"),
                  ),

                  _serviceOption(
                    selected: serviceType == "express",
                    title: "Express",
                    subtitle: "(+R20)",
                    onTap: () => setState(() => serviceType = "express"),
                  ),

                  _serviceOption(
                    selected: serviceType == "sameday",
                    title: "Same Day",
                    subtitle: "(+R50)",
                    onTap: () => setState(() => serviceType = "sameday"),
                  ),
                  // Services END
                  gapH16,

                  // Vehicle Type
                  _sectionTitle(Icons.local_shipping, "Vehicle Type"),
                  const SizedBox(height: 10),
                  _serviceOption2(
                    selected: vehicleMethod == "bike",
                    title: "Bike (Small Packages)",
                    onTap: () => setState(() => vehicleMethod = "bike"),
                  ),

                  _serviceOption2(
                    selected: vehicleMethod == "van",
                    title: "Van (Medium Load)",
                    onTap: () => setState(() => vehicleMethod = "van"),
                  ),

                  _serviceOption2(
                    selected: vehicleMethod == "truck",
                    title: "Truck (Heavy/Bulk)",
                    onTap: () => setState(() => vehicleMethod = "truck"),
                  ),
                  // Vehicle END
                  gapH16,

                  // ---------------- PAYMENT SUMMARY ----------------
                  _sectionTitle(Icons.payments, "Payment Summary"),
                  const SizedBox(height: 10),
                  _summaryRow("Base Fare", "R0.00"),
                  _summaryRow("Distance", "R0.00"),
                  _summaryRow("Weight Charge", "R0.00"),
                  _summaryRow("Services", "R0.00"),
                  const Divider(thickness: 1),
                  _summaryRow("SubTotal", "00", bold: true),
                  _summaryRow("Tax (5%)", "00", bold: true),
                  _summaryRow("Total", "00", bold: true),

                  const SizedBox(height: 25),

                  // ---------------- PAYMENT METHOD ----------------
                  _sectionTitle(Icons.account_balance_wallet, "Payment Method"),
                  const SizedBox(height: 10),

                  _paymentOption(
                    selected: paymentMethod == "wallet",
                    title: "Wallet (Balance R500.0)",
                    onTap: () => setState(() => paymentMethod = "wallet"),
                  ),

                  _paymentOption(
                    selected: paymentMethod == "cod",
                    title: "Cash on Delivery",
                    onTap: () => setState(() => paymentMethod = "cod"),
                  ),

                  _paymentOption(
                    selected: paymentMethod == "card",
                    title: "Card Payment",
                    onTap: () => setState(() => paymentMethod = "card"),
                  ),

                  const SizedBox(height: 30),

                  // ---------------- PLACE ORDER BUTTON ----------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Place Order",
                      backgroundColor: AppColors.pureWhite,

                      borderColor: AppColors.electricTeal,
                      textColor: AppColors.darkText,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OrderSuccessful(),
                          ),
                        );
                      },
                    ),
                  ),
                  gapH12,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- Widgets -----------------

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.electricTeal, size: 22),
        const SizedBox(width: 8),
        CustomText(
          txt: title,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppColors.darkText,
        ),
      ],
    );
  }

  Widget _serviceOption({
    required bool selected,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.electricTeal
                : AppColors.mediumGray.withValues(alpha: 0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? AppColors.electricTeal
                  : AppColors.mediumGray.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(txt: title, fontSize: 15, color: AppColors.darkText),
                CustomText(
                  txt: subtitle,
                  fontSize: 13,
                  color: AppColors.mediumGray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceOption2({
    required bool selected,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.electricTeal
                : AppColors.mediumGray.withValues(alpha: 0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected
                  ? AppColors.electricTeal
                  : AppColors.mediumGray.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(txt: title, fontSize: 15, color: AppColors.darkText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String left, String right, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            txt: left,

            fontSize: 15,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: AppColors.darkText,
          ),
          CustomText(
            txt: right,

            fontSize: 15,
            color: AppColors.mediumGray,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }

  Widget _paymentOption({
    required bool selected,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? AppColors.electricTeal
                : AppColors.mediumGray.withValues(alpha: 0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.electricTeal : Colors.grey,
            ),
            const SizedBox(width: 12),
            CustomText(txt: title, fontSize: 15),
          ],
        ),
      ),
    );
  }
}

const _boldText = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: AppColors.mediumGray,
);

const _subText = TextStyle(
  fontSize: 13,
  color: AppColors.mediumGray,
  fontWeight: FontWeight.w600,
);
