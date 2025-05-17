import 'package:assistantstroke/controler/family_controller.dart';
import 'package:flutter/material.dart';

class FamilyListPage extends StatefulWidget {
  const FamilyListPage({super.key});

  @override
  State<FamilyListPage> createState() => _FamilyListPageState();
}

class _FamilyListPageState extends State<FamilyListPage> {
  List<FamilyMember> familyMembers = [];
  bool _isLoading = true;
  final controller = FamilyController();

  @override
  void initState() {
    super.initState();
    _loadFamily();
  }

  Future<void> _loadFamily() async {
    final data = await controller.getFamilyMembers();
    setState(() {
      familyMembers = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteMember(FamilyMember member) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xoá'),
            content: Text('Bạn có chắc muốn xoá ${member.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Huỷ'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xoá'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await controller.deleteFamilyMember(member);
      if (success) {
        setState(() => familyMembers.remove(member));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Đã xoá ${member.name}')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Xoá thất bại')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách người nhà')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                itemCount: familyMembers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final member = familyMembers[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(
                        'assets/images/icon/avatar.jpg',
                      ),
                    ),
                    title: Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.email),
                        Text(
                          'Mối quan hệ: ${member.relationshipType}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMember(member),
                    ),
                  );
                },
              ),
    );
  }
}
