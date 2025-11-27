import 'package:flutter/material.dart';

import 'package:logisticscustomer/export.dart';

class PickupDeliveryScreen extends StatefulWidget {
  const PickupDeliveryScreen({super.key});

  @override
  State<PickupDeliveryScreen> createState() => _PickupDeliveryScreenState();
}

class _PickupDeliveryScreenState extends State<PickupDeliveryScreen> {
  bool showEditor = false;

  int selectedCardIndex = 0;

  String selectedAddress = "House 123, Street 5\nDHA Phase 6, Karachi";

  final TextEditingController editlocationController = TextEditingController();
  final TextEditingController contactnameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final editlocationFocus = FocusNode();
  final locationFocus = FocusNode();
  final contactnameFocus = FocusNode();
  final phoneFocus = FocusNode();

  final Color inactiveColor = AppColors.mediumGray;
  @override
  void initState() {
    super.initState();
    contactnameController.addListener(_checkFormFilled);
    editlocationController.addListener(_checkFormFilled);
    locationController.addListener(_checkFormFilled);
    phoneController.addListener(_checkFormFilled);
  }

  bool _isFormFilled = false;
  void _checkFormFilled() {
    final isFilled =
        editlocationController.text.isNotEmpty &&
        contactnameController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;

    if (isFilled != _isFormFilled) {
      setState(() => _isFormFilled = isFilled);
    }
  }

  @override
  void dispose() {
    editlocationFocus.dispose();
    contactnameFocus.dispose();
    locationFocus.dispose();
    phoneFocus.dispose();
    phoneFocus.dispose();
    contactnameController.dispose();
    editlocationController.dispose();
    locationController.dispose();
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("PICKUP LOCATION"),
                  const SizedBox(height: 10),

                  // Default Address
                  _defaultAddressSection(),
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
                    padding: const EdgeInsets.only(
                      top: 16,
                      right: 16,
                      left: 16,
                    ),
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

                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: AppColors.electricTeal,
                            //     borderRadius: BorderRadius.circular(8),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: AppColors.mediumGray.withValues(
                            //           alpha: 0.10,
                            //         ),
                            //         blurRadius: 4,
                            //         offset: Offset(0, 2),
                            //       ),
                            //     ],
                            //   ),
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 8,
                            //     vertical: 4,
                            //   ),
                            //   child: GestureDetector(
                            //     onTap: () {},
                            //     child: Row(
                            //       mainAxisSize: MainAxisSize.min,
                            //       children: [
                            //         CustomText(
                            //           txt: "Edit Location",
                            //           fontSize: 15,
                            //           color: AppColors.pureWhite,
                            //           fontWeight: FontWeight.bold,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        gapH16,
                        CustomAnimatedTextField(
                          controller: locationController,
                          focusNode: locationFocus,
                          labelText: "Location",
                          hintText: "Location",
                          prefixIcon: Icons.pin_drop,
                          iconColor: AppColors.electricTeal,
                          borderColor: AppColors.electricTeal,
                          textColor: AppColors.mediumGray,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            return null;
                          },
                        ),

                        // Container(
                        //   padding: const EdgeInsets.all(16),
                        //   decoration: _boxStyle,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Icon(
                        //             Icons.home,
                        //             size: 20,
                        //             color: AppColors.electricTeal,
                        //           ),
                        //           SizedBox(width: 12),
                        //           CustomText(
                        //             txt:
                        //                 "House 123, Street 5\nDHA Phase 6, Karachi",
                        //             color: AppColors.darkText,
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ],
                        //       ),
                        //       gapH4,
                        //       Row(
                        //         mainAxisAlignment: MainAxisAlignment.end,
                        //         children: [
                        //           Icon(
                        //             Icons.location_on_outlined,
                        //             size: 16,
                        //             color: AppColors.electricTeal,
                        //           ),
                        //           CustomText(
                        //             txt: "Search on Map",
                        //             color: AppColors.electricTeal,
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 14,
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  // delivery address end
                  gapH16,

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAddressSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.mediumGray.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================================================
          // HEADER + EDIT BUTTON
          // ===================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Default Address",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    showEditor = !showEditor;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.electricTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        showEditor ? Icons.close : Icons.add,
                        size: 18,
                        color: AppColors.pureWhite,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Edit Location",
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ===================================================
          // TEXT FIELD + OR (only when editing)
          // ===================================================
          if (showEditor) ...[
            CustomAnimatedTextField(
              controller: editlocationController,
              focusNode: editlocationFocus,
              labelText: "Add new location",
              hintText: "Add new location",
              prefixIcon: Icons.location_on_outlined,
              iconColor: AppColors.electricTeal,
              borderColor: AppColors.electricTeal,
              textColor: AppColors.mediumGray,
              keyboardType: TextInputType.text,
              validator: (value) => null,
            ),

            Center(
              child: Text(
                "OR",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 12),
          ],

          // ===================================================
          // ALWAYS VISIBLE — DEFAULT (SELECTED CARD)
          // ===================================================
          _selectableCard(index: selectedCardIndex, text: selectedAddress),

          // ===================================================
          // EXTRA CARDS — ONLY WHEN EDIT EDITOR OPEN
          // ===================================================
          if (showEditor) ...[
            SizedBox(height: 12),

            _selectableCard(
              index: 1,
              text: "House 200, Street 8\nKarachi, Sindh",
            ),

            SizedBox(height: 12),

            _selectableCard(
              index: 2,
              text: "Flat 12, Block C\nNorth Nazimabad, Karachi",
            ),
          ],
        ],
      ),
    );
  }

  // =====================================================
  // SELECTABLE CARD (DEFAULT + EXTRA)
  // =====================================================
  Widget _selectableCard({required int index, required String text}) {
    bool isSelected = selectedCardIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
          selectedAddress = text; // yeh card upar default ban jayega
          showEditor = false; // editor close
        });
      },

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.electricTeal : AppColors.mediumGray,
            width: isSelected ? 2 : 1,
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.home, size: 20, color: AppColors.electricTeal),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
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
