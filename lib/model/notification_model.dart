class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Thông báo',
      message: json['message'] ?? '',
      type: json['type']?.toString().toLowerCase() ?? 'info',
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'type': type,
    'timestamp': timestamp,
    'isRead': isRead,
  };

  String getFormattedTime() {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    } catch (e) {
      return timestamp;
    }
  }
}
