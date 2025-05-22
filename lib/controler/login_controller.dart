import 'dart:convert';
import 'package:assistantstroke/page/main_home/home_navbar.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  late SharedPreferences prefs;
  final String username;
  final String password;

  // Constructor nhận username và password
  LoginController({required this.username, required this.password});

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance(); // Lấy SharedPreferences
  }

  // Future<void> login(BuildContext context) async {
  //   await init(); // Đảm bảo SharedPreferences được khởi tạo
  //   // final String url = 'http://localhost:5062/api/User/login';
  //   final String url = ApiEndpoints.login;

  //   try {
  //     print('🔄 Đang gửi request đăng nhập với: $username / $password');

  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: jsonEncode({'credential': username, 'password': password}),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     print('🔍 Response Code: ${response.statusCode}');
  //     print('📩 Response Body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       try {
  //         final Map<String, dynamic> json = jsonDecode(response.body);
  //         final token = json['data']['token'];
  //         final userId = json['data']['userId'];

  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('token', token);
  //         await prefs.setInt('userId', userId);
  //         print('🔑 Token: $token');
  //         print('🆔 UserId: $userId');
  //         print('✅ Đăng nhập thành công, token đã được lưu');

  //         Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (context) => HomeNavbar()),
  //           (Route<dynamic> route) => false, // Xóa toàn bộ stack cũ
  //         );
  //       } catch (e) {
  //         print('❌ Lỗi khi decode JSON: $e');
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Lỗi xử lý phản hồi từ server!')),
  //         );
  //       }
  //     } else if (response.statusCode == 401) {
  //       print('${response.body}');
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('${response.body}')));
  //     } else {
  //       print('⚠️ Lỗi không xác định! Status Code: ${response.statusCode}');
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('Lỗi máy chủ, thử lại sau!')));
  //     }
  //   } catch (error) {
  //     print('🚨 Lỗi kết nối API: $error');
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Không thể kết nối tới server!')));
  //   }
  // }
  Future<bool> login(BuildContext context) async {
    await init();
    final String url = ApiEndpoints.login;

    try {
      print('🔄 Đang gửi request đăng nhập với: $username / $password');

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'credential': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      print('🔍 Response Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> json = jsonDecode(response.body);
          final token = json['data']['token'];
          final userId = json['data']['userId'];

          await prefs.setString('token', token);
          await prefs.setInt('userId', userId);
          print('✅ Đăng nhập thành công, token đã được lưu');

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeNavbar()),
            (Route<dynamic> route) => false,
          );

          return true;
        } catch (e) {
          print('❌ Lỗi khi decode JSON: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lỗi xử lý phản hồi từ server!')),
          );
          return false;
        }
      } else if (response.statusCode == 401) {
        print('${response.body}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${response.body}')));
        return false;
      } else {
        print('⚠️ Lỗi không xác định! Status Code: ${response.statusCode}');
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
