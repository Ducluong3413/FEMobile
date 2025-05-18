import 'package:assistantstroke/controler/data/averageall14day_controller.dart';
import 'package:assistantstroke/controler/device_list_controller.dart';
import 'package:assistantstroke/controler/indicators_controller.dart';
import 'package:assistantstroke/controler/usermedicaldatas_controller.dart';
import 'package:assistantstroke/model/UserMedicalDataResponse.dart';
import 'package:assistantstroke/model/averageall14daynew.dart';
import 'package:assistantstroke/model/indicatorModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart' as radar_chart;
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int? selectedDayIndex;
  IndicatorModel? indicatorData;
  bool isLoading = true;
  UserMedicalDataResponse? data;

  // Biến để lưu dataPercentList
  List<Map<String, dynamic>> dataPercentList = [];

  @override
  void initState() {
    super.initState();
    _loadIndicatorData();
  }

  void _loadIndicatorData() async {
    final controller = IndicatorController();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final result = await controller.fetchIndicatorData(userId);

    setState(() {
      indicatorData = result;
      isLoading = false;
      _loadData();
    });
  }

  double? temperature;
  double? spO2;
  double? heartRate;
  double? bloodPh;
  double? systolicPressure;
  double? diastolicPressure;

  Future<void> _loadData() async {
    final deviceController = DeviceController();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final devices = await deviceController.getDevices(userId);
    final controller = UserMedicalDataController();
    if (devices.isNotEmpty) {
      final deviceId =
          devices.first.deviceId; // hoặc chọn thiết bị khác theo logic bạn muốn
      final medicalController = UserMedicalDataController();

      // dùng data tiếp theo...

      try {
        final fetchedData = await controller.fetchUserMedicalData(deviceId);
        setState(() {
          data = fetchedData;
          isLoading = false;

          if (data?.dataPercent != null) {
            // Lưu từng giá trị vào các biến riêng biệt
            temperature = data!.dataPercent!['temperature'];
            spO2 = data!.dataPercent!['spO2'];
            heartRate = data!.dataPercent!['heartRate'];
            bloodPh = data!.dataPercent!['bloodPh'];
            systolicPressure = data!.dataPercent!['systolicPressure'];
            diastolicPressure = data!.dataPercent!['diastolicPressure'];

            // Assign values to a list or process them as needed
            final radarValues = [
              temperature,
              spO2,
              heartRate,
              bloodPh,
              systolicPressure,
              diastolicPressure,
            ];
          }
        });
      } catch (e) {
        print('Lỗi: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('Không có thiết bị nào được tìm thấy.');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu radar từ indicatorData
    final radarValues = [
      temperature ?? 0.0,
      spO2 ?? 0.0,
      heartRate ?? 0.0,
      bloodPh ?? 0.0,
      systolicPressure ?? 0.0,
      diastolicPressure ?? 0.0,
    ];
    print('Radar Values: $radarValues');
    final piePositive = (indicatorData?.percent ?? 0).toDouble();
    final pieNegative = (100 - piePositive).toDouble();

    return Scaffold(
      appBar: AppBar(title: Text('Biểu đồ nguy cơ đột quỵ & Radar')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : indicatorData == null
              ? Center(child: Text("Không có dữ liệu"))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Biểu đồ tròn
                    SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: piePositive,
                              color: Colors.red,
                              radius: 55,
                              title: '${piePositive.toStringAsFixed(0)}%',
                              titleStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: pieNegative,
                              color: Colors.blue,
                              radius: 50,
                              title: '${pieNegative.toStringAsFixed(0)}%',
                              titleStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(width: 20, height: 20, color: Colors.red),
                        SizedBox(width: 10),
                        Text('NGUY CƠ ĐỘT QUỴ'),
                        SizedBox(width: 20),
                        Container(width: 20, height: 20, color: Colors.blue),
                        SizedBox(width: 10),
                        Text('ÂM TÍNH'),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Biểu đồ radar
                    SizedBox(
                      height: 300,
                      child: radar_chart.RadarChart.light(
                        ticks: [0, 1, 2, 3, 4],
                        features: [
                          'NHIỆT ĐỘ',
                          'SPO2',
                          'MẠCH ĐẬP',
                          'PH',
                          'HUYẾT ÁP',
                        ],
                        data: [radarValues],

                        reverseAxis: false,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
