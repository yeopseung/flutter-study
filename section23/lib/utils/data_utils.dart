import 'package:section23/constant/status_level.dart';
import 'package:section23/model/stat_model.dart';
import 'package:section23/model/status_model.dart';

class DataUtils {
  // DateTime을 받아 YYYY-MM-DD HH:MM 으로 반환하는 메소드
  static String getTimeFromDateTime({required DateTime dateTime}) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${_getTimeFormat(number: dateTime.hour)}:${_getTimeFormat(number: dateTime.minute)}';
  }

  // datTime.hour/minute -> HH/MM 변환하는 메소드
  static String _getTimeFormat({required int number}) {
    return number.toString().padLeft(2, '0');
  }

  // 각 ItemCode의 단위를 리턴하는 메소드
  static String getUnitFromDataType({required ItemCode itemCode}) {
    switch (itemCode) {
      case ItemCode.PM10:
        return '㎍/㎥';
      case ItemCode.PM25:
        return '㎍/㎥';
      default:
        return 'ppm';
    }
  }

  // 각 ItemCode를 한국어로 변환하는 메소드
  static String getitemCodeKrString({required ItemCode itemCode}) {
    switch (itemCode) {
      case ItemCode.PM10:
        return '미세먼지';
      case ItemCode.PM25:
        return '초미세먼지';
      case ItemCode.NO2:
        return '이산화질소';
      case ItemCode.O3:
        return '오존';
      case ItemCode.CO:
        return '일산화탄소';
      case ItemCode.SO2:
        return '아황산가스';
    }
  }

  // itemCode 단위를 가지는 value가 어느 범위에 들어있는지 확인하여 StatusModel리턴
  // ex) value 7, itemCode PM10
  // -> 미세먼지 범위 1-5, 6-10, 11-15, 현재 미세먼지 7
  // -> 미세먼지 범위를 탐색하여 현재 미세먼지 값보다 작은 값 필터링 -> 1-5, 6-10
  // -> 그 중 가장 마지막 값 (큰 값) 가져오면 현재 미세먼지 범위에 맞는 범위 선택 가능 -> 6-10
  static StatusModel getStatusFromItemCodeAndValue({
    required double value,
    required ItemCode itemCode,
  }) {
    return statusLevel
        .where(
          (status){
            // 미세먼지
            if(itemCode == ItemCode.PM10){
              return status.minFineDust < value;
            }
            // 초미세먼지
            else if(itemCode == ItemCode.PM25){
              return status.minUltraFineDust < value;
            }
            // 일산화탄소
            else if(itemCode == ItemCode.CO){
              return status.minCO < value;
            }
            // 오존
            else if(itemCode == ItemCode.O3){
              return status.minO3 <value;
            }
            // 이산화질소
            else if(itemCode == ItemCode.NO2){
              return status.minNO2 <value;
            }
            // 아황산가스
            else if(itemCode == ItemCode.SO2){
              return status.minSO2 <value;
            }
            else{
              throw Exception('알수없는 ItemCode 입니다.');
            }
          }
        )
        .last;
  }
}
