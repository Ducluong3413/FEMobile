import 'dart:convert';
import 'package:assistantstroke/model/indicatorModel.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IndicatorController {
  Future<IndicatorModel?> fetchIndicatorData(final userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // final userId = prefs.getInt(
      //   'userId',
      // ); // Hoặc getString nếu userId là string

      if (userId == null) {
        print('User ID not found in SharedPreferences');
        return null;
      }
      final String url = ApiEndpoints.indicator + '?userId=$userId';

      Uri.parse(url);
      // final response = await http.get(url, headers: {'accept': '*/*'});
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IndicatorModel.fromJson(data);
      } else {
        print('Failed to fetch indicator data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching indicator data: $e');
      return null;
    }
  }
}
