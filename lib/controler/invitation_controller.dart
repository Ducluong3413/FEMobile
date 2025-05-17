import 'dart:convert';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InvitationController {
  Future<Map<String, String>> createInvitation() async {
    final String baseUrl = ApiEndpoints.create_invitation;

    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      return {"message": "Không tìm thấy userId!", "code": ""};
    }

    final url = Uri.parse('$baseUrl?userId=$userId');

    final response = await http.post(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: '', // Theo yêu cầu là rỗng
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return {
        "message": data["message"] ?? "Tạo lời mời thành công!",
        "code": data["code"] ?? "",
      };
    } else {
      return {"message": "Tạo lời mời thất bại!", "code": ""};
    }
  }

  Future<Map<String, String>> submitInvitation(String code) async {
    final String baseUrl = ApiEndpoints.use_invitation;
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      return {"message": "Không tìm thấy userId!", "code": ""};
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
        body: jsonEncode({'userId': userId, 'code': code}),
      );
      print('Response Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return {"message": "Lời mời được chấp nhận!"};
      } else if (response.statusCode == 400) {
        return {"message": "Mối quan hệ đã tồn tại!"};
      } else {
        return {"message": "'Gửi lời mời thất bại!'"};
      }
    } catch (e) {
      return {"message": "''Đã xảy ra lỗi kết nối: $e'"};
    }
  }
}
