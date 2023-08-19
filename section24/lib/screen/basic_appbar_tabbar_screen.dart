import 'package:flutter/material.dart';

import '../const/tabs.dart';

class BasicAppBarTabBarScreen extends StatelessWidget {
  const BasicAppBarTabBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TABS.length,
      child: Scaffold(
        appBar: AppBar(
          // 제목
          title: const Text('BasicAppBarScreen'),
          // 제목 아래 부분
          bottom: TabBar(
            // TabBar
            // - 가장 기본적인 탭바
            // - controller 속성을 받아야 함 -> 안받으려면 DefaultTabController로 감싸면 해결 완료

            // 선택된 항목 표시 색상
            indicatorColor: Colors.red,

            // 선택된 항목 표시 두께
            indicatorWeight: 4.0,

            // 선택된 항목 표시 크기 - tab에 맞춰서, label에 맞춰서 ,...
            indicatorSize: TabBarIndicatorSize.tab,

            // 스크롤 가능 여부
            isScrollable: false,

            // 레이블 색상
            labelColor: Colors.yellow,

            // 레이블 스타일
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
            ),

            // 선택되지 않은 레이블 색상
            unselectedLabelColor: Colors.purple,

            // tabs - Tab 목록
            tabs: TABS
                .map(
                  (e) => Tab(
                    // Tab의 아이콘
                    icon: Icon(
                      e.icon,
                    ),
                    // Tab 글씨
                    child: Text(
                      e.label,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: TABS
              .map(
                (e) => Center(
                  child: Icon(
                    e.icon,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
