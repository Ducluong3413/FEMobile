import 'package:assistantstroke/controler/device_list_controller.dart';
import 'package:flutter/material.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  List<Device> devices = [];
  bool _isLoading = true;
  final controller = DeviceController();

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    final data = await controller.getDevices();
    setState(() {
      devices = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteDevice(Device device) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xoá'),
            content: Text(
              'Bạn có chắc muốn xoá thiết bị "${device.deviceName}"?',
            ),
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
      final success = await controller.deleteDevice(device.deviceId);
      if (success) {
        setState(() => devices.remove(device));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xoá thiết bị "${device.deviceName}"')),
        );
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
      appBar: AppBar(title: const Text('Danh sách thiết bị')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                itemCount: devices.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return ListTile(
                    leading: const Icon(Icons.devices),
                    title: Text(
                      device.deviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Loại: ${device.deviceType}\nSeries: ${device.series}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDevice(device),
                    ),
                  );
                },
              ),
    );
  }
}
