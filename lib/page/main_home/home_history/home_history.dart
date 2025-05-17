import 'package:assistantstroke/controler/data/averageall14day_controller.dart';
import 'package:assistantstroke/controler/data/dailyDay_controller.dart';
import 'package:assistantstroke/controler/device_list_controller.dart';
import 'package:assistantstroke/controler/usermedicaldatas_controller.dart';
import 'package:assistantstroke/model/UserMedicalDataResponse.dart';
import 'package:assistantstroke/model/averageall14daynew.dart';
import 'package:assistantstroke/model/dailyDay.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeHistory extends StatefulWidget {
  @override
  State<HomeHistory> createState() => _HomeHistoryState();
}

class _HomeHistoryState extends State<HomeHistory> {
  UserMedicalDataResponse? data;
  bool isLoading = true;
  List<Result>? result;
  List<DailyDay>? dailyday;

  @override
  void initState() {
    super.initState();
    fetchResults();
    _loadData();
  }

  fetchResults() async {
    final deviceController = DeviceController();
    final devices = await deviceController.getDevices();
    if (devices.isNotEmpty) {
      final deviceId = devices.first.deviceId;
      result = await RemoteService().fetchResults(deviceId);
      if (result != null) {
        setState(() {
          isLoaded = true;
        });
      } else {
        setState(() {
          isLoaded = false;
        });
      }
    } else {
      setState(() {
        isLoaded = false;
      });
      print('Không có thiết bị nào.');
    }
  }

  fetchDailyDay(String date) async {
    final deviceController = DeviceController();
    final devices = await deviceController.getDevices();
    if (devices.isEmpty) {
      setState(() {
        isLoaded = false;
      });
      print('Không có thiết bị nào.');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không có thiết bị nào.')));
      return;
    }
    final deviceId = devices.first.deviceId;

    if (devices.isNotEmpty) {
      var response = await RemoteDailyController().fetchDailyDay(
        date,
        deviceId,
      );
      if (response != null) {
        setState(() {
          dailyday = response;
          isLoaded = true;
        });
      } else {
        setState(() {
          isLoaded = false;
        });
      }
    } else {
      setState(() {
        isLoaded = false;
      });
      print('Không có thiết bị nào.');
    }
  }

  var checkday = false;
  var isLoaded = false;
  Future<void> _loadData() async {
    final deviceController = DeviceController();
    final devices = await deviceController.getDevices();
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

          if (data?.results != null) {
            print('Dữ liệu đã tải thành công: ${data?.results}');
          } else {
            print('Không có dữ liệu nào.');
          }
        });
      } catch (e) {
        print('Lỗi: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Không có thiết bị nào.');
    }
  }

  int? selectedDayIndex; // null = hiển thị tất cả

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      appBar: AppBar(title: Text('Lịch sử các chỉ số sức khỏe')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildChart(
              'Huyết áp tâm thu',
              Colors.red,
              Colors.blue,
              _getData1(),
            ),
            _buildChart(
              'Huyết áp tâm trương',
              Colors.red,
              Colors.blue,
              _getData2(),
            ),
            _buildChart('SpO2', Colors.red, Colors.blue, _getData3()),
            _buildChart('Nhiệt độ (°C)', Colors.red, Colors.blue, _getData4()),
            _buildChart('Mạch đập (bpm)', Colors.red, Colors.blue, _getData5()),
            _buildChart('pH', Colors.red, Colors.blue, _getData6()),

            SizedBox(height: 20),
            _buildDayButtons(), // Nút chọn ngày ở cuối
          ],
        ),
      ),
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Container(
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
                          style: TextStyle(fontSize: 10),
                        ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget:
                        (value, meta) => Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 10),
                        ),
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
            ),
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              selectedDayIndex == null
                  ? [
                    _buildLegend(color1, 'Ngày'),
                    SizedBox(width: 16),
                    _buildLegend(color2, 'Đêm'),
                  ]
                  : [_buildLegend(color1, 'Giờ'), SizedBox(width: 16)],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(List<double> ngay, List<double> dem) {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < ngay.length; i++) {
      if (selectedDayIndex == null || selectedDayIndex == i) {
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
          child: Text('ALL'),
        ),
        ...List.generate(14, (index) {
          // Lấy ngày hôm nay
          DateTime currentDate = DateTime.now();

          // Tính toán ngày bằng cách trừ đi số ngày tương ứng (index)
          DateTime day = currentDate.subtract(Duration(days: index));
          String dayString = day.toString();
          String formattedDate =
              DateTime.parse(dayString).toIso8601String().split('T')[0];

          final isSelected = selectedDayIndex == index;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
              foregroundColor: isSelected ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                selectedDayIndex = selectedDayIndex == index ? null : index;
              });
              if (selectedDayIndex != null) {
                fetchDailyDay(dayString);
              }
            },
            child: Text(formattedDate),
          );
        }),
      ],
    );
  }

  // Dữ liệu mẫu
  // List<List<double>> _getData1() => [
  //   [155, 152, 158, 160, 165, 162, 170, 155, 152, 158, 160, 165, 162, 170],
  //   [145, 142, 148, 150, 155, 152, 158, 145, 142, 148, 150, 155, 152, 158],
  // ];

  List<List<double>> _getData1() {
    if (result == null) return [[], []];

    // Lọc và loại bỏ giá trị null rồi ép kiểu thành double không nullable
    if (selectedDayIndex == null) {
      final ngay =
          result
              ?.map((e) => e.dailyAverage?.averageSystolicPressure)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      final dem =
          result
              ?.map((e) => e.nightlyAverage?.averageSystolicPressure)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      return [ngay, dem];
    } else {
      final gio =
          dailyday
              ?.map((e) => e.systolicPressure)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];

      return [gio];
    }
  }

  List<List<double>> _getData2() {
    if (result == null) return [[], []];
    if (selectedDayIndex == null) {
      // Lọc và loại bỏ giá trị null rồi ép kiểu thành double không nullable
      final ngay =
          result
              ?.map((e) => e.dailyAverage?.averageTemperature)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      final dem =
          result
              ?.map((e) => e.nightlyAverage?.averageTemperature)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      return [ngay, dem];
    } else {
      // Nếu có chỉ số ngày được chọn
      final gio =
          dailyday
              ?.map((e) => e.temperature)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];

      return [gio];
    }
  }

  List<List<double>> _getData3() {
    if (result == null) return [[], []];
    if (selectedDayIndex == null) {
      // Lọc và loại bỏ giá trị null rồi ép kiểu thành double không nullable
      final ngay =
          result
              ?.map((e) => e.dailyAverage?.averageSpO2)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      final dem =
          result
              ?.map((e) => e.nightlyAverage?.averageSpO2)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      return [ngay, dem];
    } else {
      // Nếu có chỉ số ngày được chọn
      final gio =
          dailyday
              ?.map((e) => e.spo2Information)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];

      return [gio];
    }
  }

  List<List<double>> _getData4() {
    if (result == null) return [[], []];
    if (selectedDayIndex == null) {
      // Lọc và loại bỏ giá trị null rồi ép kiểu thành double không nullable
      final ngay =
          result
              ?.map((e) => e.dailyAverage?.averageHeartRate)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      final dem =
          result
              ?.map((e) => e.nightlyAverage?.averageHeartRate)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      return [ngay, dem];
    } else {
      // Nếu có chỉ số ngày được chọn
      final gio =
          dailyday
              ?.map((e) => e.heartRate)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];

      return [gio];
    }
  }

  List<List<double>> _getData5() {
    if (result == null) return [[], []];
    if (selectedDayIndex == null) {
      // Lọc và loại bỏ giá trị null rồi ép kiểu thành double không nullable
      final ngay =
          result
              ?.map((e) => e.dailyAverage?.averageBloodPh)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      final dem =
          result
              ?.map((e) => e.nightlyAverage?.averageBloodPh)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      return [ngay, dem];
    } else {
      // Nếu có chỉ số ngày được chọn
      final gio =
          dailyday
              ?.map((e) => e.bloodPh)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];

      return [gio];
    }
  }

  List<List<double>> _getData6() {
    if (result == null) return [[], []];
    if (selectedDayIndex == null) {
      // Lọc và loại bỏ giá trị null rồi ép kiểu thành double không nullable
      final ngay =
          result
              ?.map((e) => e.dailyAverage?.averageDiastolicPressure)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      final dem =
          result
              ?.map((e) => e.nightlyAverage?.averageDiastolicPressure)
              .where((e) => e != null) // Lọc null
              .map((e) => e!) // Ép kiểu
              .toList() ??
          [];

      return [ngay, dem];
    } else {
      // Nếu có chỉ số ngày được chọn
      final gio =
          dailyday
              ?.map((e) => e.diastolicPressure)
              .toString()
              .split(',')
              .map((e) => double.tryParse(e) ?? 0.0)
              .toList() ??
          [];

      return [gio];
    }
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
