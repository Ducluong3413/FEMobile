// To parse this JSON data, do
//
//     final averageAll14Day = averageAll14DayFromJson(jsonString);

import 'dart:convert';

AverageAll14Day averageAll14DayFromJson(String str) =>
    AverageAll14Day.fromJson(json.decode(str));

String averageAll14DayToJson(AverageAll14Day data) =>
    json.encode(data.toJson());

class AverageAll14Day {
  AverageAll14DayClass averageAll14Day;
  AverageAll14DayClass dataPercent;
  List<Warning> warning;
  List<Result> result;

  AverageAll14Day({
    required this.averageAll14Day,
    required this.dataPercent,
    required this.warning,
    required this.result,
  });

  factory AverageAll14Day.fromJson(Map<String, dynamic> json) =>
      AverageAll14Day(
        averageAll14Day: AverageAll14DayClass.fromJson(json["averageAll14Day"]),
        dataPercent: AverageAll14DayClass.fromJson(json["dataPercent"]),
        warning: List<Warning>.from(
          json["warning"].map((x) => Warning.fromJson(x)),
        ),
        result: List<Result>.from(
          json["result"].map((x) => Result.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "averageAll14Day": averageAll14Day.toJson(),
    "dataPercent": dataPercent.toJson(),
    "warning": List<dynamic>.from(warning.map((x) => x.toJson())),
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };
}

class AverageAll14DayClass {
  double temperature;
  double spO2;
  double heartRate;
  double bloodPh;
  double systolicPressure;
  double diastolicPressure;

  AverageAll14DayClass({
    required this.temperature,
    required this.spO2,
    required this.heartRate,
    required this.bloodPh,
    required this.systolicPressure,
    required this.diastolicPressure,
  });

  factory AverageAll14DayClass.fromJson(Map<String, dynamic> json) =>
      AverageAll14DayClass(
        temperature: json["temperature"]?.toDouble(),
        spO2: json["spO2"]?.toDouble(),
        heartRate: json["heartRate"]?.toDouble(),
        bloodPh: json["bloodPh"]?.toDouble(),
        systolicPressure: json["systolicPressure"]?.toDouble(),
        diastolicPressure: json["diastolicPressure"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "temperature": temperature,
    "spO2": spO2,
    "heartRate": heartRate,
    "bloodPh": bloodPh,
    "systolicPressure": systolicPressure,
    "diastolicPressure": diastolicPressure,
  };
}

class Result {
  DateTime date;
  YAverage? allDayAverage;
  YAverage? dailyAverage;
  YAverage? nightlyAverage;

  Result({
    required this.date,
    required this.allDayAverage,
    required this.dailyAverage,
    required this.nightlyAverage,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    date: DateTime.parse(json["date"]),
    allDayAverage:
        json["allDayAverage"] == null
            ? null
            : YAverage.fromJson(json["allDayAverage"]),
    dailyAverage:
        json["dailyAverage"] == null
            ? null
            : YAverage.fromJson(json["dailyAverage"]),
    nightlyAverage:
        json["nightlyAverage"] == null
            ? null
            : YAverage.fromJson(json["nightlyAverage"]),
  );

  Map<String, dynamic> toJson() => {
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "allDayAverage": allDayAverage?.toJson(),
    "dailyAverage": dailyAverage?.toJson(),
    "nightlyAverage": nightlyAverage?.toJson(),
  };
}

class YAverage {
  double averageTemperature;
  double averageSpO2;
  double averageHeartRate;
  double averageBloodPh;
  double averageSystolicPressure;
  double averageDiastolicPressure;

  YAverage({
    required this.averageTemperature,
    required this.averageSpO2,
    required this.averageHeartRate,
    required this.averageBloodPh,
    required this.averageSystolicPressure,
    required this.averageDiastolicPressure,
  });

  factory YAverage.fromJson(Map<String, dynamic> json) => YAverage(
    averageTemperature: json["averageTemperature"]?.toDouble(),
    averageSpO2: json["averageSpO2"]?.toDouble(),
    averageHeartRate: json["averageHeartRate"]?.toDouble(),
    averageBloodPh: json["averageBloodPh"]?.toDouble(),
    averageSystolicPressure: json["averageSystolicPressure"]?.toDouble(),
    averageDiastolicPressure: json["averageDiastolicPressure"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "averageTemperature": averageTemperature,
    "averageSpO2": averageSpO2,
    "averageHeartRate": averageHeartRate,
    "averageBloodPh": averageBloodPh,
    "averageSystolicPressure": averageSystolicPressure,
    "averageDiastolicPressure": averageDiastolicPressure,
  };
}

class Warning {
  String temperature;
  String spO2;
  String heartRate;
  String bloodPh;
  String systolicPressure;
  String diastolicPressure;

  Warning({
    required this.temperature,
    required this.spO2,
    required this.heartRate,
    required this.bloodPh,
    required this.systolicPressure,
    required this.diastolicPressure,
  });

  factory Warning.fromJson(Map<String, dynamic> json) => Warning(
    temperature: json["temperature"],
    spO2: json["spO2"],
    heartRate: json["heartRate"],
    bloodPh: json["bloodPh"],
    systolicPressure: json["systolicPressure"],
    diastolicPressure: json["diastolicPressure"],
  );

  Map<String, dynamic> toJson() => {
    "temperature": temperature,
    "spO2": spO2,
    "heartRate": heartRate,
    "bloodPh": bloodPh,
    "systolicPressure": systolicPressure,
    "diastolicPressure": diastolicPressure,
  };
}
