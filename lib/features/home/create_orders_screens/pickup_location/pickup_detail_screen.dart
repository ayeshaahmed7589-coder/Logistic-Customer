// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_modal.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/pickup_controller.dart';

class Step1Screen extends ConsumerStatefulWidget {
  const Step1Screen({super.key});

  @override
  ConsumerState<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends ConsumerState<Step1Screen> {
  String? selectedCountry;
  String? countryError;

  // New Product Type Variables
  String? selectedProductType;
  String? selectedProductTypeName;
  int? selectedProductTypeId;
  String? productTypeError;

  String? selectedPackageType;
  String? packageTypeError;
  // Packaging Type Variables
  String? selectedPackagingTypeName;
  int? selectedPackagingTypeId;
  String? packagingTypeError;

  List<String> staticCountries = ["Pakistan", "India", "USA", "UK", "UAE"];
  List<String> packageTypes = [
    "Box",
    "Envelope",
    "Tube",
    "Pallet",
    "Crate",
    "Bag",
    "Roll",
    "Other",
  ];

  // Text Controllers for product info
  final TextEditingController weightController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController declaredValueController = TextEditingController();
  // Dimensions variables
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  void _validateFields() {
    // Product Type validation
    if (selectedProductTypeId == null) {
      productTypeError = "Please select a product type";
    } else {
      productTypeError = null;
    }

    // Packaging Type validation (changed from Package Type)
    if (selectedPackagingTypeId == null) {
      packagingTypeError = "Please select a packaging type";
    } else {
      packagingTypeError = null;
    }

    // Country validation
    if (selectedCountry == null || selectedCountry!.isEmpty) {
      countryError = "Please select a country";
    } else {
      countryError = null;
    }
  }

  late FlutterGooglePlacesSdk places;

  String editorMode = "";
  bool showEditor = false;
  int selectedCardIndex = 0;
  String selectedAddress = "";

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

  final FocusNode editlocationFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode locationFocus = FocusNode();
  final FocusNode contactnameFocus = FocusNode();

  bool _isFormFilled = false;
  bool showDimensionsFields = false; // Added this

  @override
  void initState() {
    super.initState();

    places = FlutterGooglePlacesSdk("AIzaSyBrF_4PwauOkQ_RS8iGYhAW1NIApp3IEf0");

    setupPickupListener();
    setupDeliveryListener();

    // LOAD CACHED DATA
    Future.microtask(() {
      final cache = ref.read(
        orderCacheProvider,
      ); // Moved this to top - FIXED ISSUE 1
      selectedAddress = cache["default_selected_address"] ?? "";

      // Load dimensions from cache
      final savedLength = cache["package_length"];
      final savedWidth = cache["package_width"];
      final savedHeight = cache["package_height"];
      if (savedLength != null) lengthController.text = savedLength;
      if (savedWidth != null) widthController.text = savedWidth;
      if (savedHeight != null) heightController.text = savedHeight;

      ref.read(defaultAddressControllerProvider.notifier).loadDefaultAddress();
      ref.read(allAddressControllerProvider.notifier).loadAllAddress();
      ref.read(productTypeControllerProvider.notifier).loadProductTypes();
      ref.read(packagingTypeControllerProvider.notifier).loadPackagingTypes();

      // Load product type from cache
      final savedProductTypeId = cache["selected_product_type_id"];
      final savedProductTypeName = cache["selected_product_type_name"];

      if (savedProductTypeId != null) {
        setState(() {
          selectedProductTypeId = int.tryParse(savedProductTypeId);
          selectedProductTypeName = savedProductTypeName;
        });
      }

      // Load package type from cache
      final savedPackageType = cache["selected_package_type"];
      if (savedPackageType != null) {
        setState(() {
          selectedPackageType = savedPackageType;
        });
      }

      // Load packaging type from cache
      final savedPackagingTypeId = cache["selected_packaging_type_id"];
      final savedPackagingTypeName = cache["selected_packaging_type_name"];
      final savedRequiresDimensions =
          cache["selected_packaging_requires_dimensions"];

      if (savedPackagingTypeId != null) {
        setState(() {
          selectedPackagingTypeId = int.tryParse(savedPackagingTypeId);
          selectedPackagingTypeName = savedPackagingTypeName;

          // Check if dimensions should be shown - FIXED ISSUE 2
          if (savedRequiresDimensions != null) {
            showDimensionsFields = savedRequiresDimensions == "true";
          }
        });
      }

      // Load product info from cache
      final savedWeight = cache["total_weight"];
      final savedQuantity = cache["quantity"];
      final savedDeclaredValue = cache["declared_value"];

      if (savedWeight != null) weightController.text = savedWeight;
      if (savedQuantity != null) quantityController.text = savedQuantity;
      if (savedDeclaredValue != null) {
        declaredValueController.text = savedDeclaredValue;
      }

      // Load pickup info from cache
      contactnameController.text = cache["pickup_name"] ?? "";
      phoneController.text = cache["pickup_phone"] ?? "";
      address1Controller.text = cache["pickup_address1"] ?? "";
      address2Controller.text = cache["pickup_address2"] ?? "";
      cityController.text = cache["pickup_city"] ?? "";
      stateController.text = cache["pickup_state"] ?? "";
      postalController.text = cache["pickup_postal"] ?? "";

      // Load delivery info from cache
      contactnameDeliveryController.text = cache["delivery_name"] ?? "";
      phoneDeliveryController.text = cache["delivery_phone"] ?? "";
      address1DeliveryController.text = cache["delivery_address1"] ?? "";
      address2DeliveryController.text = cache["delivery_address2"] ?? "";
      cityDeliveryController.text = cache["delivery_city"] ?? "";
      stateDeliveryController.text = cache["delivery_state"] ?? "";
      postalDeliveryController.text = cache["delivery_postal"] ?? "";
    });

    _addDimensionCacheListeners();
    // LISTENERS FOR CACHING
    _addCacheListeners(); // Added this
  }

  void setupPickupListener() {
    address1Controller.addListener(() async {
      final input = address1Controller.text.trim();
      if (input.length < 3) return;

      try {
        final predictions = await places.findAutocompletePredictions(
          input,
          countries: ["ZA"],
        );

        if (predictions.predictions.isEmpty) return;

        final placeId = predictions.predictions.first.placeId;
        final placeDetails = await places.fetchPlace(placeId, fields: []);

        double? lat;
        double? lng;

        if (placeDetails.place?.latLng != null) {
          lat = placeDetails.place!.latLng!.lat;
          lng = placeDetails.place!.latLng!.lng;
        }

        if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
          _setPickupTestCoordinates(input);
          return;
        }

        ref
            .read(orderCacheProvider.notifier)
            .saveValue("pickup_latitude", lat.toString());
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("pickup_longitude", lng.toString());
      } catch (e) {
        _setPickupTestCoordinates(input);
      }
    });
  }

  void setupDeliveryListener() {
    address1DeliveryController.addListener(() async {
      final input = address1DeliveryController.text.trim();
      if (input.length < 3) return;

      try {
        final predictions = await places.findAutocompletePredictions(
          input,
          countries: ["ZA"],
        );

        if (predictions.predictions.isEmpty) return;

        final placeId = predictions.predictions.first.placeId;
        final placeDetails = await places.fetchPlace(placeId, fields: []);

        double? lat;
        double? lng;

        if (placeDetails.place?.latLng != null) {
          lat = placeDetails.place!.latLng!.lat;
          lng = placeDetails.place!.latLng!.lng;
        }

        if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
          _setDeliveryTestCoordinates(input);
          return;
        }

        ref
            .read(orderCacheProvider.notifier)
            .saveValue("delivery_latitude", lat.toString());
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("delivery_longitude", lng.toString());
      } catch (e) {
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
      lat = "-33.9258";
      lng = "18.4232";
    }

    ref.read(orderCacheProvider.notifier).saveValue("pickup_latitude", lat);
    ref.read(orderCacheProvider.notifier).saveValue("pickup_longitude", lng);
  }

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
      lat = "-33.9318";
      lng = "18.4172";
    }

    ref.read(orderCacheProvider.notifier).saveValue("delivery_latitude", lat);
    ref.read(orderCacheProvider.notifier).saveValue("delivery_longitude", lng);
  }

  void _addCacheListeners() {
    // Product info listeners
    weightController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("total_weight", weightController.text);
      _checkFormFilled();
      _calculatePriceWithWeight(weightController.text);
    });

    quantityController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("quantity", quantityController.text);
      _checkFormFilled();
    });

    declaredValueController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("declared_value", declaredValueController.text);
      _checkFormFilled();
    });

    // Pickup listeners
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

    // Delivery listeners
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
    final cache = ref.read(orderCacheProvider);
    final weight = cache["total_weight"] ?? "";
    final quantity = cache["quantity"] ?? "";
    final declaredValue = cache["declared_value"] ?? "";

    bool isFilled =
        selectedProductTypeId != null &&
        selectedPackagingTypeId != null &&
        selectedPackageType != null &&
        weight.isNotEmpty &&
        quantity.isNotEmpty &&
        declaredValue.isNotEmpty &&
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

    // Check dimensions if required
    if (showDimensionsFields) {
      isFilled =
          isFilled &&
          lengthController.text.isNotEmpty &&
          widthController.text.isNotEmpty &&
          heightController.text.isNotEmpty;
    }

    if (isFilled != _isFormFilled) {
      setState(() => _isFormFilled = isFilled);
    }
  }

  void _calculatePrice(double valueMultiplier) {
    final cache = ref.read(orderCacheProvider);
    final weightStr = cache["total_weight"];
    final weight = double.tryParse(weightStr ?? "0") ?? 0;

    if (weight > 0) {
      _calculatePriceWithWeight(weight.toString(), valueMultiplier);
    }
  }

  void _calculatePriceWithWeight(String weightStr, [double? multiplier]) {
    final weight = double.tryParse(weightStr) ?? 0;
    if (weight <= 0) return;

    double valueMultiplier = multiplier ?? 1.0;

    if (multiplier == null) {
      final cache = ref.read(orderCacheProvider);
      final savedMultiplier = cache["selected_product_value_multiplier"];
      valueMultiplier = double.tryParse(savedMultiplier ?? "1.0") ?? 1.0;
    }

    double baseRatePerKg = 50.0;
    double calculatedPrice = weight * baseRatePerKg * valueMultiplier;

    ref
        .read(orderCacheProvider.notifier)
        .saveValue("calculated_price", calculatedPrice.toStringAsFixed(2));
  }

  @override
  void dispose() {
    editlocationFocus.dispose();
    contactnameFocus.dispose();
    locationFocus.dispose();
    phoneFocus.dispose();

    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();

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

    weightController.dispose();
    quantityController.dispose();
    declaredValueController.dispose();

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
                  Container(
                    height: 380,
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
                          color: AppColors.mediumGray.withOpacity(0.10),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
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

                        // PRODUCT TYPE DROPDOWN
                        Consumer(
                          builder: (context, ref, child) {
                            final productTypeState = ref.watch(
                              productTypeControllerProvider,
                            );

                            return productTypeState.when(
                              data: (data) {
                                // ✅ CORRECT: Use getAllItems()
                                final productItems = data.getAllItems();

                                int? selectedIndex;
                                if (selectedProductTypeId != null) {
                                  selectedIndex = productItems.indexWhere(
                                    (item) => item.id == selectedProductTypeId,
                                  );
                                  if (selectedIndex < 0) selectedIndex = 0;
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropDownContainer(
                                      fw: FontWeight.normal,
                                      dialogueScreen:
                                          MaterialConditionPopupLeftIcon(
                                            title: productItems.isNotEmpty
                                                ? productItems[selectedIndex ??
                                                          0]
                                                      .name
                                                : '',
                                            conditions: productItems
                                                .map((e) => e.name)
                                                .toList(),
                                            initialSelectedIndex: selectedIndex,
                                            enableSearch: true,
                                          ),
                                      text:
                                          selectedProductTypeId != null &&
                                              productItems.isNotEmpty
                                          ? productItems
                                                .firstWhere(
                                                  (item) =>
                                                      item.id ==
                                                      selectedProductTypeId,
                                                  orElse: () =>
                                                      productItems.first,
                                                )
                                                .name
                                          : 'Select Product Type',
                                      onItemSelected: (value) {
                                        final selectedItem = productItems
                                            .firstWhere(
                                              (element) =>
                                                  element.name == value,
                                            );

                                        setState(() {
                                          selectedProductTypeId =
                                              selectedItem.id;
                                          selectedProductTypeName =
                                              selectedItem.name;
                                          productTypeError = null;
                                        });

                                        ref
                                            .read(orderCacheProvider.notifier)
                                            .saveValue(
                                              "selected_product_type_id",
                                              selectedItem.id.toString(),
                                            );
                                        ref
                                            .read(orderCacheProvider.notifier)
                                            .saveValue(
                                              "selected_product_type_name",
                                              selectedItem.name,
                                            );
                                        ref
                                            .read(orderCacheProvider.notifier)
                                            .saveValue(
                                              "selected_product_value_multiplier",
                                              selectedItem.valueMultiplier
                                                  .toString(),
                                            );

                                        _validateFields();
                                        _calculatePrice(
                                          selectedItem.valueMultiplier,
                                        );
                                      },
                                    ),
                                    if (productTypeError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 4,
                                        ),
                                        child: Text(
                                          productTypeError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                              loading: () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.lightBorder,
                                      ),
                                      color: AppColors.pureWhite,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Loading product types...',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              error: (error, stackTrace) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red),
                                      color: AppColors.pureWhite,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Error loading product types',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        ref
                                            .read(
                                              productTypeControllerProvider
                                                  .notifier,
                                            )
                                            .loadProductTypes();
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        gapH8,

                        // PACKAGE TYPE DROPDOWN
                        Consumer(
                          builder: (context, ref, child) {
                            final packagingTypeState = ref.watch(
                              packagingTypeControllerProvider,
                            );

                            return packagingTypeState.when(
                              data: (data) {
                                final packagingItems = data.packagingTypes;

                                int? selectedIndex;
                                if (selectedPackagingTypeId != null) {
                                  selectedIndex = packagingItems.indexWhere(
                                    (item) =>
                                        item.id == selectedPackagingTypeId,
                                  );
                                  if (selectedIndex < 0) selectedIndex = 0;
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: DropDownContainer(
                                        fw: FontWeight.normal,
                                        dialogueScreen:
                                            MaterialConditionPopupLeftIcon(
                                              title: packagingItems.isNotEmpty
                                                  ? packagingItems[selectedIndex ??
                                                            0]
                                                        .name
                                                  : '',
                                              conditions: packagingItems
                                                  .map((e) => e.name)
                                                  .toList(),
                                              initialSelectedIndex:
                                                  selectedIndex,
                                              enableSearch: true,
                                            ),
                                        text:
                                            selectedPackagingTypeId != null &&
                                                packagingItems.isNotEmpty
                                            ? packagingItems
                                                  .firstWhere(
                                                    (item) =>
                                                        item.id ==
                                                        selectedPackagingTypeId,
                                                    orElse: () =>
                                                        packagingItems.first,
                                                  )
                                                  .name
                                            : 'Select Packaging Type',
                                        onItemSelected: (value) {},
                                      ),
                                    ),

                                    if (packagingTypeError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          left: 4,
                                        ),
                                        child: Text(
                                          packagingTypeError!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),

                                    // Show packaging type details if selected
                                    if (selectedPackagingTypeName != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            final state = ref.watch(
                                              packagingTypeControllerProvider,
                                            );
                                            final selectedItem = state.when(
                                              data: (data) => data
                                                  .packagingTypes
                                                  .firstWhere(
                                                    (item) =>
                                                        item.id ==
                                                        selectedPackagingTypeId,
                                                    orElse: () =>
                                                        PackagingTypeItem(
                                                          id: 0,
                                                          name: '',
                                                          description: '',
                                                          handlingMultiplier:
                                                              1.0,
                                                          requiresDimensions:
                                                              false,
                                                        ),
                                                  ),
                                              loading: () => PackagingTypeItem(
                                                id: 0,
                                                name: '',
                                                description: '',
                                                handlingMultiplier: 1.0,
                                                requiresDimensions: false,
                                              ),
                                              error: (error, stackTrace) =>
                                                  PackagingTypeItem(
                                                    id: 0,
                                                    name: '',
                                                    description: '',
                                                    handlingMultiplier: 1.0,
                                                    requiresDimensions: false,
                                                  ),
                                            );

                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.info_outline,
                                                      size: 14,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        selectedItem
                                                            .description,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 2),
                                              ],
                                            );
                                          },
                                        ),
                                      ),

                                    // DIMENSIONS FIELDS - Only show if requiresDimensions is true
                                    if (showDimensionsFields) ...[
                                      SizedBox(height: 16),
                                      Text(
                                        "Package Dimensions (cm)",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildTextField(
                                                  controller: lengthController,
                                                  label: "Length (cm)",
                                                  icon: Icons.straighten,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: _buildTextField(
                                                  controller: widthController,
                                                  label: "Width (cm)",
                                                  icon: Icons.width_normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: _buildTextField(
                                                  controller: heightController,
                                                  label: "Height (cm)",
                                                  icon: Icons.height,
                                                ),
                                              ),
                                              // Expanded(child: Container()), // Empty space for alignment
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                );
                              },

                              loading: () => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.lightBorder,
                                      ),
                                      color: AppColors.pureWhite,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Loading packaging types...',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              error: (error, stackTrace) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red),
                                      color: AppColors.pureWhite,
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Error loading packaging types',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        ref
                                            .read(
                                              packagingTypeControllerProvider
                                                  .notifier,
                                            )
                                            .loadPackagingTypes();
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // END PACKAGING TYPE DROPDOWN
                        gapH28,

                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: weightController, // FIXED ISSUE 4
                                label: "Total Weight (kg)",
                                icon: Icons.scale, // Correct icon
                              ),
                            ),
                            gapW8,
                            Expanded(
                              child: _buildTextField(
                                controller: quantityController, // FIXED ISSUE 4
                                label: "Quantity",
                                icon: Icons.numbers, // Correct icon
                              ),
                            ),
                          ],
                        ),

                        gapH8,

                        _buildTextField(
                          controller: declaredValueController, // FIXED
                          label: "Declared Value (R)",
                          icon: Icons.attach_money, // Correct icon
                        ),
                      ],
                    ),
                  ),
                  gapH20,

                  // Default Address
                  _defaultAddressSection(),

                  // Defult address end
                  gapH16,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PACKAGING TYPE SECTION =================

Widget buildPackagingTypeSection(BuildContext context, WidgetRef ref) {
  final packagingTypeState = ref.watch(packagingTypeControllerProvider);

  return LayoutBuilder(
    builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth, // 🔥 FORCE FULL WIDTH
        child: packagingTypeState.when(
          data: (data) {
            final packagingItems = data.packagingTypes;

            int? selectedIndex;
            if (selectedPackagingTypeId != null) {
              selectedIndex = packagingItems.indexWhere(
                (item) => item.id == selectedPackagingTypeId,
              );
              if (selectedIndex < 0) selectedIndex = null;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LABEL
                const Text(
                  "Packaging Type",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                /// DROPDOWN (FULL WIDTH)
                SizedBox(
                  width: double.infinity,
                  child: DropDownContainer(
                    fw: FontWeight.normal,
                    dialogueScreen: MaterialConditionPopupLeftIcon(
                      title: selectedIndex != null &&
                              packagingItems.isNotEmpty
                          ? packagingItems[selectedIndex].name
                          : '',
                      conditions:
                          packagingItems.map((e) => e.name).toList(),
                      initialSelectedIndex: selectedIndex,
                      enableSearch: true,
                    ),
                    text: selectedPackagingTypeId != null &&
                            packagingItems.isNotEmpty
                        ? packagingItems
                            .firstWhere(
                              (item) =>
                                  item.id == selectedPackagingTypeId,
                              orElse: () => packagingItems.first,
                            )
                            .name
                        : "Select Packaging Type",
                    onItemSelected: (value) {
                      final selectedItem = packagingItems.firstWhere(
                        (item) => item.name == value,
                      );

                      selectedPackagingTypeId = selectedItem.id;
                      selectedPackagingTypeName = selectedItem.name;
                      packagingTypeError = null;
                      showDimensionsFields =
                          selectedItem.requiresDimensions;

                      /// SAVE TO CACHE
                      ref
                          .read(orderCacheProvider.notifier)
                          .saveValue(
                            "selected_packaging_type_id",
                            selectedItem.id.toString(),
                          );
                      ref
                          .read(orderCacheProvider.notifier)
                          .saveValue(
                            "selected_packaging_type_name",
                            selectedItem.name,
                          );
                      ref
                          .read(orderCacheProvider.notifier)
                          .saveValue(
                            "selected_packaging_handling_multiplier",
                            selectedItem.handlingMultiplier.toString(),
                          );
                      ref
                          .read(orderCacheProvider.notifier)
                          .saveValue(
                            "selected_packaging_requires_dimensions",
                            selectedItem.requiresDimensions.toString(),
                          );

                      if (!selectedItem.requiresDimensions) {
                        lengthController.clear();
                        widthController.clear();
                        heightController.clear();
                      }

                      _validateFields();
                    },
                  ),
                ),

                /// ERROR
                if (packagingTypeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      packagingTypeError!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),

                /// DESCRIPTION
                if (selectedPackagingTypeId != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            packagingItems
                                .firstWhere(
                                  (item) =>
                                      item.id ==
                                      selectedPackagingTypeId,
                                )
                                .description,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                /// DIMENSIONS
                if (showDimensionsFields) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Package Dimensions (cm)",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: lengthController,
                          label: "Length",
                          icon: Icons.straighten,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          controller: widthController,
                          label: "Width",
                          icon: Icons.width_normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: heightController,
                    label: "Height",
                    icon: Icons.height,
                  ),
                ],
              ],
            );
          },

          /// LOADING
          loading: () => Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),

          /// ERROR
          error: (error, _) => Column(
            children: [
              const Text(
                "Failed to load packaging types",
                style: TextStyle(color: Colors.red),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(packagingTypeControllerProvider.notifier)
                      .loadPackagingTypes();
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  void _addDimensionCacheListeners() {
    lengthController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("package_length", lengthController.text);
      _checkFormFilled();
    });

    widthController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("package_width", widthController.text);
      _checkFormFilled();
    });

    heightController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("package_height", heightController.text);
      _checkFormFilled();
    });
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Default Address",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (editorMode == "edit" && showEditor) {
                      showEditor = false;
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
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),

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

          if (showEditor && editorMode == "edit") ...[
            const SizedBox(height: 12),
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
        ],
      ),
    );
  }

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
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

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
      inputFormatters: isNumber
          ? [FilteringTextInputFormatter.digitsOnly]
          : <TextInputFormatter>[],
    );
  }

  Widget _selectableCard({required int index, required String text}) {
    bool isSelected = selectedCardIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCardIndex = index;
          selectedAddress = text;
          showEditor = false;
        });
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
            const Icon(Icons.home, size: 20, color: AppColors.electricTeal),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
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
}

// class PickupDeliveryScreen extends ConsumerStatefulWidget {
//   const PickupDeliveryScreen({super.key});

//   @override
//   ConsumerState<PickupDeliveryScreen> createState() =>
//       _PickupDeliveryScreenState();
// }

// class _PickupDeliveryScreenState extends ConsumerState<PickupDeliveryScreen> {
//   String? selectedCountry;
//   String? countryError;

//   // New Product Type Variables
//   String? selectedProductType;
//   String? selectedProductTypeName;
//   int? selectedProductTypeId;
//   String? productTypeError;

//   String? selectedPackageType;
//   String? packageTypeError;
//   // Packaging Type Variables
//   String? selectedPackagingTypeName;
//   int? selectedPackagingTypeId;
//   String? packagingTypeError;

//   List<String> staticCountries = ["Pakistan", "India", "USA", "UK", "UAE"];
//   List<String> packageTypes = [
//     "Box",
//     "Envelope",
//     "Tube",
//     "Pallet",
//     "Crate",
//     "Bag",
//     "Roll",
//     "Other",
//   ];

//   // Text Controllers for product info
//   final TextEditingController weightController = TextEditingController();
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController declaredValueController = TextEditingController();

//   void _validateFields() {
//     // Product Type validation
//     if (selectedProductTypeId == null) {
//       productTypeError = "Please select a product type";
//     } else {
//       productTypeError = null;
//     }

//     // Packaging Type validation (changed from Package Type)
//     if (selectedPackagingTypeId == null) {
//       packagingTypeError = "Please select a packaging type";
//     } else {
//       packagingTypeError = null;
//     }

//     // Country validation
//     if (selectedCountry == null || selectedCountry!.isEmpty) {
//       countryError = "Please select a country";
//     } else {
//       countryError = null;
//     }
//   }

//   late FlutterGooglePlacesSdk places;

//   String editorMode = "";
//   bool showEditor = false;
//   int selectedCardIndex = 0;
//   String selectedAddress = "";

//   final TextEditingController contactnameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController address1Controller = TextEditingController();
//   final TextEditingController address2Controller = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController postalController = TextEditingController();

//   final TextEditingController contactnameDeliveryController =
//       TextEditingController();
//   final TextEditingController phoneDeliveryController = TextEditingController();
//   final TextEditingController address1DeliveryController =
//       TextEditingController();
//   final TextEditingController address2DeliveryController =
//       TextEditingController();
//   final TextEditingController cityDeliveryController = TextEditingController();
//   final TextEditingController stateDeliveryController = TextEditingController();
//   final TextEditingController postalDeliveryController =
//       TextEditingController();

//   final FocusNode editlocationFocus = FocusNode();
//   final FocusNode phoneFocus = FocusNode();
//   final FocusNode locationFocus = FocusNode();
//   final FocusNode contactnameFocus = FocusNode();

//   bool _isFormFilled = false;

//   @override
//   void initState() {
//     super.initState();

//     places = FlutterGooglePlacesSdk("AIzaSyBrF_4PwauOkQ_RS8iGYhAW1NIApp3IEf0");

//     setupPickupListener();
//     setupDeliveryListener();

//     // LOAD CACHED DATA
//     Future.microtask(() {
//       ref.read(defaultAddressControllerProvider.notifier).loadDefaultAddress();
//       ref.read(allAddressControllerProvider.notifier).loadAllAddress();
//       ref.read(productTypeControllerProvider.notifier).loadProductTypes();
//       ref.read(packagingTypeControllerProvider.notifier).loadPackagingTypes();
//       final cache = ref.read(orderCacheProvider);
//       selectedAddress = cache["default_selected_address"] ?? "";

//       // Load product type from cache
//       final savedProductTypeId = cache["selected_product_type_id"];
//       final savedProductTypeName = cache["selected_product_type_name"];

//       if (savedProductTypeId != null) {
//         setState(() {
//           selectedProductTypeId = int.tryParse(savedProductTypeId);
//           selectedProductTypeName = savedProductTypeName;
//         });
//       }

//       // Load package type from cache
//       final savedPackageType = cache["selected_package_type"];
//       if (savedPackageType != null) {
//         setState(() {
//           selectedPackageType = savedPackageType;
//         });
//       }

//       // Load packaging type from cache
//       final savedPackagingTypeId = cache["selected_packaging_type_id"];
//       final savedPackagingTypeName = cache["selected_packaging_type_name"];

//       if (savedPackagingTypeId != null) {
//         setState(() {
//           selectedPackagingTypeId = int.tryParse(savedPackagingTypeId);
//           selectedPackagingTypeName = savedPackagingTypeName;
//         });
//       }

//       // Load product info from cache
//       final savedWeight = cache["total_weight"];
//       final savedQuantity = cache["quantity"];
//       final savedDeclaredValue = cache["declared_value"];

//       if (savedWeight != null) weightController.text = savedWeight;
//       if (savedQuantity != null) quantityController.text = savedQuantity;
//       if (savedDeclaredValue != null) {
//         declaredValueController.text = savedDeclaredValue;
//       }

//       // Load pickup info from cache
//       contactnameController.text = cache["pickup_name"] ?? "";
//       phoneController.text = cache["pickup_phone"] ?? "";
//       address1Controller.text = cache["pickup_address1"] ?? "";
//       address2Controller.text = cache["pickup_address2"] ?? "";
//       cityController.text = cache["pickup_city"] ?? "";
//       stateController.text = cache["pickup_state"] ?? "";
//       postalController.text = cache["pickup_postal"] ?? "";

//       // Load delivery info from cache
//       contactnameDeliveryController.text = cache["delivery_name"] ?? "";
//       phoneDeliveryController.text = cache["delivery_phone"] ?? "";
//       address1DeliveryController.text = cache["delivery_address1"] ?? "";
//       address2DeliveryController.text = cache["delivery_address2"] ?? "";
//       cityDeliveryController.text = cache["delivery_city"] ?? "";
//       stateDeliveryController.text = cache["delivery_state"] ?? "";
//       postalDeliveryController.text = cache["delivery_postal"] ?? "";
//     });

//     // LISTENERS FOR CACHING
//     _addCacheListeners();
//   }

//   void setupPickupListener() {
//     address1Controller.addListener(() async {
//       final input = address1Controller.text.trim();
//       if (input.length < 3) return;

//       try {
//         final predictions = await places.findAutocompletePredictions(
//           input,
//           countries: ["ZA"],
//         );

//         if (predictions.predictions.isEmpty) return;

//         final placeId = predictions.predictions.first.placeId;
//         final placeDetails = await places.fetchPlace(placeId, fields: []);

//         double? lat;
//         double? lng;

//         if (placeDetails.place?.latLng != null) {
//           lat = placeDetails.place!.latLng!.lat;
//           lng = placeDetails.place!.latLng!.lng;
//         }

//         if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
//           _setPickupTestCoordinates(input);
//           return;
//         }

//         ref
//             .read(orderCacheProvider.notifier)
//             .saveValue("pickup_latitude", lat.toString());
//         ref
//             .read(orderCacheProvider.notifier)
//             .saveValue("pickup_longitude", lng.toString());
//       } catch (e) {
//         _setPickupTestCoordinates(input);
//       }
//     });
//   }

//   void setupDeliveryListener() {
//     address1DeliveryController.addListener(() async {
//       final input = address1DeliveryController.text.trim();
//       if (input.length < 3) return;

//       try {
//         final predictions = await places.findAutocompletePredictions(
//           input,
//           countries: ["ZA"],
//         );

//         if (predictions.predictions.isEmpty) return;

//         final placeId = predictions.predictions.first.placeId;
//         final placeDetails = await places.fetchPlace(placeId, fields: []);

//         double? lat;
//         double? lng;

//         if (placeDetails.place?.latLng != null) {
//           lat = placeDetails.place!.latLng!.lat;
//           lng = placeDetails.place!.latLng!.lng;
//         }

//         if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
//           _setDeliveryTestCoordinates(input);
//           return;
//         }

//         ref
//             .read(orderCacheProvider.notifier)
//             .saveValue("delivery_latitude", lat.toString());
//         ref
//             .read(orderCacheProvider.notifier)
//             .saveValue("delivery_longitude", lng.toString());
//       } catch (e) {
//         _setDeliveryTestCoordinates(input);
//       }
//     });
//   }

//   void _setPickupTestCoordinates(String address) {
//     String lat, lng;

//     if (address.toLowerCase().contains("cape town")) {
//       lat = "-33.9249";
//       lng = "18.4241";
//     } else if (address.toLowerCase().contains("johannesburg") ||
//         address.toLowerCase().contains("joburg")) {
//       lat = "-26.2041";
//       lng = "28.0473";
//     } else if (address.toLowerCase().contains("durban")) {
//       lat = "-29.8587";
//       lng = "31.0218";
//     } else if (address.toLowerCase().contains("pretoria")) {
//       lat = "-25.7479";
//       lng = "28.2293";
//     } else {
//       lat = "-33.9258";
//       lng = "18.4232";
//     }

//     ref.read(orderCacheProvider.notifier).saveValue("pickup_latitude", lat);
//     ref.read(orderCacheProvider.notifier).saveValue("pickup_longitude", lng);
//   }

//   void _setDeliveryTestCoordinates(String address) {
//     String lat, lng;

//     if (address.toLowerCase().contains("cape town")) {
//       lat = "-33.9189";
//       lng = "18.4233";
//     } else if (address.toLowerCase().contains("johannesburg") ||
//         address.toLowerCase().contains("joburg")) {
//       lat = "-26.1952";
//       lng = "28.0346";
//     } else if (address.toLowerCase().contains("durban")) {
//       lat = "-29.8498";
//       lng = "31.0168";
//     } else {
//       lat = "-33.9318";
//       lng = "18.4172";
//     }

//     ref.read(orderCacheProvider.notifier).saveValue("delivery_latitude", lat);
//     ref.read(orderCacheProvider.notifier).saveValue("delivery_longitude", lng);
//   }

//   void _addCacheListeners() {
//     // Product info listeners
//     weightController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("total_weight", weightController.text);
//       _checkFormFilled();
//       _calculatePriceWithWeight(weightController.text);
//     });

//     quantityController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("quantity", quantityController.text);
//       _checkFormFilled();
//     });

//     declaredValueController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("declared_value", declaredValueController.text);
//       _checkFormFilled();
//     });

//     // Pickup listeners
//     contactnameController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("pickup_name", contactnameController.text);
//       _checkFormFilled();
//     });

//     phoneController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("pickup_phone", phoneController.text);
//       _checkFormFilled();
//     });

//     address1Controller.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("pickup_address1", address1Controller.text);
//       _checkFormFilled();
//     });

//     address2Controller.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("pickup_address2", address2Controller.text);
//       _checkFormFilled();
//     });

//     cityController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("pickup_city", cityController.text);
//       _checkFormFilled();
//     });

//     stateController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("pickup_state", stateController.text);
//       _checkFormFilled();
//     });

//     postalController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("pickup_postal", postalController.text);
//       _checkFormFilled();
//     });

//     // Delivery listeners
//     contactnameDeliveryController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("delivery_name", contactnameDeliveryController.text);
//       _checkFormFilled();
//     });

//     phoneDeliveryController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("delivery_phone", phoneDeliveryController.text);
//       _checkFormFilled();
//     });

//     address1DeliveryController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("delivery_address1", address1DeliveryController.text);
//       _checkFormFilled();
//     });

//     address2DeliveryController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("delivery_address2", address2DeliveryController.text);
//       _checkFormFilled();
//     });

//     cityDeliveryController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("delivery_city", cityDeliveryController.text);
//       _checkFormFilled();
//     });

//     stateDeliveryController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("delivery_state", stateDeliveryController.text);
//       _checkFormFilled();
//     });

//     postalDeliveryController.addListener(() {
//       ref
//           .read(orderCacheProvider.notifier)
//           .saveValue("delivery_postal", postalDeliveryController.text);
//       _checkFormFilled();
//     });
//   }

//   void _checkFormFilled() {
//     final cache = ref.read(orderCacheProvider);
//     final weight = cache["total_weight"] ?? "";
//     final quantity = cache["quantity"] ?? "";
//     final declaredValue = cache["declared_value"] ?? "";

//     final isFilled =
//         selectedProductTypeId != null &&
//         selectedPackagingTypeId != null &&
//         selectedPackageType != null &&
//         weight.isNotEmpty &&
//         quantity.isNotEmpty &&
//         declaredValue.isNotEmpty &&
//         contactnameController.text.isNotEmpty &&
//         phoneController.text.isNotEmpty &&
//         address1Controller.text.isNotEmpty &&
//         address2Controller.text.isNotEmpty &&
//         cityController.text.isNotEmpty &&
//         stateController.text.isNotEmpty &&
//         postalController.text.isNotEmpty &&
//         contactnameDeliveryController.text.isNotEmpty &&
//         phoneDeliveryController.text.isNotEmpty &&
//         address1DeliveryController.text.isNotEmpty &&
//         address2DeliveryController.text.isNotEmpty &&
//         cityDeliveryController.text.isNotEmpty &&
//         stateDeliveryController.text.isNotEmpty &&
//         postalDeliveryController.text.isNotEmpty;

//     if (isFilled != _isFormFilled) {
//       setState(() => _isFormFilled = isFilled);
//     }
//   }

//   void _calculatePrice(double valueMultiplier) {
//     final cache = ref.read(orderCacheProvider);
//     final weightStr = cache["total_weight"];
//     final weight = double.tryParse(weightStr ?? "0") ?? 0;

//     if (weight > 0) {
//       _calculatePriceWithWeight(weight.toString(), valueMultiplier);
//     }
//   }

//   void _calculatePriceWithWeight(String weightStr, [double? multiplier]) {
//     final weight = double.tryParse(weightStr) ?? 0;
//     if (weight <= 0) return;

//     double valueMultiplier = multiplier ?? 1.0;

//     if (multiplier == null) {
//       final cache = ref.read(orderCacheProvider);
//       final savedMultiplier = cache["selected_product_value_multiplier"];
//       valueMultiplier = double.tryParse(savedMultiplier ?? "1.0") ?? 1.0;
//     }

//     double baseRatePerKg = 50.0;
//     double calculatedPrice = weight * baseRatePerKg * valueMultiplier;

//     ref
//         .read(orderCacheProvider.notifier)
//         .saveValue("calculated_price", calculatedPrice.toStringAsFixed(2));
//   }

//   @override
//   void dispose() {
//     editlocationFocus.dispose();
//     contactnameFocus.dispose();
//     locationFocus.dispose();
//     phoneFocus.dispose();

//     contactnameController.dispose();
//     phoneController.dispose();
//     address1Controller.dispose();
//     address2Controller.dispose();
//     cityController.dispose();
//     stateController.dispose();
//     postalController.dispose();

//     contactnameDeliveryController.dispose();
//     phoneDeliveryController.dispose();
//     address1DeliveryController.dispose();
//     address2DeliveryController.dispose();
//     cityDeliveryController.dispose();
//     stateDeliveryController.dispose();
//     postalDeliveryController.dispose();

//     weightController.dispose();
//     quantityController.dispose();
//     declaredValueController.dispose();

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
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.only(
//                       top: 16,
//                       right: 16,
//                       left: 16,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.pureWhite,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.mediumGray.withOpacity(0.10),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomText(
//                               txt: "Product & Packaging Information",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ],
//                         ),
//                         gapH16,

//                         // PRODUCT TYPE DROPDOWN
//                         Consumer(
//                           builder: (context, ref, child) {
//                             final productTypeState = ref.watch(
//                               productTypeControllerProvider,
//                             );

//                             return productTypeState.when(
//                               data: (data) {
//                                 // ✅ CORRECT: Use getAllItems()
//                                 final productItems = data.getAllItems();

//                                 int? selectedIndex;
//                                 if (selectedProductTypeId != null) {
//                                   selectedIndex = productItems.indexWhere(
//                                     (item) => item.id == selectedProductTypeId,
//                                   );
//                                   if (selectedIndex < 0) selectedIndex = 0;
//                                 }

//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     DropDownContainer(
//                                       fw: FontWeight.normal,
//                                       dialogueScreen:
//                                           MaterialConditionPopupLeftIcon(
//                                             title: productItems.isNotEmpty
//                                                 ? productItems[selectedIndex ??
//                                                           0]
//                                                       .name
//                                                 : '',
//                                             conditions: productItems
//                                                 .map((e) => e.name)
//                                                 .toList(),
//                                             initialSelectedIndex: selectedIndex,
//                                             enableSearch: true,
//                                           ),
//                                       text:
//                                           selectedProductTypeId != null &&
//                                               productItems.isNotEmpty
//                                           ? productItems
//                                                 .firstWhere(
//                                                   (item) =>
//                                                       item.id ==
//                                                       selectedProductTypeId,
//                                                   orElse: () =>
//                                                       productItems.first,
//                                                 )
//                                                 .name
//                                           : 'Select Product Type',
//                                       onItemSelected: (value) {
//                                         final selectedItem = productItems
//                                             .firstWhere(
//                                               (element) =>
//                                                   element.name == value,
//                                             );

//                                         setState(() {
//                                           selectedProductTypeId =
//                                               selectedItem.id;
//                                           selectedProductTypeName =
//                                               selectedItem.name;
//                                           productTypeError = null;
//                                         });

//                                         ref
//                                             .read(orderCacheProvider.notifier)
//                                             .saveValue(
//                                               "selected_product_type_id",
//                                               selectedItem.id.toString(),
//                                             );
//                                         ref
//                                             .read(orderCacheProvider.notifier)
//                                             .saveValue(
//                                               "selected_product_type_name",
//                                               selectedItem.name,
//                                             );
//                                         ref
//                                             .read(orderCacheProvider.notifier)
//                                             .saveValue(
//                                               "selected_product_value_multiplier",
//                                               selectedItem.valueMultiplier
//                                                   .toString(),
//                                             );

//                                         _validateFields();
//                                         _calculatePrice(
//                                           selectedItem.valueMultiplier,
//                                         );
//                                       },
//                                     ),
//                                     if (productTypeError != null)
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                           top: 4,
//                                           left: 4,
//                                         ),
//                                         child: Text(
//                                           productTypeError!,
//                                           style: const TextStyle(
//                                             color: Colors.red,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 );
//                               },
//                               loading: () => Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: AppColors.lightBorder,
//                                       ),
//                                       color: AppColors.pureWhite,
//                                     ),
//                                     child: Center(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             width: 20,
//                                             height: 20,
//                                             child: CircularProgressIndicator(
//                                               strokeWidth: 2,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 8),
//                                           const Text(
//                                             'Loading product types...',
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               error: (error, stackTrace) => Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(color: Colors.red),
//                                       color: AppColors.pureWhite,
//                                     ),
//                                     child: Center(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const Icon(
//                                             Icons.error_outline,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(width: 8),
//                                           const Text(
//                                             'Error loading product types',
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Center(
//                                     child: TextButton(
//                                       onPressed: () {
//                                         ref
//                                             .read(
//                                               productTypeControllerProvider
//                                                   .notifier,
//                                             )
//                                             .loadProductTypes();
//                                       },
//                                       child: const Text('Retry'),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         gapH8,

//                         // PACKAGE TYPE DROPDOWN
//                         // PACKAGING TYPE DROPDOWN (API Based)
//                         Consumer(
//                           builder: (context, ref, child) {
//                             final packagingTypeState = ref.watch(
//                               packagingTypeControllerProvider,
//                             );

//                             return packagingTypeState.when(
//                               data: (data) {
//                                 final packagingItems = data.packagingTypes;

//                                 int? selectedIndex;
//                                 if (selectedPackagingTypeId != null) {
//                                   selectedIndex = packagingItems.indexWhere(
//                                     (item) =>
//                                         item.id == selectedPackagingTypeId,
//                                   );
//                                   if (selectedIndex < 0) selectedIndex = 0;
//                                 }

//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     DropDownContainer(
//                                       fw: FontWeight.normal,
//                                       dialogueScreen:
//                                           MaterialConditionPopupLeftIcon(
//                                             title: packagingItems.isNotEmpty
//                                                 ? packagingItems[selectedIndex ??
//                                                           0]
//                                                       .name
//                                                 : '',
//                                             conditions: packagingItems
//                                                 .map((e) => e.name)
//                                                 .toList(),
//                                             initialSelectedIndex: selectedIndex,
//                                             enableSearch: true,
//                                           ),
//                                       text:
//                                           selectedPackagingTypeId != null &&
//                                               packagingItems.isNotEmpty
//                                           ? packagingItems
//                                                 .firstWhere(
//                                                   (item) =>
//                                                       item.id ==
//                                                       selectedPackagingTypeId,
//                                                   orElse: () =>
//                                                       packagingItems.first,
//                                                 )
//                                                 .name
//                                           : 'Select Packaging Type',
//                                       onItemSelected: (value) {
//                                         final selectedItem = packagingItems
//                                             .firstWhere(
//                                               (element) =>
//                                                   element.name == value,
//                                             );

//                                         setState(() {
//                                           selectedPackagingTypeId =
//                                               selectedItem.id;
//                                           selectedPackagingTypeName =
//                                               selectedItem.name;
//                                           packagingTypeError = null;
//                                         });

//                                         // Save to cache
//                                         ref
//                                             .read(orderCacheProvider.notifier)
//                                             .saveValue(
//                                               "selected_packaging_type_id",
//                                               selectedItem.id.toString(),
//                                             );
//                                         ref
//                                             .read(orderCacheProvider.notifier)
//                                             .saveValue(
//                                               "selected_packaging_type_name",
//                                               selectedItem.name,
//                                             );
//                                         ref
//                                             .read(orderCacheProvider.notifier)
//                                             .saveValue(
//                                               "selected_packaging_handling_multiplier",
//                                               selectedItem.handlingMultiplier
//                                                   .toString(),
//                                             );
//                                         ref
//                                             .read(orderCacheProvider.notifier)
//                                             .saveValue(
//                                               "selected_packaging_requires_dimensions",
//                                               selectedItem.requiresDimensions
//                                                   .toString(),
//                                             );

//                                         _validateFields();
//                                       },
//                                     ),

//                                     if (packagingTypeError != null)
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                           top: 4,
//                                           left: 4,
//                                         ),
//                                         child: Text(
//                                           packagingTypeError!,
//                                           style: const TextStyle(
//                                             color: Colors.red,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),

//                                     // Show packaging type details if selected
//                                     if (selectedPackagingTypeName != null)
//                                       Padding(
//                                         padding: const EdgeInsets.only(top: 4),
//                                         child: Consumer(
//                                           builder: (context, ref, child) {
//                                             final state = ref.watch(
//                                               packagingTypeControllerProvider,
//                                             );
//                                             final selectedItem = state.when(
//                                               data: (data) => data
//                                                   .packagingTypes
//                                                   .firstWhere(
//                                                     (item) =>
//                                                         item.id ==
//                                                         selectedPackagingTypeId,
//                                                     orElse: () =>
//                                                         PackagingTypeItem(
//                                                           id: 0,
//                                                           name: '',
//                                                           description: '',
//                                                           handlingMultiplier:
//                                                               1.0,
//                                                           requiresDimensions:
//                                                               false,
//                                                         ),
//                                                   ),
//                                               loading: () => PackagingTypeItem(
//                                                 id: 0,
//                                                 name: '',
//                                                 description: '',
//                                                 handlingMultiplier: 1.0,
//                                                 requiresDimensions: false,
//                                               ),
//                                               error: (error, stackTrace) =>
//                                                   PackagingTypeItem(
//                                                     id: 0,
//                                                     name: '',
//                                                     description: '',
//                                                     handlingMultiplier: 1.0,
//                                                     requiresDimensions: false,
//                                                   ),
//                                             );

//                                             return Column(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Icon(
//                                                       Icons.info_outline,
//                                                       size: 14,
//                                                       color: Colors.blue,
//                                                     ),
//                                                     SizedBox(width: 4),
//                                                     Expanded(
//                                                       child: Text(
//                                                         selectedItem
//                                                             .description,
//                                                         style: TextStyle(
//                                                           fontSize: 11,
//                                                           color:
//                                                               Colors.grey[600],
//                                                         ),
//                                                         maxLines: 2,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 SizedBox(height: 2),
//                                                 if (selectedItem
//                                                     .requiresDimensions)
//                                                   Row(
//                                                     children: [
//                                                       Icon(
//                                                         Icons.warning_amber,
//                                                         size: 12,
//                                                         color: Colors.orange,
//                                                       ),
//                                                       SizedBox(width: 4),
//                                                       Text(
//                                                         "Dimensions required",
//                                                         style: TextStyle(
//                                                           fontSize: 10,
//                                                           color: Colors.orange,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                               ],
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                   ],
//                                 );
//                               },

//                               loading: () => Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         color: AppColors.lightBorder,
//                                       ),
//                                       color: AppColors.pureWhite,
//                                     ),
//                                     child: Center(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             width: 20,
//                                             height: 20,
//                                             child: CircularProgressIndicator(
//                                               strokeWidth: 2,
//                                             ),
//                                           ),
//                                           const SizedBox(width: 8),
//                                           const Text(
//                                             'Loading packaging types...',
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               error: (error, stackTrace) => Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     height: 60,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(color: Colors.red),
//                                       color: AppColors.pureWhite,
//                                     ),
//                                     child: Center(
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const Icon(
//                                             Icons.error_outline,
//                                             color: Colors.red,
//                                           ),
//                                           const SizedBox(width: 8),
//                                           const Text(
//                                             'Error loading packaging types',
//                                             style: TextStyle(color: Colors.red),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Center(
//                                     child: TextButton(
//                                       onPressed: () {
//                                         ref
//                                             .read(
//                                               packagingTypeControllerProvider
//                                                   .notifier,
//                                             )
//                                             .loadPackagingTypes();
//                                       },
//                                       child: const Text('Retry'),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         gapH8,

//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: address1DeliveryController,
//                                 label: "Total Weight (kg)",
//                                 icon: Icons.location_on,
//                               ),
//                             ),

//                             gapW8,
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: address2DeliveryController,
//                                 label: "Quantity",
//                                 icon: Icons.location_city,
//                               ),
//                             ),
//                           ],
//                         ),

//                         gapH8,

//                         _buildTextField(
//                           controller: cityDeliveryController,
//                           label: "Declared Value (R)",
//                           icon: Icons.location_city_outlined,
//                         ),
//                       ],
//                     ),
//                   ),

//                   _sectionTitle("PICKUP LOCATION"),
//                   const SizedBox(height: 10),

//                   // Default Address
//                   _defaultAddressSection(),
//                   // Defult address end
//                   const SizedBox(height: 10),
//                   _linkText(
//                     "Use Current Location",
//                     Icons.pin_drop_outlined,
//                     onTap: () {},
//                   ),

//                   // _linkText("Add New Address", Icons.add, onTap: () {}),
//                   gapH20,
//                   _sectionTitle("DELIVERY LOCATION"),

//                   const SizedBox(height: 10),

//                   // delivery address
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.only(
//                       top: 16,
//                       right: 16,
//                       left: 16,
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.pureWhite,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.mediumGray.withValues(alpha: 0.10),
//                           blurRadius: 6,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),

//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             CustomText(
//                               txt: "Office Building",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ],
//                         ),
//                         gapH16,

//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: contactnameDeliveryController,
//                                 label: "Name",
//                                 icon: Icons.person,
//                               ),
//                             ),
//                             gapW4,

//                             Expanded(
//                               child: _buildTextField(
//                                 controller: phoneDeliveryController,
//                                 label: "Phone Number",
//                                 icon: Icons.phone_android,
//                                 isNumber: true, //  ONLY NUMBER
//                               ),
//                             ),
//                           ],
//                         ),

//                         gapH8,

//                         _buildTextField(
//                           controller: address1DeliveryController,
//                           label: "Address Line 1",
//                           icon: Icons.location_on,
//                         ),
//                         gapH8,

//                         _buildTextField(
//                           controller: address2DeliveryController,
//                           label: "Address Line 2",
//                           icon: Icons.location_city,
//                         ),
//                         gapH8,

//                         Row(
//                           children: [
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: cityDeliveryController,
//                                 label: "City",
//                                 icon: Icons.location_city_outlined,
//                               ),
//                             ),
//                             gapW4,
//                             Expanded(
//                               child: _buildTextField(
//                                 controller: stateDeliveryController,
//                                 label: "State/Province",
//                                 icon: Icons.map_outlined,
//                               ),
//                             ),
//                           ],
//                         ),

//                         gapH8,

//                         _buildTextField(
//                           controller: postalDeliveryController,
//                           label: "Postal Code",
//                           icon: Icons.numbers,
//                           isNumber: true, //  ONLY NUMBER
//                         ),
//                       ],
//                     ),
//                   ),

//                   // delivery address end
//                   gapH16,
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _defaultAddressSection() {
//     final defaultAddressState = ref.watch(defaultAddressControllerProvider);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.pureWhite,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.mediumGray.withOpacity(0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               const Text(
//                 "Default Address",
//                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//               ),
//               const Spacer(),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     if (editorMode == "edit" && showEditor) {
//                       showEditor = false;
//                     } else {
//                       editorMode = "edit";
//                       showEditor = true;
//                       ref
//                           .read(allAddressControllerProvider.notifier)
//                           .loadAllAddress();
//                     }
//                   });
//                 },
//                 child: _smallButton("Edit", showEditor && editorMode == "edit"),
//               ),
//               const SizedBox(width: 8),
//               GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     if (editorMode == "add" && showEditor) {
//                       showEditor = false;
//                     } else {
//                       editorMode = "add";
//                       showEditor = true;
//                     }
//                   });
//                 },
//                 child: _smallButton("Add", showEditor && editorMode == "add"),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           if (!showEditor)
//             defaultAddressState.when(
//               loading: () =>
//                   _selectableCard(index: 0, text: "Loading address..."),
//               error: (err, _) =>
//                   _selectableCard(index: 0, text: "Failed to load address"),
//               data: (addressModel) {
//                 final address = addressModel.data;
//                 final formatted =
//                     "${address.address},\n${address.city}, ${address.state}\n${address.postalCode}";

//                 if (selectedAddress.isEmpty) {
//                   final cache = ref.read(orderCacheProvider);
//                   selectedAddress =
//                       cache["default_selected_address"] ?? formatted;
//                 }

//                 return _selectableCard(index: 0, text: selectedAddress);
//               },
//             ),

//           if (showEditor && editorMode == "edit") ...[
//             const SizedBox(height: 12),
//             Consumer(
//               builder: (context, ref, _) {
//                 final allAddressState = ref.watch(allAddressControllerProvider);

//                 return allAddressState.when(
//                   loading: () => _selectableCard(
//                     index: 999,
//                     text: "Loading saved addresses...",
//                   ),
//                   error: (err, _) => _selectableCard(
//                     index: 999,
//                     text: "Failed to load addresses",
//                   ),
//                   data: (model) {
//                     final list = model?.data ?? [];

//                     return Column(
//                       children: List.generate(list.length, (i) {
//                         final a = list[i];
//                         final formatted =
//                             "${a.address} - ${a.addressLine2}\n${a.city}, ${a.state}\n${a.postalCode}";

//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: _selectableCard(index: i + 1, text: formatted),
//                         );
//                       }),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],

//           if (showEditor && editorMode == "add") ...[
//             gapH12,
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTextField(
//                     controller: contactnameController,
//                     label: "Name",
//                     icon: Icons.person,
//                   ),
//                 ),
//                 gapW4,
//                 Expanded(
//                   child: _buildTextField(
//                     controller: phoneController,
//                     label: "Phone Number",
//                     icon: Icons.phone_android,
//                     isNumber: true,
//                   ),
//                 ),
//               ],
//             ),
//             gapH8,
//             _buildTextField(
//               controller: address1Controller,
//               label: "Address Line 1",
//               icon: Icons.location_on,
//             ),
//             gapH8,
//             _buildTextField(
//               controller: address2Controller,
//               label: "Address Line 2",
//               icon: Icons.location_city,
//             ),
//             gapH8,
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildTextField(
//                     controller: cityController,
//                     label: "City",
//                     icon: Icons.location_city_outlined,
//                   ),
//                 ),
//                 gapW4,
//                 Expanded(
//                   child: _buildTextField(
//                     controller: stateController,
//                     label: "State/Province",
//                     icon: Icons.map_outlined,
//                   ),
//                 ),
//               ],
//             ),
//             gapH8,
//             _buildTextField(
//               controller: postalController,
//               label: "Postal Code",
//               icon: Icons.numbers,
//               isNumber: true,
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _smallButton(String text, bool isOpen) {
//     IconData icon;

//     if (isOpen) {
//       icon = Icons.close;
//     } else {
//       icon = (text == "Add") ? Icons.add : Icons.edit;
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.electricTeal,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       child: Row(
//         children: [
//           Icon(icon, size: 12, color: Colors.white),
//           const SizedBox(width: 4),
//           Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     bool isNumber = false,
//   }) {
//     return CustomAnimatedTextField(
//       controller: controller,
//       focusNode: FocusNode(),
//       labelText: label,
//       hintText: label,
//       prefixIcon: icon,
//       iconColor: AppColors.electricTeal,
//       borderColor: AppColors.electricTeal,
//       textColor: AppColors.mediumGray,
//       keyboardType: isNumber ? TextInputType.number : TextInputType.text,
//       inputFormatters: isNumber
//           ? [FilteringTextInputFormatter.digitsOnly]
//           : <TextInputFormatter>[],
//     );
//   }

//   Widget _selectableCard({required int index, required String text}) {
//     bool isSelected = selectedCardIndex == index;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedCardIndex = index;
//           selectedAddress = text;
//           showEditor = false;
//         });
//         ref
//             .read(orderCacheProvider.notifier)
//             .saveValue("default_selected_address", text);
//       },
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.pureWhite,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? AppColors.electricTeal : AppColors.electricTeal,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Icon(Icons.home, size: 20, color: AppColors.electricTeal),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 text,
//                 style: const TextStyle(
//                   color: AppColors.darkText,
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _sectionTitle(String title) {
//     return CustomText(
//       txt: title,
//       color: AppColors.darkText,
//       fontSize: 15,
//       fontWeight: FontWeight.bold,
//     );
//   }

//   Widget _linkText(String text, IconData icon, {required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         children: [
//           Icon(icon, color: AppColors.electricTeal),
//           const SizedBox(width: 6),
//           CustomText(
//             txt: text,
//             color: AppColors.darkText,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ],
//       ),
//     );
//   }
// }
