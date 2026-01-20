import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logisticscustomer/export.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/order_cache_provider.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/fetch_order/service_payment_screen.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown.dart';

import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/dropdown/product_type_controller.dart';
import 'package:logisticscustomer/features/home/create_orders_screens/pickup_location/pickup_controller.dart';

class Step2Screen extends ConsumerStatefulWidget {
  const Step2Screen({super.key});

  @override
  ConsumerState<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends ConsumerState<Step2Screen> {
  // Multi-Stop Variables
  bool isMultiStopEnabled = false;
  List<RouteStop> routeStops = [];

  // Single Stop Variables (Existing)
  String? selectedCountry;
  String? countryError;
  String? selectedProductType;
  String? selectedProductTypeName;
  int? selectedProductTypeId;
  String? productTypeError;
  String? selectedPackageType;
  String? packageTypeError;
  String? selectedPackagingTypeName;
  int? selectedPackagingTypeId;
  String? packagingTypeError;

  // Text Controllers for product info
  final TextEditingController weightController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController declaredValueController = TextEditingController();

  // Dimensions variables
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  late FlutterGooglePlacesSdk places;

  String editorMode = "";
  bool showEditor = false;
  int selectedCardIndex = 0;
  String selectedAddress = "";

  // Single Stop Controllers
  final TextEditingController contactnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

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
  final TextEditingController emailDeliveryController = TextEditingController();
  final TextEditingController notesDeliveryController = TextEditingController();

  final FocusNode editlocationFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode locationFocus = FocusNode();
  final FocusNode contactnameFocus = FocusNode();

  bool _isFormFilled = false;
  bool showDimensionsFields = false;

  @override
  void initState() {
    super.initState();

    places = FlutterGooglePlacesSdk("AIzaSyBrF_4PwauOkQ_RS8iGYhAW1NIApp3IEf0");

    setupPickupListener();
    setupDeliveryListener();

    // LOAD CACHED DATA
    Future.microtask(() {
      final cache = ref.read(orderCacheProvider);

      // Load multi-stop setting
      final savedMultiStop = cache["is_multi_stop_enabled"];
      if (savedMultiStop != null) {
        setState(() {
          isMultiStopEnabled = savedMultiStop == "true";
        });
      }

      // Load route stops from cache
      _loadRouteStopsFromCache(cache);

      // Load single stop data
      _loadSingleStopData(cache);

      // Initialize multi-stop if enabled
      if (isMultiStopEnabled && routeStops.isEmpty) {
        _initializeMultiStop();
      }

      ref.read(defaultAddressControllerProvider.notifier).loadDefaultAddress();
      ref.read(allAddressControllerProvider.notifier).loadAllAddress();
      ref.read(productTypeControllerProvider.notifier).loadProductTypes();
      ref.read(packagingTypeControllerProvider.notifier).loadPackagingTypes();

      // Check form initially
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkFormFilled();
      });
    });

    _addDimensionCacheListeners();
    _addCacheListeners();
  }

  void _initializeMultiStop() {
    // Initialize with 2 stops by default when multi-stop is enabled
    setState(() {
      routeStops = [
        RouteStop(
          id: 1,
          stopType: StopType.pickup,
          contactName: TextEditingController(),
          contactPhone: TextEditingController(),
          address: TextEditingController(),
          city: TextEditingController(),
          state: TextEditingController(),
          postalCode: TextEditingController(),
          contactEmail: TextEditingController(),
          notes: TextEditingController(),
          weight: TextEditingController(),
          quantity: TextEditingController(),
        ),
        RouteStop(
          id: 2,
          stopType: StopType.dropOff,
          contactName: TextEditingController(),
          contactPhone: TextEditingController(),
          address: TextEditingController(),
          city: TextEditingController(),
          state: TextEditingController(),
          postalCode: TextEditingController(),
          contactEmail: TextEditingController(),
          notes: TextEditingController(),
          weight: TextEditingController(),
          quantity: TextEditingController(),
        ),
      ];

      // Add listeners for initial stops
      _addMultiStopListeners();
    });
  }

  void _loadRouteStopsFromCache(Map<String, dynamic> cache) {
    // Load route stops count
    final stopsCountStr = cache["route_stops_count"]?.toString() ?? "";
    if (stopsCountStr.isNotEmpty) {
      final stopsCount = int.tryParse(stopsCountStr) ?? 0;

      List<RouteStop> loadedStops = [];

      for (int i = 1; i <= stopsCount; i++) {
        final stopTypeStr = cache["stop_${i}_type"]?.toString() ?? "";
        StopType stopType;

        try {
          stopType = StopType.values.firstWhere(
            (type) => type.toString() == stopTypeStr,
          );
        } catch (e) {
          stopType = i == 1 ? StopType.pickup : StopType.dropOff;
        }

        final stop = RouteStop(
          id: i,
          stopType: stopType,
          contactName: TextEditingController(
            text: cache["stop_${i}_contact_name"]?.toString() ?? "",
          ),
          contactPhone: TextEditingController(
            text: cache["stop_${i}_contact_phone"]?.toString() ?? "",
          ),
          address: TextEditingController(
            text: cache["stop_${i}_address"]?.toString() ?? "",
          ),
          city: TextEditingController(
            text: cache["stop_${i}_city"]?.toString() ?? "",
          ),
          state: TextEditingController(
            text: cache["stop_${i}_state"]?.toString() ?? "",
          ),
          postalCode: TextEditingController(
            text: cache["stop_${i}_postal_code"]?.toString() ?? "",
          ),
          contactEmail: TextEditingController(
            text: cache["stop_${i}_contact_email"]?.toString() ?? "",
          ),
          notes: TextEditingController(
            text: cache["stop_${i}_notes"]?.toString() ?? "",
          ),

          quantity: TextEditingController(
            text: cache["stop_${i}_quantity"]?.toString() ?? "",
          ),
          weight: TextEditingController(
            text: cache["stop_${i}_total_weight"]?.toString() ?? "",
          ),
        );
        loadedStops.add(stop);
      }

      if (loadedStops.isNotEmpty) {
        setState(() {
          routeStops = loadedStops;
        });

        // Add listeners for loaded stops
        _addMultiStopListeners();
      }
    }
  }

  void _loadSingleStopData(Map<String, dynamic> cache) {
    // Load existing single stop data
    selectedAddress = cache["default_selected_address"]?.toString() ?? "";

    // Load dimensions from cache
    final savedLength = cache["package_length"]?.toString();
    final savedWidth = cache["package_width"]?.toString();
    final savedHeight = cache["package_height"]?.toString();
    if (savedLength != null) lengthController.text = savedLength;
    if (savedWidth != null) widthController.text = savedWidth;
    if (savedHeight != null) heightController.text = savedHeight;

    // Load product type from cache
    final savedProductTypeId = cache["selected_product_type_id"]?.toString();
    final savedProductTypeName = cache["selected_product_type_name"]
        ?.toString();

    if (savedProductTypeId != null) {
      setState(() {
        selectedProductTypeId = int.tryParse(savedProductTypeId);
        selectedProductTypeName = savedProductTypeName;
      });
    }

    // Load package type from cache
    final savedPackageType = cache["selected_package_type"]?.toString();
    if (savedPackageType != null) {
      setState(() {
        selectedPackageType = savedPackageType;
      });
    }

    // Load packaging type from cache
    final savedPackagingTypeId = cache["selected_packaging_type_id"]
        ?.toString();
    final savedPackagingTypeName = cache["selected_packaging_type_name"]
        ?.toString();
    final savedRequiresDimensions =
        cache["selected_packaging_requires_dimensions"]?.toString();

    if (savedPackagingTypeId != null) {
      setState(() {
        selectedPackagingTypeId = int.tryParse(savedPackagingTypeId);
        selectedPackagingTypeName = savedPackagingTypeName;

        if (savedRequiresDimensions != null) {
          showDimensionsFields = savedRequiresDimensions == "true";
        }
      });
    }

    // Load product info from cache
    final savedWeight = cache["total_weight"]?.toString();
    final savedQuantity = cache["quantity"]?.toString();
    final savedDeclaredValue = cache["declared_value"]?.toString();

    if (savedWeight != null) weightController.text = savedWeight;
    if (savedQuantity != null) quantityController.text = savedQuantity;
    if (savedDeclaredValue != null) {
      declaredValueController.text = savedDeclaredValue;
    }

    // Load pickup info from cache
    contactnameController.text = cache["pickup_name"]?.toString() ?? "";
    phoneController.text = cache["pickup_phone"]?.toString() ?? "";
    address1Controller.text = cache["pickup_address1"]?.toString() ?? "";
    address2Controller.text = cache["pickup_address2"]?.toString() ?? "";
    cityController.text = cache["pickup_city"]?.toString() ?? "";
    stateController.text = cache["pickup_state"]?.toString() ?? "";
    postalController.text = cache["pickup_postal"]?.toString() ?? "";
    emailController.text = cache["pickup_email"]?.toString() ?? "";
    notesController.text = cache["pickup_notes"]?.toString() ?? "";

    // Load delivery info from cache
    contactnameDeliveryController.text =
        cache["delivery_name"]?.toString() ?? "";
    phoneDeliveryController.text = cache["delivery_phone"]?.toString() ?? "";
    address1DeliveryController.text =
        cache["delivery_address1"]?.toString() ?? "";
    address2DeliveryController.text =
        cache["delivery_address2"]?.toString() ?? "";
    cityDeliveryController.text = cache["delivery_city"]?.toString() ?? "";
    stateDeliveryController.text = cache["delivery_state"]?.toString() ?? "";
    postalDeliveryController.text = cache["delivery_postal"]?.toString() ?? "";
    emailDeliveryController.text = cache["delivery_email"]?.toString() ?? "";
    notesDeliveryController.text = cache["delivery_notes"]?.toString() ?? "";
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
    // Always add single stop listeners initially
    _addSingleStopListeners();

    // Also add multi-stop listeners if enabled
    if (isMultiStopEnabled) {
      _addMultiStopListeners();
    }
  }

  void _addSingleStopListeners() {
    // Product info listeners
    weightController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("total_weight", weightController.text);
      _checkFormFilled();
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

    emailController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_email", emailController.text);
      _checkFormFilled();
    });

    notesController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("pickup_notes", notesController.text);
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

    emailDeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_email", emailDeliveryController.text);
      _checkFormFilled();
    });

    notesDeliveryController.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("delivery_notes", notesDeliveryController.text);
      _checkFormFilled();
    });
  }

  void _addMultiStopListeners() {
    // Save route stops count
    ref
        .read(orderCacheProvider.notifier)
        .saveValue("route_stops_count", routeStops.length.toString());

    // Save each stop data
    for (int i = 0; i < routeStops.length; i++) {
      final stop = routeStops[i];
      final stopIndex = i + 1;

      // Save stop type initially
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${stopIndex}_type", stop.stopType.toString());

      stop.contactName.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("stop_${stopIndex}_contact_name", stop.contactName.text);
        _checkFormFilled();
      });

      stop.contactPhone.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue(
              "stop_${stopIndex}_contact_phone",
              stop.contactPhone.text,
            );
        _checkFormFilled();
      });

      stop.address.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("stop_${stopIndex}_address", stop.address.text);
        _checkFormFilled();
      });

      stop.city.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("stop_${stopIndex}_city", stop.city.text);
        _checkFormFilled();
      });

      stop.state.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("stop_${stopIndex}_state", stop.state.text);
        _checkFormFilled();
      });

      stop.postalCode.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("stop_${stopIndex}_postal_code", stop.postalCode.text);
        _checkFormFilled();
      });

      stop.contactEmail.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue(
              "stop_${stopIndex}_contact_email",
              stop.contactEmail.text,
            );
        _checkFormFilled();
      });

      stop.notes.addListener(() {
        ref
            .read(orderCacheProvider.notifier)
            .saveValue("stop_${stopIndex}_notes", stop.notes.text);
        _checkFormFilled();
      });
    }
  }

  void _checkFormFilled() {
    bool isFilled;

    if (isMultiStopEnabled) {
      // Check multi-stop form
      if (routeStops.isEmpty) {
        isFilled = false;
      } else {
        isFilled = true;
        for (final stop in routeStops) {
          isFilled =
              isFilled &&
              stop.contactName.text.trim().isNotEmpty &&
              stop.contactPhone.text.trim().isNotEmpty &&
              stop.address.text.trim().isNotEmpty &&
              stop.city.text.trim().isNotEmpty &&
              stop.state.text.trim().isNotEmpty;

          if (!isFilled) {
            break;
          }
        }
      }
    } else {
      // Check single stop form
      isFilled =
          contactnameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          address1Controller.text.trim().isNotEmpty &&
          cityController.text.trim().isNotEmpty &&
          stateController.text.trim().isNotEmpty &&
          contactnameDeliveryController.text.trim().isNotEmpty &&
          phoneDeliveryController.text.trim().isNotEmpty &&
          address1DeliveryController.text.trim().isNotEmpty &&
          cityDeliveryController.text.trim().isNotEmpty &&
          stateDeliveryController.text.trim().isNotEmpty;
    }

    if (isFilled != _isFormFilled) {
      setState(() => _isFormFilled = isFilled);
    }
  }

  // Continue Button Validation Method
  void _onNextPressed() {
    // Validate multi-stop or single-stop
    if (isMultiStopEnabled) {
      // Validate multi-stop route
      if (routeStops.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Multi-stop route requires at least 2 stops"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      for (final stop in routeStops) {
        if (stop.contactName.text.trim().isEmpty ||
            stop.contactPhone.text.trim().isEmpty ||
            stop.address.text.trim().isEmpty ||
            stop.city.text.trim().isEmpty ||
            stop.postalCode.text.trim().isEmpty ||
            stop.contactEmail.text.trim().isEmpty ||
            stop.notes.text.trim().isEmpty ||
            stop.state.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Please complete all stop information"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }

      // Save multi-stop data to cache
      _saveMultiStopData();

      // ✅ DEBUG: Print cache to verify
      print("✅ Multi-stop data saved to cache:");
      final allCache = ref.read(orderCacheProvider);
      print("   pickup_name: ${allCache["pickup_name"]}");
      print("   pickup_phone: ${allCache["pickup_phone"]}");
      print("   pickup_address1: ${allCache["pickup_address1"]}");
      print("   pickup_city: ${allCache["pickup_city"]}");
      print("   pickup_state: ${allCache["pickup_state"]}");
      print("   pickup_postal: ${allCache["pickup_postal"]}");
      print("   pickup_email: ${allCache["pickup_email"]}");
      print("   pickup_notes: ${allCache["pickup_notes"]}");
      //
      print("   delivery_name: ${allCache["delivery_name"]}");
      print("   delivery_phone: ${allCache["delivery_phone"]}");
      print("   delivery_address1: ${allCache["delivery_address1"]}");
      print("   delivery_city: ${allCache["delivery_city"]}");
      print("   delivery_state: ${allCache["delivery_state"]}");
      print("   delivery_postal: ${allCache["delivery_postal"]}");
      print("   delivery_email: ${allCache["delivery_email"]}");
      print("   delivery_notes: ${allCache["delivery_notes"]}");
    } else {
      // Validate single-stop
      if (!_isFormFilled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please complete all form fields"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Save single-stop data to cache
      _saveSingleStopData();
    }

    // Navigate to next screen (ServicePaymentScreen)
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ServicePaymentScreen()),
    );
  }

  void _saveMultiStopData() {
    final cache = ref.read(orderCacheProvider.notifier);

    // Save stops count
    cache.saveValue("route_stops_count", routeStops.length.toString());

    // Save each stop
    for (int i = 0; i < routeStops.length; i++) {
      final stop = routeStops[i];
      final stopIndex = i + 1;
      cache.saveValue("stop_${stopIndex}_type", stop.stopType.toString());
      cache.saveValue("stop_${stopIndex}_contact_name", stop.contactName.text);
      cache.saveValue(
        "stop_${stopIndex}_contact_phone",
        stop.contactPhone.text,
      );
      cache.saveValue("stop_${stopIndex}_address", stop.address.text);
      cache.saveValue("stop_${stopIndex}_city", stop.city.text);
      cache.saveValue("stop_${stopIndex}_state", stop.state.text);
      cache.saveValue("stop_${stopIndex}_postal_code", stop.postalCode.text);
      cache.saveValue(
        "stop_${stopIndex}_contact_email",
        stop.contactEmail.text,
      );
      cache.saveValue("stop_${stopIndex}_notes", stop.notes.text);
      cache.saveValue("stop_${stopIndex}_quantity", stop.quantity.text);
      cache.saveValue("stop_${stopIndex}_weight", stop.weight.text);

      // ✅ ADD COORDINATES FOR EACH STOP
      // Yeh default coordinates hain, aap inhe dynamic bana sakte hain
      String lat = "-26.2041";
      String lng = "28.0473";

      // Agar city ke hisaab se different coordinates chahiye
      final city = stop.city.text.toLowerCase();
      if (city.contains("cape town")) {
        lat = "-33.9249";
        lng = "18.4241";
      } else if (city.contains("durban")) {
        lat = "-29.8587";
        lng = "31.0218";
      } else if (city.contains("pretoria")) {
        lat = "-25.7479";
        lng = "28.2293";
      }

      cache.saveValue("stop_${stopIndex}_latitude", lat);
      cache.saveValue("stop_${stopIndex}_longitude", lng);

      // cache.saveValue("stop_${stopIndex}_type", stop.stopType.toString());
      // cache.saveValue("stop_${stopIndex}_contact_name", stop.contactName.text);
      // cache.saveValue(
      //   "stop_${stopIndex}_contact_phone",
      //   stop.contactPhone.text,
      // );
      // cache.saveValue("stop_${stopIndex}_address", stop.address.text);
      // cache.saveValue("stop_${stopIndex}_city", stop.city.text);
      // cache.saveValue("stop_${stopIndex}_state", stop.state.text);
      // cache.saveValue("stop_${stopIndex}_postal_code", stop.postalCode.text);
      // cache.saveValue(
      //   "stop_${stopIndex}_contact_email",
      //   stop.contactEmail.text,
      // );
      // cache.saveValue("stop_${stopIndex}_notes", stop.notes.text);

      // ✅ IMPORTANT: Save to pickup/delivery cache for ServicePaymentScreen
      if (stop.stopType == StopType.pickup) {
        cache.saveValue("pickup_name", stop.contactName.text);
        cache.saveValue("pickup_phone", stop.contactPhone.text);
        cache.saveValue("pickup_address1", stop.address.text);
        cache.saveValue("pickup_city", stop.city.text);
        cache.saveValue("pickup_state", stop.state.text);
        cache.saveValue("pickup_postal", stop.postalCode.text);
        cache.saveValue("pickup_email", stop.contactEmail.text);
        cache.saveValue("pickup_notes", stop.notes.text);

        // Also save for backward compatibility
        cache.saveValue("contact_name", stop.contactName.text);
        cache.saveValue("contact_phone", stop.contactPhone.text);
      } else if (stop.stopType == StopType.dropOff) {
        cache.saveValue("delivery_name", stop.contactName.text);
        cache.saveValue("delivery_phone", stop.contactPhone.text);
        cache.saveValue("delivery_address1", stop.address.text);
        cache.saveValue("delivery_city", stop.city.text);
        cache.saveValue("delivery_state", stop.state.text);
        cache.saveValue("delivery_postal", stop.postalCode.text);
        cache.saveValue("delivery_email", stop.contactEmail.text);
        cache.saveValue("delivery_notes", stop.notes.text);

        // Also save for backward compatibility
        cache.saveValue("delivery_contact_name", stop.contactName.text);
        cache.saveValue("delivery_contact_phone", stop.contactPhone.text);
      }
    }
  }

  void _saveSingleStopData() {
    final cache = ref.read(orderCacheProvider.notifier);

    // ✅ Save pickup info - City aur State ko save karna zaroori hai
    cache.saveValue("pickup_name", contactnameController.text);
    cache.saveValue("pickup_phone", phoneController.text);
    cache.saveValue("pickup_address1", address1Controller.text);
    cache.saveValue("pickup_city", cityController.text.trim()); // ✅ Trim karein
    cache.saveValue(
      "pickup_state",
      stateController.text.trim(),
    ); // ✅ Trim karein
    cache.saveValue("pickup_email", emailController.text);
    cache.saveValue("pickup_notes", notesController.text);

    // ✅ Save delivery info
    cache.saveValue("delivery_name", contactnameDeliveryController.text);
    cache.saveValue("delivery_phone", phoneDeliveryController.text);
    cache.saveValue("delivery_address1", address1DeliveryController.text);
    cache.saveValue(
      "delivery_city",
      cityDeliveryController.text.trim(),
    ); // ✅ Trim
    cache.saveValue(
      "delivery_state",
      stateDeliveryController.text.trim(),
    ); // ✅ Trim
    cache.saveValue("delivery_email", emailDeliveryController.text);
    cache.saveValue("delivery_notes", notesDeliveryController.text);

    // ✅ DEBUG: Print what's being saved
    print("💾 Saving to cache:");
    print("Pickup City: ${cityController.text.trim()}");
    print("Pickup State: ${stateController.text.trim()}");
    print("Delivery City: ${cityDeliveryController.text.trim()}");
    print("Delivery State: ${stateDeliveryController.text.trim()}");

    // ✅ Save address2 and postal if available
    if (address2Controller.text.isNotEmpty) {
      cache.saveValue("pickup_address2", address2Controller.text);
    }
    if (postalController.text.isNotEmpty) {
      cache.saveValue("pickup_postal", postalController.text);
    }
    if (address2DeliveryController.text.isNotEmpty) {
      cache.saveValue("delivery_address2", address2DeliveryController.text);
    }
    if (postalDeliveryController.text.isNotEmpty) {
      cache.saveValue("delivery_postal", postalDeliveryController.text);
    }
  }

  // Add a new route stop
  void _addRouteStop() {
    setState(() {
      final newId = routeStops.length + 1;
      final newStop = RouteStop(
        id: newId,
        stopType: StopType.waypoint,
        contactName: TextEditingController(),
        contactPhone: TextEditingController(),
        address: TextEditingController(),
        city: TextEditingController(),
        state: TextEditingController(),
        postalCode: TextEditingController(),
        contactEmail: TextEditingController(),
        notes: TextEditingController(),
        quantity: TextEditingController(),
        weight: TextEditingController(),
      );

      routeStops.add(newStop);

      // Add listeners for new stop
      _addStopListeners(newStop, newId);
    });

    // Save to cache
    ref
        .read(orderCacheProvider.notifier)
        .saveValue("route_stops_count", routeStops.length.toString());

    // Check form after adding stop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFormFilled();
    });
  }

  void _addStopListeners(RouteStop stop, int index) {
    stop.contactName.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_contact_name", stop.contactName.text);
      _checkFormFilled();
    });

    stop.contactPhone.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_contact_phone", stop.contactPhone.text);
      _checkFormFilled();
    });
    stop.address.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_address", stop.address.text);
      _checkFormFilled();

      // Auto-set coordinates based on address
      _setStopCoordinates(stop.address.text, index);
    });

    stop.city.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_city", stop.city.text);
      _checkFormFilled();
    });

    stop.state.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_state", stop.state.text);
      _checkFormFilled();
    });

    stop.postalCode.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_postal_code", stop.postalCode.text);
      _checkFormFilled();
    });

    stop.contactEmail.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_contact_email", stop.contactEmail.text);
      _checkFormFilled();
    });

    stop.notes.addListener(() {
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${index}_notes", stop.notes.text);
      _checkFormFilled();
    });
  }

  void _setStopCoordinates(String address, int stopIndex) async {
    if (address.length < 3) return;

    try {
      final places = FlutterGooglePlacesSdk(
        "AIzaSyBrF_4PwauOkQ_RS8iGYhAW1NIApp3IEf0",
      );
      final predictions = await places.findAutocompletePredictions(
        address,
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
        // Use default coordinates
        lat = -26.2041;
        lng = 28.0473;
      }

      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${stopIndex}_latitude", lat.toString());
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${stopIndex}_longitude", lng.toString());
    } catch (e) {
      // Use default coordinates on error
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${stopIndex}_latitude", "-26.2041");
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("stop_${stopIndex}_longitude", "28.0473");
    }
  }

  // Remove a route stop
  void _removeRouteStop(int index) {
    if (routeStops.length > 2) {
      // Keep at least 2 stops
      setState(() {
        // Dispose controllers of the removed stop
        final removedStop = routeStops[index];
        removedStop.contactName.dispose();
        removedStop.contactPhone.dispose();
        removedStop.address.dispose();
        removedStop.city.dispose();
        removedStop.state.dispose();
        removedStop.postalCode.dispose();
        removedStop.contactEmail.dispose();
        removedStop.notes.dispose();

        routeStops.removeAt(index);

        // Reassign IDs
        for (int i = 0; i < routeStops.length; i++) {
          routeStops[i].id = i + 1;
        }
      });

      // Update cache
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("route_stops_count", routeStops.length.toString());

      _checkFormFilled();
    }
  }

  // Toggle multi-stop - UPDATED
  void _toggleMultiStop(bool value) {
    setState(() {
      isMultiStopEnabled = value;

      // Save to cache
      ref
          .read(orderCacheProvider.notifier)
          .saveValue("is_multi_stop_enabled", value.toString());

      if (value && routeStops.isEmpty) {
        // Initialize with 2 stops
        _initializeMultiStop();
      }
    });

    // Check form after toggle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFormFilled();
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
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
    emailController.dispose();
    notesController.dispose();

    contactnameDeliveryController.dispose();
    phoneDeliveryController.dispose();
    address1DeliveryController.dispose();
    address2DeliveryController.dispose();
    cityDeliveryController.dispose();
    stateDeliveryController.dispose();
    postalDeliveryController.dispose();
    emailDeliveryController.dispose();
    notesDeliveryController.dispose();

    weightController.dispose();
    quantityController.dispose();
    declaredValueController.dispose();

    // Dispose route stop controllers
    for (final stop in routeStops) {
      stop.contactName.dispose();
      stop.contactPhone.dispose();
      stop.address.dispose();
      stop.city.dispose();
      stop.state.dispose();
      stop.postalCode.dispose();
      stop.contactEmail.dispose();
      stop.notes.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color inactiveColor = Colors.transparent;
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Multi-Stop Toggle Container
                        _buildMultiStopToggleContainer(),

                        gapH20,

                        if (!isMultiStopEnabled) ...[
                          // Single Stop UI
                          _sectionTitle("PICKUP LOCATION"),
                          gapH8,
                          _defaultAddressSection(),
                          gapH20,
                          _sectionTitle("DELIVERY LOCATION"),
                          gapH8,
                          _deliveryAddressSection(),
                        ] else ...[
                          // Multi-Stop UI
                          _buildMultiStopUI(),
                        ],

                        gapH16,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Continue Button at Bottom
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.electricTeal)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: CustomButton(
                text: "Next",
                backgroundColor: _isFormFilled
                    ? AppColors.electricTeal
                    : inactiveColor,
                borderColor: AppColors.electricTeal,
                textColor: _isFormFilled
                    ? AppColors.pureWhite
                    : AppColors.electricTeal,

                // backgroundColor: _isFormFilled
                //     ? AppColors.electricTeal
                //     : Colors.transparent,
                // borderColor: _isFormFilled ? AppColors.electricTeal : Colors.grey,
                // textColor: Colors.white,
                onPressed: _isFormFilled ? _onNextPressed : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Multi-Stop Switch Toggle Container
  Widget _buildMultiStopToggleContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enable Multi-Stop Route?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Add multiple pickup/delivery points for this order",
                    style: TextStyle(fontSize: 10, color: AppColors.mediumGray),
                  ),
                ],
              ),
              Flexible(
                child: Switch(
                  value: isMultiStopEnabled,
                  onChanged: _toggleMultiStop,
                  activeColor: AppColors.electricTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Multi-Stop UI
  Widget _buildMultiStopUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle("Route Stops"),
            ElevatedButton.icon(
              onPressed: _addRouteStop,
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Add Stop"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        gapH8,
        ...routeStops.asMap().entries.map((entry) {
          final index = entry.key;
          final stop = entry.value;
          return _buildRouteStopCard(stop, index);
        }).toList(),
      ],
    );
  }

  // Route Stop Card - UPDATED with onChanged
  Widget _buildRouteStopCard(RouteStop stop, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
              Text(
                "Stop ${stop.id}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              if (routeStops.length > 2)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed: () => _removeRouteStop(index),
                ),
            ],
          ),
          gapH16,

          // Stop Type Dropdown - UPDATED with onChanged
          _buildStopTypeDropdown(stop),
          gapH24,

          // Contact Name and Phone - UPDATED with onChanged
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: stop.contactName,
                  label: "Contact Name*",
                  icon: Icons.person,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  controller: stop.contactPhone,
                  label: "Contact Phone*",
                  icon: Icons.phone,
                  isNumber: true,
                ),
              ),
            ],
          ),
          // gapH8,

          // Address - UPDATED with onChanged
          _buildTextField(
            controller: stop.address,
            label: "Address*",
            icon: Icons.location_on,
          ),
          // gapH8,

          // City and State - UPDATED with onChanged
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: stop.city,
                  label: "City*",
                  icon: Icons.location_city,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  controller: stop.state,
                  label: "State/Province*",
                  icon: Icons.map,
                ),
              ),
            ],
          ),
          // gapH8,

          // Postal Code and Email - UPDATED with onChanged
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: stop.postalCode,
                  label: "Postal Code",
                  icon: Icons.numbers,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTextField(
                  controller: stop.contactEmail,
                  label: "Contact Email",
                  icon: Icons.email,
                ),
              ),
            ],
          ),
          // gapH8,

          // Notes - UPDATED with onChanged
          _buildTextField(
            controller: stop.notes,
            label: "Notes / Special Instructions",
            icon: Icons.note,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // Stop Type Dropdown - UPDATED with onChanged
  Widget _buildStopTypeDropdown(RouteStop stop) {
    final stopTypes = StopType.values;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Stop Type*",
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mediumGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),

        // Modal popup style dropdown
        DropDownContainer(
          fw: FontWeight.normal,
          dialogueScreen: MaterialConditionPopupLeftIcon(
            title: stop.stopType.displayName,
            conditions: stopTypes.map((type) => type.displayName).toList(),
            initialSelectedIndex: stopTypes.indexOf(stop.stopType),
            enableSearch: stopTypes.length > 10, // Enable search if many items
          ),
          text: stop.stopType.displayName,
          onItemSelected: (value) {
            final selectedStopType = StopType.values.firstWhere(
              (type) => type.displayName == value,
            );

            setState(() {
              stop.stopType = selectedStopType;
            });

            // Save to cache
            ref
                .read(orderCacheProvider.notifier)
                .saveValue("stop_${stop.id}_type", selectedStopType.toString());

            // Check form
            _checkFormFilled();
          },
        ),
      ],
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

  // Single Stop Pickup Address Section
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapH12,
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: contactnameController,
                  label: "Contact Name*",
                  icon: Icons.person,
                ),
              ),
              gapW4,
              Expanded(
                child: _buildTextField(
                  controller: phoneController,
                  label: "Contact Phone*",
                  icon: Icons.phone_android,
                  isNumber: true,
                ),
              ),
            ],
          ),
          // gapH8,
          _buildTextField(
            controller: address1Controller,
            label: "Pickup Address*",
            icon: Icons.location_on,
          ),
          // gapH8,
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: cityController,
                  label: "City*",
                  icon: Icons.location_city_outlined,
                ),
              ),
              gapW4,
              Expanded(
                child: _buildTextField(
                  controller: stateController,
                  label: "State/Province*",
                  icon: Icons.map_outlined,
                ),
              ),
            ],
          ),
          // gapH8,
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: postalController,
                  label: "Postal Code",
                  icon: Icons.numbers,
                  isNumber: true,
                ),
              ),
              gapW4,
              Expanded(
                child: _buildTextField(
                  controller: emailController,
                  label: "Contact Email",
                  icon: Icons.email,
                ),
              ),
            ],
          ),
          // gapH8,
          _buildTextField(
            controller: notesController,
            label: "Notes / Special Instructions",
            icon: Icons.note,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // Single Stop Delivery Address Section
  Widget _deliveryAddressSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            children: [
              Expanded(
                child: _buildTextField(
                  controller: contactnameDeliveryController,
                  label: "Contact Name*",
                  icon: Icons.person,
                ),
              ),
              gapW4,
              Expanded(
                child: _buildTextField(
                  controller: phoneDeliveryController,
                  label: "Contact Phone*",
                  icon: Icons.phone_android,
                  isNumber: true,
                ),
              ),
            ],
          ),
          // gapH8,
          _buildTextField(
            controller: address1DeliveryController,
            label: "Delivery Address*",
            icon: Icons.location_on,
          ),
          // gapH8,
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: cityDeliveryController,
                  label: "City*",
                  icon: Icons.location_city_outlined,
                ),
              ),
              gapW4,
              Expanded(
                child: _buildTextField(
                  controller: stateDeliveryController,
                  label: "State/Province*",
                  icon: Icons.map_outlined,
                ),
              ),
            ],
          ),
          // gapH8,
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: postalDeliveryController,
                  label: "Postal Code",
                  icon: Icons.numbers,
                  isNumber: true,
                ),
              ),
              gapW4,
              Expanded(
                child: _buildTextField(
                  controller: emailDeliveryController,
                  label: "Contact Email",
                  icon: Icons.email,
                ),
              ),
            ],
          ),
          // gapH8,
          _buildTextField(
            controller: notesDeliveryController,
            label: "Notes / Special Instructions",
            icon: Icons.note,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
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
      onChanged: (value) {
        // Trigger form validation for single stop fields too
        _checkFormFilled();
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.darkText,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Route Stop Model
class RouteStop {
  int id;
  StopType stopType;
  TextEditingController contactName;
  TextEditingController contactPhone;
  TextEditingController address;
  TextEditingController city;
  TextEditingController state;
  TextEditingController postalCode;
  TextEditingController contactEmail;
  TextEditingController notes;
  TextEditingController quantity;
  TextEditingController weight;

  RouteStop({
    required this.id,
    required this.stopType,
    required this.contactName,
    required this.contactPhone,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.contactEmail,
    required this.notes,
    required this.quantity,
    required this.weight,
  });
}

// Stop Type Enum
enum StopType {
  pickup('Pickup'),
  waypoint('Waypoint'),
  dropOff('Drop-off');

  final String displayName;
  const StopType(this.displayName);
}
