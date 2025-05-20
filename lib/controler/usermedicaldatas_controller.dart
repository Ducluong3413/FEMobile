import 'dart:convert';
import 'package:assistantstroke/model/UserMedicalDataResponse.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserMedicalDataController {
  Future<UserMedicalDataResponse> fetchUserMedicalData(int deviceId) async {
    final String url = '${ApiEndpoints.averageAll14Day}$deviceId';
    print('URL: $url');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return UserMedicalDataResponse.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy dữ liệu (404)');
      } else if (response.statusCode == 401) {
        throw Exception('Không được phép truy cập (401 - Unauthorized)');
      } else {
        throw Exception(
          'Lỗi không xác định khi tải dữ liệu: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Lỗi khi gọi API: $e');
      throw Exception('Lỗi kết nối đến server hoặc xử lý dữ liệu');
    }
  }
}
