import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Sử dụng mobile_scanner thay vì qr_code_scanner
import 'package:assistantstroke/controler/invitation_controller.dart';

class ScanInvitationPage extends StatefulWidget {
  const ScanInvitationPage({super.key});

  @override
  State<ScanInvitationPage> createState() => _ScanInvitationPageState();
}

class _ScanInvitationPageState extends State<ScanInvitationPage> {
  bool _isProcessing = false;
  String resultMessage = '';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      // Không cần dừng hay tiếp tục camera như QRViewController
      // mobile_scanner tự động xử lý khi cần
    }
  }

  void _onDetect(BarcodeCapture barcodeCapture) async {
    if (!_isProcessing) {
      setState(() {
        _isProcessing = true;
      });

      final barcode =
          barcodeCapture
              .barcodes
              .first; // Lấy barcode đầu tiên nếu có nhiều hơn một
      final invitationCode = barcode.rawValue;

      final response = await InvitationController().submitInvitation(
        invitationCode ?? '',
      );

      setState(() {
        resultMessage = response['message'] ?? 'Không nhận được phản hồi.';
      });

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context, resultMessage);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quét mã lời mời')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              onDetect:
                  (BarcodeCapture barcodeCapture) => _onDetect(barcodeCapture),
            ),
          ),
          if (resultMessage.isNotEmpty)
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  resultMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
