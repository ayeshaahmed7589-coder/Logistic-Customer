import 'package:flutter/material.dart';
import 'package:logisticscustomer/common_widgets/custom_button.dart';
import 'package:logisticscustomer/common_widgets/custom_text.dart';
import 'package:logisticscustomer/constants/colors.dart';

class ServicePaymentScreen extends StatefulWidget {
  const ServicePaymentScreen({super.key});

  @override
  State<ServicePaymentScreen> createState() => _ServicePaymentScreenState();
}

class _ServicePaymentScreenState extends State<ServicePaymentScreen> {
  String serviceType = "standard";
  String paymentMethod = "wallet";

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
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
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
                      txt: "[4/4]",
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
                  _sectionTitle(Icons.local_shipping, "Service Type"),

                  const SizedBox(height: 10),

                  _serviceOption(
                    selected: serviceType == "standard",
                    title: "Standard Delivery",
                    subtitle: "2–3 days  |  \$50",
                    onTap: () => setState(() => serviceType = "standard"),
                  ),

                  _serviceOption(
                    selected: serviceType == "express",
                    title: "Express Delivery",
                    subtitle: "Same day  |  \$70",
                    onTap: () => setState(() => serviceType = "express"),
                  ),

                  const SizedBox(height: 20),

                  // ---------------- PAYMENT SUMMARY ----------------
                  _sectionTitle(Icons.payments, "Payment Summary"),
                  const SizedBox(height: 10),

                  _summaryRow("Base Cost", "\$50"),
                  _summaryRow("Distance", "\$20"),

                  const Divider(thickness: 1),
                  _summaryRow("Total", "\$70", bold: true),

                  const SizedBox(height: 25),

                  // ---------------- PAYMENT METHOD ----------------
                  _sectionTitle(Icons.account_balance_wallet, "Payment Method"),
                  const SizedBox(height: 10),

                  _paymentOption(
                    selected: paymentMethod == "wallet",
                    title: "Wallet (\$150)",
                    onTap: () => setState(() => paymentMethod = "wallet"),
                  ),

                  _paymentOption(
                    selected: paymentMethod == "cod",
                    title: "Cash on Delivery",
                    onTap: () => setState(() => paymentMethod = "cod"),
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
                            builder: (_) => const ServicePaymentScreen(),
                          ),
                        );
                      },
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
