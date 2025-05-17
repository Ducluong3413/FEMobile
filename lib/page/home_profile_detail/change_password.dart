import 'package:assistantstroke/controler/change_pasword_controller.dart';
import 'package:assistantstroke/page/login/home_login.dart';
import 'package:assistantstroke/page/main_home/home_profile/home_profile.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  // final String email;

  // const ChangePassword({Key? key, required this.email}) : super(key: key);
  const ChangePassword({Key? key}) : super(key: key);
  @override
  State<ChangePassword> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  late String email;

  @override
  void initState() {
    super.initState();
    // email = widget.email; // Lưu vào biến email
  }

  bool passwordVisible = false;
  bool passwordVisiblee = false;
  bool confirmPasswordVisible = false;
  final TextEditingController Password = TextEditingController();
  final TextEditingController Passwordnew = TextEditingController();
  final TextEditingController Re_passwordnew = TextEditingController();
  bool _isLoading = false;

  void _handlpasword() async {
    String password = Password.text.trim();
    String passwordnew = Passwordnew.text.trim();
    String re_passwordnew = Re_passwordnew.text.trim();
    print('$passwordnew / $password / $re_passwordnew');

    if (passwordnew.isEmpty || password.isEmpty || re_passwordnew.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin.')),
      );
      return;
    }

    if (passwordnew != re_passwordnew) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không trùng khớp.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Gọi API xử lý ở đây nếu cần, ví dụ:
    // bool success = await SomeController.resetPassword(otp: a, password: b);

    NewChangePassword forgotController = NewChangePassword(
      password: password,
      passwordnew: passwordnew,
    );
    bool success = await forgotController.forgot(context);

    setState(() => _isLoading = false);

    if (success) {
      print('Đổi mật khẩu thành công');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => HomeProfile(
                onLogout: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
        ),
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
                  "Thay đổi mật khẩu",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Vui lòng nhập mật cũ và mật khẩu mới để tiến hành đổi mật khẩu của bạn.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mật khẩu cũ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                _buildPasswordField(
                  hint: "Mật khẩu mới",
                  isVisible: passwordVisiblee,
                  toggleVisibility: () {
                    setState(() {
                      passwordVisiblee = !passwordVisiblee;
                    });
                  },
                  controller: Password,
                ),
                // SizedBox(height: 4),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Kiểm tra email của bạn",
                //     style: TextStyle(color: Colors.red, fontSize: 14),
                //   ),
                // ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mật khẩu mới",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                _buildPasswordField(
                  hint: "Mật khẩu mới",
                  isVisible: passwordVisible,
                  toggleVisibility: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  controller: Passwordnew,
                ),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nhập lại mật khẩu mới",
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
                  controller: Re_passwordnew,
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
