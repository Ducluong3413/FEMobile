import 'package:assistantstroke/model/AverageAll14Day.dart';

class UserMedicalDataResponse {
  final Map<String, double>? dataPercent;
  final List<DailyResult>? results;
  UserMedicalDataResponse({this.dataPercent, this.results});

  factory UserMedicalDataResponse.fromJson(Map<String, dynamic> json) {
    return UserMedicalDataResponse(
      dataPercent: (json['dataPercent'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value ?? 0).toDouble()),
      ),
      results:
          (json['result'] as List<dynamic>?)
              ?.map((item) => DailyResult.fromJson(item))
              .toList(),
    );
  }
}
