import 'dart:convert';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String patientName;
  String dateOfBirth; // Giữ nguyên là String vì bạn cần lưu cả thời gian
  bool gender;

  User({
    required this.patientName,
    required this.dateOfBirth,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      patientName: json['patientName'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '', // Chắc chắn là dạng ISO 8601
      gender: json['gender'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    };
  }

  // Getter cho ngày sinh đã được format lại
  String? get formattedDob {
    return _formatDob(dateOfBirth); // Trả về ngày đã định dạng nếu hợp lệ
  }

  // Hàm định dạng ngày với phần giờ
  String? _formatDob(String dob) {
    try {
      DateTime parsedDate = DateTime.parse(
        dob,
      ); // Đảm bảo là dạng ISO 8601 với thời gian
      return parsedDate.toIso8601String(); // Trả về đầy đủ giờ và phút
    } catch (e) {
      print('Lỗi khi parse ngày sinh: $e');
      return null; // Trả về null nếu không parse được
    }
  }
}

class UserController {
  Future<User> fetchUser() async {
    final String baseUrl = ApiEndpoints.profile;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt(
      'userId',
    ); // Hoặc getString nếu userId là string
    final token = prefs.getString('token');

    final Uri url = Uri.parse('$baseUrl/$userId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return User.fromJson(data);
    } else {
      throw Exception('Không thể tải thông tin người dùng');
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token'); // 👈 đổi nếu bạn dùng key khác
      print(token);
      if (token == null) {
        print('Không tìm thấy token!');
        return false;
      }

      final Uri url = Uri.parse(ApiEndpoints.update_basic_info);
      print(url);
      print(user.toJson());
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Lỗi cập nhật: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi kết nối khi cập nhật: $e');
      return false;
    }
  }
}
