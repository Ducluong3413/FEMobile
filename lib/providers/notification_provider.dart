import 'package:assistantstroke/model/notification_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/signalr_service.dart';
import '../services/api_service.dart';

class NotificationProvider with ChangeNotifier {
  final SignalRService _signalRService = SignalRService();
  List<NotificationModel> _notifications = [];
  bool _isConnected = false;
  bool _isLoading = false;
  String? _error;
  int? _userId;

  List<NotificationModel> get notifications => _notifications;
  bool get isConnected => _isConnected;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int? get userId => _userId;

  // Số thông báo chưa đọc
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    // Lắng nghe thông báo mới
    _signalRService.notificationStream.listen((notification) {
      _notifications.insert(0, notification);
      notifyListeners();
    });
  }

  Future<void> initialize(int userId) async {
    try {
      _isLoading = true;
      _userId = userId;
      notifyListeners();

      await _signalRService.initialize(userId);

      _notifications = await _signalRService.getStoredNotifications();

      await _signalRService.connect();
      _isConnected = true;

      await fetchNotifications(userId);

      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Lỗi khởi tạo thông báo: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNotifications(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoints.mobileNotificationsForUser(userId)),
      );
      debugPrint('Đang tải thông báo từ API: ${response.request?.url}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _notifications =
            data
                .map<NotificationModel>(
                  (item) => NotificationModel.fromJson(item),
                )
                .toList();

        notifyListeners();
      } else {
        throw Exception('Không thể tải thông báo: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Lỗi tải thông báo: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await http.put(
        Uri.parse(ApiEndpoints.markAsRead(notificationId)),
      );

      if (response.statusCode == 200) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index >= 0) {
          final updatedNotification = NotificationModel(
            id: _notifications[index].id,
            title: _notifications[index].title,
            message: _notifications[index].message,
            type: _notifications[index].type,
            timestamp: _notifications[index].timestamp,
            isRead: true,
          );

          _notifications[index] = updatedNotification;
          notifyListeners();
        }
      } else {
        throw Exception('Không thể đánh dấu đã đọc');
      }
    } catch (e) {
      debugPrint('Lỗi đánh dấu đã đọc: $e');
    }
  }

  Future<void> reconnect() async {
    if (_userId != null) {
      await _signalRService.connect();
      _isConnected = true;
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    await _signalRService.disconnect();
    _isConnected = false;
    notifyListeners();
  }

  Future<bool> sendTestNotification() async {
    if (_userId == null) return false;

    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.mobileNotifications}/test'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': _userId,
          'title': 'Test Notification',
          'message': 'Đây là thông báo test từ Flutter app',
          'type': 'info',
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lỗi gửi thông báo test: $e');
      return false;
    }
  }
}
