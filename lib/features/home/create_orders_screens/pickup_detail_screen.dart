import 'package:flutter/material.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/delivery_detail_screen.dart';

class PickupDetailScreen extends StatefulWidget {
  const PickupDetailScreen({super.key});

  @override
  State<PickupDetailScreen> createState() => _PickupDetailScreenState();
}

class _PickupDetailScreenState extends State<PickupDetailScreen> {
  final TextEditingController contactnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalController = TextEditingController();

  final contactnameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final pickupFocus = FocusNode();
  final cityFocus = FocusNode();
  final postalFocus = FocusNode();
  final Color inactiveColor = AppColors.mediumGray;
  @override
  void initState() {
    super.initState();
    contactnameController.addListener(_checkFormFilled);
    phoneController.addListener(_checkFormFilled);
    pickupController.addListener(_checkFormFilled);
    postalController.addListener(_checkFormFilled);
  }

  bool _isFormFilled = false;
  void _checkFormFilled() {
    final isFilled =
        contactnameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        pickupController.text.isNotEmpty &&
        postalController.text.isNotEmpty;

    if (isFilled != _isFormFilled) {
      setState(() => _isFormFilled = isFilled);
    }
  }

  @override
  void dispose() {
    contactnameFocus.dispose();
    phoneFocus.dispose();
    cityFocus.dispose();
    phoneFocus.dispose();
    //
    contactnameController.dispose();
    phoneController.dispose();
    pickupController.dispose();
    postalFocus.dispose();

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
                      txt: "[1/4]",
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
                        txt: "Pickup Details",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  gapH12,
                  CustomAnimatedTextField(
                    controller: contactnameController,
                    focusNode: contactnameFocus,
                    labelText: "Contact Name",
                    hintText: "Contact Name",
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
                    controller: phoneController,
                    focusNode: phoneFocus,
                    labelText: "Phone Number",
                    hintText: "Phone Number",
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
                    controller: pickupController,
                    focusNode: pickupFocus,
                    labelText: "Pickup Address",
                    hintText: "Pickup Address",
                    prefixIcon: Icons.contact_page_outlined,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return null;
                    },
                  ),
                  gapH16,

                  Row(
                    children: [
                      Icon(
                        Icons.pin_drop_outlined,
                        color: AppColors.electricTeal,
                      ),
                      SizedBox(width: 6),
                      CustomText(
                        txt: "Use Current Location",
                        color: AppColors.darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  gapH12,
                  // ---------- City ----------
                  CustomAnimatedTextField(
                    controller: cityController,
                    focusNode: cityFocus,
                    labelText: "City",
                    hintText: "City",
                    prefixIcon: Icons.calendar_today_outlined,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: Colors.black87,
                    keyboardType: TextInputType.datetime,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      color: AppColors.electricTeal,
                      onPressed: () {},
                    ),
                  ),

                  gapH8,

                  // ---------- Postal Code ----------
                  CustomAnimatedTextField(
                    controller: postalController,
                    focusNode: postalFocus,
                    labelText: "Postal Code (Optional)",
                    hintText: "Postal Code (Optional)",
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
                                  builder: (_) => DeliveryDetailScreen(),
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
