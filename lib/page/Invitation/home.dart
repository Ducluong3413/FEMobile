import 'package:assistantstroke/page/Invitation/enterorscan.dart';
import 'package:assistantstroke/page/Invitation/family_list_page.dart';
import 'package:assistantstroke/page/Invitation/invitation_result_page.dart';
import 'package:flutter/material.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Lời Mời')),
      body: ListView(
        children: [
          _buildOption(
            icon: Icons.share,
            title: 'Chia Sẻ Lời Mời',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InvitationResultPage()),
              );
            },
          ),
          _buildOption(
            icon: Icons.input,
            title: 'Nhập Lời Mời',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EnterOrScanInvitationPage(),
                ),
              );
              // TODO: Điều hướng tới trang nhập lời mời
            },
          ),
          _buildOption(
            icon: Icons.group,
            title: 'Danh Sách Người Nhà',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FamilyListPage()),
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
