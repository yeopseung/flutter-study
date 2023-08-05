import 'package:flutter/material.dart';
import 'package:section22/const/colors.dart';
import 'package:section22/layout/main_layout.dart';

// ListView
// - 스크롤 가능한 List를 생성하는 위젯
class ListViewScreen extends StatelessWidget {
  // 테스트를 위한 숫자 리스트
  final List<int> numbers = List.generate(100, (index) => index);

  ListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ListViewScreen',
      body: renderSeparater(),
    );
  }

  // 1. ListView
  // - 모든 자식 위젯들을 동시에 생성하고 렌더링 -> 메모리 측면에서 비효율적
  Widget renderDefault() {
    return ListView(
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

  // 2. ListView.builder
  // - itemBuilder 콜백 함수를 통해 동적으로 자식 위젯들을 생성
  // - 한번에 렌더링 하는것이 아닌 부분적으로 렌더링 함 -> 메모리 사용 효율적
  Widget renderBuilder() {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );
  }

  // 3. ListView.separated
  // - itemBuilder 콜백 함수를 사용하여 동적으로 자식 위젯들을 생성
  // - separatorBuilder 콜백 함수를 사용하여 아이템 사이의 공간 정의
  // - 품목 사이에 광고배너를 넣기에 매우 적합
  Widget renderSeparater() {

    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        index += 1;

        // 5개의 아이템 마다 1개씩
        if(index % 5 == 0){
          return renderContainer(
            color: Colors.black,
            index: index,
            height: 100,
          );
        }

        return Container();
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
