import 'package:assistantstroke/controler/data/averageall14day_controller.dart';
import 'package:assistantstroke/controler/data/dailyDay_controller.dart';
import 'package:assistantstroke/controler/device_list_controller.dart';
import 'package:assistantstroke/controler/family_controller.dart';
import 'package:assistantstroke/controler/indicators_controller.dart';
import 'package:assistantstroke/controler/usermedicaldatas_controller.dart';
import 'package:assistantstroke/model/UserMedicalDataResponse.dart';
import 'package:assistantstroke/model/averageall14daynew.dart';
import 'package:assistantstroke/model/dailyDay.dart';
import 'package:assistantstroke/model/indicatorModel.dart';
import 'package:assistantstroke/page/main_home/home_profile/warning_view.dart';
import 'package:assistantstroke/widgets/notification_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart' as radar_chart;
import 'package:shared_preferences/shared_preferences.dart';

class HealthDashboard extends StatefulWidget {
  @override
  _HealthDashboardState createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard> {
  UserMedicalDataResponse? medicalData;
  IndicatorModel? indicatorData;
  List<Result>? results;
  List<DailyDay>? dailyData;
  bool isLoading = true;
  bool isLoaded = false;
  int? selectedDayIndex;
  final FamilyController familyController = FamilyController();
  List<FamilyMember> familyMembers = [];
  FamilyMember? selectedFamilyMember;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _loadFamilyMembers();
  }

  Future<void> _loadAllData({int? familyUserId}) async {
    if (familyUserId != null) {
      print('familyUserId: $familyUserId');
      final deviceController = DeviceController();

      final devices = await deviceController.getDevices(familyUserId);
      if (devices.isEmpty) {
        setState(() {
          isLoading = false;
          isLoaded = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Không có thiết bị nào.')));
        return;
      }

      final deviceId = devices.first.deviceId;

      try {
        // Fetch all data concurrently
        final medicalController = UserMedicalDataController();
        final indicatorController = IndicatorController();
        final remoteService = RemoteService();
        final dailyController = RemoteDailyController();
        final a = await medicalController.fetchUserMedicalData(deviceId);
        print('a: $a');

        final b = await indicatorController.fetchIndicatorData(familyUserId);
        print('b: $b');
        final c = await remoteService.fetchResults(deviceId);
        print('c: $c');
        // final [
        //   fetchedMedicalData,
        //   fetchedIndicatorData,
        //   fetchedResults,
        // ] = await Future.wait([
        //   medicalController.fetchUserMedicalData(deviceId),
        //   indicatorController.fetchIndicatorData(),
        //   remoteService.fetchResults(deviceId),
        // ]);

        setState(() {
          medicalData = a;
          indicatorData = b;
          results = c;
          isLoading = false;
          isLoaded = true;
          print('medicalData: $medicalData');
          print('indicatorData: $indicatorData');
          print('results: $results');
        });
      } catch (e) {
        print('Lỗi: $e');
        setState(() {
          isLoading = false;
          isLoaded = false;
        });
      }
    } else {
      final deviceController = DeviceController();
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      print('userId: $userId');

      // 🔹 Gọi indicator trước vì không phụ thuộc device
      final indicatorController = IndicatorController();
      late final dynamic indicatorData;
      try {
        indicatorData = await indicatorController.fetchIndicatorData(userId);
        print('b: $indicatorData');
      } catch (e) {
        print('❌ Lỗi khi lấy dữ liệu indicator: $e');
      }

      final devices = await deviceController.getDevices(userId);
      if (devices.isEmpty) {
        setState(() {
          isLoading = false;
          isLoaded = false;
          this.indicatorData = indicatorData; // vẫn hiển thị nếu muốn
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Không có thiết bị nào.')));
        return;
      }

      final deviceId = devices.first.deviceId;

      try {
        final medicalController = UserMedicalDataController();
        final remoteService = RemoteService();

        final medicalData = await medicalController.fetchUserMedicalData(
          deviceId,
        );
        final results = await remoteService.fetchResults(deviceId);

        setState(() {
          this.medicalData = medicalData;
          this.indicatorData = indicatorData;
          this.results = results;
          isLoading = false;
          isLoaded = true;
        });
      } catch (e) {
        print('❌ Lỗi khi lấy dữ liệu thiết bị: $e');
        setState(() {
          isLoading = false;
          isLoaded = false;
          this.indicatorData = indicatorData; // giữ lại phần đã load được
        });
      }
    }
  }

  Future<void> fetchDailyDay(String date) async {
    final deviceController = DeviceController();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final devices = await deviceController.getDevices(userId);
    if (devices.isEmpty) {
      setState(() {
        isLoaded = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không có thiết bị nào.')));
      return;
    }

    final deviceId = devices.first.deviceId;
    final response = await RemoteDailyController().fetchDailyDay(
      date,
      deviceId,
    );
    setState(() {
      dailyData = response;
      isLoaded = response != null;
    });
  }

  Future<void> _loadFamilyMembers() async {
    try {
      final members = await familyController.getFamilyMembers();
      setState(() {
        familyMembers = members;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải danh sách người nhà: $e')),
      );
    }
  }

  void _showFamilyMemberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn Người Thân'),
          content: Container(
            width: double.maxFinite,
            child:
                familyMembers.isEmpty
                    ? const Text('Không có người thân nào.')
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: familyMembers.length,
                      itemBuilder: (context, index) {
                        final member = familyMembers[index];
                        return ListTile(
                          title: Text(member.name),
                          subtitle: Text(
                            '${member.relationshipType} - ${member.email}',
                          ),
                          onTap: () {
                            setState(() {
                              selectedFamilyMember = member;
                              isLoading = true;
                            });
                            _loadAllData(familyUserId: member.inviterId);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Hồ Sơ Sức Khỏe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.family_restroom),
            onPressed: _showFamilyMemberDialog,
            tooltip: 'Chọn người thân',
          ),
          IconButton(
            icon: const Icon(Icons.warning_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WarningView()),
              );
            },
          ),
          NotificationButton(),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stroke Risk Section
                    _buildStrokeRiskSection(),
                    const SizedBox(height: 30),
                    // Radar Chart Section
                    _buildRadarChartSection(),
                    const SizedBox(height: 30),
                    // Health Metrics History Section
                    _buildHealthMetricsSection(),
                    const SizedBox(height: 20),
                    // Day Selection Buttons
                    _buildDayButtons(),
                  ],
                ),
              ),
    );
  }

  Widget _buildStrokeRiskSection() {
    final piePositive = (indicatorData?.percent ?? 0).toDouble();
    final pieNegative = (100 - piePositive).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nguy Cơ Đột Quỵ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
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
                  titleStyle: const TextStyle(
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
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(width: 20, height: 20, color: Colors.red),
            const SizedBox(width: 10),
            const Text('NGUY CƠ ĐỘT QUỴ'),
            const SizedBox(width: 20),
            Container(width: 20, height: 20, color: Colors.blue),
            const SizedBox(width: 10),
            const Text('ÂM TÍNH'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadarChartSection() {
    final radarValues = [
      medicalData?.dataPercent?['temperature'] ?? 0.0,
      medicalData?.dataPercent?['spO2'] ?? 0.0,
      medicalData?.dataPercent?['heartRate'] ?? 0.0,
      medicalData?.dataPercent?['bloodPh'] ?? 0.0,
      medicalData?.dataPercent?['systolicPressure'] ?? 0.0,
      medicalData?.dataPercent?['diastolicPressure'] ?? 0.0,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Biểu Đồ Radar Chỉ Số Sức Khỏe',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          child: radar_chart.RadarChart.light(
            ticks: const [0, 1, 2, 3, 4],
            features: const [
              'NHIỆT ĐỘ',
              'SPO2',
              'MẠCH ĐẬP',
              'PH',
              'H.ÁP TÂM THU',
              'H.ÁP TÂM TRƯƠNG',
            ],
            data: [radarValues],
            reverseAxis: false,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthMetricsSection() {
    return Column(
      children: [
        _buildChart(
          'Huyết Áp Tâm Thu',
          Colors.red,
          Colors.blue,
          _getSystolicData(),
        ),
        _buildChart(
          'Huyết Áp Tâm Trương',
          Colors.red,
          Colors.blue,
          _getDiastolicData(),
        ),
        _buildChart('SpO2', Colors.red, Colors.blue, _getSpO2Data()),
        _buildChart(
          'Nhiệt Độ (°C)',
          Colors.red,
          Colors.blue,
          _getTemperatureData(),
        ),
        _buildChart(
          'Mạch Đập (bpm)',
          Colors.red,
          Colors.blue,
          _getHeartRateData(),
        ),
        _buildChart('pH', Colors.red, Colors.blue, _getBloodPhData()),
      ],
    );
  }

  Widget _buildChart(
    String title,
    Color color1,
    Color color2,
    List<List<double>> data,
  ) {
    List<double> ngay = [];
    List<double> dem = [];
    List<double> gio = [];
    if (selectedDayIndex == null) {
      ngay = data[0];
      dem = data[1];
    } else {
      gio = data[0];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          child: BarChart(
            BarChartData(
              barGroups:
                  selectedDayIndex == null
                      ? _buildBarGroups(ngay, dem)
                      : _buildBarDailyday(gio),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget:
                        (value, meta) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 10),
                        ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget:
                        (value, meta) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 10),
                        ),
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              selectedDayIndex == null
                  ? [
                    _buildLegend(color1, 'Ngày'),
                    const SizedBox(width: 16),
                    _buildLegend(color2, 'Đêm'),
                  ]
                  : [_buildLegend(color1, 'Giờ'), const SizedBox(width: 16)],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<double> ngay, List<double> dem) {
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < ngay.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(toY: ngay[i], color: Colors.red, width: 8),
            BarChartRodData(toY: dem[i], color: Colors.blue, width: 8),
          ],
        ),
      );
    }
    return groups;
  }

  List<BarChartGroupData> _buildBarDailyday(List<double> gio) {
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < gio.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i + 1,
          barRods: [BarChartRodData(toY: gio[i], color: Colors.red, width: 8)],
        ),
      );
    }
    return groups;
  }

  Widget _buildDayButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                selectedDayIndex == null ? Colors.blue : Colors.grey[300],
            foregroundColor:
                selectedDayIndex == null ? Colors.white : Colors.black,
          ),
          onPressed: () {
            setState(() {
              selectedDayIndex = null;
            });
          },
          child: const Text('ALL'),
        ),
        ...List.generate(14, (index) {
          DateTime day = DateTime.now().subtract(Duration(days: index));
          String dayString = day.toIso8601String().split('T')[0];
          final isSelected = selectedDayIndex == index;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
              foregroundColor: isSelected ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                selectedDayIndex = isSelected ? null : index;
              });
              if (selectedDayIndex != null) {
                fetchDailyDay(dayString);
              }
            },
            child: Text(dayString),
          );
        }),
      ],
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  List<List<double>> _getSystolicData() {
    if (results == null) return [[], []];
    if (selectedDayIndex == null) {
      final ngay =
          results
              ?.map((e) => e.dailyAverage?.averageSystolicPressure)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      final dem =
          results
              ?.map((e) => e.nightlyAverage?.averageSystolicPressure)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      return [ngay, dem];
    } else {
      final gio =
          dailyData
              ?.map((e) => e.systolicPressure)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];
      return [gio];
    }
  }

  List<List<double>> _getDiastolicData() {
    if (results == null) return [[], []];
    if (selectedDayIndex == null) {
      final ngay =
          results
              ?.map((e) => e.dailyAverage?.averageDiastolicPressure)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      final dem =
          results
              ?.map((e) => e.nightlyAverage?.averageDiastolicPressure)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      return [ngay, dem];
    } else {
      final gio =
          dailyData
              ?.map((e) => e.diastolicPressure)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];
      return [gio];
    }
  }

  List<List<double>> _getSpO2Data() {
    if (results == null) return [[], []];
    if (selectedDayIndex == null) {
      final ngay =
          results
              ?.map((e) => e.dailyAverage?.averageSpO2)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      final dem =
          results
              ?.map((e) => e.nightlyAverage?.averageSpO2)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      return [ngay, dem];
    } else {
      final gio =
          dailyData
              ?.map((e) => e.spo2Information)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];
      return [gio];
    }
  }

  List<List<double>> _getTemperatureData() {
    if (results == null) return [[], []];
    if (selectedDayIndex == null) {
      final ngay =
          results
              ?.map((e) => e.dailyAverage?.averageTemperature)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      final dem =
          results
              ?.map((e) => e.nightlyAverage?.averageTemperature)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      return [ngay, dem];
    } else {
      final gio =
          dailyData
              ?.map((e) => e.temperature)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];
      return [gio];
    }
  }

  List<List<double>> _getHeartRateData() {
    if (results == null) return [[], []];
    if (selectedDayIndex == null) {
      final ngay =
          results
              ?.map((e) => e.dailyAverage?.averageHeartRate)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      final dem =
          results
              ?.map((e) => e.nightlyAverage?.averageHeartRate)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      return [ngay, dem];
    } else {
      final gio =
          dailyData
              ?.map((e) => e.heartRate)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];
      return [gio];
    }
  }

  List<List<double>> _getBloodPhData() {
    if (results == null) return [[], []];
    if (selectedDayIndex == null) {
      final ngay =
          results
              ?.map((e) => e.dailyAverage?.averageBloodPh)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      final dem =
          results
              ?.map((e) => e.nightlyAverage?.averageBloodPh)
              .where((e) => e != null)
              .map((e) => e!)
              .toList() ??
          [];
      return [ngay, dem];
    } else {
      final gio =
          dailyData
              ?.map((e) => e.bloodPh)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];
      return [gio];
    }
  }
}
