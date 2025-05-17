import 'package:assistantstroke/controler/usercontroller.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _controller = UserController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _gender = 'Nam';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      User user = await _controller.fetchUser();
      _nameController.text = user.patientName;
      _dobController.text = user.dateOfBirth; // Giữ nguyên thời gian đầy đủ
      _gender = user.gender ? 'Nam' : 'Nữ';
    } catch (e) {
      print('Lỗi khi tải user: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final user = User(
      patientName: _nameController.text,
      dateOfBirth:
          _dobController.text, // Lưu ngày sinh đầy đủ, bao gồm thời gian
      gender: _gender == 'Nam',
    );

    final success = await _controller.updateUser(user);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Cập nhật thành công' : 'Cập nhật thất bại'),
      ),
    );
  }

  Widget buildInputField(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.blueGrey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildInputDate(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
  ) {
    // return TextField(
    //   controller: controller,
    //   readOnly: true,
    //   onTap: () async {
    //     DateTime? pickedDate = await showDatePicker(
    //       context: context,
    //       initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
    //       firstDate: DateTime(1900),
    //       lastDate: DateTime.now(),
    //     );
    //     if (pickedDate != null) {
    //       controller.text =
    //           "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}T${pickedDate.hour.toString().padLeft(2, '0')}:${pickedDate.minute.toString().padLeft(2, '0')}:${pickedDate.second.toString().padLeft(2, '0')}.000Z";
    //     }
    //   },
    //   decoration: InputDecoration(
    //     labelText: label,
    //     hintText: hint,
    //     prefixIcon: Icon(icon),
    //     filled: true,
    //     fillColor: Colors.blueGrey[50],
    //     border: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide.none,
    //     ),
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            readOnly: true, // Chặn nhập tay, chỉ chọn qua DatePicker
            onTap: () => _selectDate(context),
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

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa hồ sơ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildInputField(
              'Họ tên',
              'Nhập họ tên',
              Icons.person,
              _nameController,
            ),
            const SizedBox(height: 20),
            buildInputDate(
              'Ngày sinh',
              'DD/MM/YYYY',
              Icons.calendar_today,
              _dobController,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: InputDecoration(
                labelText: 'Giới tính',
                prefixIcon: const Icon(Icons.wc),
                filled: true,
                fillColor: Colors.blueGrey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              items:
                  ['Nam', 'Nữ']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Lưu thông tin',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 24, 188, 203),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
