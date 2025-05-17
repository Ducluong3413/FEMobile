import 'package:assistantstroke/controler/otp_controller.dart';
import 'package:assistantstroke/controler/singn_controller.dart';
import 'package:assistantstroke/page/forget_password/home_otp.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'package:assistantstroke/page/login/home_login.dart';

class SignUp extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<SignUp> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();

  bool _isLoading = false;

  void _handleSign() async {
    String username = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String re_password = _rePasswordController.text.trim();
    String dob = _dobController.text.trim();
    String sex = _sexController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập email hoặc số điện thoại và mật khẩu'),
        ),
      );
      return;
    } else if (password != re_password) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mật khẩu không khớp')));
      return;
    }

    setState(() => _isLoading = true);

    // Pass data to LoginController
    SignController signController = SignController(
      username: username,
      email: email,
      phone: phone,
      password: password,
      dob: dob,
      sex: sex,
    );
    await signController.sign(context); // Call login method
    // Truyền dữ liệu sang OtpController
    // OtpController otpController = OtpController(
    //   otp: otp, // Bạn sẽ có OTP từ màn hình OTP
    //   username: username,
    //   email: email,
    //   phone: phone,
    //   password: password,
    //   dob: dob,
    //   sex: sex,
    // );
    // await otpController.Otp(context); // Gọi phương thức OTP

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  "Đăng Ký",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 24, 188, 203),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildInputField(
                "Họ và Tên",
                "Nhập Họ và Tên",
                Icons.person,
                _fullNameController,
              ),
              buildInputField(
                "Email",
                "Nhập Email",
                Icons.email,
                _emailController,
              ),
              buildInputField(
                "Số điện thoại",
                "Nhập số điện thoại",
                Icons.phone,
                _phoneController,
              ),
              buildInputField(
                "Mật khẩu",
                "Nhập  mật khẩu",
                Icons.lock,
                _passwordController,
                isPassword: true,
              ),
              buildInputField(
                "Nhập lại mật khẩu",
                "Nhập lại mật khẩu",
                Icons.lock,
                _rePasswordController,
                isPassword: true,
              ),
              Row(
                children: [
                  Expanded(
                    // child: buildInputField(
                    //   "Date Of Birth",
                    //   "DD/MM/YYYY",
                    //   Icons.calendar_today,
                    //   _dobController,
                    // ),
                    child: buildInputdate(
                      "Ngày Sinh",
                      "DD/MM/YYYY",
                      Icons.calendar_today,
                      _dobController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Expanded(
                  //   child: buildInputField(
                  //     "Sex",
                  //     "Male/Female",
                  //     Icons.wc,
                  //     _sexController,
                  //   ),
                  // ),
                  Expanded(
                    child: buildInputSex("Giới tính", Icons.wc, _sexController),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Bằng cách tiếp tục, Bạn đồng ý",
                      style: TextStyle(color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "Điều khoản sử dụng và Chính sách bảo mật.",
                        style: TextStyle(
                          color: Color.fromARGB(255, 24, 188, 203),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSign,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Color.fromARGB(255, 24, 188, 203),
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
              // const SizedBox(height: 20),
              // const Center(child: Text("or sign up with")),
              // const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: const [
              //     Icon(
              //       Icons.g_mobiledata,
              //       size: 40,
              //       color: Color.fromARGB(255, 24, 188, 203),
              //     ),
              //     SizedBox(width: 20),
              //     Icon(
              //       Icons.facebook,
              //       size: 40,
              //       color: Color.fromARGB(255, 24, 188, 203),
              //     ),
              //     SizedBox(width: 20),
              //     Icon(
              //       Icons.fingerprint,
              //       size: 40,
              //       color: Color.fromARGB(255, 24, 188, 203),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeLogin()),
                    );
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: "Bạn đã có tài khoản? ",
                      children: [
                        TextSpan(
                          text: "Đăng Nhập",
                          style: TextStyle(
                            color: Color.fromARGB(255, 24, 188, 203),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: hint,
              filled: true,
              fillColor: Colors.blueGrey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputdate(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: controller,
            readOnly: true, // Chặn nhập tay, chỉ chọn qua DatePicker
            onTap: () => _selectDate(context),
            obscureText: isPassword,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: "YYYY-MM-DD",
              // hintText: hint,
              filled: true,
              fillColor: Colors.blueGrey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputSex(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: Colors.blueGrey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            items: [
              DropdownMenuItem(value: "true", child: Text("Nam")),
              DropdownMenuItem(value: "false", child: Text("Nữ")),
            ],
            onChanged: (value) {
              setState(() {
                controller.text = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  // Hàm mở DatePicker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      // Format lại ngày thành yyyy-MM-dd
      String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }
}
