import 'package:flutter/material.dart';
import 'package:section24/const/tabs.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen>
    with TickerProviderStateMixin {
  late final TabController controller;

  @override
  void initState() {
    super.initState();

    // 컨트롤러 초기화
    controller = TabController(
      length: TABS.length,
      vsync: this,
    );

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBarScreen'),
      ),
      body: TabBarView(
        controller: controller,
        children: TABS
            .map(
              (e) => Center(
                child: Icon(e.icon),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 선택된 아이템의 색상 (그 외 fontSize, style 등이 있음)
        selectedItemColor: Colors.black,

        // 선택되지 않은 아이템의 색상
        unselectedItemColor: Colors.grey,

        // 선택된 탭의 레이블을 보여줄 것인가 - default(true)
        showSelectedLabels: true,

        // 선택되지 않은 탭의 레이블을 보여줄 것인가 - default(false)
        showUnselectedLabels: true,

        // 현재 인덱스
        currentIndex: controller.index,

        // 몇 번 탭이 눌렸는지 누를때마다 실행
        onTap: (index) {
          controller.animateTo(index);
        },

        // 타입 설정 (선택된 아이콘이 확대된다와 같은 타입(shifting))
        type: BottomNavigationBarType.fixed,

        // 아이템 목록
        items: TABS
            .map(
              (e) => BottomNavigationBarItem(
                // 아이콘
                icon: Icon(
                  e.icon,
                ),
                // 제목, 레이블
                label: e.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
