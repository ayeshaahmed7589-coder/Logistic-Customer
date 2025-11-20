import 'package:flutter/material.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/service_payment_screen.dart';

class PackageDetailScreen extends StatefulWidget {
  const PackageDetailScreen({super.key});

  @override
  State<PackageDetailScreen> createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  final TextEditingController what_sendingController = TextEditingController();
  final TextEditingController package_weightController =
      TextEditingController();
  final TextEditingController estimated_weightController =
      TextEditingController();
  final TextEditingController special_instructionsController =
      TextEditingController();

  final what_sendingFocus = FocusNode();
  final package_weightFocus = FocusNode();
  final special_instructionsFocus = FocusNode();
  final estimated_weightFocus = FocusNode();
  final Color inactiveColor = AppColors.mediumGray;
  @override
  void initState() {
    super.initState();
    what_sendingController.addListener(_checkFormFilled);
    package_weightController.addListener(_checkFormFilled);
    estimated_weightController.addListener(_checkFormFilled);
    special_instructionsController.addListener(_checkFormFilled);
  }

  bool _isFormFilled = false;
  void _checkFormFilled() {
    final isFilled =
        what_sendingController.text.isNotEmpty &&
        package_weightController.text.isNotEmpty &&
        estimated_weightController.text.isNotEmpty &&
        special_instructionsController.text.isNotEmpty;

    if (isFilled != _isFormFilled) {
      setState(() => _isFormFilled = isFilled);
    }
  }

  @override
  void dispose() {
    what_sendingFocus.dispose();
    package_weightFocus.dispose();
    special_instructionsFocus.dispose();
    estimated_weightFocus.dispose();
    //
    what_sendingController.dispose();
    package_weightController.dispose();
    estimated_weightController.dispose();
    special_instructionsController.dispose();

    super.dispose();
  }

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
                      txt: "[3/4]",
                      fontSize: 14,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ],
              ),
            ),
            //appbar end

            // ---------- Pickup Details Heading ----------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Icon(Icons.location_pin, color: Colors.red),
                      SizedBox(width: 6),
                      CustomText(
                        txt: "Package Details",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  gapH12,
                  CustomAnimatedTextField(
                    controller: what_sendingController,
                    focusNode: what_sendingFocus,
                    labelText: "What are you sending?",
                    hintText: "What are you sending?",
                    prefixIcon: Icons.contact_page_outlined,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return null;
                    },
                  ),

                  gapH8,

                  CustomAnimatedTextField(
                    controller: package_weightController,
                    focusNode: package_weightFocus,
                    labelText: "Package Weight",
                    hintText: "Package Weight",
                    prefixIcon: Icons.contact_page_outlined,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return null;
                    },
                  ),

                  gapH8,

                  CustomAnimatedTextField(
                    controller: estimated_weightController,
                    focusNode: estimated_weightFocus,
                    labelText: "Estimated Weight",
                    hintText: "Estimated Weight",
                    prefixIcon: Icons.contact_page_outlined,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return null;
                    },
                  ),

                  gapH8,

                  // ---------- Postal Code ----------
                  CustomAnimatedTextField(
                    controller: special_instructionsController,
                    focusNode: special_instructionsFocus,
                    labelText: "Special Instructions",
                    hintText: "Special Instructions",
                    prefixIcon: Icons.contact_page_outlined,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return null;
                    },
                  ),

                  gapH20,

                  // ---------- Continue Button ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      isChecked: _isFormFilled,
                      text: "Continue",
                      backgroundColor: _isFormFilled
                          ? AppColors.electricTeal
                          : inactiveColor,
                      borderColor: AppColors.electricTeal,
                      textColor: AppColors.lightGrayBackground,
                      onPressed: _isFormFilled
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ServicePaymentScreen(),
                                ),
                              );
                            }
                          : null,
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
