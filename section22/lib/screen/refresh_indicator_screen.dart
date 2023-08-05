import 'package:flutter/material.dart';
import 'package:section22/const/colors.dart';
import 'package:section22/layout/main_layout.dart';

class RefreshIndicatorScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  RefreshIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'RefreshIndicatorScreen',
      // 맨위의 한계점까지 당겼을 때 로딩창(보통 새로고침)을 만들고 싶다면 RefreshIndicator 사용하면 됨
      body: RefreshIndicator(
        // onRefresh 콜백 메소드에 이후 행동 정의
        onRefresh: () async {
          // ex) 서버 요청 후 데이터 새로고침 대기
          await Future.delayed(const Duration(seconds: 3));
        },
        child: SingleChildScrollView(
          child: Column(
            children: numbers
                .map(
                  (e) => renderContainer(
                    color: rainbowColors[e % rainbowColors.length],
                    index: e,
                  ),
                )
                .toList(),
          ),
        ),
      ),
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
