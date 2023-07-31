import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constant/colors.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final OnDaySelected? onDaySelected;

  const Calendar({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 날짜 박스 스타일
    final defaultBoxDeco = BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      color: Colors.grey[200],
    );

    // 기본 날짜 텍스트 스타일
    final defaultTextStyle = TextStyle(
      color: Colors.grey[600],
      fontWeight: FontWeight.w700,
    );

    return TableCalendar(
      // 언어 설정
      locale: 'ko_KR',

      // 화면에 몇월을 보여줄지 결정하게 되는 날짜 (7/23 -> 7월)
      focusedDay: focusedDay,

      // 날짜 최솟값
      firstDay: DateTime(1800),
      // 날짜 최댓값
      lastDay: DateTime(3000),

      // 헤더 스타일 설정
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        // 제목 정렬
        titleCentered: true,
        // 제목 텍스트 스타일
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),

      // 캘린더 스타일 설정
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,

        // 평일 날짜 박스 스타일 설정
        defaultDecoration: defaultBoxDeco,

        // 주말 날짜 박스 스타일 설정
        weekendDecoration: defaultBoxDeco,

        // 선택된 날짜 박스 스타일 설정
        selectedDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),

        // 해당하는 월 외의 날짜 스타일 설정
        outsideDecoration: const BoxDecoration(
          shape: BoxShape.rectangle,
        ),

        // 평일 날짜 텍스트 스타일 설정
        defaultTextStyle: defaultTextStyle,

        // 주말 날짜 텍스트 스타일 설정
        weekendTextStyle: defaultTextStyle,

        // 선택된 날짜 텍스트 스타일 설정
        selectedTextStyle: defaultTextStyle.copyWith(
          color: PRIMARY_COLOR,
        ),
      ),

      // 날짜가 선택되었을 때 콜백 함수
      onDaySelected: onDaySelected,

      // 화면에 보이는 날짜가 선택되었는지 확인하는 함수
      selectedDayPredicate: (DateTime date) {
        // 선택된 날짜가 없을 경우 -> false
        if (selectedDay == null) {
          return false;
        }

        // 선택된 날짜가 있을 경우 -> 선택된 날짜와 화면에 보이는 날짜가 같은지 확인
        return date.year == selectedDay.year &&
            date.month == selectedDay.month &&
            date.day == selectedDay.day;
      },
    );
  }
}
