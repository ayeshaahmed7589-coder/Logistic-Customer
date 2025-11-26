import 'package:flutter/material.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/delivery_detail_screen.dart';

class PickupDeliveryScreen extends StatefulWidget {
  const PickupDeliveryScreen({super.key});

  @override
  State<PickupDeliveryScreen> createState() => _PickupDeliveryScreenState();
}

class _PickupDeliveryScreenState extends State<PickupDeliveryScreen> {
  final TextEditingController contactnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final contactnameFocus = FocusNode();
  final phoneFocus = FocusNode();

  final Color inactiveColor = AppColors.mediumGray;
  @override
  void initState() {
    super.initState();
    contactnameController.addListener(_checkFormFilled);
    phoneController.addListener(_checkFormFilled);
  }

  bool _isFormFilled = false;
  void _checkFormFilled() {
    final isFilled =
        contactnameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;

    if (isFilled != _isFormFilled) {
      setState(() => _isFormFilled = isFilled);
    }
  }

  @override
  void dispose() {
    contactnameFocus.dispose();
    phoneFocus.dispose();
    phoneFocus.dispose();
    //
    contactnameController.dispose();
    phoneController.dispose();
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
                      txt: "[1/3]",
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
                  _sectionTitle("PICKUP LOCATION"),
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
                              txt: "Default Address",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.electricTeal,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.mediumGray.withValues(
                                      alpha: 0.10,
                                    ),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      txt: "Edit Location",
                                      fontSize: 15,
                                      color: AppColors.pureWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: _boxStyle,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Icon(
                                Icons.home,
                                size: 20,
                                color: AppColors.electricTeal,
                              ),
                              SizedBox(width: 12),
                              CustomText(
                                txt:
                                    "House 123, Street 5\nDHA Phase 6, Karachi",
                                color: AppColors.darkText,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Defult address end
                  const SizedBox(height: 10),
                  _linkText(
                    "Use Current Location",
                    Icons.pin_drop_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(height: 4),
                  _linkText("Add New Address", Icons.add, onTap: () {}),

                  gapH20,
                  _sectionTitle("DELIVERY LOCATION"),

                  const SizedBox(height: 10),

                  // delivery address
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
                              txt: "Office Building",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.electricTeal,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.mediumGray.withValues(
                                      alpha: 0.10,
                                    ),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                      txt: "Edit Location",
                                      fontSize: 15,
                                      color: AppColors.pureWhite,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        gapH8,
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: _boxStyle,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: 20,
                                    color: AppColors.electricTeal,
                                  ),
                                  SizedBox(width: 12),
                                  CustomText(
                                    txt:
                                        "House 123, Street 5\nDHA Phase 6, Karachi",
                                    color: AppColors.darkText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              gapH4,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: AppColors.electricTeal,
                                  ),
                                  CustomText(
                                    txt: "Search on Map",
                                    color: AppColors.electricTeal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // delivery address end
                  const SizedBox(height: 30),

                  // ---------- Pickup Details Heading ----------
                  Column(
                    children: [
                      Row(
                        children: [
                          // Icon(Icons.location_pin, color: Colors.red),
                          SizedBox(width: 6),
                          CustomText(
                            txt: "Contact Information",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      gapH16,
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
                    ],
                  ),

                  // ---------- Continue Button ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomButton(
                      text: "Continue",
                      backgroundColor: AppColors.electricTeal,
                      borderColor: AppColors.electricTeal,
                      textColor: AppColors.lightGrayBackground,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PackageDetailsScreen(),
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

  Widget _sectionTitle(String title) {
    return CustomText(
      txt: title,
      color: AppColors.darkText,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _linkText(String text, IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.electricTeal),
          const SizedBox(width: 6),
          CustomText(
            txt: text,
            color: AppColors.darkText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

const _boxStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(12)),
  border: Border.fromBorderSide(BorderSide(color: AppColors.electricTeal)),
);

///////////////

// class PickupDetailScreen extends StatefulWidget {
//   const PickupDetailScreen({super.key});

//   @override
//   State<PickupDetailScreen> createState() => _PickupDetailScreenState();
// }

// class _PickupDetailScreenState extends State<PickupDetailScreen> {
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
//                       txt: "[1/4]",
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
//                         txt: "Pickup Details",
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
//                                   builder: (_) => DeliveryDetailScreen(),
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
