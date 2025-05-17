// To parse this JSON data, do
//
//     final dailyDay = dailyDayFromJson(jsonString);

import 'dart:convert';

List<DailyDay> dailyDayFromJson(String str) =>
    List<DailyDay>.from(json.decode(str).map((x) => DailyDay.fromJson(x)));

String dailyDayToJson(List<DailyDay> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyDay {
  int userMedicalDataId;
  int deviceId;
  int systolicPressure;
  int diastolicPressure;
  double temperature;
  double bloodPh;
  DateTime recordedAt;
  int spo2Information;
  int heartRate;
  DateTime createdAt;
  DateTime updatedAt;

  DailyDay({
    required this.userMedicalDataId,
    required this.deviceId,
    required this.systolicPressure,
    required this.diastolicPressure,
    required this.temperature,
    required this.bloodPh,
    required this.recordedAt,
    required this.spo2Information,
    required this.heartRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyDay.fromJson(Map<String, dynamic> json) => DailyDay(
    userMedicalDataId: json["userMedicalDataId"],
    deviceId: json["deviceId"],
    systolicPressure: json["systolicPressure"],
    diastolicPressure: json["diastolicPressure"],
    temperature: json["temperature"]?.toDouble(),
    bloodPh: json["bloodPh"]?.toDouble(),
    recordedAt: DateTime.parse(json["recordedAt"]),
    spo2Information: json["spo2Information"],
    heartRate: json["heartRate"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "userMedicalDataId": userMedicalDataId,
    "deviceId": deviceId,
    "systolicPressure": systolicPressure,
    "diastolicPressure": diastolicPressure,
    "temperature": temperature,
    "bloodPh": bloodPh,
    "recordedAt": recordedAt.toIso8601String(),
    "spo2Information": spo2Information,
    "heartRate": heartRate,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
