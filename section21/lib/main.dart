import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:section21/database/drift_database.dart';
import 'package:section21/screen/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // red
  'F44336',
  // orange
  'FF9800',
  // yellow
  'FFEB3B',
  // green
  'FCAF50',
  // blue
  '2196F3',
  // indigo
  '3F51B5',
  // purple
  '9C27B0',
];

void main() async {
  // Flutter 프레임워크가 준비될 때 까지 기다림
  // runApp을 실행하면 자동으로 실행되는 함수인데 runApp 전에 코드를 추가할 경우 작성 필요
  WidgetsFlutterBinding.ensureInitialized();

  // 날짜 관련 포맷 초기화 -> intl 패키지 사용 가능
  await initializeDateFormatting();

  // 로컬 DB
  final database = LocalDatabase();

  // Get It 의존성 주입 툴 -> GetIt을 활용하여 값을 어디서든지 가져올 수 있게 됨
  GetIt.I.registerSingleton<LocalDatabase>(database);

  // 저장된 컬러
  final colors = await database.getCategoryColors();

  // 없을 경우 DB에 저장
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        ),
      );
    }
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: const HomeScreen(),
    ),
  );
}
