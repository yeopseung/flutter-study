import 'package:section23/model/stat_model.dart';
import 'package:section23/model/status_model.dart';

class StatAndStatusModel{
  // 미세먼지/초미세먼지
  final ItemCode itemCode;
  // 통계 데이터
  final StatusModel status;
  // 정보 데이터
  final StatModel stat;

  StatAndStatusModel({required this.itemCode, required this.status,required this.stat});
}

