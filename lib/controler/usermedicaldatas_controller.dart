import 'dart:convert';
import 'package:assistantstroke/model/UserMedicalDataResponse.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;

class UserMedicalDataController {
  Future<UserMedicalDataResponse> fetchUserMedicalData(int deviceId) async {
    final String url = '${ApiEndpoints.averageAll14Day}$deviceId';

    final response = await http.get(Uri.parse(url));
    // print('Status: ${response.statusCode}');
    // print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserMedicalDataResponse.fromJson(jsonData);
    } else {
      throw Exception('Lỗi khi tải dữ liệu: ${response.statusCode}');
    }
  }
}
