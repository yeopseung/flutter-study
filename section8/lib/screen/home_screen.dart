import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      print('Timer!');

      // double인 이유 절반 넘어가면 0.5
      int currentPage = controller.page!.toInt();
      int nextPage = currentPage + 1;

      if (nextPage > 4) {
        nextPage = 0;
      }
      controller.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    // dispose 될 때 controller 종료하여 메모리 누수를 막음
    controller.dispose();
    // dispose 될 때 timer도 종료하여 메모리 누수를 막음
    if (timer != null) {
      timer!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 라이트/다크 모드 설정
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [1, 2, 3, 4, 5]
            .map((e) => Image.asset(
                  'asset/img/image_$e.jpeg',
                  fit: BoxFit.cover,
                ))
            .toList(),
      ),
    );
  }
}
