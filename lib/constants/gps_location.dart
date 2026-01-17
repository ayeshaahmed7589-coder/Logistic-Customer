import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Position> getCurrentPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

Future<String> getCityFromGoogle(Position position) async {
  final apiKey = "AIzaSyBrF_4PwauOkQ_RS8iGYhAW1NIApp3IEf0";
  final url =
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final results = data['results'] as List;
      if (results.isNotEmpty) {
        final components = results[0]['address_components'] as List;
        for (var comp in components) {
          final types = comp['types'] as List;
          if (types.contains('locality')) {
            return comp['long_name']; // This is your city
          }
        }
      }
    }
  }
  return "Unknown city";
}

Future<String> getCurrentCity() async {
  try {
    Position position = await getCurrentPosition();
    String city = await getCityFromGoogle(position);
    return city;
  } catch (e) {
    print("Error fetching city: $e");
    return "Unknown city";
  }
}
