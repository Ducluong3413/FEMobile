import 'package:assistantstroke/chatbox.dart';
import 'package:assistantstroke/page/firstaidstrokepage/firstaidstroke.dart';
import 'package:assistantstroke/page/main_home/SymptomFormPage/SymptomFormPage.dart';
import 'package:assistantstroke/page/main_home/SymptomFormPage/symptom_all.dart';
import 'package:assistantstroke/page/main_home/home_history/home_history.dart';
import 'package:assistantstroke/page/main_home/home_map/home_map.dart';
import 'package:assistantstroke/page/main_home/home_profile/home_profile.dart';
import 'package:assistantstroke/page/main_home/home_view/home_view.dart';
import 'package:assistantstroke/page/main_home/home_view/home_view_all.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  HomeScreen({required this.onLogout});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HealthDashboard(),
      HomeMap(),
      // HomeHistory(),
      ChatApp(),
      SymptomFormPage(),
      IndicatorView(),
      FirstAidStrokePage(),
      HomeProfile(onLogout: widget.onLogout), // Truyền onLogout vào HomeProfile
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.cyan.withOpacity(0.5),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Bản đồ"),
          // BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Lượng Đồ"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chatbot"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Biểu Hiện"),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_calendar),
            label: "Chỉ số",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: "Sơ cứu",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Hồ sơ"),
        ],
      ),
    );
  }
}
