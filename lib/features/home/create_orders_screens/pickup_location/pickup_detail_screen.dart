import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/pickup_controller.dart';

class PickupDeliveryScreen extends ConsumerStatefulWidget {
  const PickupDeliveryScreen({super.key});

  @override
  ConsumerState<PickupDeliveryScreen> createState() =>
      _PickupDeliveryScreenState();
}

class _PickupDeliveryScreenState extends ConsumerState<PickupDeliveryScreen> {
  String editorMode = ""; // "", "edit", "add"
  bool showEditor = false;
  String mode = ""; // "edit" or "add"

  int selectedCardIndex = 0;
  String selectedAddress = "";

  // String selectedAddress = "House 123, Street 5\nDHA Phase 6, Karachi";

  final TextEditingController contactnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final editlocationFocus = FocusNode();
  final phoneFocus = FocusNode();
  final locationFocus = FocusNode();
  final contactnameFocus = FocusNode();

  final Color inactiveColor = AppColors.mediumGray;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(defaultAddressControllerProvider.notifier).loadDefaultAddress();
      ref.read(allAddressControllerProvider.notifier).loadAllAddress();
    });

    contactnameController.addListener(_checkFormFilled);
    phoneController.addListener(_checkFormFilled);
    address1Controller.addListener(_checkFormFilled);
    address2Controller.addListener(_checkFormFilled);
    cityController.addListener(_checkFormFilled);
    stateController.addListener(_checkFormFilled);
    postalController.addListener(_checkFormFilled);

    locationController.addListener(_checkFormFilled);
  }

  bool _isFormFilled = false;
  void _checkFormFilled() {
    final isFilled =
        contactnameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        address1Controller.text.isNotEmpty &&
        address2Controller.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        postalController.text.isNotEmpty &&
        locationController.text.isNotEmpty;

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
    phoneController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalController.dispose();

    locationController.dispose();
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

                  // const SizedBox(height: 4),
                  // _linkText("Add New Address", Icons.add, onTap: () {}),
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
                        
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: contactnameController,
                    label: "Name",
                    icon: Icons.person,
                  ),
                ),
                gapW4,

                Expanded(
                  child: _buildTextField(
                    controller: phoneController,
                    label: "Phone Number",
                    icon: Icons.phone_android,
                    isNumber: true, //  ONLY NUMBER
                  ),
                ),
              ],
            ),

            gapH8,

            _buildTextField(
              controller: address1Controller,
              label: "Address Line 1",
              icon: Icons.location_on,
            ),
            gapH8,

            _buildTextField(
              controller: address2Controller,
              label: "Address Line 2",
              icon: Icons.location_city,
            ),
            gapH8,

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: cityController,
                    label: "City",
                    icon: Icons.location_city_outlined,
                  ),
                ),
                gapW4,
                Expanded(
                  child: _buildTextField(
                    controller: stateController,
                    label: "State/Province",
                    icon: Icons.map_outlined,
                  ),
                ),
              ],
            ),

            gapH8,

            _buildTextField(
              controller: postalController,
              label: "Postal Code",
              icon: Icons.numbers,
              isNumber: true, //  ONLY NUMBER
            ),
          
                        // CustomAnimatedTextField(
                        //   controller: locationController,
                        //   focusNode: locationFocus,
                        //   labelText: "Location",
                        //   hintText: "Location",
                        //   prefixIcon: Icons.pin_drop,
                        //   iconColor: AppColors.electricTeal,
                        //   borderColor: AppColors.electricTeal,
                        //   textColor: AppColors.mediumGray,
                        //   keyboardType: TextInputType.emailAddress,
                        //   validator: (value) {
                        //     return null;
                        //   },
                        // ),

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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultAddressSection() {
    final defaultAddressState = ref.watch(defaultAddressControllerProvider);

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
          // ---------------- HEADER ----------------
          Row(
            children: [
              Text(
                "Default Address",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Spacer(),

              // EDIT BUTTON
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (editorMode == "edit" && showEditor) {
                      showEditor = false; // CLOSE
                    } else {
                      editorMode = "edit";
                      showEditor = true;
                      ref
                          .read(allAddressControllerProvider.notifier)
                          .loadAllAddress();
                    }
                  });
                },
                child: _smallButton("Edit", showEditor && editorMode == "edit"),
              ),

              SizedBox(width: 8),

              // ADD BUTTON
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (editorMode == "add" && showEditor) {
                      showEditor = false; // CLOSE
                    } else {
                      editorMode = "add";
                      showEditor = true;
                    }
                  });
                },
                child: _smallButton("Add", showEditor && editorMode == "add"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // -------------------------------------------------------
          // DEFAULT ADDRESS — only when editor OFF
          // -------------------------------------------------------
          if (!showEditor)
            defaultAddressState.when(
              loading: () =>
                  _selectableCard(index: 0, text: "Loading address..."),

              error: (err, _) =>
                  _selectableCard(index: 0, text: "Failed to load address"),

              data: (addressModel) {
                final address = addressModel.data;

                final formatted =
                    "${address.address},\n${address.city}, ${address.state}\n${address.postalCode}";

                if (selectedAddress.isEmpty) {
                  selectedAddress = formatted;
                }

                return _selectableCard(index: 0, text: selectedAddress);
              },
            ),

          // -------------------------------------------------------
          // EDIT MODE (all addresses)
          // -------------------------------------------------------
          if (showEditor && editorMode == "edit") ...[
            SizedBox(height: 12),

            Consumer(
              builder: (context, ref, _) {
                final allAddressState = ref.watch(allAddressControllerProvider);

                return allAddressState.when(
                  loading: () => _selectableCard(
                    index: 999,
                    text: "Loading saved addresses...",
                  ),

                  error: (err, _) => _selectableCard(
                    index: 999,
                    text: "Failed to load addresses",
                  ),

                  data: (model) {
                    final list = model?.data ?? [];

                    return Column(
                      children: List.generate(list.length, (i) {
                        final a = list[i];
                        final formatted =
                            "${a.address} - ${a.addressLine2}\n${a.city}, ${a.state}\n${a.postalCode}";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _selectableCard(index: i + 1, text: formatted),
                        );
                      }),
                    );
                  },
                );
              },
            ),
          ],

          // -------------------------------------------------------
          // ADD MODE — fields
          // -------------------------------------------------------
          if (showEditor && editorMode == "add") ...[
            gapH12,

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: contactnameController,
                    label: "Name",
                    icon: Icons.person,
                  ),
                ),
                gapW4,

                Expanded(
                  child: _buildTextField(
                    controller: phoneController,
                    label: "Phone Number",
                    icon: Icons.phone_android,
                    isNumber: true, //  ONLY NUMBER
                  ),
                ),
              ],
            ),

            gapH8,

            _buildTextField(
              controller: address1Controller,
              label: "Address Line 1",
              icon: Icons.location_on,
            ),
            gapH8,

            _buildTextField(
              controller: address2Controller,
              label: "Address Line 2",
              icon: Icons.location_city,
            ),
            gapH8,

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: cityController,
                    label: "City",
                    icon: Icons.location_city_outlined,
                  ),
                ),
                gapW4,
                Expanded(
                  child: _buildTextField(
                    controller: stateController,
                    label: "State/Province",
                    icon: Icons.map_outlined,
                  ),
                ),
              ],
            ),

            gapH8,

            _buildTextField(
              controller: postalController,
              label: "Postal Code",
              icon: Icons.numbers,
              isNumber: true, //  ONLY NUMBER
            ),
          
          ],
        ],
      ),
    );
  }

  /// SMALL BUTTON WIDGET
  Widget _smallButton(String text, bool isOpen) {
    IconData icon;

    if (isOpen) {
      icon = Icons.close;
    } else {
      icon = (text == "Add") ? Icons.add : Icons.edit;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.electricTeal,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  /// TEXTFIELD SHORTCUT
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return CustomAnimatedTextField(
      controller: controller,
      focusNode: FocusNode(),
      labelText: label,
      hintText: label,
      prefixIcon: icon,
      iconColor: AppColors.electricTeal,
      borderColor: AppColors.electricTeal,
      textColor: AppColors.mediumGray,

      keyboardType: isNumber ? TextInputType.number : TextInputType.text,

      //  ALWAYS provide a list (never null)
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : <TextInputFormatter>[],
    );
  }

  // SELECTABLE CARD (DEFAULT + EXTRA)
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
            color: isSelected ? AppColors.electricTeal : AppColors.electricTeal,
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
