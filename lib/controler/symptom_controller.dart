import 'dart:convert';
import 'package:assistantstroke/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SymptomModel {
  bool headache;
  bool numbness;
  bool dizziness;
  bool speechDifficulty;
  bool temporaryMemoryLoss;
  bool confusion;
  bool visionLoss;
  bool imbalance;
  bool nausea;
  bool difficultyswallowing;

  SymptomModel({
    required this.headache,
    required this.numbness,
    required this.dizziness,
    required this.speechDifficulty,
    required this.temporaryMemoryLoss,
    required this.confusion,
    required this.visionLoss,
    required this.imbalance,
    required this.nausea,
    required this.difficultyswallowing,
  });

  Map<String, dynamic> toJson({
    required int userId,
    required String recordedAt,
  }) {
    return {
      "userID": userId,
      "recordedAt": recordedAt,
      "dauDau": headache,
      "teMatChi": numbness,
      "chongMat": dizziness,
      "khoNoi": speechDifficulty,
      "matTriNhoTamThoi": temporaryMemoryLoss,
      "luLan": confusion,
      "giamThiLuc": visionLoss,
      "matThangCan": imbalance,
      "buonNon": nausea,
      "khoNuot": difficultyswallowing,
    };
  }
}

class SymptomController {
  final String url = ApiEndpoints.symptom;

  Future<bool> saveSymptoms(SymptomModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt("userId");

    if (userId == null) {
      debugPrint("Không tìm thấy userId trong SharedPreferences");
      return false;
    }

    final String now = DateTime.now().toUtc().toIso8601String();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer ${prefs.getString('token')}',
      },
      body: jsonEncode(model.toJson(userId: userId, recordedAt: now)),
    );

    debugPrint("Response: ${response.statusCode} - ${response.body}");

    return response.statusCode == 200 || response.statusCode == 201;
  }
}

// import 'dart:convert';
// import 'package:assistantstroke/services/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// // Existing SymptomModel (unchanged)
// class SymptomModel {
//   bool headache;
//   bool numbness;
//   bool dizziness;
//   bool speechDifficulty;
//   bool temporaryMemoryLoss;
//   bool confusion;
//   bool visionLoss;
//   bool imbalance;
//   bool nausea;
//   bool difficultyswallowing;

//   SymptomModel({
//     required this.headache,
//     required this.numbness,
//     required this.dizziness,
//     required this.speechDifficulty,
//     required this.temporaryMemoryLoss,
//     required this.confusion,
//     required this.visionLoss,
//     required this.imbalance,
//     required this.nausea,
//     required this.difficultyswallowing,
//   });

//   Map<String, dynamic> toJson({
//     required int userId,
//     required String recordedAt,
//   }) {
//     return {
//       "userID": userId,
//       "recordedAt": recordedAt,
//       "dauDau": headache,
//       "teMatChi": numbness,
//       "chongMat": dizziness,
//       "khoNoi": speechDifficulty,
//       "matTriNhoTamThoi": temporaryMemoryLoss,
//       "luLan": confusion,
//       "giamThiLuc": visionLoss,
//       "matThangCan": imbalance,
//       "buonNon": nausea,
//       "khoNuot": difficultyswallowing,
//     };
//   }

//   factory SymptomModel.fromJson(Map<String, dynamic> json) {
//     return SymptomModel(
//       headache: json['dauDau'] ?? false,
//       numbness: json['teMatChi'] ?? false,
//       dizziness: json['chongMat'] ?? false,
//       speechDifficulty: json['khoNoi'] ?? false,
//       temporaryMemoryLoss: json['matTriNhoTamThoi'] ?? false,
//       confusion: json['luLan'] ?? false,
//       visionLoss: json['giamThiLuc'] ?? false,
//       imbalance: json['matThangCan'] ?? false,
//       nausea: json['buonNon'] ?? false,
//       difficultyswallowing: json['khoNuot'] ?? false,
//     );
//   }
// }

// // New ClinicalIndicator model
// class ClinicalIndicator {
//   final int clinicalIndicatorID;
//   final int userID;
//   final bool isActived;
//   final String recordedAt;
//   final SymptomModel symptoms;
//   final int reportCount;

//   ClinicalIndicator({
//     required this.clinicalIndicatorID,
//     required this.userID,
//     required this.isActived,
//     required this.recordedAt,
//     required this.symptoms,
//     required this.reportCount,
//   });

//   factory ClinicalIndicator.fromJson(Map<String, dynamic> json) {
//     return ClinicalIndicator(
//       clinicalIndicatorID: json['clinicalIndicatorID'] ?? 0,
//       userID: json['userID'] ?? 0,
//       isActived: json['isActived'] ?? false,
//       recordedAt: json['recordedAt'] ?? '',
//       symptoms: SymptomModel.fromJson(json),
//       reportCount: json['reportCount'] ?? 0,
//     );
//   }
// }

// // New MolecularIndicator model
// class MolecularIndicator {
//   final int molecularIndicatorID;
//   final int userID;
//   final bool isActived;
//   final String recordedAt;
//   final bool miR30e5p;
//   final bool miR165p;
//   final bool miR1403p;
//   final bool miR320d;
//   final bool miR320p;
//   final bool miR20a5p;
//   final bool miR26b5p;
//   final bool miR19b5p;
//   final bool miR8745p;
//   final bool miR451a;
//   final int reportCount;

//   MolecularIndicator({
//     required this.molecularIndicatorID,
//     required this.userID,
//     required this.isActived,
//     required this.recordedAt,
//     required this.miR30e5p,
//     required this.miR165p,
//     required this.miR1403p,
//     required this.miR320d,
//     required this.miR320p,
//     required this.miR20a5p,
//     required this.miR26b5p,
//     required this.miR19b5p,
//     required this.miR8745p,
//     required this.miR451a,
//     required this.reportCount,
//   });

//   factory MolecularIndicator.fromJson(Map<String, dynamic> json) {
//     return MolecularIndicator(
//       molecularIndicatorID: json['molecularIndicatorID'] ?? 0,
//       userID: json['userID'] ?? 0,
//       isActived: json['isActived'] ?? false,
//       recordedAt: json['recordedAt'] ?? '',
//       miR30e5p: json['miR_30e_5p'] ?? false,
//       miR165p: json['miR_16_5p'] ?? false,
//       miR1403p: json['miR_140_3p'] ?? false,
//       miR320d: json['miR_320d'] ?? false,
//       miR320p: json['miR_320p'] ?? false,
//       miR20a5p: json['miR_20a_5p'] ?? false,
//       miR26b5p: json['miR_26b_5p'] ?? false,
//       miR19b5p: json['miR_19b_5p'] ?? false,
//       miR8745p: json['miR_874_5p'] ?? false,
//       miR451a: json['miR_451a'] ?? false,
//       reportCount: json['reportCount'] ?? 0,
//     );
//   }
// }

// // New SubclinicalIndicator model
// class SubclinicalIndicator {
//   final int subclinicalIndicatorID;
//   final int userID;
//   final bool isActived;
//   final String recordedAt;
//   final bool s100B;
//   final bool mmP9;
//   final bool gfap;
//   final bool rbP4;
//   final bool nTProBNP;
//   final bool sRAGE;
//   final bool dDimer;
//   final bool lipids;
//   final bool protein;
//   final bool vonWillebrand;
//   final int reportCount;

//   SubclinicalIndicator({
//     required this.subclinicalIndicatorID,
//     required this.userID,
//     required this.isActived,
//     required this.recordedAt,
//     required this.s100B,
//     required this.mmP9,
//     required this.gfap,
//     required this.rbP4,
//     required this.nTProBNP,
//     required this.sRAGE,
//     required this.dDimer,
//     required this.lipids,
//     required this.protein,
//     required this.vonWillebrand,
//     required this.reportCount,
//   });

//   factory SubclinicalIndicator.fromJson(Map<String, dynamic> json) {
//     return SubclinicalIndicator(
//       subclinicalIndicatorID: json['subclinicalIndicatorID'] ?? 0,
//       userID: json['userID'] ?? 0,
//       isActived: json['isActived'] ?? false,
//       recordedAt: json['recordedAt'] ?? '',
//       s100B: json['s100B'] ?? false,
//       mmP9: json['mmP9'] ?? false,
//       gfap: json['gfap'] ?? false,
//       rbP4: json['rbP4'] ?? false,
//       nTProBNP: json['nT_proBNP'] ?? false,
//       sRAGE: json['sRAGE'] ?? false,
//       dDimer: json['d_dimer'] ?? false,
//       lipids: json['lipids'] ?? false,
//       protein: json['protein'] ?? false,
//       vonWillebrand: json['vonWillebrand'] ?? false,
//       reportCount: json['reportCount'] ?? 0,
//     );
//   }
// }

// // Model to hold all indicators
// class HealthIndicators {
//   final ClinicalIndicator clinicalIndicator;
//   final MolecularIndicator? molecularIndicator;
//   final SubclinicalIndicator? subclinicalIndicator;

//   HealthIndicators({
//     required this.clinicalIndicator,
//     this.molecularIndicator,
//     this.subclinicalIndicator,
//   });

//   factory HealthIndicators.fromJson(Map<String, dynamic> json) {
//     return HealthIndicators(
//       clinicalIndicator: ClinicalIndicator.fromJson(
//         json['clinicalIndicator'] ?? {},
//       ),
//       molecularIndicator:
//           json['molecularIndicator'] != null
//               ? MolecularIndicator.fromJson(json['molecularIndicator'])
//               : null,
//       subclinicalIndicator:
//           json['subclinicalIndicator'] != null
//               ? SubclinicalIndicator.fromJson(json['subclinicalIndicator'])
//               : null,
//     );
//   }
// }

// // Updated SymptomController
// class SymptomController {
//   // Existing saveSymptoms method (unchanged)
//   Future<bool> saveSymptoms(SymptomModel model) async {
//     final String url = ApiEndpoints.symptom;

//     final prefs = await SharedPreferences.getInstance();
//     final int? userId = prefs.getInt("userId");

//     if (userId == null) {
//       debugPrint("Không tìm thấy userId trong SharedPreferences");
//       return false;
//     }

//     final String now = DateTime.now().toUtc().toIso8601String();

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': 'Bearer ${prefs.getString('token')}',
//       },
//       body: jsonEncode(model.toJson(userId: userId, recordedAt: now)),
//     );

//     debugPrint("Response: ${response.statusCode} - ${response.body}");

//     return response.statusCode == 200 || response.statusCode == 201;
//   }

//   // New method to fetch health indicators
//   Future<HealthIndicators?> fetchHealthIndicators() async {
//     final String url = ApiEndpoints.get_symptom;

//     final prefs = await SharedPreferences.getInstance();
//     final int? userId = prefs.getInt("userId");
//     final String? token = prefs.getString("token");

//     if (userId == null || token == null) {
//       debugPrint("Không tìm thấy userId hoặc token trong SharedPreferences");
//       return null;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse('$url/$userId'),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $token',
//         },
//       );

//       debugPrint("Fetch Response: ${response.statusCode} - ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//         if (jsonData is List && jsonData.isNotEmpty) {
//           return HealthIndicators.fromJson(jsonData[0]);
//         } else {
//           debugPrint("Dữ liệu trả về không hợp lệ hoặc rỗng");
//           return null;
//         }
//       } else {
//         debugPrint("Lỗi khi lấy dữ liệu: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       debugPrint("Lỗi khi gọi API: $e");
//       return null;
//     }
//   }
// }
