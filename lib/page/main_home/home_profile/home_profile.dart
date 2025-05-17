import 'package:assistantstroke/controler/profile_controller.dart';
import 'package:assistantstroke/page/Invitation/home.dart';
import 'package:assistantstroke/page/devices/home.dart';
import 'package:assistantstroke/page/home_profile_detail/change_password.dart';
import 'package:assistantstroke/page/home_profile_detail/editprofilepage.dart';
import 'package:assistantstroke/page/home_profile_detail/settings.dart';
import 'package:assistantstroke/page/main_home/home_profile/warning_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProfile extends StatefulWidget {
  final VoidCallback onLogout;

  HomeProfile({required this.onLogout});

  @override
  _HomeProfileState createState() => _HomeProfileState();
}

class _HomeProfileState extends State<HomeProfile> {
  String username = "Đang tải...";
  String email = "Đang tải...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    ProfileController profileController = ProfileController();
    Map<String, dynamic>? userData = await profileController.fetchUserData(
      context,
    );

    if (userData != null) {
      setState(() {
        username = userData['patientName'] ?? "Không có tên";
        // email = userData['email'] ?? "Không có email";
      });
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    widget.onLogout(); // Gọi hàm logout từ HomeNavbar
  }

  final List<Map<String, dynamic>> menuItems = [
    {"icon": Icons.person, "text": "Thông Tin Cá Nhân"},
    {"icon": Icons.warning, "text": "Thông Báo"},
    {"icon": Icons.favorite, "text": "Người Nhà"},
    {"icon": Icons.lock, "text": "Quản Lý Mật Khẩu"},
    {"icon": Icons.device_thermostat, "text": "Thiết Bị"},
    // {"icon": Icons.settings, "text": "Cài Đặt"},
    // {"icon": Icons.help, "text": "Tợ Giúp "},
    {"icon": Icons.logout, "text": "Đăng Xuất"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            // const Text(
            //   "User Information",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.cyan,
            //   ),
            // ),
            const SizedBox(height: 20),
            _buildUserProfile(),
            const SizedBox(height: 20),
            _buildMenuList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.transparent,
          // backgroundImage: AssetImage("assets/images/icon/IMG_1616.JPG"),
          backgroundImage: AssetImage("assets/images/icon/avatar.jpg"),
        ),
        const SizedBox(height: 10),
        Text(
          username,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Text(email, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildMenuList() {
    return Column(
      children: menuItems.map((item) => _buildMenuItem(item)).toList(),
    );
  }

  // Widget _buildMenuItem(Map<String, dynamic> item) {
  //   return ListTile(
  //     leading: CircleAvatar(
  //       backgroundColor: Colors.cyan,
  //       child: Icon(item["icon"], color: Colors.white),
  //     ),
  //     title: Text(item["text"]),
  //     trailing: const Icon(Icons.arrow_forward_ios, color: Colors.cyan),
  //     onTap: () {
  //       if (item["text"] == "Logout") {
  //         _logout();
  //       }
  //     },
  //   );
  // }
  Widget _buildMenuItem(Map<String, dynamic> item) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.cyan,
        child: Icon(item["icon"], color: Colors.white),
      ),
      title: Text(item["text"]),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.cyan),
      // onTap: () {
      //   switch (item["text"]) {
      //     case "Profile":
      //       Navigator.pushNamed(
      //         context,
      //         '/profile',
      //       ); // ví dụ điều hướng đến trang Profile
      //       break;
      //     case "More Emergency Phone Number":
      //       Navigator.pushNamed(context, '/emergency');
      //       break;
      //     case "Password Manager":
      //       Navigator.pushNamed(context, '/password');

      //       break;
      //     case "Settings":
      //       Navigator.pushNamed(context, '/settings');
      //       break;
      //     case "Help":
      //       Navigator.pushNamed(context, '/help');
      //       break;
      //     case "Logout":
      //       _logout();
      //       break;
      //     default:
      //       break;
      //   }
      // },
      onTap: () {
        switch (item["text"]) {
          case "Thông Tin Cá Nhân":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditProfilePage()),
            );
            break;
          case "Thông Báo":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WarningView()),
            );
            break;
          case "Người Nhà":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InvitationPage()),
            );
            break;
          case "Quản Lý Mật Khẩu":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword()),
            );
            break;
          case "Thiết Bị":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DevicesPage()),
            );
            break;

          case "Cài Đặt":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
            break;
          case "Trợ Giúp":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChangePassword()),
            );
            break;
          case "Đăng Xuất":
            _logout();
            break;
          default:
            break;
        }
      },
    );
  }
}
