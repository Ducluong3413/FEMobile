import 'package:assistantstroke/controler/user_gps_controller.dart';
import 'package:assistantstroke/page/forget_password/home_forget_password.dart';
import 'package:assistantstroke/page/login/home_login.dart';
import 'package:assistantstroke/page/main_home/home_navbar.dart';
// import 'package:assistantstroke/page/main_home/home_main_home.dart';

import 'package:flutter/material.dart';
import 'package:assistantstroke/page/home/widgets/home_stroke_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gpsController = UserGpsController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    sendGps();
  }

  Future<void> sendGps() async {
    await gpsController.sendUserGps();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Nếu token tồn tại, chuyển thẳng đến trang chính
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeNavbar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: const Color.fromARGB(255, 255, 255, 255),
        // decoration: BoxDecoration(
        //   gradient: SweepGradient(colors: [Colors.white]),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeStrokeIcon(),

            Text(
              'Stroke AI',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: const Color.fromARGB(255, 24, 188, 203),
              ),
            ),
            Container(
              width: 300,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                'Ứng dụng hỗ trợ người bệnh đột quỵ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            Container(
              width: 210,
              height: 50,

              margin: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeLogin(),
                    ), // Mở trang mới
                  );
                  print('Sign Up');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                    255,
                    33,
                    212,
                    243,
                  ), // Màu nền của button
                  foregroundColor: const Color.fromARGB(255, 253, 253, 253),

                  shadowColor: Colors.black, // Thêm bóng cho button khi nhấn
                  elevation: 10,
                ),
                child: Text(
                  'Đăng Nhập',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              width: 210,
              height: 50,
              margin: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(),
                    ), // Mở trang mới
                  );
                  print('Sign Up');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 69, 68, 68),

                  shadowColor: Colors.black, // Thêm bóng cho button khi nhấn
                  elevation: 10,
                ),
                child: Text(
                  'Đăng ký',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
