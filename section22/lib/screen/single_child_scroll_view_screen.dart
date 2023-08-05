import 'package:flutter/material.dart';
import 'package:section22/const/colors.dart';
import 'package:section22/layout/main_layout.dart';

// SingleChildScrollView
// - 가장 기본적인 Scroll 위젯
class SingleChildScrollViewScreen extends StatelessWidget {
  // 테스트를 위한 숫자 리스트
  final List<int> numbers = List.generate(100, (index) => index);

  SingleChildScrollViewScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'SingleChildScrollView',
      body: renderSimple(),
    );
  }

  // 1. 기본적인 렌더링 방법
  // - 기본적으로는 스크롤이 되지 않는 상태를 유지하다가 화면을 넘어설 경우 스크롤 활성화
  // - NeverScrollableScrollPhysics 상태에서 화면을 넘어설 경우 AlwaysScrollableScrollPhysics로 변경됨
  Widget renderSimple() {
    return SingleChildScrollView(
      child: Column(
        children: rainbowColors
            .map(
              (e) => renderContainer(color: e),
            )
            .toList(),
      ),
    );
  }

  // 2. 화면을 넘어가지 않아도 스크롤 되게 하는 방법
  // - physics 속성을 설정하여 변경 가능 -> AlwaysScrollableScrollPhysics로 설정
  // - NeverScrollableScrollPhysics -> 스크롤 안됨
  // - AlwaysScrollableScrollPhysics -> 스크롤 됨
  // - BouncingScrollPhysics -> 스크롤 끝에 오면 바운싱되는 효과 적용 (ios 스타일 스크롤 애니메이션)
  // - ClampingScrollPhysics -> 스크롤 끝에 오면 걸리는 효과 적용 (android 스타일 스크롤 애니메이션)
  Widget renderAlwaysScroll() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(color: Colors.black),
        ],
      ),
    );
  }

  // 3. 스크롤 시 위젯이 잘리지 않게 하는 방법
  // - clipBehavior 속성을 사용하여 자식 요소를 어떻게 클리핑(잘라내기)할지 설정 가능 -> Clip.none
  // - Clip.none -> 자식 요소를 잘라내지 않음, 부모 위젯의 경계를 넘어 표시될 수 있음
  // - Clip.hardEdge -> 부모 위젯의 경계에 맞게 잘라냄
  // - Clip.antiAlias -> hardEdge + 안티엘리어싱 효과
  // - Clip.antiAliasWithSaveLayer -> antiAlias + 잘라낸 부분을 저장 레이어로 처리하여 더 나은 안티엘리어싱 제공
  Widget renderClip() {
    return SingleChildScrollView(
      clipBehavior: Clip.hardEdge,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(color: Colors.black),
        ],
      ),
    );
  }

  // 4. SingleChildScrollView의 장/단점
  // - 사용하기 쉽고 간단하다
  // - 자식 위젯들을 한번에 모두 렌더링하여 리소스 부담이 크다
  Widget renderPerformance(){
    return SingleChildScrollView(
      child: Column(
        children: numbers
            .map(
              (e) => renderContainer(
            color: rainbowColors[e % rainbowColors.length],
          ),
        )
            .toList(),
      ),
    );
  }

  // 테스트를 위한 컨테이너 렌더링 메소드
  Widget renderContainer({
    required Color color,
    int? index,
  }) {
    // 테스트를 위한 순서 print 문
    if(index != null){
      print(index);
    }
    return Container(
      height: 300,
      color: color,
    );
  }
}
