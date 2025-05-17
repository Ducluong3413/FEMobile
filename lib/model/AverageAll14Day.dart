class AverageValue {
  final double averageTemperature;
  final double averageSpO2;
  final double averageHeartRate;
  final double averageBloodPh;
  final double averageSystolicPressure;
  final double averageDiastolicPressure;

  AverageValue({
    required this.averageTemperature,
    required this.averageSpO2,
    required this.averageHeartRate,
    required this.averageBloodPh,
    required this.averageSystolicPressure,
    required this.averageDiastolicPressure,
  });

  factory AverageValue.fromJson(Map<String, dynamic> json) {
    return AverageValue(
      averageTemperature: (json['averageTemperature'] ?? 0).toDouble(),
      averageSpO2: (json['averageSpO2'] ?? 0).toDouble(),
      averageHeartRate: (json['averageHeartRate'] ?? 0).toDouble(),
      averageBloodPh: (json['averageBloodPh'] ?? 0).toDouble(),
      averageSystolicPressure:
          (json['averageSystolicPressure'] ?? 0).toDouble(),
      averageDiastolicPressure:
          (json['averageDiastolicPressure'] ?? 0).toDouble(),
    );
  }
}

class DailyResult {
  final double averageSystolicPressure;
  final double averageDiastolicPressure;
  final double averageSpO2;
  final double averageTemperature;
  final double averageHeartRate;
  final double averagePH;

  final double averageSystolicPressureNight;
  final double averageDiastolicPressureNight;
  final double averageSpO2Night;
  final double averageTemperatureNight;
  final double averageHeartRateNight;
  final double averagePHNight;

  DailyResult({
    required this.averageSystolicPressure,
    required this.averageDiastolicPressure,
    required this.averageSpO2,
    required this.averageTemperature,
    required this.averageHeartRate,
    required this.averagePH,
    required this.averageSystolicPressureNight,
    required this.averageDiastolicPressureNight,
    required this.averageSpO2Night,
    required this.averageTemperatureNight,
    required this.averageHeartRateNight,
    required this.averagePHNight,
  });

  factory DailyResult.fromJson(Map<String, dynamic> json) {
    final daily = json['dailyAverage'] ?? {};
    final nightly = json['nightlyAverage'] ?? {};

    return DailyResult(
      averageSystolicPressure:
          (daily['averageSystolicPressure'] ?? 0).toDouble(),
      averageDiastolicPressure:
          (daily['averageDiastolicPressure'] ?? 0).toDouble(),
      averageSpO2: (daily['averageSpO2'] ?? 0).toDouble(),
      averageTemperature: (daily['averageTemperature'] ?? 0).toDouble(),
      averageHeartRate: (daily['averageHeartRate'] ?? 0).toDouble(),
      averagePH: (daily['averageBloodPh'] ?? 0).toDouble(),

      averageSystolicPressureNight:
          (nightly['averageSystolicPressure'] ?? 0).toDouble(),
      averageDiastolicPressureNight:
          (nightly['averageDiastolicPressure'] ?? 0).toDouble(),
      averageSpO2Night: (nightly['averageSpO2'] ?? 0).toDouble(),
      averageTemperatureNight: (nightly['averageTemperature'] ?? 0).toDouble(),
      averageHeartRateNight: (nightly['averageHeartRate'] ?? 0).toDouble(),
      averagePHNight: (nightly['averageBloodPh'] ?? 0).toDouble(),
    );
  }
}
