import 'package:flutter/material.dart';
import 'package:section24/screen/appbar_using_controller.dart';
import 'package:section24/screen/basic_appbar_tabbar_screen.dart';

import 'bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BasicAppBarTabBarScreen()),
                );
              },
              child: const Text(
                'Basic AppBar TabBar Screen',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AppBarUsingController()),
                );
              },
              child: const Text(
                'AppBar Using Controller',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BottomNavigationBarScreen()),
                );
              },
              child: const Text(
                'BottomNavigationBarScreen',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
