import 'dart:convert';

import 'package:http/http.dart' as http;

class PincodeService {
  static Future<Map<String, String>?> getAddressFromPincode(
      String pincode,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.postalpincode.in/pincode/$pincode',
        ),
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      if (data is! List || data.isEmpty) {
        return null;
      }

      final result = data.first;

      if (result["Status"] != "Success") {
        return null;
      }

      final offices = result["PostOffice"];

      if (offices == null || offices.isEmpty) {
        return null;
      }

      final office = offices.first;

      return {
        "area": office["Name"] ?? "",
        "city": office["District"] ?? "",
        "state": office["State"] ?? "",
      };
    } catch (e) {
      return null;
    }
  }
}
