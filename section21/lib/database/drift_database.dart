// private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:section21/model/category_color.dart';
import 'package:section21/model/schedule_with_color.dart';
import '../model/schedule.dart';
import 'package:path/path.dart' as p;

// private 값까지 볼러올 수 있다. 2:54
part 'drift_database.g.dart';

@DriftDatabase(
  // 사용할 테이블 정의
  tables: [
    Schedules,
    CategoryColors,
  ],
)
// _$LocalDatabase - LocalDatabase를 Drift가 'drift_database.g.dart'파일에 만들어준다
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // INSERT - insert한 값의 primary key 반환
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  // SELECT - 일회성으로 값 받기
  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // SELECT - 지속적으로 업데이트 된 값 받기
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    // 정석
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);

    query.where(schedules.date.equals(date));

    query.orderBy([OrderingTerm.asc(schedules.startTime)]);

    return query.watch().map((rows) => rows
        .map((row) => ScheduleWithColor(
            schedule: row.readTable(schedules),
            categoryColor: row.readTable(categoryColors)))
        .toList());

    // .. 연산자 사용
    // return (select(schedules)..where((table)=> table.date.equals(date))).watch();
  }

  // SELECT
  Future<Schedule> getScheduleById(int id) => (select(schedules)..where((table) => table.id.equals(id))).getSingle();

  // DELETE
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((table) => table.id.equals(id))).go();

  // UPDATE
  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((table) => table.id.equals(id))).write(data);

  // 스키마 버전
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 앱이 사용하는 폴더의 위치를 가져옴
    final dbFolder = await getApplicationDocumentsDirectory();

    // dbFolder 위치에 'db.sqlite' 파일 생성
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase(file);
  });
}
