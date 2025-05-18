import 'package:assistantstroke/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          // Hiển thị trạng thái kết nối
          // Consumer<NotificationProvider>(
          //   builder:
          //       (context, provider, _) => Icon(
          //         provider.isConnected ? Icons.wifi : Icons.wifi_off,
          //         color: provider.isConnected ? Colors.green : Colors.grey,
          //       ),
          // ),

          // Nút làm mới
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final provider = Provider.of<NotificationProvider>(
                context,
                listen: false,
              );
              if (provider.userId != null) {
                provider.fetchNotifications(provider.userId!);
              }
            },
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã xảy ra lỗi: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (provider.userId != null) {
                        provider.initialize(provider.userId!);
                      }
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (provider.notifications.isEmpty) {
            return const Center(child: Text('Không có thông báo nào'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (provider.userId != null) {
                await provider.fetchNotifications(provider.userId!);
              }
            },
            child: ListView.builder(
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    provider.markAsRead(notification.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: _getNotificationIcon(),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              notification.getFormattedTime(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _getNotificationIcon() {
    IconData iconData;
    Color color;

    switch (notification.type.toLowerCase()) {
      case 'warning':
        iconData = Icons.warning_amber_rounded;
        color = Colors.red;
        break;
      case 'risk':
        iconData = Icons.warning_rounded;
        color = Colors.orange;
        break;
      default:
        iconData = Icons.info_outline;
        color = Colors.blue;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(iconData, color: color),
    );
  }
}
