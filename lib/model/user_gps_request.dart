class UserGpsRequest {
  final int userId;
  final double lat;
  final double long;
  final int deviceId;
  final double readingValue;
  final DateTime recordedAt;

  UserGpsRequest({
    required this.userId,
    required this.lat,
    required this.long,
    required this.deviceId,
    required this.readingValue,
    required this.recordedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "lat": lat,
      "long": long,
      "deviceId": deviceId,
      "readingValue": readingValue,
      "recordedAt": recordedAt.toIso8601String(),
    };
  }
}
