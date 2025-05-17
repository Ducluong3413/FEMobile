import 'dart:convert';

import 'package:assistantstroke/page/login/home_login.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpController {
  final String otp;
  final String username;
  final String email;
  final String phone;
  final String password;
  final String dob;
  final String sex;

  OtpController({
    required this.otp,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.dob,
    required this.sex,
  });

  Future<void> Otp(BuildContext context) async {
    final String url = ApiEndpoints.verifyOtp; //otpc

    try {
      print(
        '🔄 Đang gửi request đăng ký với: otp: $otp, phone: $phone, email: $email, username: $username',
      );
      String formattedDob = DateTime.parse(dob).toIso8601String().split('T')[0];

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "patientName": username,
          "dateOfBirth": formattedDob,
          "gender": sex == "Male",
          "phone": phone,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('✅ Đăng ký thành công');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('✅ Đăng ký thành công!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeLogin()),
        );
      } else if (response.statusCode == 400) {
        print('❌ sai otp!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ sai otp, vui lòng nhập lại!')),
        );
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
