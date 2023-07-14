import 'package:flutter/material.dart';
import 'package:section14/screen/home_screen.dart';
import 'package:section14/screen/route_one_screen.dart';
import 'package:section14/screen/route_three_screen.dart';
import 'package:section14/screen/route_two_screen.dart';


// 다음과 같이 URL을 변수로 빼서 사용하는 방법도 있음 (추천)
// home == '/'
const HOME_ROUTE = '/';

void main() {
  runApp(
    MaterialApp(
      // home: HomeScreen(),

      // initialRoute - 초기 화면

      initialRoute: '/',

      // NamedRoute
      // key: 경로, value: RouteBuilder
      routes: {
        HOME_ROUTE : (context) => HomeScreen(),
        '/one': (context) => RouteOneScreen(),
        '/two': (context) => RouteTwoScreen(),
        '/three': (context) => RouteThreeScreen(),
      },
    ),
  );
}
