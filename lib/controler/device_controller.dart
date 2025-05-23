// import 'package:assistantstroke/services/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/material.dart';

// class DeviceController {
//   static Future<void> submitDeviceInfo({
//     required BuildContext context,
//     required String deviceName,
//     required String deviceType,
//     required String series,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     final url = ApiEndpoints.add_devices;
//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('User ID không tồn tại trong SharedPreferences'),
//         ),
//       );
//       return;
//     }

//     final data = {
//       'userId': userId,
//       'deviceName': deviceName,
//       'deviceType': deviceType,
//       'series': series,
//     };

//     try {
//       final response = await http.post(
//         Uri.parse('$url'),

//         // Uri.parse('http://localhost:5062/api/Devices/add-device'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${prefs.getString('token')}',
//         },
//         body: jsonEncode(data),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Gửi thông tin thiết bị thành công')),
//         );
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Lỗi: ${response.statusCode}')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
//     }
//   }
// }
import 'package:assistantstroke/helper/notification_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:assistantstroke/page/main_home/home_map/location_service.dart';
import 'package:assistantstroke/controler/device_list_controller.dart';

class DeviceController {
  Future<List<Device>> getDevices(final userId) async {
    final baseUrl = ApiEndpoints.get_devices;
    final prefs = await SharedPreferences.getInstance();
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

      if (body.isEmpty) {
        return [];
      }

      try {
        final Map<String, dynamic> decoded = jsonDecode(body);

        if (decoded.containsKey('devices') && decoded['devices'] is List) {
          final List<dynamic> devicesJson = decoded['devices'];

          return devicesJson.map((e) => Device.fromJson(e)).toList();
        } else {
          print('Không tìm thấy key devices hoặc không phải danh sách');
          return [];
        }
      } catch (e) {
        print('Lỗi parse JSON: $e');
        return [];
      }
    } else {
      return [];
    }
  }

  static Future<void> submitDeviceInfo({
    required BuildContext context,
    required String deviceName,
    required String deviceType,
    required String series,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final token = prefs.getString('token');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User ID không tồn tại trong SharedPreferences'),
        ),
      );
      return;
    }

    final data = {
      'userId': userId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'series': series,
    };

    try {
      final url = ApiEndpoints.add_devices;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi thông tin thiết bị thành công')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
    }
  }

  static Future<void> submitMedicalData({
    required BuildContext context,
    required String series,
    required double? systolicPressure,
    required double? diastolicPressure,
    required double? temperature,
    required double? bloodPh,
    required double? spo2Information,
    required double? heartRate,
  }) async {
    //Cảnh báo khẩn cấp khi nhấn button
    if (systolicPressure == 0 &&
        diastolicPressure == 0 &&
        temperature == 0 &&
        bloodPh == 0 &&
        spo2Information == 0 &&
        heartRate == 0) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);
      final userId = prefs.getInt('userId');
      Position userLocation = await LocationService.getUserLocation();
      final data = {
        'userId': userId,
        'latitude': userLocation.latitude,
        'longitude': userLocation.longitude,
        'additionalInfo': " Cần cấp cứu y tế ngay lập tức",
      };
      try {
        final response = await http.post(
          Uri.parse(ApiEndpoints.emergencyButton),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gửi thông tin cấp cứu thành công')),
          );
          // await NotificationHelper.showNotification(
          //   title: '🚨 Cảnh báo khẩn cấp',
          //   body: 'Thông tin cấp cứu đã được gửi đến hệ thống',
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print("Lôi xử lý lỗi: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
      }
    }

    //Gửi dữ liệu sức khỏe ảo
    if (systolicPressure == 1.0 &&
        diastolicPressure == 1.0 &&
        temperature == 1.0 &&
        bloodPh == 1.0 &&
        spo2Information == 1.0 &&
        heartRate == 1.0) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);
      final userId = prefs.getInt('userId');
      Position userLocation = await LocationService.getUserLocation();
      final cotroller = DeviceController();
      final device = await cotroller.getDevices(userId);
      final data = {
        "userId": userId,
        "deviceId": int.parse(device[0].deviceId.toString()),
        "measurements": {
          "temperature": 33,
          "heartRate": 50,
          "systolicPressure": 110,
          "diastolicPressure": 70,
          "spO2": 80,
          "bloodPH": 7,
        },
        "gps": {
          "lat": userLocation.latitude,
          "long": userLocation.longitude,
          "timestamp": DateTime.now().toIso8601String(),
        },
        "recordedAt": DateTime.now().toIso8601String(),
      };

      try {
        final url = ApiEndpoints.postWarning;
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gửi thông tin cảnh báo thành công')),
          );
          // await NotificationHelper.showNotification(
          //   title: '⚠️ Cảnh báo sức khỏe',
          //   body: 'Dữ liệu bất thường đã được gửi đi',
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
      }
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final data = {
      'series': series,
      'systolicPressure': systolicPressure,
      'diastolicPressure': diastolicPressure,
      'temperature': temperature,
      'bloodPh': bloodPh,
      'recordedAt': DateTime.now().toIso8601String(),
      'spo2Information': spo2Information,
      'heartRate': heartRate,
    };

    try {
      final url = ApiEndpoints.postMedicalData;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi dữ liệu sức khỏe thành công')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: ${response.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
    }
  }
}
