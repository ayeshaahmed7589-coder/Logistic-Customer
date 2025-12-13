// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/pickup_controller.dart';

import 'package:flutter/services.dart';

class PickupDeliveryScreen extends ConsumerStatefulWidget {
  const PickupDeliveryScreen({super.key});

  @override
  ConsumerState<PickupDeliveryScreen> createState() =>
      _PickupDeliveryScreenState();
}

class _PickupDeliveryScreenState extends ConsumerState<PickupDeliveryScreen> {
  String? selectedCountry;
  String? countryError; // Error message ke liye

  List<String> staticCountries = ["Pakistan", "India", "USA", "UK", "UAE"];

  void _validateFields() {
    // Country validation
    if (selectedCountry == null || selectedCountry!.isEmpty) {
      countryError = "Please select a country";
    } else {
      countryError = null;
    }
  }

  late FlutterGooglePlacesSdk places;

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

  final TextEditingController contactnameDeliveryController =
      TextEditingController();
  final TextEditingController phoneDeliveryController = TextEditingController();
  final TextEditingController address1DeliveryController =
      TextEditingController();
  final TextEditingController address2DeliveryController =
      TextEditingController();
  final TextEditingController cityDeliveryController = TextEditingController();
  final TextEditingController stateDeliveryController = TextEditingController();
  final TextEditingController postalDeliveryController =
      TextEditingController();

  final editlocationFocus = FocusNode();
  final phoneFocus = FocusNode();
  final locationFocus = FocusNode();
  final contactnameFocus = FocusNode();

  final Color inactiveColor = AppColors.mediumGray;
  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();

    places = FlutterGooglePlacesSdk("AIzaSyBrF_4PwauOkQ_RS8iGYhAW1NIApp3IEf0");

    setupPickupListener();
    setupDeliveryListener();

    // --------------------
    // 1. LOAD CACHED DATA
    // --------------------
    Future.microtask(() {
      ref.read(defaultAddressControllerProvider.notifier).loadDefaultAddress();
      ref.read(allAddressControllerProvider.notifier).loadAllAddress();
      final cache = ref.read(orderCacheProvider);
      selectedAddress = cache["default_selected_address"] ?? "";

      // Pickup
      contactnameController.text = cache["pickup_name"] ?? "";
      phoneController.text = cache["pickup_phone"] ?? "";
      address1Controller.text = cache["pickup_address1"] ?? "";
      address2Controller.text = cache["pickup_address2"] ?? "";
      cityController.text = cache["pickup_city"] ?? "";
      stateController.text = cache["pickup_state"] ?? "";
      postalController.text = cache["pickup_postal"] ?? "";

      // Delivery
      contactnameDeliveryController.text = cache["delivery_name"] ?? "";
      phoneDeliveryController.text = cache["delivery_phone"] ?? "";
      address1DeliveryController.text = cache["delivery_address1"] ?? "";
      address2DeliveryController.text = cache["delivery_address2"] ?? "";
      cityDeliveryController.text = cache["delivery_city"] ?? "";
      stateDeliveryController.text = cache["delivery_state"] ?? "";
      postalDeliveryController.text = cache["delivery_postal"] ?? "";
    });

    // ----------------------------
    // 2. LISTENERS FOR CACHING
    // ----------------------------
    _addCacheListeners();
  }

  void setupPickupListener() {
    address1Controller.addListener(() async {
      final input = address1Controller.text.trim();

      if (input.length < 3) return;

      print("🎯 Pickup Address Line 1 changed: $input");

      try {
        // Step 1: Get autocomplete predictions
        final predictions = await places.findAutocompletePredictions(
          input,
          countries: ["ZA"],
        );

        if (predictions.predictions.isEmpty) {
          print("⚠️ No predictions found for pickup");
          return;
        }

        print("📊 Found ${predictions.predictions.length} pickup predictions");

        // Step 2: Show all predictions
        for (var i = 0; i < predictions.predictions.length; i++) {
          final pred = predictions.predictions[i];
          // ignore: dead_code
          print("${i + 1}. ${pred.fullText} (ID: ${pred.placeId})");
        }

        // Step 3: Use first prediction
        final placeId = predictions.predictions.first.placeId;
        print("🔍 Selected Pickup Place ID: $placeId");

        // Step 4: Fetch place details - Version 0.4.2+1 mein WITHOUT fields parameter
        final placeDetails = await places.fetchPlace(placeId, fields: []);

        // Step 5: DEBUG - Print full response
        print("📋 Complete Pickup Place Response:");
        if (placeDetails.place != null) {
          final placeJson = placeDetails.place!.toJson();
          placeJson.forEach((key, value) {
            print("  $key: $value");
          });
        }

        // Step 6: Extract coordinates
        double? lat;
        double? lng;

        // Try different possible locations
        if (placeDetails.place?.latLng != null) {
          lat = placeDetails.place!.latLng!.lat;
          lng = placeDetails.place!.latLng!.lng;
          print("✅ Got from latLng: $lat, $lng");
        }

        // If coordinates not found, use test coordinates for now
        if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
          print("❌ Could not extract valid coordinates from Google Places");
          _setPickupTestCoordinates(input);
          return;
        }

        // Save to cache
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("pickup_latitude", lat.toString());
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("pickup_longitude", lng.toString());

        print("✅ Pickup coordinates saved to cache: $lat, $lng");
      } catch (e) {
        print("⛔ Error in setupPickupListener: $e");
        _setPickupTestCoordinates(input);
      }
    });
  }

  void setupDeliveryListener() {
    address1DeliveryController.addListener(() async {
      final input = address1DeliveryController.text.trim();

      if (input.length < 3) return;

      print("🎯 Delivery Address Line 1 changed: $input");

      try {
        final predictions = await places.findAutocompletePredictions(
          input,
          countries: ["ZA"],
        );

        if (predictions.predictions.isEmpty) {
          print("⚠️ No predictions found for delivery");
          return;
        }

        print(
          "📊 Found ${predictions.predictions.length} delivery predictions",
        );

        final placeId = predictions.predictions.first.placeId;
        print("🔍 Selected Delivery Place ID: $placeId");

        // Fetch place details
        final placeDetails = await places.fetchPlace(placeId, fields: []);

        // Extract coordinates
        double? lat;
        double? lng;

        if (placeDetails.place?.latLng != null) {
          lat = placeDetails.place!.latLng!.lat;
          lng = placeDetails.place!.latLng!.lng;
          print("✅ Delivery got from latLng: $lat, $lng");
        }

        // If coordinates not found, use test coordinates
        if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
          print("❌ Could not extract delivery coordinates");
          _setDeliveryTestCoordinates(input);
          return;
        }

        // Save to cache
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("delivery_latitude", lat.toString());
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("delivery_longitude", lng.toString());

        print("✅ Delivery coordinates saved to cache: $lat, $lng");
      } catch (e) {
        print("⛔ Error in setupDeliveryListener: $e");
        _setDeliveryTestCoordinates(input);
      }
    });
  }

  void _setPickupTestCoordinates(String address) {
    String lat, lng;

    if (address.toLowerCase().contains("cape town")) {
      lat = "-33.9249";
      lng = "18.4241";
    } else if (address.toLowerCase().contains("johannesburg") ||
        address.toLowerCase().contains("joburg")) {
      lat = "-26.2041";
      lng = "28.0473";
    } else if (address.toLowerCase().contains("durban")) {
      lat = "-29.8587";
      lng = "31.0218";
    } else if (address.toLowerCase().contains("pretoria")) {
      lat = "-25.7479";
      lng = "28.2293";
    } else {
      // Default to Cape Town coordinates
      lat = "-33.9258";
      lng = "18.4232";
    }

    ref.read(orderCacheProvider.notifier).saveValue("pickup_latitude", lat);
    ref.read(orderCacheProvider.notifier).saveValue("pickup_longitude", lng);
    print("✅ TEST: Pickup coordinates set to: $lat, $lng");
  }

  // Test coordinates for delivery
  void _setDeliveryTestCoordinates(String address) {
    String lat, lng;

    if (address.toLowerCase().contains("cape town")) {
      lat = "-33.9189";
      lng = "18.4233";
    } else if (address.toLowerCase().contains("johannesburg") ||
        address.toLowerCase().contains("joburg")) {
      lat = "-26.1952";
      lng = "28.0346";
    } else if (address.toLowerCase().contains("durban")) {
      lat = "-29.8498";
      lng = "31.0168";
    } else {
      // Slightly different from pickup for distance calculation
      lat = "-33.9318";
      lng = "18.4172";
    }

    ref.read(orderCacheProvider.notifier).saveValue("delivery_latitude", lat);
    ref.read(orderCacheProvider.notifier).saveValue("delivery_longitude", lng);
    print("✅ TEST: Delivery coordinates set to: $lat, $lng");
  }

  void _addCacheListeners() {
    // Pickup
    contactnameController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_name", contactnameController.text);
      _checkFormFilled();
    });

    phoneController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_phone", phoneController.text);
      _checkFormFilled();
    });

    address1Controller.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_address1", address1Controller.text);
      _checkFormFilled();
    });

    address2Controller.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_address2", address2Controller.text);
      _checkFormFilled();
    });

    cityController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_city", cityController.text);
      _checkFormFilled();
    });

    stateController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_state", stateController.text);
      _checkFormFilled();
    });

    postalController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_postal", postalController.text);
      _checkFormFilled();
    });

    // Delivery
    contactnameDeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_name", contactnameDeliveryController.text);
      _checkFormFilled();
    });

    phoneDeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_phone", phoneDeliveryController.text);
      _checkFormFilled();
    });

    address1DeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_address1", address1DeliveryController.text);
      _checkFormFilled();
    });

    address2DeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_address2", address2DeliveryController.text);
      _checkFormFilled();
    });

    cityDeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_city", cityDeliveryController.text);
      _checkFormFilled();
    });

    stateDeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_state", stateDeliveryController.text);
      _checkFormFilled();
    });

    postalDeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_postal", postalDeliveryController.text);
      _checkFormFilled();
    });
  }

  void _checkFormFilled() {
    final isFilled =
        contactnameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        address1Controller.text.isNotEmpty &&
        address2Controller.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        stateController.text.isNotEmpty &&
        postalController.text.isNotEmpty &&
        contactnameDeliveryController.text.isNotEmpty &&
        phoneDeliveryController.text.isNotEmpty &&
        address1DeliveryController.text.isNotEmpty &&
        address2DeliveryController.text.isNotEmpty &&
        cityDeliveryController.text.isNotEmpty &&
        stateDeliveryController.text.isNotEmpty &&
        postalDeliveryController.text.isNotEmpty;

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

    contactnameController.dispose();
    phoneController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalController.dispose();

    contactnameDeliveryController.dispose();
    phoneDeliveryController.dispose();
    address1DeliveryController.dispose();
    address2DeliveryController.dispose();
    cityDeliveryController.dispose();
    stateDeliveryController.dispose();
    postalDeliveryController.dispose();

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
                  // _sectionTitle(""),
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
                              txt: "Product & Packaging Information",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        gapH16,

                        // Dropdown widget
                        DropDownContainer(
                          fw: FontWeight.normal,
                          dialogueScreen: MaterialConditionPopupLeftIcon(
                            title: '',
                            conditions: staticCountries,
                            initialSelectedIndex: selectedCountry != null
                                ? staticCountries.indexOf(selectedCountry!)
                                : null,
                          ),
                          text: selectedCountry ?? "Product Type",
                          onItemSelected: (value) {
                            setState(() {
                              selectedCountry = value;
                              _validateFields();
                            });
                          },
                        ),

                        gapH8,
                        DropDownContainer(
                          fw: FontWeight.normal,
                          dialogueScreen: MaterialConditionPopupLeftIcon(
                            title: '',
                            conditions: staticCountries,
                            initialSelectedIndex: selectedCountry != null
                                ? staticCountries.indexOf(selectedCountry!)
                                : null,
                          ),
                          text: selectedCountry ?? "Package Type",
                          onItemSelected: (value) {
                            setState(() {
                              selectedCountry = value;
                              _validateFields();
                            });
                          },
                        ),

                        gapH8,

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: address1DeliveryController,
                                label: "Total Weight (kg)",
                                icon: Icons.location_on,
                              ),
                            ),

                            gapW8,
                            Expanded(
                              child: _buildTextField(
                                controller: address2DeliveryController,
                                label: "Quantity",
                                icon: Icons.location_city,
                              ),
                            ),
                          ],
                        ),

                        gapH8,

                        _buildTextField(
                          controller: cityDeliveryController,
                          label: "Declared Value (R)",
                          icon: Icons.location_city_outlined,
                        ),
                      ],
                    ),
                  ),

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
                                controller: contactnameDeliveryController,
                                label: "Name",
                                icon: Icons.person,
                              ),
                            ),
                            gapW4,

                            Expanded(
                              child: _buildTextField(
                                controller: phoneDeliveryController,
                                label: "Phone Number",
                                icon: Icons.phone_android,
                                isNumber: true, //  ONLY NUMBER
                              ),
                            ),
                          ],
                        ),

                        gapH8,

                        _buildTextField(
                          controller: address1DeliveryController,
                          label: "Address Line 1",
                          icon: Icons.location_on,
                        ),
                        gapH8,

                        _buildTextField(
                          controller: address2DeliveryController,
                          label: "Address Line 2",
                          icon: Icons.location_city,
                        ),
                        gapH8,

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: cityDeliveryController,
                                label: "City",
                                icon: Icons.location_city_outlined,
                              ),
                            ),
                            gapW4,
                            Expanded(
                              child: _buildTextField(
                                controller: stateDeliveryController,
                                label: "State/Province",
                                icon: Icons.map_outlined,
                              ),
                            ),
                          ],
                        ),

                        gapH8,

                        _buildTextField(
                          controller: postalDeliveryController,
                          label: "Postal Code",
                          icon: Icons.numbers,
                          isNumber: true, //  ONLY NUMBER
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
                  final cache = ref.read(orderCacheProvider);
                  selectedAddress =
                      cache["default_selected_address"] ?? formatted;
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
          selectedAddress = text;
          showEditor = false;
        });

        // SAVE SELECTED DEFAULT ADDRESS
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("default_selected_address", text);
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
