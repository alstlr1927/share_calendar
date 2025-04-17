import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

import '../../../util/couple_style.dart';
import '../../common/components/custom_button/base_button.dart';
import '../model/schedule_model.dart';

typedef OnClickMonthCell = void Function(
    {required DateTime date,
    required List<ScheduleModel> scheduleList,
    required MonthType type});

enum MonthType {
  PREV,
  CURRENT,
  NEXT;
}

class CalendarMonthWidget extends StatefulWidget {
  final int year;
  final int month;
  final List<ScheduleModel> scheduleList;
  final OnClickMonthCell? onPressedDay;

  const CalendarMonthWidget({
    super.key,
    required this.year,
    required this.month,
    required this.scheduleList,
    this.onPressedDay,
  });

  @override
  State<CalendarMonthWidget> createState() => _CalendarMonthWidgetState();
}

class _CalendarMonthWidgetState extends State<CalendarMonthWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.toWidth),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCalendar(widget.year, widget.month),
                      SizedBox(height: CoupleStyle.bottomActionHeight),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    List<Widget> items = [];

    List<String> weekdays = ["일", "월", "화", "수", "목", "금", "토"];
    for (var day in weekdays) {
      items.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(4),
        child: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
      ));
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7, // 7열 (일~토)
      shrinkWrap: true,
      children: items,
    );
  }

  Widget _buildCalendar(int year, int month) {
    int lastDay = DateTime(year, month + 1, 0).day;
    int startWeekday = DateTime(year, month, 1).weekday;
    int prevMonthLastDay = DateTime(year, month, 0).day;

    List<Widget> rows = [];
    List<_MonthDayCell> week = [];

    // 이전 달
    int prevMonthDays = startWeekday % 7;
    for (int i = prevMonthDays; i > 0; i--) {
      final DateTime dt = DateTime(
        month == 1 ? year - 1 : year,
        month == 1 ? 12 : month - 1,
        prevMonthLastDay - i + 1,
      );

      week.add(
        _MonthDayCell(
          dt: dt,
          textColor: CoupleStyle.gray060,
          onPressed: () => widget.onPressedDay?.call(
            date: dt,
            scheduleList: [],
            type: MonthType.PREV,
          ),
        ),
      );
    }

    // 현재 달
    for (int day = 1; day <= lastDay; day++) {
      final now = DateTime.now();
      final targetDt = DateTime(year, month, day);
      final list = widget.scheduleList.where((e) {
        final data = CoupleUtil().dateTimeToString(e.startDate);
        final target = CoupleUtil().dateTimeToString(targetDt);
        return data == target;
      }).toList();
      Color textColor = week.length == 0 || week.length == 6
          ? CoupleStyle.primary050
          : CoupleStyle.gray090;

      if (day == now.day && month == now.month && year == now.year) {
        textColor = CoupleStyle.white;
      }

      week.add(
        _MonthDayCell(
          dt: targetDt,
          textColor: textColor,
          scheduleList: list,
          onPressed: () => widget.onPressedDay?.call(
            date: targetDt,
            scheduleList: list,
            type: MonthType.CURRENT,
          ),
        ),
      );

      // 한 주가 끝나면 Row 추가
      if (week.length == 7) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: week,
          ),
        );
        week = [];
      }
    }

    // **다음 달 날짜 추가 (빈 칸 채우기
    int remainingCells = (7 - week.length) % 7;
    for (int i = 1; i <= remainingCells; i++) {
      final dt = DateTime(
        month == 12 ? year + 1 : year,
        month == 12 ? 1 : month + 1,
        i,
      );

      week.add(
        _MonthDayCell(
          dt: dt,
          textColor: CoupleStyle.gray060,
          onPressed: () => widget.onPressedDay?.call(
            date: dt,
            scheduleList: [],
            type: MonthType.NEXT,
          ),
        ),
      );
    }

    // 마지막 주 추가
    if (week.isNotEmpty) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: week,
        ),
      );
    }

    return Column(
      children: rows.superJoin(SizedBox(height: 10.toHeight)).toList(),
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  final DateTime dt;
  final Color textColor;
  final List<ScheduleModel> scheduleList;
  // final MonthType type;
  // final OnClickMonthCell onPressed;
  final Function() onPressed;

  const _MonthDayCell({
    Key? key,
    required this.dt,
    required this.textColor,
    this.scheduleList = const [],
    required this.onPressed,
    // required this.type,
    // required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nowDt = DateTime.now();
    final isNow =
        dt.year == nowDt.year && dt.month == nowDt.month && dt.day == nowDt.day;

    return Flexible(
      child: BaseButton(
        onPressed: onPressed.call,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 80.toHeight,
          ),
          padding: EdgeInsets.all(4.toWidth),
          decoration: BoxDecoration(
            color: CoupleStyle.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(4.toWidth),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isNow ? CoupleStyle.subBlue : CoupleStyle.white,
                ),
                child: Text(
                  '${dt.day}',
                  style: CoupleStyle.body2(
                    color: textColor,
                  ),
                ),
              ),
              ...scheduleList
                  .map((e) => _buildCellScheduleItem(e))
                  .superJoin(SizedBox(height: 3.toHeight))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCellScheduleItem(ScheduleModel schedule) {
    return Container(
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 2.toWidth,
              color: schedule.theme.textColor,
            ),
            Expanded(
              child: Container(
                color: schedule.theme.backColor,
                padding: EdgeInsets.only(left: 3.toWidth),
                child: Text(
                  schedule.title,
                  style: CoupleStyle.overline(color: schedule.theme.textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
