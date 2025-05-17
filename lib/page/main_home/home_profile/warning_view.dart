import 'package:assistantstroke/controler/data/averageall14day_controller.dart';
import 'package:flutter/material.dart';
import 'package:assistantstroke/model/averageall14daynew.dart';

class WarningView extends StatefulWidget {
  const WarningView({super.key});

  @override
  State<WarningView> createState() => _WarningViewState();
}

class _WarningViewState extends State<WarningView> {
  late Future<List<Warning>?> _warningFuture;

  @override
  void initState() {
    super.initState();
    _warningFuture = RemoteService().fetchWarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cảnh báo chỉ số')),
      body: FutureBuilder<List<Warning>?>(
        future: _warningFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có cảnh báo'));
          } else {
            var warnings = snapshot.data!;
            return ListView.builder(
              itemCount: warnings.length,
              itemBuilder: (context, index) {
                var warning = warnings[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWarningItem('Nhiệt độ', warning.temperature),
                        _buildWarningItem('SpO2', warning.spO2),
                        _buildWarningItem('Nhịp tim', warning.heartRate),
                        _buildWarningItem('pH máu', warning.bloodPh),
                        _buildWarningItem(
                          'Huyết áp tâm thu',
                          warning.systolicPressure,
                        ),
                        _buildWarningItem(
                          'Huyết áp tâm trương',
                          warning.diastolicPressure,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildWarningItem(String title, String value) {
    Color statusColor;
    switch (value) {
      case 'Risk':
        statusColor = Colors.red;
        break;
      case 'Normal':
        statusColor = Colors.green;
        break;
      case 'Warning':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _translateStatus(value),
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'Risk':
        return 'NGUY HIỂM';
      case 'Normal':
        return 'Bình thường';
      case 'Warning':
        return 'Cảnh báo';
      default:
        return 'Không xác định';
    }
  }
}
