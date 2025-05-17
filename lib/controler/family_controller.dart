import 'dart:convert';

import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FamilyMember {
  final String name;
  final int relationshipId;
  final String email;
  final String relationshipType;
  final int id;

  FamilyMember({
    required this.name,
    required this.relationshipId,
    required this.email,
    required this.relationshipType,
    required this.id,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['userId'] ?? 0,
      relationshipId: json['relationshipId'] ?? '',
      name: json['nameInviter'] ?? '',
      email: json['emailInviter'] ?? '',
      relationshipType: json['relationshipType'] ?? '',
    );
  }
}

class FamilyController {
  Future<List<FamilyMember>> getFamilyMembers() async {
    final String url = ApiEndpoints.get_elationship;

    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');
    final token = prefs.getString('token');

    if (userId == null) {
      throw Exception('Không tìm thấy userId trong bộ nhớ!');
    }

    final baseUrl = Uri.parse("$url?userId=$userId");

    final response = await http.get(
      baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => FamilyMember.fromJson(item)).toList();
    }
    if (response.statusCode == 401) {
      throw Exception('Token không hợp lệ hoặc đã hết hạn.');
    } else if (response.statusCode == 403) {
      throw Exception('Không có quyền truy cập vào tài nguyên này.');
    } else if (response.statusCode == 404) {
      throw Exception('Tài nguyên không tìm thấy.');
    } else if (response.statusCode == 500) {
      throw Exception('Lỗi máy chủ nội bộ.');
    } else {
      throw Exception('Không thể tải danh sách người nhà');
    }
  }

  // class FamilyController {
  //   Future<List<FamilyMember>> getFamilyMembers() async {
  //     await Future.delayed(const Duration(seconds: 1));
  //     return [
  //       FamilyMember(
  //         name: 'Nguyễn Văn A',
  //         email: 'a@example.com',
  //         relationshipType: 'Cha',
  //       ),
  //       FamilyMember(
  //         name: 'Trần Thị B',
  //         email: 'b@example.com',
  //         relationshipType: 'Mẹ',
  //       ),
  //       FamilyMember(
  //         name: 'Lê Văn C',
  //         email: 'c@example.com',
  //         relationshipType: 'Anh trai',
  //       ),
  //     ];
  //   }

  Future<bool> deleteFamilyMember(FamilyMember member) async {
    final String url = ApiEndpoints.delete_relationship;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    int Id = member.relationshipId;
    final baseUrl = Uri.parse("$url\$$Id");
    final response = await http.delete(
      baseUrl,
      headers: {
        'accept': '*/*',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Đã xoá thành viên: ${member.name}");
      return true;
    } else {
      print(response.statusCode);
      throw Exception('Không thể xoá thành viên');
    }
  }
}
