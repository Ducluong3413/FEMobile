import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:assistantstroke/controler/invitation_controller.dart';

class InvitationResultPage extends StatefulWidget {
  const InvitationResultPage({super.key});

  @override
  State<InvitationResultPage> createState() => _InvitationResultPageState();
}

class _InvitationResultPageState extends State<InvitationResultPage> {
  String message = '';
  String code = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _createInvitation();
  }

  Future<void> _createInvitation() async {
    final controller = InvitationController();
    final result = await controller.createInvitation();

    setState(() {
      message = result['message']!;
      code = result['code']!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mã lời mời')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   message,
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w600,
                    //     color:
                    //         message.contains("thành công")
                    //             ? Colors.green
                    //             : Colors.red,
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    if (code.isNotEmpty) ...[
                      const Text(
                        "🔐 Mã lời mời:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          code,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "📱 Quét mã QR để kết nối",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: QrImageView(
                          data: code,
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}
