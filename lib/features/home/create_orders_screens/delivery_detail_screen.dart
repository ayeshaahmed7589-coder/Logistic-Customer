import 'package:flutter/material.dart';
import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/service_payment_screen.dart';
import 'add_product_manualy_screen/add_product_manualy_screen.dart';
import 'search_screen/search_screen.dart';

class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key});

  void showSearchProductsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7), // background dim
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(vertical: 30),
          backgroundColor: AppColors.lightGrayBackground,
          child: Container(
            width: double.infinity,
            height:
                MediaQuery.of(context).size.height *
                0.73, // center modal height
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SearchProductWidget(), // tumhara UI
          ),
        );
      },
    );
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
                      icon: Icon(Icons.arrow_back, color: AppColors.pureWhite),
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
                      txt: "[2/3]",
                      fontSize: 14,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ],
              ),
            ),

            //appbar end
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("PACKAGE DETAILS"),

                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      showSearchProductsModal(
                        context,
                      ); // ← yeh function modal kholta hai
                    },
                    child: Container(
                      height: 52,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricTeal.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: AppColors.electricTeal,
                            size: 24,
                          ),
                          SizedBox(width: 12),

                          // Yahan TextField ko readOnly kar diya — taake click sirf modal khole
                          Expanded(
                            child: TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: "Search Shopify Products...",
                                hintStyle: TextStyle(
                                  color: AppColors.mediumGray,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(
                                color: AppColors.darkText,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: () {
                                showSearchProductsModal(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Search bar end
                  const SizedBox(height: 10),
                  Center(
                    child: CustomText(
                      txt: "OR",
                      color: AppColors.darkText,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Defult address
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
                              txt: "Add Item Manually",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor:
                                      AppColors.lightGrayBackground,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(22),
                                    ),
                                  ),
                                  transitionAnimationController:
                                      AnimationController(
                                        duration: Duration(
                                          milliseconds: 450,
                                        ), // Slow & Smooth
                                        vsync: Navigator.of(context),
                                      ),

                                  // --------------------------------------------------------
                                  builder: (_) => const AddManualItemModal(),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 20,
                                    color: AppColors.electricTeal,
                                  ),
                                  CustomText(
                                    txt: "Add",
                                    fontSize: 15,
                                    color: AppColors.darkText,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: _boxStyle,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        txt: "Electronics Package",
                                        color: AppColors.electricTeal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Qty",
                                        value: "2",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors
                                            .mediumGray, // Different color for value
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Weight",
                                        value: "5.5 kg",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors.mediumGray,
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Value",
                                        value: "R50,00",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors.mediumGray,
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Note",
                                        value: "Handle with care",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors.mediumGray,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                            gapH12,
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: _boxStyle,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        txt: "Electronics Package",
                                        color: AppColors.electricTeal,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Qty",
                                        value: "2",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors
                                            .mediumGray, // Different color for value
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Weight",
                                        value: "5.5 kg",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors.mediumGray,
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Value",
                                        value: "R50,00",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors.mediumGray,
                                      ),
                                      gapH4,
                                      _infoRow(
                                        label: "Note",
                                        value: "Handle with care",
                                        labelColor: AppColors.electricTeal,
                                        valueColor: AppColors.mediumGray,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  gapH20,

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow("Total Weight:", "6.0 kg"),
                        gapH8,
                        _buildInfoRow("Total Items:", "3"),
                      ],
                    ),
                  ),

                  gapH12,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.electricTeal,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Back",
                              style: TextStyle(
                                color: AppColors.electricTeal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.electricTeal,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ServicePaymentScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  // Helper widget
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          txt: label,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.mediumGray,
        ),
        CustomText(
          txt: value,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.electricTeal,
        ),
      ],
    );
  }

  Widget _infoRow({
    required String label,
    required String value,
    Color labelColor = AppColors.mediumGray,
    Color valueColor = AppColors.darkText,
  }) {
    return Row(
      children: [
        CustomText(
          txt: "$label:",
          color: labelColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(width: 8),
        CustomText(
          txt: value,
          color: valueColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.darkText,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

const _boxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.electricTeal)),
);

//////////////

// class DeliveryDetailScreen extends StatefulWidget {
//   const DeliveryDetailScreen({super.key});

//   @override
//   State<DeliveryDetailScreen> createState() => _DeliveryDetailScreenState();
// }

// class _DeliveryDetailScreenState extends State<DeliveryDetailScreen> {
//   final TextEditingController contactnameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController pickupController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController postalController = TextEditingController();

//   final contactnameFocus = FocusNode();
//   final phoneFocus = FocusNode();
//   final pickupFocus = FocusNode();
//   final cityFocus = FocusNode();
//   final postalFocus = FocusNode();
//   final Color inactiveColor = AppColors.mediumGray;
//   @override
//   void initState() {
//     super.initState();
//     contactnameController.addListener(_checkFormFilled);
//     phoneController.addListener(_checkFormFilled);
//     pickupController.addListener(_checkFormFilled);
//     postalController.addListener(_checkFormFilled);
//   }

//   bool _isFormFilled = false;
//   void _checkFormFilled() {
//     final isFilled =
//         contactnameController.text.isNotEmpty &&
//         phoneController.text.isNotEmpty &&
//         pickupController.text.isNotEmpty &&
//         postalController.text.isNotEmpty;

//     if (isFilled != _isFormFilled) {
//       setState(() => _isFormFilled = isFilled);
//     }
//   }

//   @override
//   void dispose() {
//     contactnameFocus.dispose();
//     phoneFocus.dispose();
//     cityFocus.dispose();
//     phoneFocus.dispose();
//     //
//     contactnameController.dispose();
//     phoneController.dispose();
//     pickupController.dispose();
//     postalFocus.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.lightGrayBackground,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //appbar
//             Container(
//               padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: AppColors.electricTeal,
//                 // boxShadow: [
//                 //   BoxShadow(
//                 //     color: Colors.black26,
//                 //     blurRadius: 6,
//                 //     offset: Offset(0, 3),
//                 //   )
//                 // ],
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // --- LEFT SIDE (Close Icon) ---
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.close, color: AppColors.pureWhite),
//                     ),
//                   ),

//                   // --- CENTER TITLE ---
//                   CustomText(
//                     txt: "New Order",
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.pureWhite,
//                   ),

//                   // --- RIGHT SIDE (Step indicator) ---
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: CustomText(
//                       txt: "[2/4]",
//                       fontSize: 14,
//                       color: AppColors.pureWhite,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             //appbar end

//             // ---------- Pickup Details Heading ----------
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       // Icon(Icons.location_pin, color: Colors.red),
//                       SizedBox(width: 6),
//                       CustomText(
//                         txt: "Delivery Details",
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ],
//                   ),
//                   gapH12,
//                   CustomAnimatedTextField(
//                     controller: contactnameController,
//                     focusNode: contactnameFocus,
//                     labelText: "Contact Name",
//                     hintText: "Contact Name",
//                     prefixIcon: Icons.contact_page_outlined,
//                     iconColor: AppColors.electricTeal,
//                     borderColor: AppColors.electricTeal,
//                     textColor: AppColors.mediumGray,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       return null;
//                     },
//                   ),

//                   gapH8,

//                   CustomAnimatedTextField(
//                     controller: phoneController,
//                     focusNode: phoneFocus,
//                     labelText: "Phone Number",
//                     hintText: "Phone Number",
//                     prefixIcon: Icons.contact_page_outlined,
//                     iconColor: AppColors.electricTeal,
//                     borderColor: AppColors.electricTeal,
//                     textColor: AppColors.mediumGray,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       return null;
//                     },
//                   ),

//                   gapH8,

//                   CustomAnimatedTextField(
//                     controller: pickupController,
//                     focusNode: pickupFocus,
//                     labelText: "Pickup Address",
//                     hintText: "Pickup Address",
//                     prefixIcon: Icons.contact_page_outlined,
//                     iconColor: AppColors.electricTeal,
//                     borderColor: AppColors.electricTeal,
//                     textColor: AppColors.mediumGray,
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       return null;
//                     },
//                   ),
//                   gapH16,

//                   Row(
//                     children: [
//                       Icon(
//                         Icons.pin_drop_outlined,
//                         color: AppColors.electricTeal,
//                       ),
//                       SizedBox(width: 6),
//                       CustomText(
//                         txt: "Use Current Location",
//                         color: AppColors.darkText,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ],
//                   ),
//                   gapH12,
//                   // ---------- City ----------
//                   CustomAnimatedTextField(
//                     controller: cityController,
//                     focusNode: cityFocus,
//                     labelText: "City",
//                     hintText: "City",
//                     prefixIcon: Icons.calendar_today_outlined,
//                     iconColor: AppColors.electricTeal,
//                     borderColor: AppColors.electricTeal,
//                     textColor: Colors.black87,
//                     keyboardType: TextInputType.datetime,
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.keyboard_arrow_down_rounded),
//                       color: AppColors.electricTeal,
//                       onPressed: () {},
//                     ),
//                   ),

//                   gapH8,

//                   // ---------- Postal Code ----------
//                   CustomAnimatedTextField(
//                     controller: postalController,
//                     focusNode: postalFocus,
//                     labelText: "Postal Code (Optional)",
//                     hintText: "Postal Code (Optional)",
//                     prefixIcon: Icons.contact_page_outlined,
//                     iconColor: AppColors.electricTeal,
//                     borderColor: AppColors.electricTeal,
//                     textColor: AppColors.mediumGray,
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       return null;
//                     },
//                   ),

//                   gapH20,

//                   // ---------- Continue Button ----------
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: CustomButton(
//                       isChecked: _isFormFilled,
//                       text: "Continue",
//                       backgroundColor: _isFormFilled
//                           ? AppColors.electricTeal
//                           : inactiveColor,
//                       borderColor: AppColors.electricTeal,
//                       textColor: AppColors.lightGrayBackground,
//                       onPressed: _isFormFilled
//                           ? () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => const PackageDetailScreen(),
//                                 ),
//                               );
//                             }
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
