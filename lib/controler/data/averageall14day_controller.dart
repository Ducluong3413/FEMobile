import 'package:assistantstroke/controler/device_list_controller.dart';
import 'package:assistantstroke/model/averageall14daynew.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RemoteService {
  Future<AverageAll14Day?> fetchAverageAll14Day(int deviceId) async {
    var client = http.Client();
    final String url = ApiEndpoints.fetchResults;

    var uri = Uri.parse('$url/$deviceId');
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var data = averageAll14DayFromJson(jsonString); // Phân tích dữ liệu JSON
      return data; // Trả về toàn bộ AverageAll14Day
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Warning>?> fetchWarnings() async {
    var client = http.Client();
    final String url = ApiEndpoints.fetchResults;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final deviceController = DeviceController();

    final devices = await deviceController.getDevices(userId);
    // if (devices.isEmpty) {
    //   ScaffoldMessenger.of().showSnackBar(
    //     const SnackBar(content: Text('Không có thiết bị nào được kết nối')),
    //   );
    // }

    final deviceId = devices.first.deviceId;
    print('Device ID: $deviceId');
    var uri = Uri.parse('$url$deviceId');
    print('URL: $uri');
    var response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var data = averageAll14DayFromJson(jsonString); // Phân tích dữ liệu JSON
      return data.warning; // Trả về phần Warning
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Result>?> fetchResults(int devices) async {
    var client = http.Client();
    // var uri = Uri.parse(
    //   'http://localhost:5062/api/UserMedicalDatas/average-daily-night-last-14-days/$devices',
    // );
    final String url = ApiEndpoints.fetchResults;
    final prefs = await SharedPreferences.getInstance();

    var uri = Uri.parse('$url$devices');

    var response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
    );

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var data = averageAll14DayFromJson(jsonString); // Phân tích dữ liệu JSON
      var dailyAverage =
          data.result
              .map((e) => e.dailyAverage)
              .toList(); // Lấy danh sách dailyAverage từ kết quả
      var nightlyAverage =
          data.result
              .map((e) => e.nightlyAverage)
              .toList(); // Lấy danh sách nightlyAverage từ kết quả
      var allDayAverage =
          data.result
              .map((e) => e.allDayAverage)
              .toList(); // Lấy danh sách allDayAverage từ kết quả
      print(data.result);

      return data.result; // Trả về phần Result
    } else {
      throw Exception('Failed to load data');
    }
  }
}
