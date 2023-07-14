import 'package:flutter/material.dart';
import 'package:section14/layout/main_layout.dart';
import 'package:section14/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home Screen',
      children: [

        ElevatedButton(
          onPressed: () {
            // canPop - 뒤로갈 페이지가 있는지 없는지 확인
            // maybePop - 뒤로갈 페이지가 없을 때 (라우트 스택이 비어있을 때) pop 하지 않음 (자동으로 canPop하여 확인함)
            Navigator.of(context).maybePop();
          },
          child: const Text('maybePop'),
        ),

        ElevatedButton(
          onPressed: () async {
            // RouteOne 이동
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    const RouteOneScreen(number: 1),
              ),
            );
            print('result $result');
          },
          child: const Text('Push'),
        ),
      ],
    );
  }
}
