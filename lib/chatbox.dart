import 'package:assistantstroke/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'n8n Chat', home: ChatScreen());
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  final String webhookUrl = ApiEndpoints.chatbot;

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });

    _controller.clear();

    try {
      final payload = {
        "sessionId": "b37aed5b5ca84fb7999c48d512525921",
        "action": "sendMessage",
        "chatInput": text,
      };
      //https://ronmanhwa.app.n8n.cloud/webhook/c06e7c6d-be67-4e4b-ac71-3781fdaea258/chat
      final response = await http.post(
        Uri.parse(webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final output = responseData['output'] ?? 'Không có phản hồi.';
        setState(() {
          _messages.add(ChatMessage(text: output, isUser: false));
        });
      } else {
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Lỗi server (${response.statusCode}): ${response.body}',
              isUser: false,
            ),
          );
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(text: 'Lỗi kết nối đến webhook: $e', isUser: false),
        );
      });
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(message.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat với Stroke')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          Divider(height: 1),
          // Đặt padding 10px từ dưới cùng
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 10.0,
            ), // Thêm khoảng cách 10px từ dưới
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Nhập tin nhắn...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
