import 'package:drift/drift.dart';

// 스케줄 테이블
class Schedules extends Table {
  // Getter

  // PRIMARY KEY
  // autoIncrement - 자동으로 id 배정
  IntColumn get id => integer().autoIncrement()();

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 종료 시간
  IntColumn get endTime => integer()();

  // 컬러 id
  IntColumn get colorId => integer()();

  // 생성 날짜
  // clientDefault - 기본값 설정
  DateTimeColumn get createAt => dateTime().clientDefault(() => DateTime.now())();
}
