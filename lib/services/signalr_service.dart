import 'dart:async';
import 'dart:convert';
import 'package:assistantstroke/model/notification_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'api_service.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;

  SignalRService._internal();

  HubConnection? _hubConnection;
  String _baseUrl = ApiEndpoints.notificationHub;
  int? _userId;
  final _notificationStreamController =
      StreamController<NotificationModel>.broadcast();

  // Getter để các widget có thể lắng nghe thông báo mới
  Stream<NotificationModel> get notificationStream =>
      _notificationStreamController.stream;

  Future<void> initialize(int userId) async {
    _userId = userId;
    debugPrint('Khởi tạo SignalR service cho user: $userId');

    // Lưu userId hiện tại
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', userId);
  }

  Future<void> connect() async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      debugPrint('SignalR đã được kết nối');
      return;
    }

    if (_userId == null) {
      throw Exception('Bạn phải khởi tạo service với userId trước');
    }

    try {
      debugPrint('Đang kết nối đến SignalR: $_baseUrl?userId=$_userId');

      // Tạo hub connection
      _hubConnection =
          HubConnectionBuilder().withUrl('$_baseUrl?userId=$_userId').build();

      // Thiết lập xử lý sự kiện
      _setupSignalRCallbacks();

      // Bắt đầu kết nối
      await _hubConnection!.start();
      debugPrint('✅ Kết nối SignalR thành công');
    } catch (e) {
      debugPrint('❌ Lỗi kết nối SignalR: $e');
      rethrow;
    }
  }

  void _setupSignalRCallbacks() {
    _hubConnection!.on('ReceiveNotification', _handleReceiveNotification);
  }

  void _handleReceiveNotification(List<Object?>? arguments) {
    if (arguments == null || arguments.isEmpty) return;

    try {
      final data = arguments[0] as Map<String, dynamic>;
      debugPrint('Nhận thông báo: ${data['title']}');

      // Tạo notification model
      final notification = NotificationModel.fromJson(data);

      // Lưu notification
      _saveNotification(notification);

      // Thêm vào stream để UI cập nhật
      _notificationStreamController.add(notification);
    } catch (e) {
      debugPrint('Lỗi xử lý thông báo: $e');
    }
  }

  Future<void> _saveNotification(NotificationModel notification) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Lấy thông báo đã lưu
      final notificationsJson =
          prefs.getString('notifications_$_userId') ?? '[]';
      List<dynamic> notificationsList = json.decode(notificationsJson);

      // Thêm thông báo mới vào đầu
      notificationsList.insert(0, notification.toJson());

      // Giới hạn số lượng thông báo lưu trữ
      if (notificationsList.length > 50) {
        notificationsList = notificationsList.take(50).toList();
      }

      // Lưu lại vào shared preferences
      await prefs.setString(
        'notifications_$_userId',
        json.encode(notificationsList),
      );
    } catch (e) {
      debugPrint('Lỗi lưu thông báo: $e');
    }
  }

  Future<void> disconnect() async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      await _hubConnection!.stop();
      debugPrint('SignalR đã ngắt kết nối');
    }
  }

  Future<List<NotificationModel>> getStoredNotifications() async {
    try {
      if (_userId == null) return [];

      final prefs = await SharedPreferences.getInstance();
      final notificationsJson =
          prefs.getString('notifications_$_userId') ?? '[]';
      List<dynamic> notificationsList = json.decode(notificationsJson);

      return notificationsList
          .map<NotificationModel>(
            (jsonData) => NotificationModel.fromJson(jsonData),
          )
          .toList();
    } catch (e) {
      debugPrint('Lỗi tải thông báo: $e');
      return [];
    }
  }
}
