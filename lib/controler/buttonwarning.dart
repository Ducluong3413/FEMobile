import 'package:assistantstroke/model/warning_request.dart';
import 'package:assistantstroke/page/main_home/home_map/location_service.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ButtonWarning {
  Future<void> sendWarning() async {
    final url = ApiEndpoints.send_warning;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    try {
      Position position = await LocationService.getUserLocation();
      final request = WarningRequest(
        userId: userId!,
        latitude: position.latitude,
        longitude: position.longitude,
        additionalInfo: 'Người dùng có tỷ lệ đột quỵ cao',
      );
      final response = await http.post(
        // url,
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        print("Gửi cảnh báo thành công");
      } else {
        print(
          "Lỗi khi gửi cảnh báo: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("Lỗi kết nối khi gửi cảnh báo: $e");
    }
  }
}
