import 'package:flutter/material.dart';
import 'package:assistantstroke/controler/symptom_controller.dart';

class SymptomFormPage extends StatefulWidget {
  const SymptomFormPage({super.key});

  @override
  State<SymptomFormPage> createState() => _SymptomFormPageState();
}

class _SymptomFormPageState extends State<SymptomFormPage> {
  // Map lưu trạng thái của checkbox
  Map<String, bool> symptoms = {
    "headache": false,
    "numbness": false,
    "dizziness": false,
    "speechDifficulty": false,
    "temporaryMemoryLoss": false,
    "confusion": false,
    "visionLoss": false,
    "imbalance": false,
    "nausea": false,
    "difficultyswallowing": false,
  };

  bool _isLoading = false;

  Future<void> submitSymptoms() async {
    setState(() => _isLoading = true);

    final model = SymptomModel(
      headache: symptoms['headache'] ?? false,
      numbness: symptoms['numbness'] ?? false,
      dizziness: symptoms['dizziness'] ?? false,
      speechDifficulty: symptoms['speechDifficulty'] ?? false,
      temporaryMemoryLoss: symptoms['temporaryMemoryLoss'] ?? false,
      confusion: symptoms['confusion'] ?? false,
      visionLoss: symptoms['visionLoss'] ?? false,
      imbalance: symptoms['imbalance'] ?? false,
      nausea: symptoms['nausea'] ?? false,
      difficultyswallowing: symptoms['difficultyswallowing'] ?? false,
    );

    final controller = SymptomController();
    final success = await controller.saveSymptoms(model);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gửi dữ liệu thành công!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gửi dữ liệu thất bại!")));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Triệu chứng sức khỏe')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  ...symptoms.keys.map((key) {
                    return CheckboxListTile(
                      title: Text(_convertKeyToLabel(key)),
                      value: symptoms[key],
                      onChanged: (val) {
                        setState(() {
                          symptoms[key] = val ?? false;
                        });
                      },
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitSymptoms,
                    child: const Text('Khai Báo'),
                  ),
                ],
              ),
    );
  }

  String _convertKeyToLabel(String key) {
    switch (key) {
      case "headache":
        return "Đau đầu";
      case "numbness":
        return "Tê tay";
      case "dizziness":
        return "Chóng mặt";
      case "speechDifficulty":
        return "Khó nói";
      case "temporaryMemoryLoss":
        return "Mất trí nhớ tạm thời";
      case "confusion":
        return "Lú lẫn";
      case "visionLoss":
        return "Giảm thị lực";
      case "imbalance":
        return "Mất thăng bằng";
      case "nausea":
        return "Buồn nôn";
      case "difficultyswallowing":
        return "Khó nuốt";
      default:
        return key;
    }
  }
}
// import 'package:flutter/material.dart';
// import 'package:assistantstroke/controler/symptom_controller.dart'; // Ensure this import matches your project structure

// class SymptomFormPage extends StatefulWidget {
//   const SymptomFormPage({super.key});

//   @override
//   State<SymptomFormPage> createState() => _SymptomFormPageState();
// }

// class _SymptomFormPageState extends State<SymptomFormPage> {
//   // Map lưu trạng thái của checkbox
//   Map<String, bool> symptoms = {
//     "headache": false,
//     "numbness": false,
//     "dizziness": false,
//     "speechDifficulty": false,
//     "temporaryMemoryLoss": false,
//     "confusion": false,
//     "visionLoss": false,
//     "imbalance": false,
//     "nausea": false,
//     "difficultyswallowing": false,
//   };

//   bool _isLoading = false;
//   HealthIndicators? _healthIndicators;

//   @override
//   void initState() {
//     super.initState();
//     _fetchHealthIndicators();
//   }

//   Future<void> _fetchHealthIndicators() async {
//     setState(() => _isLoading = true);
//     final controller = SymptomController();
//     final indicators = await controller.fetchHealthIndicators();
//     setState(() {
//       _healthIndicators = indicators;
//       _isLoading = false;
//     });
//   }

//   Future<void> submitSymptoms() async {
//     setState(() => _isLoading = true);

//     final model = SymptomModel(
//       headache: symptoms['headache'] ?? false,
//       numbness: symptoms['numbness'] ?? false,
//       dizziness: symptoms['dizziness'] ?? false,
//       speechDifficulty: symptoms['speechDifficulty'] ?? false,
//       temporaryMemoryLoss: symptoms['temporaryMemoryLoss'] ?? false,
//       confusion: symptoms['confusion'] ?? false,
//       visionLoss: symptoms['visionLoss'] ?? false,
//       imbalance: symptoms['imbalance'] ?? false,
//       nausea: symptoms['nausea'] ?? false,
//       difficultyswallowing: symptoms['difficultyswallowing'] ?? false,
//     );

//     final controller = SymptomController();
//     final success = await controller.saveSymptoms(model);

//     if (success) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Gửi dữ liệu thành công!")));
//       // Refresh health indicators after submission
//       await _fetchHealthIndicators();
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Gửi dữ liệu thất bại!")));
//     }

//     setState(() => _isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Triệu chứng sức khỏe')),
//       body:
//           _isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   // Clinical Symptoms (Editable Checkboxes)
//                   const Text(
//                     'Triệu Chứng Lâm Sàng',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   ...symptoms.keys.map((key) {
//                     return CheckboxListTile(
//                       title: Text(_convertKeyToLabel(key)),
//                       value: symptoms[key],
//                       onChanged: (val) {
//                         setState(() {
//                           symptoms[key] = val ?? false;
//                         });
//                       },
//                     );
//                   }).toList(),
//                   const SizedBox(height: 20),

//                   // Molecular Indicators (Non-editable Labels)
//                   if (_healthIndicators?.molecularIndicator != null) ...[
//                     const Text(
//                       'Chỉ Số Phân Tử',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     _buildIndicatorLabel(
//                       'miR-30e-5p',
//                       _healthIndicators!.molecularIndicator!.miR30e5p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-16-5p',
//                       _healthIndicators!.molecularIndicator!.miR165p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-140-3p',
//                       _healthIndicators!.molecularIndicator!.miR1403p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-320d',
//                       _healthIndicators!.molecularIndicator!.miR320d,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-320p',
//                       _healthIndicators!.molecularIndicator!.miR320p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-20a-5p',
//                       _healthIndicators!.molecularIndicator!.miR20a5p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-26b-5p',
//                       _healthIndicators!.molecularIndicator!.miR26b5p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-19b-5p',
//                       _healthIndicators!.molecularIndicator!.miR19b5p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-874-5p',
//                       _healthIndicators!.molecularIndicator!.miR8745p,
//                     ),
//                     _buildIndicatorLabel(
//                       'miR-451a',
//                       _healthIndicators!.molecularIndicator!.miR451a,
//                     ),
//                     const SizedBox(height: 20),
//                   ],

//                   // Subclinical Indicators (Non-editable Labels)
//                   if (_healthIndicators?.subclinicalIndicator != null) ...[
//                     const Text(
//                       'Chỉ Số Cận Lâm Sàng',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     _buildIndicatorLabel(
//                       'S100B',
//                       _healthIndicators!.subclinicalIndicator!.s100B,
//                     ),
//                     _buildIndicatorLabel(
//                       'MMP9',
//                       _healthIndicators!.subclinicalIndicator!.mmP9,
//                     ),
//                     _buildIndicatorLabel(
//                       'GFAP',
//                       _healthIndicators!.subclinicalIndicator!.gfap,
//                     ),
//                     _buildIndicatorLabel(
//                       'RBP4',
//                       _healthIndicators!.subclinicalIndicator!.rbP4,
//                     ),
//                     _buildIndicatorLabel(
//                       'NT-proBNP',
//                       _healthIndicators!.subclinicalIndicator!.nTProBNP,
//                     ),
//                     _buildIndicatorLabel(
//                       'sRAGE',
//                       _healthIndicators!.subclinicalIndicator!.sRAGE,
//                     ),
//                     _buildIndicatorLabel(
//                       'D-dimer',
//                       _healthIndicators!.subclinicalIndicator!.dDimer,
//                     ),
//                     _buildIndicatorLabel(
//                       'Lipids',
//                       _healthIndicators!.subclinicalIndicator!.lipids,
//                     ),
//                     _buildIndicatorLabel(
//                       'Protein',
//                       _healthIndicators!.subclinicalIndicator!.protein,
//                     ),
//                     _buildIndicatorLabel(
//                       'von Willebrand',
//                       _healthIndicators!.subclinicalIndicator!.vonWillebrand,
//                     ),
//                     const SizedBox(height: 20),
//                   ],

//                   // Submit Button
//                   ElevatedButton(
//                     onPressed: submitSymptoms,
//                     child: const Text('Khai Báo'),
//                   ),
//                 ],
//               ),
//     );
//   }

//   String _convertKeyToLabel(String key) {
//     switch (key) {
//       case "headache":
//         return "Đau đầu";
//       case "numbness":
//         return "Tê tay";
//       case "dizziness":
//         return "Chóng mặt";
//       case "speechDifficulty":
//         return "Khó nói";
//       case "temporaryMemoryLoss":
//         return "Mất trí nhớ tạm thời";
//       case "confusion":
//         return "Lú lẫn";
//       case "visionLoss":
//         return "Giảm thị lực";
//       case "imbalance":
//         return "Mất thăng bằng";
//       case "nausea":
//         return "Buồn nôn";
//       case "difficultyswallowing":
//         return "Khó nuốt";
//       default:
//         return key;
//     }
//   }

//   Widget _buildIndicatorLabel(String label, bool value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
//           Icon(
//             value ? Icons.check_circle : Icons.cancel,
//             color: value ? Colors.green : Colors.red,
//           ),
//         ],
//       ),
//     );
//   }
// }
