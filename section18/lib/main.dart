import 'package:flutter/material.dart';
import 'package:section18/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NotoScans',
      ),
      home: const HomeScreen(),
    ),
  );
}
