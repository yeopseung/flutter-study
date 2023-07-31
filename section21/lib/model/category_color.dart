import 'package:drift/drift.dart';

class CategoryColors extends Table {
  // Getter

  // PRIMARY KEY
  // autoIncrement - 자동으로 id 배정
  IntColumn get id => integer().autoIncrement()();

  // 색상 코드
  TextColumn get hexCode => text()();
}
