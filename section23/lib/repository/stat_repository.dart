import 'package:dio/dio.dart';

import '../constant/data.dart';
import '../model/stat_model.dart';

// API 요청하여 받은 응답을 데이터로 변환하는 클래스
class StatRepository {
  // fetch - 가져오다
  // 데이터를 가져오는 메소드
  static Future<List<StatModel>> fetchData({
    required ItemCode itemCode,
  }) async {
    final response = await Dio().get(
      'http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst',
      queryParameters: {
        'serviceKey': serviceKey,
        'returnType': 'json',
        'numberOfRows': 30,
        'pageNo': 1,
        'itemCode': itemCode.name,
        'dataGubun': 'HOUR',
        'searchCondition': 'WEEK',
      },
    );

    return response.data['response']['body']['items']
        .map<StatModel>(
          (item) => StatModel.fromJson(json: item),
        )
        .toList();
  }
}
