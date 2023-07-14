import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 버튼 스타일 방법 1. ButtonStyle
          // 원래 버튼 스타일이 정석
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              // MaterialStateProperty
              // all - 모든 상황에 똑같이 적용
              // resolveWith - 상황마다 다르게 적용

              // MaterialState
              // 자주 쓰는건 pressed, disabled, default
              // hovered - 호버링 상태 (마우스 커서를 올려놓은 상태)
              // focused - 포커스 됐을때 (텍스트 필드)
              // pressed - 눌렀을때
              // dragged - 드래그 됐을때
              // selected - 선택됐을때 (체크박스, 라디오 버튼)
              // scrollUnder - 다른 컴포넌트 밑으로 스크롤링 됐을때
              // disabled - 비활성화 됐을때 (onPress : false)

              // 자주 쓰는 속성, 그 외에는 ButtonStyle에서 확인
              // 배경색
              backgroundColor: MaterialStateProperty.all(Colors.black),

              // 글자색
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                // 눌렸을 때
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white;
                }
                // 기본 상태
                return Colors.red;
              }),

              // padding
              padding: MaterialStateProperty.resolveWith((states) {
                // 눌렸을 때
                if (states.contains(MaterialState.pressed)) {
                  return const EdgeInsets.all(100.0);
                }
                // 기본 상태
                return null;
              }),
            ),
            child: const Text('ButtonStyle'),
          ),

          // 버튼 스타일 방법 2. styleFrom
          // ButtonStyle의 경량화 버전, 보통 방법 2를 선호
          ElevatedButton(
            onPressed: () {},
            // ElevatedButton, OutlinedButton, TextButton 다 같은 스타일 폼
            style: ElevatedButton.styleFrom(
              // primary - deprecated -> backgroundColor
              // onPrimary - deprecated -> foregroundColor

              // 배경색, 메인 컬러
              backgroundColor: Colors.red,
              // 텍스트, 버튼 클릭시 이펙트 (ripple effect) 색
              foregroundColor: Colors.black,
              // 그림자 색
              shadowColor: Colors.green,

              // 버튼의 튀어 나오는 정도
              elevation: 10.0,

              // 버튼 텍스트 스타일
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),

              // padding
              padding: const EdgeInsets.all(32.0),

              // 테투리 스타일
              side: const BorderSide(
                color: Colors.black,
                width: 4.0,
              ),
            ),
            child: const Text('ElevatedButton'),
          ),
          OutlinedButton(
            onPressed: () {},
            // ElevatedButton, OutlinedButton, TextButton 다 같은 스타일 폼
            // OutlinedButton.styleFrom()
            child: const Text('OutlinedButton'),
          ),
          TextButton(
            onPressed: () {},
            // ElevatedButton, OutlinedButton, TextButton 다 같은 스타일 폼
            // TextButton.styleFrom()
            child: const Text('TextButton'),
          ),
        ],
      ),
    );
  }
}
