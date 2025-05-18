import 'dart:convert';
import 'package:assistantstroke/controler/device_list_controller.dart';
import 'package:assistantstroke/model/user_gps_request.dart';
import 'package:assistantstroke/page/main_home/home_map/location_service.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserGpsController {
  final String url = ApiEndpoints.user_gps;

  Future<bool> sendUserGps() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    if (token == null || userId == null) {
      print("Token hoặc userId không hợp lệ");
      return false;
    }
    Position userLocation = await LocationService.getUserLocation();
    print(
      "📍 Vị trí hiện tại: ${userLocation.latitude}, ${userLocation.longitude}",
    );
    final lat = userLocation.latitude;
    final long = userLocation.longitude;
    // final prefs = await SharedPreferences.getInstance();
    final deviceController = DeviceController();

    final devices = await deviceController.getDevices(userId);
    // if (devices.isEmpty) {
    //   print("Không có thiết bị nào được kết nối");
    //   return false;
    // }
    // Cho phép devices null hoặc rỗng vẫn chạy
    final deviceId =
        (devices?.isNotEmpty ?? false) ? devices.first.deviceId : 0;

    final request = UserGpsRequest(
      userId: userId,
      deviceId: deviceId,
      lat: lat,
      long: long,
      readingValue: 0,
      recordedAt: DateTime.now(),
    );
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode(request.toJson()),
      );
      print("Gửi vị trí: ${request.toJson()}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Gửi thành công: ${response.body}");
        return true;
      } else {
        print("Gửi thất bại: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi khi gửi vị trí: $e");
      return false;
    }
  }
}
