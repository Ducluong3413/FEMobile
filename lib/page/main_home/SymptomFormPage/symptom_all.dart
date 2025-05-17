// views/indicator_view.dart
import 'package:assistantstroke/controler/indicators_all.dart';
import 'package:assistantstroke/model/indicatorall.dart';
import 'package:flutter/material.dart';

class IndicatorView extends StatefulWidget {
  @override
  State<IndicatorView> createState() => _IndicatorViewState();
}

class _IndicatorViewState extends State<IndicatorView> {
  final controller = IndicatorControllerAll();
  Future<IndicatorModelAll?>? futureIndicators;

  @override
  void initState() {
    super.initState();
    futureIndicators = controller.fetchIndicators();
  }

  Widget buildIndicatorSection(String title, Map<String, bool> indicators) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children:
            indicators.entries
                .map(
                  (entry) => ListTile(
                    title: Text(entry.key),
                    trailing: Icon(
                      entry.value ? Icons.check_circle : Icons.cancel,
                      color: entry.value ? Colors.green : Colors.red,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉ Số Sức Khoẻ')),
      body: FutureBuilder<IndicatorModelAll?>(
        future: futureIndicators,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Không có dữ liệu hoặc lỗi'));
          }

          final data = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildIndicatorSection('Chỉ số lâm sàng', {
                  'Đau đầu': data.clinicalIndicator.dauDau,
                  'Tê mặt chi': data.clinicalIndicator.teMatChi,
                  'Chóng mặt': data.clinicalIndicator.chongMat,
                  'Khó nói': data.clinicalIndicator.khoNoi,
                  'Mất trí nhớ tạm thời':
                      data.clinicalIndicator.matTriNhoTamThoi,
                  'Lú lẫn': data.clinicalIndicator.luLan,
                  'Giảm thị lực': data.clinicalIndicator.giamThiLuc,
                  'Mất thăng cân': data.clinicalIndicator.matThangCan,
                  'Buồn nôn': data.clinicalIndicator.buonNon,
                  'Khó nuốt': data.clinicalIndicator.khoNuot,
                }),
                buildIndicatorSection('Chỉ số phân tử', {
                  'miR_30e_5p': data.molecularIndicator.miR_30e_5p,
                  'miR_16_5p': data.molecularIndicator.miR_16_5p,
                  'miR_140_3p': data.molecularIndicator.miR_140_3p,
                  'miR_320d': data.molecularIndicator.miR_320d,
                  'miR_320p': data.molecularIndicator.miR_320p,
                  'miR_20a_5p': data.molecularIndicator.miR_20a_5p,
                  'miR_26b_5p': data.molecularIndicator.miR_26b_5p,
                  'miR_19b_5p': data.molecularIndicator.miR_19b_5p,
                  'miR_874_5p': data.molecularIndicator.miR_874_5p,
                  'miR_451a': data.molecularIndicator.miR_451a,
                }),
                buildIndicatorSection('Chỉ số cận lâm sàng', {
                  'S100B': data.subclinicalIndicator.s100B,
                  'MMP9': data.subclinicalIndicator.mmP9,
                  'GFAP': data.subclinicalIndicator.gfap,
                  'RBP4': data.subclinicalIndicator.rbP4,
                  'NT_proBNP': data.subclinicalIndicator.nT_proBNP,
                  'sRAGE': data.subclinicalIndicator.sRAGE,
                  'D-Dimer': data.subclinicalIndicator.d_dimer,
                  'Lipids': data.subclinicalIndicator.lipids,
                  'Protein': data.subclinicalIndicator.protein,
                  'Von Willebrand': data.subclinicalIndicator.vonWillebrand,
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
