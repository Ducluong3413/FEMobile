import 'dart:convert';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Device {
  final int deviceId;
  final String deviceName;
  final String deviceType;
  final String series;

  Device({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.series,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId'],
      deviceName: json['deviceName'],
      deviceType: json['deviceType'],
      series: json['series'],
    );
  }
}

class DeviceController {
  Future<List<Device>> getDevices(final userId) async {
    final baseUrl = ApiEndpoints.get_devices;
    final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getInt('userId');
    final token = prefs.getString('token');

    if (userId == null) return [];

    final url = Uri.parse('$baseUrl/$userId');
    print(url);
    final res = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(res.body);

    if (res.statusCode == 200) {
      final body = res.body.trim();

      if (body == '[]') {
        // Trường hợp không có thiết bị nào
        return [];
      }

      try {
        final List<dynamic> json = jsonDecode(body);
        return json.map((e) => Device.fromJson(e)).toList();
      } catch (e) {
        // Trường hợp body không đúng định dạng JSON danh sách
        print('Lỗi parse JSON: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  Future<bool> deleteDevice(int deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final baseUrl = ApiEndpoints.delete_devices;
    print(deviceId);

    final url = Uri.parse('$baseUrl/$deviceId');
    final res = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(res.statusCode);
    return res.statusCode == 200;
  }
}
