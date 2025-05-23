// import 'package:assistantstroke/controler/device_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';

// class DeviceInputPage extends StatefulWidget {
//   const DeviceInputPage({super.key});

//   @override
//   State<DeviceInputPage> createState() => _DeviceInputPageState();
// }

// class _DeviceInputPageState extends State<DeviceInputPage> {
//   final TextEditingController _deviceNameController = TextEditingController();
//   final TextEditingController _deviceTypeController = TextEditingController();
//   final TextEditingController _seriesController = TextEditingController();

//   bool _isLoading = false;
//   BluetoothDevice? _connectedDevice;
//   bool _isScanning = false;

//   Future<void> _onSubmit() async {
//     setState(() => _isLoading = true);
//     if (_deviceNameController.text.isEmpty ||
//         _deviceTypeController.text.isEmpty ||
//         _seriesController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     await DeviceController.submitDeviceInfo(
//       context: context,
//       deviceName: _deviceNameController.text,
//       deviceType: _deviceTypeController.text,
//       series: _seriesController.text,
//     );

//     setState(() => _isLoading = false);
//   }

//   Future<void> _connectBluetoothDevice() async {
//     // Xin quyền Bluetooth trước
//     Map<Permission, PermissionStatus> statuses =
//         await [
//           Permission.bluetooth,
//           Permission.bluetoothScan,
//           Permission.bluetoothConnect,
//           Permission.locationWhenInUse,
//         ].request();

//     bool allGranted = statuses.values.every((status) => status.isGranted);
//     if (!allGranted) {
//       _showPermissionDialog();
//       return;
//     }

//     if (_isScanning) return; // Nếu đang quét thì không cho quét tiếp

//     setState(() => _isScanning = true);

//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

//     var subscription = FlutterBluePlus.scanResults.listen((results) async {
//       if (results.isNotEmpty) {
//         BluetoothDevice device = results.first.device;

//         try {
//           await device.connect();
//           setState(() {
//             _connectedDevice = device;
//           });
//           FlutterBluePlus.stopScan();

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Đã kết nối với thiết bị: ${device.name}')),
//           );
//         } catch (e) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('Kết nối thất bại: $e')));
//         }
//       }
//     });

//     await Future.delayed(const Duration(seconds: 6));
//     await subscription.cancel();

//     setState(() => _isScanning = false);
//   }

//   void _showPermissionDialog() {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Cần quyền Bluetooth'),
//             content: const Text(
//               'Ứng dụng cần quyền Bluetooth để kết nối thiết bị. Bạn có muốn mở Cài đặt không?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Hủy'),
//               ),
//               TextButton(
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   await openAppSettings();
//                 },
//                 child: const Text('Mở Cài đặt'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   void dispose() {
//     _deviceNameController.dispose();
//     _deviceTypeController.dispose();
//     _seriesController.dispose();
//     _connectedDevice?.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Thêm thiết bị'), centerTitle: true),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _deviceNameController,
//               decoration: const InputDecoration(labelText: 'Tên thiết bị'),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _deviceTypeController,
//               decoration: const InputDecoration(labelText: 'Loại thiết bị'),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: _seriesController,
//               decoration: const InputDecoration(labelText: 'Series'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _onSubmit,
//               child:
//                   _isLoading
//                       ? const CircularProgressIndicator()
//                       : const Text('Gửi thông tin'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _connectBluetoothDevice,
//               icon: const Icon(Icons.bluetooth),
//               label: Text(
//                 _isScanning ? 'Đang quét...' : 'Kết nối Bluetooth với thiết bị',
//               ),
//             ),
//             if (_connectedDevice != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Text(
//                   'Đã kết nối với: ${_connectedDevice!.name}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:assistantstroke/controler/device_controller.dart';
import 'package:assistantstroke/services/bluetooth_service.dart';

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
  bool _isScanning = false;
  List<BluetoothDevice> _devicesList = [];

  double? _systolic;
  double? _diastolic;
  double? _temperature;
  double? _bloodPh;
  int? _spo2;
  int? _heartRate;

  @override
  void initState() {
    super.initState();
    BluetoothService().onDataReceived.listen((data) {
      setState(() {
        _systolic = data['SystolicPressure']?.toDouble();
        _diastolic = data['DiastolicPressure']?.toDouble();
        _temperature = data['Temperature']?.toDouble();
        _bloodPh = data['BloodPh']?.toDouble();
        _spo2 = data['Spo2Information']?.toInt();
        _heartRate = data['HeartRate']?.toInt();
      });
    });
  }

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

  Future<void> _connectBluetoothDevice(BluetoothDevice device) async {
    Map<perm.Permission, perm.PermissionStatus> statuses =
        await [
          perm.Permission.bluetooth,
          perm.Permission.bluetoothConnect,
        ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      _showPermissionDialog();
      return;
    }

    try {
      await BluetoothService().connect(device, context);
      setState(() {
        _deviceNameController.text = device.name ?? "Không tên";
        _deviceTypeController.text = "Đo sức khỏe";
        _seriesController.text = device.address;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã kết nối với thiết bị: ${device.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Kết nối thất bại: $e')));
    }
  }

  Future<void> _scanForDevices() async {
    if (_isScanning) return;

    Map<perm.Permission, perm.PermissionStatus> statuses =
        await [
          perm.Permission.bluetoothScan,
          perm.Permission.bluetoothConnect,
        ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      _showPermissionDialog();
      return;
    }

    setState(() {
      _isScanning = true;
      _devicesList.clear();
    });

    FlutterBluetoothSerial.instance.getBondedDevices().then((devices) {
      setState(() {
        _devicesList = devices;
        _isScanning = false;
      });
    });
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
                  await perm.openAppSettings();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhập thông tin thiết bị')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _deviceNameController,
              decoration: const InputDecoration(labelText: 'Tên thiết bị'),
              // readOnly: true,
            ),
            TextField(
              controller: _deviceTypeController,
              decoration: const InputDecoration(labelText: 'Loại thiết bị'),
              // readOnly: true,
            ),
            TextField(
              controller: _seriesController,
              decoration: const InputDecoration(labelText: 'Series'),
              // readOnly: true,
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
            ElevatedButton(
              onPressed: _scanForDevices,
              child: const Text('Quét thiết bị Bluetooth'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _devicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_devicesList[index].name ?? "Không tên"),
                    subtitle: Text(_devicesList[index].address),
                    onTap: () => _connectBluetoothDevice(_devicesList[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📡 Dữ liệu nhận từ ESP32:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_systolic != null)
                  Text("🔴 Huyết áp tâm thu: $_systolic mmHg"),
                if (_diastolic != null)
                  Text("🔵 Huyết áp tâm trương: $_diastolic mmHg"),
                if (_temperature != null)
                  Text("🌡️ Nhiệt độ cơ thể: $_temperature °C"),
                if (_bloodPh != null) Text("🧪 pH máu: $_bloodPh"),
                if (_spo2 != null) Text("🫁 SpO₂: $_spo2%"),
                if (_heartRate != null) Text("❤️ Nhịp tim: $_heartRate BPM"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
