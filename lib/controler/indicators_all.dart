// controllers/indicator_controller.dart
import 'dart:convert';
import 'package:assistantstroke/model/indicatorall.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IndicatorControllerAll {
  Future<IndicatorModelAll?> fetchIndicators() async {
    final String base = ApiEndpoints.get_indicator;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final token = prefs.getString('token');
    final url = Uri.parse('$base/$userId'); // Thay ID tùy ý
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return IndicatorModelAll.fromJson(data);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return null;
  }
}
