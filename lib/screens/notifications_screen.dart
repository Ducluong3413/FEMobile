// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/notification_provider.dart';
// import '../model/notification_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({Key? key}) : super(key: key);

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeProvider();
//   }

//   Future<void> _initializeProvider() async {
//     final provider = Provider.of<NotificationProvider>(context, listen: false);
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('userId');
//     print('initState: userId từ SharedPreferences = $userId');
//     if (userId != null) {
//       await provider.initialize();
//     } else {
//       print('Lỗi: Không tìm thấy userId trong SharedPreferences');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Thông báo'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () async {
//               final provider = Provider.of<NotificationProvider>(
//                 context,
//                 listen: false,
//               );
//               final prefs = await SharedPreferences.getInstance();
//               final userId = prefs.getInt('userId');
//               print('Nút làm mới: userId = $userId');
//               if (userId != null) {
//                 await provider.fetchNotifications(userId);
//               } else {
//                 print('Lỗi: userId là null khi nhấn làm mới');
//               }
//             },
//           ),
//         ],
//       ),
//       body: Consumer<NotificationProvider>(
//         builder: (context, provider, _) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (provider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     provider.error ==
//                             'Không tìm thấy userId trong SharedPreferences'
//                         ? 'Vui lòng đăng nhập để xem thông báo'
//                         : 'Đã xảy ra lỗi: ${provider.error}',
//                     style: const TextStyle(color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final prefs = await SharedPreferences.getInstance();
//                       final userId = prefs.getInt('userId');
//                       if (userId != null) {
//                         await provider.fetchNotifications(userId);
//                       }
//                     },
//                     child: const Text('Thử lại'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           if (provider.notifications.isEmpty) {
//             return const Center(child: Text('Không có thông báo nào'));
//           }
//           return RefreshIndicator(
//             onRefresh: () async {
//               final provider = Provider.of<NotificationProvider>(
//                 context,
//                 listen: false,
//               );
//               final prefs = await SharedPreferences.getInstance();
//               final userId = prefs.getInt('userId');
//               print('RefreshIndicator: userId = $userId');
//               if (userId != null) {
//                 await provider.fetchNotifications(userId);
//               }
//             },
//             child: ListView.builder(
//               itemCount: provider.notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = provider.notifications[index];
//                 return NotificationTile(
//                   notification: notification,
//                   onTap: () => provider.markAsRead(notification.id),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // Ensure NotificationTile is defined here
// class NotificationTile extends StatelessWidget {
//   final NotificationModel notification;
//   final VoidCallback onTap;

//   const NotificationTile({
//     Key? key,
//     required this.notification,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: ListTile(
//         onTap: onTap,
//         leading: _getNotificationIcon(),
//         title: Text(
//           notification.title,
//           style: TextStyle(
//             fontWeight:
//                 notification.isRead ? FontWeight.normal : FontWeight.bold,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               notification.message,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               notification.getFormattedTime(),
//               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//             ),
//           ],
//         ),
//         isThreeLine: true,
//       ),
//     );
//   }

//   Widget _getNotificationIcon() {
//     IconData iconData;
//     Color color;

//     switch (notification.type.toLowerCase()) {
//       case 'warning':
//         iconData = Icons.warning_amber_rounded;
//         color = Colors.red;
//         break;
//       case 'risk':
//         iconData = Icons.warning_rounded;
//         color = Colors.orange;
//         break;
//       default:
//         iconData = Icons.info_outline;
//         color = Colors.blue;
//     }

//     return CircleAvatar(
//       backgroundColor: color.withOpacity(0.2),
//       child: Icon(iconData, color: color),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';
import '../model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_detail_screen.dart'; // Import the new detail screen

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    print('initState: userId từ SharedPreferences = $userId');
    if (userId != null) {
      await provider.initialize();
    } else {
      // classes.dart';
      print('Lỗi: Không tìm thấy userId trong SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final provider = Provider.of<NotificationProvider>(
                context,
                listen: false,
              );
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getInt('userId');
              print('Nút làm mới: userId = $userId');
              if (userId != null) {
                await provider.fetchNotifications(userId);
              } else {
                print('Lỗi: userId là null khi nhấn làm mới');
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
                    provider.error ==
                            'Không tìm thấy userId trong SharedPreferences'
                        ? 'Vui lòng đăng nhập để xem thông báo'
                        : 'Đã xảy ra lỗi: ${provider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getInt('userId');
                      if (userId != null) {
                        await provider.fetchNotifications(userId);
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
              final provider = Provider.of<NotificationProvider>(
                context,
                listen: false,
              );
              final prefs = await SharedPreferences.getInstance();
              final userId = prefs.getInt('userId');
              print('RefreshIndicator: userId = $userId');
              if (userId != null) {
                await provider.fetchNotifications(userId);
              }
            },
            child: ListView.builder(
              itemCount: provider.notifications.length,
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () {
                    // Navigate to detail screen and mark as read
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => NotificationDetailScreen(
                              notification: notification,
                            ),
                      ),
                    ).then((_) {
                      // Mark as read after navigating
                      provider.markAsRead(notification.id);
                    });
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
          notification.message, // Display only the message
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          notification.getFormattedTime(),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        isThreeLine: false, // Simplified to two lines
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
