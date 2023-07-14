import 'package:flutter/material.dart';
import 'package:section14/layout/main_layout.dart';
import 'package:section14/screen/route_two_screen.dart';

class RouteOneScreen extends StatelessWidget {
  final int? number;

  const RouteOneScreen({super.key, this.number});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Route One Screen',
      children: [
        Text(
          'number: $number',
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          onPressed: () {
            // 뒤로가기
            Navigator.of(context).pop(1);
          },
          child: const Text('Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            // RouteTwo 이동
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const RouteTwoScreen(),
                settings: const RouteSettings(
                  arguments: 2,
                )
              ),
            );
          },
          child: const Text('Push'),
        ),
      ],
    );
  }
}
