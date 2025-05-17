import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          _buildSectionTitle("Account"),
          _buildSettingsItem(
            icon: Icons.person,
            text: 'Edit Profile',
            onTap: () {
              // TODO: Điều hướng đến trang chỉnh sửa hồ sơ
            },
          ),
          _buildSettingsItem(
            icon: Icons.lock,
            text: 'Change Password',
            onTap: () {
              // TODO: Điều hướng đến trang đổi mật khẩu
            },
          ),

          const Divider(height: 40),

          _buildSectionTitle("App"),
          _buildSettingsItem(
            icon: Icons.notifications,
            text: 'Notifications',
            onTap: () {
              // TODO: Điều hướng đến cài đặt thông báo
            },
          ),
          _buildSettingsItem(
            icon: Icons.language,
            text: 'Language',
            onTap: () {
              // TODO: Điều hướng đến cài đặt ngôn ngữ
            },
          ),
          _buildSettingsItem(
            icon: Icons.dark_mode,
            text: 'Dark Mode',
            trailing: Switch(value: false, onChanged: (val) {}),
          ),

          const Divider(height: 40),

          _buildSectionTitle("More"),
          _buildSettingsItem(
            icon: Icons.info,
            text: 'About',
            onTap: () {
              // TODO: Hiện dialog hoặc trang About
            },
          ),
          _buildSettingsItem(
            icon: Icons.help_outline,
            text: 'Help & Support',
            onTap: () {
              // TODO: Điều hướng đến trang trợ giúp
            },
          ),
          _buildSettingsItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              // TODO: Gọi hàm logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String text,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.cyan.shade100,
        child: Icon(icon, color: Colors.cyan),
      ),
      title: Text(text),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
