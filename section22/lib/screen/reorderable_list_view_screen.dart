import 'package:flutter/material.dart';
import 'package:section22/const/colors.dart';
import 'package:section22/layout/main_layout.dart';

// ReorderableListView
// - 자식들의 순서를 바꿀수 있는 리스트
// - 단, 화면에서만 순서를 바꿔주지 실제 데이터 값을 변경해주지는 않음
// - 따라서 그것을 반영하고 싶다면 실제 데이터 값도 변경해주는 로직 필요 -> onReorder에서
class ReorderableListViewScreen extends StatefulWidget {
  const ReorderableListViewScreen({super.key});

  @override
  State<ReorderableListViewScreen> createState() =>
      _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {
  List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ReorderableListViewScreen',
      body: renderBuilder(),
    );
  }

  // ReorderableListView
  // - 기본적인 ReorderableListView
  // - 자식 들을 한번에 불러오는 단점 존재
  Widget renderDefault() {
    return ReorderableListView(
      // 순서를 바꿀 경우 실행되는 메소드
      onReorder: (int oldIndex, int newIndex) {
        // [red, orange, yellow]
        // oldIndex [0, 1, 2]
        //
        // 1번 - red를 yellow 다음으로 옮기고 싶을 경우
        // -> red의 oldIndex 0번  -> newIndex 3번
        // -> 그러나 실제 옮겨진 뒤에 위치는 2번임 (실제 옮겨지는 위치는 newIndex-1)
        // [orange, yellow, red]
        //
        // 2번 - yellow를 red 앞으로 옮기고 싶을 경우
        // -> yellow의 oldIndex 2번 -> newIndex 0번
        // -> 로직 이상 없음
        // [yellow, red, orange]
        //
        // 결론 - onReorder에서 oldIndex 와 newIndex 위치 선정 기준은 옮기기 전의 위치를 기준으로 하므로 주의해야 한다

        // 1번 조건 반영
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        // 실제 데이터에 변경된 순서 적용하는 로직
        setState(() {
          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
      children: numbers
          .map(
            (e) => renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ),
          )
          .toList(),
    );
  }

  // ReorderableListView.builder
  // - 효율적인 렌더링 가능
  Widget renderBuilder(){
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[numbers[index] % rainbowColors.length],
          index: numbers[index],
        );
      },
      itemCount: numbers.length,
      onReorder: (int oldIndex, int newIndex) {
        // [red, orange, yellow]
        // oldIndex [0, 1, 2]
        //
        // 1번 - red를 yellow 다음으로 옮기고 싶을 경우
        // -> red의 oldIndex 0번  -> newIndex 3번
        // -> 그러나 실제 옮겨진 뒤에 위치는 2번임 (실제 옮겨지는 위치는 newIndex-1)
        // [orange, yellow, red]
        //
        // 2번 - yellow를 red 앞으로 옮기고 싶을 경우
        // -> yellow의 oldIndex 2번 -> newIndex 0번
        // -> 로직 이상 없음
        // [yellow, red, orange]
        //
        // 결론 - onReorder에서 oldIndex 와 newIndex 위치 선정 기준은 옮기기 전의 위치를 기준으로 하므로 주의해야 한다

        // 1번 조건 반영
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        // 실제 데이터에 변경된 순서 적용하는 로직
        setState(() {
          final item = numbers.removeAt(oldIndex);
          numbers.insert(newIndex, item);
        });
      },
    );
  }

  // 테스트를 위한 컨테이너 렌더링 메소드
  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    // 테스트를 위한 순서 print 문
    print(index);

    return Container(
      // key - 시스템이 Container를 구별하는 고유값
      key: Key(index.toString()),
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}
