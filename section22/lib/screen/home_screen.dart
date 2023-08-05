import 'package:flutter/material.dart';
import 'package:section22/layout/main_layout.dart';
import 'package:section22/screen/custom_scroll_view_screen.dart';
import 'package:section22/screen/grid_view_screen.dart';
import 'package:section22/screen/list_view_screen.dart';
import 'package:section22/screen/refresh_indicator_screen.dart';
import 'package:section22/screen/reorderable_list_view_screen.dart';
import 'package:section22/screen/scroll_bar_screen.dart';
import 'package:section22/screen/single_child_scroll_view_screen.dart';

// 페이지 이동시 자주 사용하는 패턴
class ScreenModel {
  final WidgetBuilder builder;
  final String name;

  ScreenModel({required this.builder, required this.name});
}

// 홈 화면
class HomeScreen extends StatelessWidget {
  // 페이지 이동시 자주 사용하는 패턴
  final screens = [
    ScreenModel(
      builder: (_) => SingleChildScrollViewScreen(),
      name: 'SingleChildScrollViewScreen',
    ),
    ScreenModel(
      builder: (_) => ListViewScreen(),
      name: 'ListViewScreen',
    ),
    ScreenModel(
      builder: (_) => GridViewScreen(),
      name: 'GridViewScreen',
    ),
    ScreenModel(
      builder: (_) => const ReorderableListViewScreen(),
      name: 'ReorderableListViewScreen',
    ),
    ScreenModel(
      builder: (_) => CustomScrollViewScreen(),
      name: 'CustomScrollViewScreen',
    ),
    ScreenModel(
      builder: (_) => ScrollbarScreen(),
      name: 'ScrollbarScreen',
    ),
    ScreenModel(
      builder: (_) => RefreshIndicatorScreen(),
      name: 'RefreshIndicatorScreen',
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // 페이지 이동시 자주 사용하는 패턴
            children: screens
                .map(
                  (screen) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: screen.builder),
                      );
                    },
                    child: Text(screen.name),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
