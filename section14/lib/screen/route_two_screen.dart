import 'package:flutter/material.dart';
import 'package:section14/layout/main_layout.dart';
import 'package:section14/screen/route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    return MainLayout(
      title: 'Route Two Screen',
      children: [
        Text(
          'arguments: $arguments',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/three',
              arguments: 3,
            );
          },
          child: const Text('pushNamed'),
        ),
        ElevatedButton(
          onPressed: () {
            // pushReplacement - 현재 위젯을 이동할 위젯으로 교체하며 이동
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => RouteThreeScreen()));
          },
          child: const Text('pushReplacement'),
        ),
        ElevatedButton(
          onPressed: () {
            // pushReplacement - 현재 위젯을 이동할 위젯으로 교체하며 이동
            Navigator.of(context).pushReplacementNamed(
              '/three',
              arguments: 3,
            );
          },
          child: const Text('pushReplacementNamed'),
        ),
        ElevatedButton(
          onPressed: () {
            // pushAndRemoveUntil - 지정된 경로로 이동하고, 이전에 쌓인 모든 화면 제거
            Navigator.of(context).pushAndRemoveUntil(
              // 라우트 이동
              MaterialPageRoute(builder: (_) => RouteThreeScreen()),
              // option - 해당하는 라우트를 제외하고 다 삭제
              (route) => route.settings.name == '/',
            );
          },
          child: const Text('pushAndRemoveUntil'),
        ),
        ElevatedButton(
          onPressed: () {
            // pushAndRemoveUntil - 지정된 경로로 이동하고, 이전에 쌓인 모든 화면 제거
            Navigator.of(context).pushNamedAndRemoveUntil(
              // 라우트 이동
              '/three',
              // option - 해당하는 라우트를 제외하고 다 삭제
              (route) => route.settings.name == '/',
            );
          },
          child: const Text('pushAndRemoveUntil'),
        ),
      ],
    );
  }
}
