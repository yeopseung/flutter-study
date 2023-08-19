import 'package:flutter/material.dart';

import '../const/tabs.dart';

class AppBarUsingController extends StatefulWidget {
  const AppBarUsingController({super.key});

  @override
  State<AppBarUsingController> createState() => _AppBarUsingControllerState();
}

// TickerProviderStateMixin - 한 프레임(틱) 당의 움직임을 세밀하게 컨드롤하게 해줌
class _AppBarUsingControllerState extends State<AppBarUsingController>
    with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: TABS.length,
      vsync: this,
    );

    // 리스너 추가 - index가 변경될 때 마다 호출
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AppBarUsingController',
        ),
        bottom: TabBar(
          // 직접 TabController를 만들어 사용할 경우
          controller: tabController,
          tabs: TABS
              .map(
                (e) => Tab(
                  icon: Icon(
                    e.icon,
                  ),
                  child: Text(
                    e.label,
                  ),
                ),
              )
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: TABS
            .map(
              (e) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    e.icon,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (tabController.index != 0)
                        ElevatedButton(
                          onPressed: () {
                            // animateTo - 이동 메소드
                            tabController.animateTo(
                              // 현재 인덱스의 이전
                              tabController.index - 1,
                            );
                          },
                          child: const Text(
                            '이전',
                          ),
                        ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      if (tabController.index != TABS.length - 1)
                        ElevatedButton(
                          onPressed: () {
                            // animateTo - 이동 메소드
                            tabController.animateTo(
                              // 현재 인덱스의 다음
                              tabController.index + 1,
                            );
                          },
                          child: const Text(
                            '다음',
                          ),
                        ),
                    ],
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
