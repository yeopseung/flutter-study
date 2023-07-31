import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:section21/component/calendar.dart';
import 'package:section21/component/schedule_bottom_sheet.dart';
import 'package:section21/component/schedule_card.dart';
import 'package:section21/component/today_banner.dart';
import 'package:section21/constant/colors.dart';
import 'package:section21/model/schedule_with_color.dart';

import '../database/drift_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 시간 기준은 UTC 기준
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8.0),
            TodayBanner(
              selectedDay: selectedDay,
            ),
            const SizedBox(height: 8.0),
            _ScheduleList(
              selectedDay: selectedDay,
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          // showModalBottomSheet를 통해 볼 수 있는 bottomsheet의 최대 크기는 화면의 절반
          // isScrollControlled를 true로 하면 변경 가능
          isScrollControlled: true,
          builder: (_) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          },
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: const Icon(Icons.add),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      focusedDay = selectedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDay;

  const _ScheduleList({required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<ScheduleWithColor>>(
            stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('스케줄이 없습니다.'),
                );
              }

              return ListView.separated(
                // 리스트 추가할 아이템 개수
                // 전체 개수를 부분적으로 보여준다 (100개를 10개씩 나눠서)
                itemCount: snapshot.data!.length,

                // 아이템 하나에 아이템빌더 한번 실행
                // context와 아이템 순서를 나타내는 index 전달
                itemBuilder: (context, index) {
                  final scheduleWithColor = snapshot.data![index];
                  // 순서에 해당하는 아이템 설정 가능

                  // 스와이프 삭제 이벤트 설정하는 위젯
                  return Dismissible(
                    // 삭제할 아이템 키
                    key: ObjectKey(scheduleWithColor.schedule.id),
                    // 삭제 이벤트 방향
                    direction: DismissDirection.endToStart,
                    // 삭제시 콜백 함수
                    onDismissed: (DismissDirection direction) {
                      GetIt.I<LocalDatabase>()
                          .removeSchedule(scheduleWithColor.schedule.id);
                    },

                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          // showModalBottomSheet를 통해 볼 수 있는 bottomsheet의 최대 크기는 화면의 절반
                          // isScrollControlled를 true로 하면 변경 가능
                          isScrollControlled: true,
                          builder: (_) {
                            return ScheduleBottomSheet(
                              selectedDate: selectedDay,
                              scheduleId: scheduleWithColor.schedule.id,
                            );
                          },
                        );
                      },
                      child: ScheduleCard(
                        startTime: scheduleWithColor.schedule.startTime,
                        endTime: scheduleWithColor.schedule.endTime,
                        content: scheduleWithColor.schedule.content,
                        color: Color(int.parse(
                            'FF${scheduleWithColor.categoryColor.hexCode}',
                            radix: 16)),
                      ),
                    ),
                  );
                },

                // 아이템 빌더 실행 후 실행
                // 아이템 사이의 공간 정의
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8.0,
                  );
                },
              );
            }),
      ),
    );
  }
}
