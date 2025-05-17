import 'package:assistantstroke/controler/device_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceInputPage extends StatefulWidget {
  const DeviceInputPage({super.key});

  @override
  State<DeviceInputPage> createState() => _DeviceInputPageState();
}

class _DeviceInputPageState extends State<DeviceInputPage> {
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceTypeController = TextEditingController();
  final TextEditingController _seriesController = TextEditingController();

  bool _isLoading = false;
  BluetoothDevice? _connectedDevice;
  bool _isScanning = false;

  Future<void> _onSubmit() async {
    setState(() => _isLoading = true);
    if (_deviceNameController.text.isEmpty ||
        _deviceTypeController.text.isEmpty ||
        _seriesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      setState(() => _isLoading = false);
      return;
    }

    await DeviceController.submitDeviceInfo(
      context: context,
      deviceName: _deviceNameController.text,
      deviceType: _deviceTypeController.text,
      series: _seriesController.text,
    );

    setState(() => _isLoading = false);
  }

  Future<void> _connectBluetoothDevice() async {
    // Xin quyền Bluetooth trước
    Map<Permission, PermissionStatus> statuses =
        await [
          Permission.bluetooth,
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse,
        ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      _showPermissionDialog();
      return;
    }

    if (_isScanning) return; // Nếu đang quét thì không cho quét tiếp

    setState(() => _isScanning = true);

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    var subscription = FlutterBluePlus.scanResults.listen((results) async {
      if (results.isNotEmpty) {
        BluetoothDevice device = results.first.device;

        try {
          await device.connect();
          setState(() {
            _connectedDevice = device;
          });
          FlutterBluePlus.stopScan();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã kết nối với thiết bị: ${device.name}')),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Kết nối thất bại: $e')));
        }
      }
    });

    await Future.delayed(const Duration(seconds: 6));
    await subscription.cancel();

    setState(() => _isScanning = false);
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cần quyền Bluetooth'),
            content: const Text(
              'Ứng dụng cần quyền Bluetooth để kết nối thiết bị. Bạn có muốn mở Cài đặt không?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: const Text('Mở Cài đặt'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _deviceTypeController.dispose();
    _seriesController.dispose();
    _connectedDevice?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm thiết bị'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _deviceNameController,
              decoration: const InputDecoration(labelText: 'Tên thiết bị'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deviceTypeController,
              decoration: const InputDecoration(labelText: 'Loại thiết bị'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _seriesController,
              decoration: const InputDecoration(labelText: 'Series'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _onSubmit,
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Gửi thông tin'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _connectBluetoothDevice,
              icon: const Icon(Icons.bluetooth),
              label: Text(
                _isScanning ? 'Đang quét...' : 'Kết nối Bluetooth với thiết bị',
              ),
            ),
            if (_connectedDevice != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Đã kết nối với: ${_connectedDevice!.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
