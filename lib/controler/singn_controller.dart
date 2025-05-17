import 'dart:convert';

import 'package:assistantstroke/page/forget_password/home_otp.dart';
// import 'package:assistantstroke/page/login/home_login.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignController {
  late SharedPreferences prefs;

  final String username;
  final String password;
  final String email;
  final String phone;
  final String dob;
  final String sex;

  SignController({
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.dob,
    required this.sex,
  });

  // bool _isLoading = false;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance(); // Lấy SharedPreferences
  }

  Future<void> sign(BuildContext context) async {
    await init();
    final String url = ApiEndpoints.register;

    try {
      print(
        '🔄 Đang gửi request đăng ký với: ten $username / $password / $sex / $dob / email $email / $phone ',
      );

      // Chuyển DateOfBirth thành chuỗi yyyy-MM-dd
      String formattedDob = DateTime.parse(dob).toIso8601String().split('T')[0];

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "Username": email,
          "Password": password,
          // "Role": "User",
          "Email": email,
          "Phone": phone,
          "PatientName": username,
          "DateOfBirth": formattedDob, // Định dạng đúng yyyy-MM-dd
          "Gender":
              sex == "true", // Nếu sex là "Male" thì true, ngược lại false
        }),
        headers: {'Content-Type': 'application/json'},
      );

      print('🔍 Response Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeOtp(
                  username: username,
                  email: email,
                  phone: phone,
                  password: password,
                  dob: dob,
                  sex: sex,
                ),
          ),
        );
        print('✅ Đã gửi mã đến gmail');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('✅ Đã gửi mã đến gmail!')));
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeOtp()),
        // );
      } else if (response.statusCode == 400) {
        print('❌ Tài khoản đã tồn tại!');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Tài khoản đã tồn tại!')));
      } else {
        print('⚠️ Lỗi không xác định! Status Code: ${response.statusCode}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi máy chủ, thử lại sau!')));
      }
    } catch (error) {
      print('🚨 Lỗi kết nối API: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể kết nối tới server!')));
    }
  }
}
