import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: Column(
              // MainAxisAlignment - 주축 정렬
              // start - 시작
              // end - 끝
              // center - 가운데
              // spaceBetween - 위젯과 위젯 사이가 동일하게
              // spaceEvenly - 위젯을 같은 간격으로 배치하지만 끝과 끝을 비워 놓음
              // spaceAround - spaceEvenly + 끝과 끝의 간격은 1/2
              mainAxisAlignment: MainAxisAlignment.start,

              // CrossAxisAlignment - 반대축 정렬
              // start - 시작
              // end - 끝
              // center - 가운데
              // stretch - 최대한으로 늘림
              crossAxisAlignment: CrossAxisAlignment.start,

              // MainAxisSize - 주축 크기
              // max - 최대
              // min - 최소
              mainAxisSize: MainAxisSize.max,

              children: [
                // Expanded / Flexible - 주의. Row,Column의 children에서만 사용 가능
                // Expanded (자주 사용 O)
                // - 가능한 많은 공간 확보 (weight)
                // - flex: 기본값 1 (weight 값)
                // Flexible (자수 사용 X)
                // - 자신의 크기에 맞게 공간 확보
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.red,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.orange,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                Container(
                  color: Colors.yellow,
                  width: 50.0,
                  height: 50.0,
                ),
                Container(
                  color: Colors.green,
                  width: 50.0,
                  height: 50.0,
                ),
              ],
            ),
          ),
        )
    );
  }
}
