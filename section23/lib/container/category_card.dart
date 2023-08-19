import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:section23/component/card_title.dart';
import 'package:section23/component/main_card.dart';
import 'package:section23/model/stat_model.dart';

import '../utils/data_utils.dart';
import '../component/main_stat.dart';

// 메인화면 - 종류별 통계
class CategoryCard extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final String region;

  const CategoryCard(
      {super.key,
      required this.region,
      required this.darkColor,
      required this.lightColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: MainCard(
        backgroundColor: lightColor,
        // Tip. ListView의 아이템들을 n개의 개수로 제한하여 정확히 나누고 싶을 경우
        // -> 1. Scroll가능한 위젯의 부모 위젯을 LayoutBuilder로 감싼다.
        // -> 2. constraint 속성을 사용하여 maxWidth/maxHeight를 n개로 나누어 아이템에 전달한다.
        child: LayoutBuilder(builder: (context, constraint) {
          // constraint -  LayoutBuilder가 차지하고 있는 공간을 기준으로 사이즈를 알 수 있음
          // constraint.maxHeight
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(
                title: '종류별 통계',
                backgroundColor: darkColor,
              ),
              Expanded(
                child: ListView(
                  // 스크롤 방향
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  children: ItemCode.values
                      .map((ItemCode itemCode) => ValueListenableBuilder<Box>(
                            valueListenable:
                                Hive.box<StatModel>(itemCode.name).listenable(),
                            builder: (context, box, widget) {
                              final stat = (box.values.last as StatModel);
                              final status =
                                  DataUtils.getStatusFromItemCodeAndValue(
                                value: stat.getLevelFromRegion(region),
                                itemCode: itemCode,
                              );

                              return MainStat(
                                category: DataUtils.getitemCodeKrString(
                                  itemCode: itemCode,
                                ),
                                imgPath: status.imagePath,
                                level: status.label,
                                stat: '${stat.getLevelFromRegion(
                                  region,
                                )}${DataUtils.getUnitFromDataType(
                                  itemCode: itemCode,
                                )}',
                                width: constraint.maxWidth / 3,
                              );
                            },
                          ))
                      .toList(),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
