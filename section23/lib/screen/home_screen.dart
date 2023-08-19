import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:section23/container/category_card.dart';
import 'package:section23/container/hourly_card.dart';
import 'package:section23/component/main_app_bar.dart';
import 'package:section23/model/stat_model.dart';
import 'package:section23/repository/stat_repository.dart';
import 'package:section23/utils/data_utils.dart';

import '../component/main_drawer.dart';
import '../constant/regions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  //
  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    fetchData();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final now = DateTime.now();
      final fetchTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      );

      final box = Hive.box(ItemCode.PM10.name);

      if (box.values.isNotEmpty && (box.values.last as StatModel).dataTime.isAtSameMomentAs(fetchTime)) {
        return;
      }

      // 모든 itemCode에 해당하는 데이터 값들을 불러옴
      // 아래의 코드는 각 요청들을 개별적으로 await하여 시간이 오래 걸림 (직렬로 처리)
      // for(ItemCode itemCode in ItemCode.values){
      //   final List<StatModel> statModels = await StatRepository.fetchData(itemCode: itemCode);
      //
      //   // 응답 결과 저장
      //   stats.addAll({
      //   itemCode: statModels,
      //   });
      // }

      // 모든 요청을 동시에 보내고 모든 응답이 다 돌아올 때 까지 await 하는 방법 (병렬로 처리)
      // 모든 요청을 가지고있는 리스트
      List<Future> futures = [];
      for (ItemCode itemCode in ItemCode.values) {
        // 리스트에 비동기로 처리하는 함수들을 넣음
        futures.add(
          StatRepository.fetchData(
            itemCode: itemCode,
          ),
        );
      }

      // 리스트 안에 있는 모든 작업이 끝날때까지 기다림 -> 끝난 순서대로 값들이 저장됨(== 리스트에 집어넣은 순서와 같음)
      final results = await Future.wait(futures);

      // 응답 결과 저장
      for (int i = 0; i < results.length; i++) {
        // ItemCode
        final key = ItemCode.values[i];
        // List<StatModel>
        final value = results[i];

        // 박스 가져오기
        final box = Hive.box<StatModel>(key.name);

        // 각 박스에 값 저장
        for (StatModel stat in value) {
          box.put(stat.dataTime.toString(), stat);
        }

        final allKeys = box.keys.toList();
        if (allKeys.length > 24) {
          final deleteKeys = allKeys.sublist(0, allKeys.length - 24);
          box.deleteAll(deleteKeys);
        }
      }
    } on DioException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '인터넷 연결이 원활하지 않습니다.',
          ),
        ),
      );
    }
  }

  scrollListener() {
    // scrollController.offset - 스크롤을 얼만큼 했는지 그 크기를 알수있음
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;

    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
      builder: (context, box, widget) {
        if(box.values.isEmpty){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // 가장 최근 통계의 미세먼지 범위 선택 알고리즘
        // 미세먼지 범위 1-5, 6-10, 11-15, 현재 미세먼지 7
        // 미세먼지 범위를 탐색하여 현재 미세먼지 값보다 작은 값 필터링 -> 1-5, 6-10
        // 그 중 가장 마지막 값 (큰 값) 가져오면 현재 미세먼지 범위에 맞는 범위 선택 가능 -> 6-10
        final recentStat = box.values.toList().last;
        final status = DataUtils.getStatusFromItemCodeAndValue(
          value: recentStat.getLevelFromRegion(region),
          itemCode: ItemCode.PM10,
        );

        return Scaffold(
          drawer: MainDrawer(
            lightColor: status.lightColor,
            darkColor: status.darkColor,
            selectedRegion: region,
            onRegionTap: (String region) {
              // 선택된 region으로 업데이트하고 Drawer를 닫음
              setState(() {
                this.region = region;
              });
              Navigator.of(context).pop();
            },
          ),
          body: Container(
            color: status.primaryColor,
            child: RefreshIndicator(
              onRefresh: () async {
                await fetchData();
              },
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  MainAppBar(
                    stat: recentStat,
                    status: status,
                    region: region,
                    dateTime: recentStat.dataTime,
                    isExpanded: isExpanded,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                          region: region,
                          darkColor: status.darkColor,
                          lightColor: status.lightColor,
                        ),
                        const SizedBox(height: 16.0),
                        ...ItemCode.values.map((itemCode) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: HourlyCard(
                              darkColor: status.darkColor,
                              lightColor: status.lightColor,
                              region: region,
                              itemCode: itemCode,
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
