import 'package:flutter/material.dart';
import 'package:section22/const/colors.dart';

// SliverPersistentHeader의 Delegate
class _SliverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverFixedHeaderDelegate(
      {required this.child, required this.maxHeight, required this.minHeight});

  // build -> Delegate build 방법 정의
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  // 최대 높이
  @override
  double get maxExtent => maxHeight;

  // 최소 높이
  @override
  double get minExtent => minHeight;

  // covariant -> 상속된 클래스도 사용가능
  // oldDelegate -> parameter가 변경되거나 해서 다시 build될 때 기존 Delegate
  // this -> 새로운 Delegate
  // shouldRebuild -> 새로 빌드를 해야할지 말지 결정, false 빌드 X, true 빌드 O
  @override
  bool shouldRebuild(_SliverFixedHeaderDelegate oldDelegate) {
    // minHeight, maxHeight, child 값이 변경되었을 때 만 rebuild
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.child != child;
  }
}

// CustomScrollView
// - 여러개의 스크롤 가능한 위젯들을 한번에 한 위젯에 집어넣게 해주는 기능을 제공
// - ex) ListView, GridView 따로 스크롤 되지 않고 두가지가 동시에 스크롤되게 하고 싶을 경우 사용
class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);

  CustomScrollViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        // List 형태의 위젯들을 다 사용 가능
        // - 넣을 수 있는 위젯들을 Sliver를 접두어로 가짐
        // - ex) AppBar도 스크롤되게 만들 수 있음
        slivers: [
          renderSliverAppBar(),
          renderHeader(),
          renderChildSliverList(),
          renderHeader(),
          renderBuilderChildSliverList(),
          renderChildSliverGridDefaultCount(),
          renderChildSliverGridBuilderMax(),
        ],
      ),
    );
  }

  // SliverPersistentHeader
  // - Sliver 위젯들 사이제 헤더 공간을 정의 -> 위젯 사이에 광고 배너 넣기 적합
  SliverPersistentHeader renderHeader(){
    return SliverPersistentHeader(
      delegate: _SliverFixedHeaderDelegate(
        child: Container(
          color: Colors.black,
          child: const Center(
            child: Text(
              '곽승엽',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        minHeight: 75,
        maxHeight: 150,
      ),
    );
  }

  // SliverAppBar
  SliverAppBar renderSliverAppBar() {
    return const SliverAppBar(
      // floating
      // - true -> 밑으로 스크롤하면 없어지고, 위로 스크롤하면 생김
      // - false -> 스크롤의 일부가 됨, default
      floating: false,

      // pinned
      // - true -> 스크롤해도 위에 Appbar가 고정되어 있음, SliverAppBar가 아닌 기본적인 AppBar의 형태
      // - false -> 스크롤의 일부가 됨, default
      pinned: false,

      // snap
      // - ture -> floating이 true일 때, floating 애니메이션을 조금 더 확실하게 반응함 (all or nothing)
      // - false -> default
      snap: false,

      // stretch
      // - true -> 맨 위에서 한계 이상으로 스크롤 했을때 남는 공간을 차지
      // - false -> default
      stretch: false,

      // expandedHeight, collapsedHeight
      // - 차지하는 공간의 최대/최소 크기 지정 가능
      expandedHeight: 200,
      collapsedHeight: 150,

      // flexibleSpace
      // - 차지하는 공간의 스타일 등을 지정할 수 있음
      flexibleSpace: FlexibleSpaceBar(
        title: Text('FlexibleSpace'),
      ),

      title: Text('CustomScrollViewScreen'),
    );
  }

  // 1. SliverList -> SliverChildListDelegate
  // - 자식 위젯들을 한번에 렌더링
  // - ListView 기본 생성자와 유사함
  SliverList renderChildSliverList() {
    return SliverList(
      // 어떤 형태로 만들것인지 - default, builder 등
      // SliverChildListDelegate -> default
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
            )
            .toList(),
      ),
    );
  }

  // 2. SliverList -> SliverChildBuilderDelegate
  // - ListView.builder와 유사함
  SliverList renderBuilderChildSliverList() {
    return SliverList(
      // 어떤 형태로 만들것인지 - default, builder 등
      // SliverChildListDelegate -> default
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
      ),
    );
  }

  // 3. SliverGrid -> SliverGridDelegateWithFixedCrossAxisCount
  // - delegate 속성은 SliverList에서 쓰던것과 같고 gridDelegate가 추가된 형태
  // - delegate -> GrideView 기본 생성자
  // - gridDelegate -> GridView의 FixedCount
  SliverGrid renderChildSliverGridDefaultCount() {
    return SliverGrid(
      // 어떤 형태로 만들것인지 - default, builder 등
      // SliverChildListDelegate -> default
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(
                color: rainbowColors[e % rainbowColors.length],
                index: e,
              ),
            )
            .toList(),
      ),
      // MaxCrossAxisExtent, FixedCrossAxisCount 등 Grid와 같음
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  // 4. SliverGrid -> SliverGridDelegateWithMaxCrossAxisExtent
  // - delegate 속성은 SliverList에서 쓰던것과 같고 gridDelegate가 추가된 형태
  // - delegate -> GridView.builder와 유사함
  // - gridDelegate -> GridView의 MaxExtent
  SliverGrid renderChildSliverGridBuilderMax() {
    return SliverGrid(
      // 어떤 형태로 만들것인지 - default, builder 등
      // SliverChildListDelegate -> default
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
        childCount: 100,
      ),
      // MaxCrossAxisExtent, FixedCrossAxisCount 등 Grid와 같음
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
    );
  }

  // 테스트를 위한 컨테이너 렌더링 메소드
  Widget renderContainer({
    required Color color,
    required int index,
    double? height,
  }) {
    // 테스트를 위한 순서 print 문
    print(index);

    return Container(
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}
