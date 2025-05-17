import 'package:assistantstroke/page/devices/device_input_page.dart';
import 'package:assistantstroke/page/devices/device_list_page.dart';
import 'package:flutter/material.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Thiết bị')),
      body: ListView(
        children: [
          _buildOption(
            icon: Icons.newspaper,
            title: 'Thêm Thiết Bị Mới',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeviceInputPage()),
              );
            },
          ),

          _buildOption(
            icon: Icons.list,
            title: 'Danh Sách Thiết Bị',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DeviceListPage()),
              );

              // TODO: Điều hướng tới trang danh sách người nhà
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.cyan,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.cyan),
      onTap: onTap,
    );
  }
}
