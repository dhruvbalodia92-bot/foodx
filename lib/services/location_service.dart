import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Map<String, String>?> getCurrentAddress() async {
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) return null;

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition();
    print("LAT: ${position.latitude}, LNG: ${position.longitude}");

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}",
    );

    final response = await http.get(
      url,
      headers: {
        "User-Agent": "FoodX/1.0",
      },
    );

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    final address = data["address"] ?? {};

    return {
      "house": (address["house_number"] ?? "").toString(),
      "area": (address["suburb"] ??
          address["neighbourhood"] ??
          address["village"] ??
          "")
          .toString(),
      "city": (address["city"] ??
          address["town"] ??
          address["county"] ??
          "")
          .toString(),
      "state": (address["state"] ?? "").toString(),
      "pincode": (address["postcode"] ?? "").toString(),
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
    };
  }
}