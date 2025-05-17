import 'package:assistantstroke/page/home/home_page.dart';
import 'package:assistantstroke/page/main_home/home_main_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNavbar extends StatefulWidget {
  @override
  _HomeNavbarState createState() => _HomeNavbarState();
}

class _HomeNavbarState extends State<HomeNavbar> {
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    setState(() {
      isLoggedIn = token != null;
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      isLoggedIn = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (!isLoggedIn!) {
      return HomePage();
    }

    return HomeScreen(onLogout: _logout);
  }
}
