import 'dart:convert';

import 'package:assistantstroke/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewChangePassword {
  late SharedPreferences prefs;

  final String password;
  final String passwordnew;

  // Constructor nhận username và password
  NewChangePassword({required this.password, required this.passwordnew});
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance(); // Lấy SharedPreferences
  }

  Future<bool> forgot(BuildContext context) async {
    await init();
    final String url = ApiEndpoints.change;
    // final String token;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      // print('🔄 Đang gửi đổi mật khẩu với: $email');

      final response = await http.put(
        Uri.parse(url),
        body: jsonEncode({
          'currentPassword': password,
          'newPassword': passwordnew,
        }),
        // headers: {'Content-Type': 'application/json'},
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔍 Response Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Đổi pass thành công');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công!')),
        );
        return true;
      } else if (response.statusCode == 401) {
        print('❌ Sai mật khẩu cũ!');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('otp không tồn tại!')));
        return false;
      } else {
        print('⚠️ Lỗi không xác định!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi máy chủ, thử lại sau!')),
        );
        return false;
      }
    } catch (error) {
      print('🚨 Lỗi kết nối API: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể kết nối tới server!')),
      );
      return false;
    }
  }
}
