import 'package:assistantstroke/controler/commit_password_controller.dart';
import 'package:assistantstroke/page/login/home_login.dart';
import 'package:flutter/material.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;

  const NewPasswordScreen({Key? key, required this.email}) : super(key: key);
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late String email;

  @override
  void initState() {
    super.initState();
    email = widget.email; // Lưu vào biến email
  }

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  final TextEditingController Otp = TextEditingController();
  final TextEditingController Password = TextEditingController();
  final TextEditingController Re_password = TextEditingController();
  bool _isLoading = false;

  void _handlpasword() async {
    String otp = Otp.text.trim();
    String password = Password.text.trim();
    String re_password = Re_password.text.trim();
    print('$otp / $password / $re_password');

    if (otp.isEmpty || password.isEmpty || re_password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin.')),
      );
      return;
    }

    if (password != re_password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không trùng khớp.')),
      );
      return;
    }

    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mật khẩu phải có ít nhất 8 ký tự, bao gồm số và chữ in hoa.',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Gọi API xử lý ở đây nếu cần, ví dụ:
    // bool success = await SomeController.resetPassword(otp: a, password: b);

    NewPasswordController forgotController = NewPasswordController(
      otp: otp,
      password: password,
      re_password: re_password,
      email: email,
    );
    bool success = await forgotController.forgot(context);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                Text(
                  "Tạo Mật Khẩu Mới",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Vui lòng nhập mã OTP và mật khẩu mới để khôi phục tài khoản của bạn.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "OTP",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                _buildInputField(hint: "OTP", controller: Otp),
                SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Kiểm tra email của bạn",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mật khẩu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                _buildPasswordField(
                  hint: "Mật khẩu",
                  isVisible: passwordVisible,
                  toggleVisibility: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  controller: Password,
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nhập lại mật khẩu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                _buildPasswordField(
                  hint: "Nhập lại mật khẩu của bạn",
                  isVisible: confirmPasswordVisible,
                  toggleVisibility: () {
                    setState(() {
                      confirmPasswordVisible = !confirmPasswordVisible;
                    });
                  },
                  controller: Re_password,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handlpasword,
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyan, Colors.blueAccent],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 60,
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Cập Nhật",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(fontWeight: FontWeight.bold),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.cyan,
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
