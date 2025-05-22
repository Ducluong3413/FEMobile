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
                if (data.clinicalIndicator != null)
                  () {
                    final clinical = data.clinicalIndicator!;
                    return buildIndicatorSection('Chỉ số lâm sàng', {
                      'Đau đầu': clinical.dauDau,
                      'Tê mặt chi': clinical.teMatChi,
                      'Chóng mặt': clinical.chongMat,
                      'Khó nói': clinical.khoNoi,
                      'Mất trí nhớ tạm thời': clinical.matTriNhoTamThoi,
                      'Lú lẫn': clinical.luLan,
                      'Giảm thị lực': clinical.giamThiLuc,
                      'Mất thăng cân': clinical.matThangCan,
                      'Buồn nôn': clinical.buonNon,
                      'Khó nuốt': clinical.khoNuot,
                    });
                  }(),

                if (data.molecularIndicator != null)
                  () {
                    final molecular = data.molecularIndicator!;
                    return buildIndicatorSection('Chỉ số phân tử', {
                      'miR_30e_5p': molecular.miR_30e_5p,
                      'miR_16_5p': molecular.miR_16_5p,
                      'miR_140_3p': molecular.miR_140_3p,
                      'miR_320d': molecular.miR_320d,
                      'miR_320p': molecular.miR_320p,
                      'miR_20a_5p': molecular.miR_20a_5p,
                      'miR_26b_5p': molecular.miR_26b_5p,
                      'miR_19b_5p': molecular.miR_19b_5p,
                      'miR_874_5p': molecular.miR_874_5p,
                      'miR_451a': molecular.miR_451a,
                    });
                  }(),

                if (data.subclinicalIndicator != null)
                  () {
                    final subclinical = data.subclinicalIndicator!;
                    return buildIndicatorSection('Chỉ số cận lâm sàng', {
                      'S100B': subclinical.s100B,
                      'MMP9': subclinical.mmP9,
                      'GFAP': subclinical.gfap,
                      'RBP4': subclinical.rbP4,
                      'NT_proBNP': subclinical.nT_proBNP,
                      'sRAGE': subclinical.sRAGE,
                      'D-Dimer': subclinical.d_dimer,
                      'Lipids': subclinical.lipids,
                      'Protein': subclinical.protein,
                      'Von Willebrand': subclinical.vonWillebrand,
                    });
                  }(),
              ],
            ),
          );
        },
      ),
    );
  }
}
