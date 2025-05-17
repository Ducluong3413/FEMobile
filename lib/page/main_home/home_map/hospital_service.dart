import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class HospitalService {
  static Future<List<Map<String, dynamic>>> getNearbyHospitals(
    double lat,
    double lon,
  ) async {
    String url =
        "https://nominatim.openstreetmap.org/search?format=json&q=hospital&bounded=1&limit=10&viewbox=${lon - 0.1},${lat + 0.1},${lon + 0.1},${lat - 0.1}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "User-Agent":
            "YourAppName (tranduckhoinguyen3413@email.com)", // Cần User-Agent để tránh bị block
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((hospital) {
        return {
          "name": hospital["display_name"],
          "lat": double.parse(hospital["lat"]),
          "lon": double.parse(hospital["lon"]),
        };
      }).toList();
    } else {
      throw Exception("Không thể lấy danh sách bệnh viện");
    }
  }

  static double calculateDistance(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon) /
        1000; // Chuyển sang Km
  }
}
