import 'package:hive/hive.dart';

part 'stat_model.g.dart';

@HiveType(typeId: 2)
enum ItemCode {
  // 미세먼지
  @HiveField(0)
  PM10,
  // 초미세먼지
  @HiveField(1)
  PM25,
  // 이산화질소
  @HiveField(2)
  NO2,
  // 오존
  @HiveField(3)
  O3,
  // 일산화탄소
  @HiveField(4)
  CO,
  // 이황산가스
  @HiveField(5)
  SO2,
}

// 통계 데이터 클래스
@HiveType(typeId: 1)
class StatModel {
  @HiveField(0)
  final double daegu;
  @HiveField(1)
  final double chungnam;
  @HiveField(2)
  final double incheon;
  @HiveField(3)
  final double daejeon;
  @HiveField(4)
  final double gyeongbuk;
  @HiveField(5)
  final double sejong;
  @HiveField(6)
  final double gwangju;
  @HiveField(7)
  final double jeonbuk;
  @HiveField(8)
  final double jeonnam;
  @HiveField(9)
  final double gangwon;
  @HiveField(10)
  final double ulsan;
  @HiveField(11)
  final double seoul;
  @HiveField(12)
  final double busan;
  @HiveField(13)
  final double jeju;
  @HiveField(14)
  final double chungbuk;
  @HiveField(15)
  final double gyeongnam;
  @HiveField(16)
  final double gyeonggi;
  @HiveField(17)
  final DateTime dataTime;
  @HiveField(18)
  final ItemCode itemCode;

  StatModel({
    required this.daegu,
    required this.chungnam,
    required this.incheon,
    required this.daejeon,
    required this.gyeongbuk,
    required this.sejong,
    required this.gwangju,
    required this.jeonbuk,
    required this.jeonnam,
    required this.gangwon,
    required this.ulsan,
    required this.seoul,
    required this.busan,
    required this.jeju,
    required this.chungbuk,
    required this.gyeongnam,
    required this.gyeonggi,
    required this.dataTime,
    required this.itemCode,
  }); // Constructor

  // fromJson - JSON 형태로 부터 데이터를 받아온다
  StatModel.fromJson({required Map<String, dynamic> json})
      : daegu = double.parse(json['daegu'] ?? '0'),
        chungnam = double.parse(json['chungnam'] ?? '0'),
        incheon = double.parse(json['incheon'] ?? '0'),
        daejeon = double.parse(json['daejeon'] ?? '0'),
        gyeongbuk = double.parse(json['gyeongbuk'] ?? '0'),
        sejong = double.parse(json['sejong'] ?? '0'),
        gwangju = double.parse(json['gwangju'] ?? '0'),
        jeonbuk = double.parse(json['jeonbuk'] ?? '0'),
        jeonnam = double.parse(json['jeonbuk'] ?? '0'),
        gangwon = double.parse(json['gangwon'] ?? '0'),
        ulsan = double.parse(json['ulsan'] ?? '0'),
        seoul = double.parse(json['seoul'] ?? '0'),
        busan = double.parse(json['busan'] ?? '0'),
        jeju = double.parse(json['jeju'] ?? '0'),
        chungbuk = double.parse(json['chungbuk'] ?? '0'),
        gyeongnam = double.parse(json['gyeongnam'] ?? '0'),
        gyeonggi = double.parse(json['gyeonggi'] ?? '0'),
        dataTime = DateTime.parse(json['dataTime']),
        itemCode = parseItemCode(json['itemCode']);

// ItemCode 값을 enum형 ItemCode로 변환하는 메소드
  static ItemCode parseItemCode(String raw) {
    if (raw == 'PM2.5') {
      return ItemCode.PM25;
    }

// ItemCode.NO2.name;
// -> 'NO2'
// ItemCode.NO2.toString();
// -> 'ItemCode.NO2'

// ItemCode enum의 모든 값(values) 중에 element.name == raw에 해당하는 첫번째 값을 리턴
    return ItemCode.values.firstWhere((element) => element.name == raw);
  }

// 한글로 지역 입력 시 해당하는 지역의 값 리턴해주는 메소드
// 서울 -> seoul의 값 리턴
  double getLevelFromRegion(String region) {
    if (region == '서울') {
      return seoul;
    } else if (region == '경기') {
      return gyeonggi;
    } else if (region == '대구') {
      return daegu;
    } else if (region == '충남') {
      return chungnam;
    } else if (region == '인천') {
      return incheon;
    } else if (region == '대전') {
      return daejeon;
    } else if (region == '경북') {
      return gyeongbuk;
    } else if (region == '세종') {
      return sejong;
    } else if (region == '광주') {
      return gwangju;
    } else if (region == '전북') {
      return jeonbuk;
    } else if (region == '강원') {
      return gangwon;
    } else if (region == '울산') {
      return ulsan;
    } else if (region == '전남') {
      return jeonnam;
    } else if (region == '부산') {
      return busan;
    } else if (region == '제주') {
      return jeju;
    } else if (region == '충북') {
      return chungbuk;
    } else if (region == '경남') {
      return gyeongnam;
    } else {
      throw Exception('알수없는 지역입니다');
    }
  }
}
