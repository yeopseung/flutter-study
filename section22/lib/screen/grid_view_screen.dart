import 'package:flutter/material.dart';
import 'package:section22/const/colors.dart';
import 'package:section22/layout/main_layout.dart';

// GirdView
// - 행/열을 설정할 수 있는 위젯
// (이외의 다른 GridLayout 종류도 있지만 대표적으로 쓰는건 다음과 같음)
class GridViewScreen extends StatelessWidget {
  // 테스트를 위한 숫자 리스트
  final List<int> numbers = List.generate(100, (index) => index);

  GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'GridViewScreen',
      body: renderCount(),
    );
  }

  // 1. GridView.count
  // - 열 개수와 간격등을 지정할 수 있는 GridView
  // - 가장 간단하지만, 모든 자식 위젯들을 한번에 렌더링하는 단점 존재
  // (Default GridView는 Scroll을 우리가 Custom 할 때만 사용하여 pass)
  Widget renderCount() {
    return GridView.count(
      // 열 개수
      crossAxisCount: 2,
      // 열 간격
      crossAxisSpacing: 12.0,
      // 행 간격
      mainAxisSpacing: 12.0,
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

  // 2. GridView.builder
  // - 화면에 보이는곳만 부분적으로 렌더링
  // - SliverGridDelegateWithFixedCrossAxisCount -> 개수를 지정해서 나타냄
  Widget renderBuilderCrossAxisCount() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        // 열 개수
        crossAxisCount: 2,
        // 열 간격
        crossAxisSpacing: 12.0,
        // 행 간격
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );
  }

  // 3. GridView.builder
  // - 화면에 보이는곳만 부분적으로 렌더링
  // - SliverGridDelegateWithMaxCrossAxisExtent -> 길이를 지정해서 나타냄
  Widget renderBuilderMaxExtent() {
    return  GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        // 위젯들의 최대 길이 -> 그 길이에 맞춰서 칸이 나눠짐
        maxCrossAxisExtent: 100.0,
        // 열 간격
        crossAxisSpacing: 12.0,
        // 행 간격
        mainAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
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
