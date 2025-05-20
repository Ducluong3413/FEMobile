import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/signalr_service.dart';
import '../services/api_service.dart';
import '../model/notification_model.dart';

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

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _signalRService.notificationStream.listen((notification) {
      _notifications.insert(0, notification);
      notifyListeners();
    });
  }

  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Lấy userId từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getInt('userId');
      print('Khởi tạo NotificationProvider: userId = $_userId');

      if (_userId == null) {
        throw Exception('Không tìm thấy userId trong SharedPreferences');
      }

      await _signalRService.initialize(_userId!);
      _notifications = await _signalRService.getStoredNotifications();
      await _signalRService.connect();
      _isConnected = true;

      await fetchNotifications(_userId!);
      _error = null;
    } catch (e) {
      _error = e.toString();
      print('Lỗi khởi tạo thông báo: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNotifications(int userId) async {
    print('Đang tải thông báo cho userId: $userId');
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final url = ApiEndpoints.mobileNotificationsForUser(userId);
      print('API URL: $url');
      final response = await http.get(Uri.parse(url));
      print('Phản hồi API: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _notifications =
            data
                .map<NotificationModel>(
                  (item) => NotificationModel.fromJson(item),
                )
                .toList();
      } else {
        throw Exception('Không thể tải thông báo: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
      print('Lỗi tải thông báo: $_error');
    } finally {
      _isLoading = false;
      notifyListeners();
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
      print('Lỗi đánh dấu đã đọc: $e');
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

  // Future<bool> sendTestNotification() async {
  //   if (_userId == null) return false;
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${ApiEndpoints.mobileNotifications}/test'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'userId': _userId,
  //         'title': 'Test Notification',
  //         'message': 'Đây là thông báo test từ Flutter app',
  //         'type': 'info',
  //       }),
  //     );
  //     return response.statusCode == 200;
  //   } catch (e) {
  //     print('Lỗi gửi thông báo test: $e');
  //     return false;
  //   }
  // }
}
