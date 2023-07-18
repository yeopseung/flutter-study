import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textStyle = const TextStyle(
    fontSize: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // 일회성 응답에 사용
        // 앨범에서 이미지 가져오기, 배터리 표시, 파일 가져오기, http 요청 등
        child: FutureBuilder(
          // future - Future를 리턴해주는 어떤 함수든 넣을 수 있음
          future: getNumber(),

          // builder - Future 함수의 상태가 변경 될 때 마다 builder를 다시 실행하여 화면을 업데이트
          builder: (context, snapshot) {

            // 처음 빌드가 되는것 말고는 FutureBuilder의 Data 값이 저장되어 있음 (캐싱)
            // 따라서 로딩바는 처음 snapshot 데이터가 들어있지 않은 경우에만 띄워줘도 됨
            // if (!snapshot.hasData) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            // Data와 Error의 특성을 사용하여 만드는 일반적인 구조
            // if(snapshot.hasData){
            //   // 데이터가 있을 때 위젯 렌더링
            // }
            // if(snapshot.hasError){
            //   // 에러가 났을 때 위젯 렌더링
            // }
            // // 로딩중일 때 위젯 렌더링

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'FutureBuilder',
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  // connectionState - future 함수에 따른 State
                  //  - none - future parameter를 안썼을 때, default
                  //  - waiting - future 함수 대기
                  //  - done - future 함수가 실행이 완벽히 끝나거나 에러가 발생했을 때
                  'ConnectionState : ${snapshot.connectionState}',
                  style: textStyle,
                ),
                Text(
                  // data - future 함수 실행 결과물
                  //  - null - default
                  'Data : ${snapshot.data}',
                  style: textStyle,
                ),
                Text(
                  // error - 에러 발생시 출력
                  //  - null - default
                  'Error : ${snapshot.error}',
                  style: textStyle,
                ),
                ElevatedButton(
                  onPressed: () {
                    // setState 를 실행하면 다시 빌드가 됨
                    // 처음 빌드가 되는것 말고는 FutureBuilder의 Data 값이 저장되어 있음 (캐싱)
                    setState(() {});
                  },
                  child: const Text('setState'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<int> getNumber() async {
    await Future.delayed(const Duration(seconds: 3));

    final random = Random();

    // 에러 던지고 싶을 때 주석 제거
    // throw Exception('에러가 발생했습니다.');

    return random.nextInt(100);
  }
}
