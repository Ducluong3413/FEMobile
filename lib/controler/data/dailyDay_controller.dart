import 'package:assistantstroke/model/dailyDay.dart';
import 'package:assistantstroke/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RemoteDailyController {
  // Future<List<DailyDay>> getDailyDay() async {
  //   final response = await http.get(Uri.parse('https://api.example.com/dailyday'));
  //   if (response.statusCode == 200) {
  //     List<DailyDay> dailyDays = (json.decode(response.body) as List)
  //         .map((data) => DailyDay.fromJson(data))
  //         .toList();
  //     return dailyDays;
  //   } else {
  //     throw Exception('Failed to load daily days');
  //   }
  // }
  Future<List<DailyDay>> fetchDailyDay(String date, int devices) async {
    var client = http.Client();
    final String url = ApiEndpoints.fetchDailyDay;
    final prefs = await SharedPreferences.getInstance();

    var uri = Uri.parse('$url$date/$devices');
    // var uri = Uri.parse(
    //   'http://localhost:5062/api/UserMedicalDatas/daily/$date/$devices',
    // );
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
      var data = dailyDayFromJson(jsonString);
      // var systolicPressure =
      //     data
      //         .map((e) => e.systolicPressure)
      //         .toList(); // Lấy danh sách systolicPressure từ kết quả
      // var diastolicPressure =
      //     data
      //         .map((e) => e.diastolicPressure)
      //         .toList(); // Lấy danh sách diastolicPressure từ kết quả
      // var temperature =
      //     data
      //         .map((e) => e.temperature)
      //         .toList(); // Lấy danh sách temperature từ kết quả
      // var bloodPh =
      //     data
      //         .map((e) => e.bloodPh)
      //         .toList(); // Lấy danh sách bloodPh từ kết quả
      // var recordedAt =
      //     data
      //         .map((e) => e.recordedAt)
      //         .toList(); // Lấy danh sách recordedAt từ kết quả
      // var spo2Information =
      //     data
      //         .map((e) => e.spo2Information)
      //         .toList(); // Lấy danh sách spo2Information từ kết quả
      // var heartRate =
      //     data
      //         .map((e) => e.heartRate)
      //         .toList(); // Lấy danh sách heartRate từ kết quả

      return data; // Trả về toàn bộ DailyDay
    } else {
      throw Exception('Failed to load data');
    }
  }
}
