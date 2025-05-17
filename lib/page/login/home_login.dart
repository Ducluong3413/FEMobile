import 'package:assistantstroke/controler/login_controller.dart';
import 'package:assistantstroke/page/forgot_password/forgot_password.dart';
import 'package:flutter/material.dart';
// import 'package:assistantstroke/controller/login_controller.dart'; // Import LoginController
import 'package:assistantstroke/page/forget_password/home_forget_password.dart'; // Import Forget Password page

class HomeLogin extends StatefulWidget {
  const HomeLogin({super.key});

  @override
  _HomeLoginState createState() => _HomeLoginState();
}

class _HomeLoginState extends State<HomeLogin> {
  final TextEditingController Username = TextEditingController();
  final TextEditingController Password = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Biến kiểm soát hiển thị mật khẩu

  void _handleLogin() async {
    String username = Username.text.trim();
    String password = Password.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập email hoặc số điện thoại và mật khẩu'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    LoginController loginController = LoginController(
      username: username,
      password: password,
    );
    await loginController.login(context);

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
                "Đăng Nhập",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 24, 188, 203),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: Username,
              decoration: InputDecoration(
                labelText: 'Email hoặc SĐT',
                prefixIcon: const Icon(Icons.email),
                hintText: "Nhập email hoặc số điện thoại",
                filled: true,
                fillColor: const Color.fromARGB(255, 239, 240, 241),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: Password,
              obscureText: !_isPasswordVisible, // Điều khiển hiển thị mật khẩu
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
                hintText: "Nhập mật khẩu",
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    // Chuyển đến trang quên mật khẩu
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: const Text(
                    "Quên mật khẩu?",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
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
                          "Đăng nhập",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
