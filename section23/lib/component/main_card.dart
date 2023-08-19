import 'package:flutter/material.dart';

import '../constant/colors.dart';

// 메인화면 - 카드 (종류별 통계, 시간별 미세먼지)
class MainCard extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const MainCard({super.key, required this.child, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      color: backgroundColor,
      child: child,
    );
  }
}
