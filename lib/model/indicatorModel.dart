class IndicatorModel {
  final double percent;

  final ClinicalIndicator clinicalIndicator;
  final MolecularIndicator molecularIndicator;
  final SubclinicalIndicator subclinicalIndicator;

  IndicatorModel({
    required this.percent,
    required this.clinicalIndicator,
    required this.molecularIndicator,
    required this.subclinicalIndicator,
  });

  // Phương thức từ JSON
  factory IndicatorModel.fromJson(Map<String, dynamic> json) {
    return IndicatorModel(
      percent: json['percent']?.toDouble() ?? 0.0,
      clinicalIndicator: ClinicalIndicator.fromJson(json['clinicalIndicator']),
      molecularIndicator: MolecularIndicator.fromJson(
        json['molecularIndicator'],
      ),
      subclinicalIndicator: SubclinicalIndicator.fromJson(
        json['subclinicalIndicator'],
      ),
    );
  }
}

class ClinicalIndicator {
  final double percent;
  final int trueCount;

  ClinicalIndicator({required this.percent, required this.trueCount});

  // Phương thức từ JSON
  factory ClinicalIndicator.fromJson(Map<String, dynamic> json) {
    return ClinicalIndicator(
      percent: json['percent']?.toDouble() ?? 0.0,
      trueCount: json['trueCount'] ?? 0,
    );
  }
}

class MolecularIndicator {
  final double percent;
  final int trueCount;

  MolecularIndicator({required this.percent, required this.trueCount});

  // Phương thức từ JSON
  factory MolecularIndicator.fromJson(Map<String, dynamic> json) {
    return MolecularIndicator(
      percent: json['percent']?.toDouble() ?? 0.0,
      trueCount: json['trueCount'] ?? 0,
    );
  }
}

class SubclinicalIndicator {
  final double percent;
  final int trueCount;

  SubclinicalIndicator({required this.percent, required this.trueCount});

  // Phương thức từ JSON
  factory SubclinicalIndicator.fromJson(Map<String, dynamic> json) {
    return SubclinicalIndicator(
      percent: json['percent']?.toDouble() ?? 0.0,
      trueCount: json['trueCount'] ?? 0,
    );
  }
}
