import 'package:assistantstroke/page/Invitation/scan_invitation_page.dart';
import 'package:flutter/material.dart';
import 'package:assistantstroke/controler/invitation_controller.dart';

class EnterOrScanInvitationPage extends StatefulWidget {
  const EnterOrScanInvitationPage({super.key});

  @override
  State<EnterOrScanInvitationPage> createState() =>
      _EnterOrScanInvitationPageState();
}

class _EnterOrScanInvitationPageState extends State<EnterOrScanInvitationPage> {
  final TextEditingController _codeController = TextEditingController();
  String resultMessage = '';
  bool _isLoading = false;

  Future<void> _submitCode(String code) async {
    setState(() {
      _isLoading = true;
      resultMessage = '';
    });

    final result = await InvitationController().submitInvitation(code);

    setState(() {
      resultMessage = result['message'] ?? '';
      _isLoading = false;
    });
  }

  void _openQRScanner() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScanInvitationPage()),
    );

    if (result != null && result is String) {
      setState(() {
        resultMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập hoặc quét mã lời mời')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nhập mã lời mời:"),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: "Nhập mã ở đây...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _submitCode(_codeController.text.trim()),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _openQRScanner,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("Quét mã QR"),
              ),
            ),
            const SizedBox(height: 30),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (resultMessage.isNotEmpty)
              Center(
                child: Text(
                  resultMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
