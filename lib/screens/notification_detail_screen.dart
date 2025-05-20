import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({Key? key, required this.notification})
    : super(key: key);

  // Check if the message contains HTML tags
  bool _isHtml(String? message) {
    if (message == null) {
      print('NotificationDetailScreen: Message is null');
      return false;
    }
    final isHtml = message.contains(RegExp(r'<[a-zA-Z][^>]*>'));
    print('NotificationDetailScreen: Is HTML: $isHtml');
    return isHtml;
  }

  // Filter out animations from HTML
  String _filterAnimations(String html) {
    print('NotificationDetailScreen: Filtering animations from HTML');
    String filtered = html;

    // Remove <style> tags containing @keyframes
    filtered = filtered.replaceAllMapped(
      RegExp(
        r'<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>',
        caseSensitive: false,
      ),
      (match) {
        final styleContent = match.group(0)!;
        if (styleContent.contains(
          RegExp(r'@keyframes', caseSensitive: false),
        )) {
          print('NotificationDetailScreen: Removed @keyframes style tag');
          return '';
        }
        return styleContent;
      },
    );

    // Remove inline animation properties from style attributes
    filtered = filtered.replaceAllMapped(
      RegExp(r'style\s*=\s*"([^"]*)"', caseSensitive: false),
      (match) {
        final styleContent = match.group(1)!;
        // Split style into properties and filter out animation-related ones
        final properties =
            styleContent
                .split(';')
                .map((p) => p.trim())
                .where((p) => p.isNotEmpty)
                .toList();
        final filteredProperties = properties
            .where((prop) {
              final propLower = prop.toLowerCase();
              return !propLower.startsWith('animation') &&
                  !propLower.startsWith('-webkit-animation') &&
                  !propLower.startsWith('-moz-animation') &&
                  !propLower.startsWith('-o-animation');
            })
            .join('; ');
        print(
          'NotificationDetailScreen: Filtered style: $styleContent -> $filteredProperties',
        );
        return 'style="$filteredProperties"';
      },
    );

    return filtered;
  }

  // Handle link taps for URLs and phone numbers
  Future<void> _onLinkTap(String? url, BuildContext context) async {
    if (url == null) {
      print('Link tap: URL is null');
      return;
    }
    print('Link tap: Attempting to open $url');
    try {
      final uri = Uri.parse(url);
      print('Link tap: Parsed URI: $uri');
      final canLaunch = await canLaunchUrl(uri).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('Link tap: canLaunchUrl timed out');
          return false;
        },
      );
      print('Link tap: Can launch URL: $canLaunch');
      if (canLaunch) {
        print('Link tap: Launching URL');
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        print('Link tap: URL launched successfully');
      } else {
        print('Link tap: Cannot launch URL');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Không thể mở liên kết: $url')));
      }
    } catch (e, stackTrace) {
      print('Link tap error: $e\n$stackTrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi mở liên kết: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      'NotificationDetailScreen: Building with notification: ${notification.title}',
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết thông báo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Builder(
          builder: (context) {
            try {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? 'Không có tiêu đề',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Loại: ${notification.type ?? 'Không xác định'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    notification.getFormattedTime() ?? 'Không có thời gian',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  _isHtml(notification.message)
                      ? Flexible(
                        child: SingleChildScrollView(
                          child: Builder(
                            builder: (context) {
                              final filteredHtml = _filterAnimations(
                                notification.message!,
                              );
                              print(
                                'NotificationDetailScreen: Rendering HTML content: ${filteredHtml.substring(0, filteredHtml.length > 200 ? 200 : filteredHtml.length)}...',
                              );
                              try {
                                return FutureBuilder(
                                  future: Future.delayed(
                                    Duration.zero,
                                    () => true,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    try {
                                      return Html(
                                        data: filteredHtml,
                                        onLinkTap:
                                            (url, _, __) =>
                                                _onLinkTap(url, context),
                                        style: {
                                          'body': Style(
                                            margin: Margins.zero,
                                            fontSize: FontSize(16),
                                          ),
                                          'div': Style(
                                            margin: Margins(bottom: Margin(12)),
                                          ),
                                          'a': Style(
                                            color: Colors.white,
                                            textDecoration: TextDecoration.none,
                                          ),
                                        },
                                      );
                                    } catch (e, stackTrace) {
                                      print(
                                        'NotificationDetailScreen: HTML rendering error: $e\n$stackTrace',
                                      );
                                      return const Text(
                                        'Lỗi hiển thị nội dung HTML',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                );
                              } catch (e, stackTrace) {
                                print(
                                  'NotificationDetailScreen: HTML setup error: $e\n$stackTrace',
                                );
                                return const Text(
                                  'Lỗi thiết lập nội dung HTML',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )
                      : Text(
                        notification.message ?? 'Không có nội dung',
                        style: const TextStyle(fontSize: 16),
                      ),
                  if (!_isHtml(notification.message)) const Spacer(),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        print('NotificationDetailScreen: Back button pressed');
                        Navigator.pop(context);
                      },
                      child: const Text('Quay lại'),
                    ),
                  ),
                ],
              );
            } catch (e, stackTrace) {
              print('NotificationDetailScreen: Build error: $e\n$stackTrace');
              return const Center(
                child: Text(
                  'Lỗi tải màn hình chi tiết',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
