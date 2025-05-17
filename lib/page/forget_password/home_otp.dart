import 'package:assistantstroke/controler/otp_controller.dart';
import 'package:flutter/material.dart';
// import 'package:assistantstroke/controller/login_controller.dart'; // Import LoginController

class HomeOtp extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String password;
  final String dob;
  final String sex;
  const HomeOtp({
    super.key,
    required this.username,
    required this.email,
    required this.phone,
    required this.password,
    required this.dob,
    required this.sex,
  });

  @override
  _HomeOtp createState() => _HomeOtp();
}

class _HomeOtp extends State<HomeOtp> {
  final TextEditingController Otp = TextEditingController();
  bool _isLoading = false;

  // Handle login when user presses login button
  void _handleOtp() async {
    String otp = Otp.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng nhập otp')));
      return;
    }
    OtpController otpController = OtpController(
      otp: otp, // Bạn sẽ có OTP từ màn hình OTP
      username: widget.username,
      email: widget.email,
      phone: widget.phone,
      password: widget.password,
      dob: widget.dob,
      sex: widget.sex,
    );
    await otpController.Otp(context); // Call login method

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                "OTP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 24, 188, 203),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Mã otp"),
            TextField(
              controller: Otp,
              decoration: InputDecoration(
                // prefixIcon: const Icon(Icons.o),
                filled: true,
                fillColor: const Color.fromARGB(255, 239, 240, 241),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleOtp,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 24, 188, 203),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Đăng ký",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
