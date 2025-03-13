import 'dart:convert';

import 'package:http/http.dart' as http;

class GoogleGeocodingService {
  static const String _apiKey = "AIzaSyBYLi9lWPXZGRT6uYuW813v2Mxt-NJ9FoM"; // Replace with your API Key

  static Future<String> getAddressFromCoordinates(double lat, double lng) async {
    final String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == "OK" && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address']; // First result is most relevant
        } else {
          return "Address not found";
        }
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error fetching address";
    }
  }
}
