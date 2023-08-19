import 'package:flutter/material.dart';
import '../constant/regions.dart';

// 선택한 지역이 어디인지 리턴하는 함수를 정의
typedef OnRegionTap = void Function(String region);

// 메인화면 - 드로어
class MainDrawer extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final OnRegionTap onRegionTap;
  final String selectedRegion;

  const MainDrawer({
    super.key,
    required this.onRegionTap,
    required this.selectedRegion,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: darkColor,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              '지역 선택',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
          // cascading operator
          ...regions
              .map(
                (e) => ListTile(
                  // 누르는 공간의 전체 == Tile
                  // Tile의 기본 배경색
                  tileColor: Colors.white,
                  // Tile이 선택되었을 때 배경색
                  selectedTileColor: lightColor,
                  // Tile이 선택된 상태에서 글자 색
                  selectedColor: Colors.black,
                  // Tile이 선택된 상태인지 (T/F)
                  selected: e == selectedRegion,

                  onTap: () {
                    onRegionTap(e);
                  },
                  title: Text(
                    e,
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
