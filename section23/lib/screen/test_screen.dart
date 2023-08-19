import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:section23/main.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TestScreen',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(
            valueListenable: Hive.box(testBox).listenable(),
            builder: (context, box, widget) {
              print('key: ${box.keys.toList()}');
              print('value: ${box.values.toList()}');

              return Column(
                children: box.values
                    .map(
                      (e) => Text(e.toString()),
                    )
                    .toList(),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              // main에서 만든 box를 불러옴
              final box = Hive.box(testBox);
              print('key: ${box.keys.toList()}');
              print('value: ${box.values.toList()}');
            },
            child: const Text(
              '박스 프린트하기',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // main에서 만든 box를 불러옴
              final box = Hive.box(testBox);

              // 값 넣기 (add) { 0: 테스트1, ... }
              // - key 값은 자동으로 오름차순으로 생성
              box.add('테스트1');

              // 값 넣기 (put) { 99: 테스트2, ... }
              // - 데이터를 생성하거나 업데이트
              // - key 값을 지정해야 함
              box.put(99, '테스트2');
            },
            child: const Text(
              '데이터 넣기',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // main에서 만든 box를 불러옴
              final box = Hive.box(testBox);

              // key 값을 이용해 값 가져오기 (get)
              print(box.get(0));

              // n번째 값을 가져오기
              print(box.getAt(0));
            },
            child: const Text(
              '특정 값 가져오기',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // main에서 만든 box를 불러옴
              final box = Hive.box(testBox);
              // key 값을 이용해 값 삭제
              box.delete(2);

              // n번째 값을 삭제
              box.deleteAt(0);
            },
            child: const Text(
              '값 삭제하기',
            ),
          ),
        ],
      ),
    );
  }
}
