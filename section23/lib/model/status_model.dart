import 'dart:ui';

// 상태 데이터 클래스
class StatusModel {
  // 단계
  final int level;

  // 단계 이름
  final String label;

  // 주색상
  final Color primaryColor;

  // 어두운 색상
  final Color darkColor;

  // 밝은 색상
  final Color lightColor;

  // 폰트 색상
  final Color detailFontColor;

  // 이모티콘 이미지
  final String imagePath;

  // 코멘트
  final String comment;

  // 미세먼지 최소치
  final double minFineDust;

  // 초미세먼지 최소치
  final double minUltraFineDust;

  // 오존 최소치
  final double minO3;

  // 이산화질소 최소치
  final double minNO2;

  // 일산화탄소 최소치
  final double minCO;

  // 이황산가스 최소치
  final double minSO2;

  StatusModel({
    // 단계
    required this.level,

    // 단계 이름
    required this.label,

    // 주색상
    required this.primaryColor,

    // 어두운 색상
    required this.darkColor,

    // 밝은 색상
    required this.lightColor,

    // 폰트 색상
    required this.detailFontColor,

    // 이모티콘 이미지
    required this.imagePath,

    // 코멘트
    required this.comment,

    // 미세먼지 최소치
    required this.minFineDust,

    // 초미세먼지 최소치
    required this.minUltraFineDust,

    // 오존 최소치
    required this.minO3,

    // 이산화질소 최소치
    required this.minNO2,

    // 일산화탄소 최소치
    required this.minCO,

    // 이황산가스 최소치
    required this.minSO2,
  });
}
