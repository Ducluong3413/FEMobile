// models/indicator_model.dart
class ClinicalIndicator {
  final bool dauDau;
  final bool teMatChi;
  final bool chongMat;
  final bool khoNoi;
  final bool matTriNhoTamThoi;
  final bool luLan;
  final bool giamThiLuc;
  final bool matThangCan;
  final bool buonNon;
  final bool khoNuot;

  ClinicalIndicator({
    required this.dauDau,
    required this.teMatChi,
    required this.chongMat,
    required this.khoNoi,
    required this.matTriNhoTamThoi,
    required this.luLan,
    required this.giamThiLuc,
    required this.matThangCan,
    required this.buonNon,
    required this.khoNuot,
  });

  factory ClinicalIndicator.fromJson(Map<String, dynamic> json) {
    return ClinicalIndicator(
      dauDau: json['dauDau'],
      teMatChi: json['teMatChi'],
      chongMat: json['chongMat'],
      khoNoi: json['khoNoi'],
      matTriNhoTamThoi: json['matTriNhoTamThoi'],
      luLan: json['luLan'],
      giamThiLuc: json['giamThiLuc'],
      matThangCan: json['matThangCan'],
      buonNon: json['buonNon'],
      khoNuot: json['khoNuot'],
    );
  }
}

class MolecularIndicator {
  final bool miR_30e_5p;
  final bool miR_16_5p;
  final bool miR_140_3p;
  final bool miR_320d;
  final bool miR_320p;
  final bool miR_20a_5p;
  final bool miR_26b_5p;
  final bool miR_19b_5p;
  final bool miR_874_5p;
  final bool miR_451a;

  MolecularIndicator({
    required this.miR_30e_5p,
    required this.miR_16_5p,
    required this.miR_140_3p,
    required this.miR_320d,
    required this.miR_320p,
    required this.miR_20a_5p,
    required this.miR_26b_5p,
    required this.miR_19b_5p,
    required this.miR_874_5p,
    required this.miR_451a,
  });

  factory MolecularIndicator.fromJson(Map<String, dynamic> json) {
    return MolecularIndicator(
      miR_30e_5p: json['miR_30e_5p'],
      miR_16_5p: json['miR_16_5p'],
      miR_140_3p: json['miR_140_3p'],
      miR_320d: json['miR_320d'],
      miR_320p: json['miR_320p'],
      miR_20a_5p: json['miR_20a_5p'],
      miR_26b_5p: json['miR_26b_5p'],
      miR_19b_5p: json['miR_19b_5p'],
      miR_874_5p: json['miR_874_5p'],
      miR_451a: json['miR_451a'],
    );
  }
}

class SubclinicalIndicator {
  final bool s100B;
  final bool mmP9;
  final bool gfap;
  final bool rbP4;
  final bool nT_proBNP;
  final bool sRAGE;
  final bool d_dimer;
  final bool lipids;
  final bool protein;
  final bool vonWillebrand;

  SubclinicalIndicator({
    required this.s100B,
    required this.mmP9,
    required this.gfap,
    required this.rbP4,
    required this.nT_proBNP,
    required this.sRAGE,
    required this.d_dimer,
    required this.lipids,
    required this.protein,
    required this.vonWillebrand,
  });

  factory SubclinicalIndicator.fromJson(Map<String, dynamic> json) {
    return SubclinicalIndicator(
      s100B: json['s100B'],
      mmP9: json['mmP9'],
      gfap: json['gfap'],
      rbP4: json['rbP4'],
      nT_proBNP: json['nT_proBNP'],
      sRAGE: json['sRAGE'],
      d_dimer: json['d_dimer'],
      lipids: json['lipids'],
      protein: json['protein'],
      vonWillebrand: json['vonWillebrand'],
    );
  }
}

class IndicatorModelAll {
  final ClinicalIndicator clinicalIndicator;
  final MolecularIndicator molecularIndicator;
  final SubclinicalIndicator subclinicalIndicator;

  IndicatorModelAll({
    required this.clinicalIndicator,
    required this.molecularIndicator,
    required this.subclinicalIndicator,
  });

  factory IndicatorModelAll.fromJson(Map<String, dynamic> json) {
    return IndicatorModelAll(
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
