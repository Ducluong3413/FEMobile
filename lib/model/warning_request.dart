class WarningRequest {
  final int userId;
  final double latitude;
  final double longitude;
  final String additionalInfo;

  WarningRequest({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.additionalInfo,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'latitude': latitude,
    'longitude': longitude,
    'additionalInfo': additionalInfo,
  };
}
