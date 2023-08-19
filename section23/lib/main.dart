import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:section23/model/stat_model.dart';
import 'package:section23/screen/home_screen.dart';

const testBox = 'test';

void main() async {
  // 플러터를 초기화
  await Hive.initFlutter();

  // 어뎁터 등록
  Hive.registerAdapter<StatModel>(StatModelAdapter());
  Hive.registerAdapter<ItemCode>(ItemCodeAdapter());

  // 테스트용 박스 오픈
  await Hive.openBox(testBox);

  // ItemCode별 박스 오픈
  for(ItemCode itemCode in ItemCode.values){
    await Hive.openBox<StatModel>(itemCode.name);
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunflower',
      ),
      home: const HomeScreen(),
    ),
  );
}
