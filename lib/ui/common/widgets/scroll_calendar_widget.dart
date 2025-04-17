import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/custom_button/base_button.dart';
import '../components/date_picker_dialog/date_picker_dialog.dart';

class ScrollCalendarWidget extends StatefulWidget {
  final Function(DateTime)? onChanged;
  const ScrollCalendarWidget({
    super.key,
    this.onChanged,
  });

  @override
  State<ScrollCalendarWidget> createState() => _ScrollCalendarWidgetState();
}

class _ScrollCalendarWidgetState extends State<ScrollCalendarWidget> {
  late DateTime selectedDateTime;

  String get selectedDtString =>
      CoupleUtil().dateTimeToString(selectedDateTime, dayExclude: true);

  int daysCnt = 0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    selectedDateTime = DateTime.now();
    getCntDays(selectedDateTime.year, selectedDateTime.month);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: CoupleStyle.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSelectYearMonthButton(),
          SizedBox(height: 8.toHeight),
          _buildDateRow(),
        ],
      ),
    );
  }

  Widget _buildSelectYearMonthButton() {
    return BaseButton(
      onPressed: showDatePickerDialog,
      child: Container(
        margin: EdgeInsets.only(left: 16.toWidth),
        padding:
            EdgeInsets.symmetric(horizontal: 8.toWidth, vertical: 4.toHeight),
        decoration: BoxDecoration(
          border: Border.all(width: 1.toWidth, color: CoupleStyle.gray060),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          selectedDtString,
          style: CoupleStyle.body2(
            weight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDateRow() {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
        child: Row(
          children: List.generate(
            daysCnt,
            (index) {
              final day = index + 1;
              final isSelected = selectedDateTime.day == day;
              return _dayItem(
                day: day,
                isSelected: isSelected,
              );
            },
          )
              .superJoin(
                SizedBox(
                  width: 8.toWidth,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _dayItem({
    required int day,
    required bool isSelected,
  }) {
    final fillColor = isSelected ? CoupleStyle.primary050 : CoupleStyle.white;
    final textColor = isSelected ? CoupleStyle.white : CoupleStyle.gray090;
    return CupertinoButton(
      onPressed: () => onClickDayItem(day),
      padding: EdgeInsets.zero,
      minSize: 0,
      child: SizedBox(
        child: Column(
          children: [
            Text(
              CoupleUtil()
                  .dateTimeToDayOfWeek(selectedDateTime.copyWith(day: day)),
              style: CoupleStyle.caption(
                weight: FontWeight.w600,
                color: CoupleStyle.gray070,
              ),
            ),
            SizedBox(height: 4.toHeight),
            Container(
              width: 30.toWidth,
              height: 30.toWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fillColor,
              ),
              child: Center(
                child: Text(
                  '$day',
                  style: CoupleStyle.caption(
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showDatePickerDialog() async {
    var result = await showDialog<DateTime?>(
      context: context,
      builder: (context) {
        return CoupleDatePicker(
          title: '조회 날짜 선택',
          initDateTime: selectedDateTime,
        );
      },
    );

    if (result == null) return;

    setSelectedDateTime(result);

    getCntDays(result.year, result.month);

    setState(() {});
  }

  void setSelectedDateTime(DateTime dt) {
    selectedDateTime = dt;
    widget.onChanged?.call(dt);
  }

  void getCntDays(int year, int month) {
    DateTime firstDayThisMonth = DateTime(year, month, 1);
    DateTime firstDayNextMonth = DateTime(year, month + 1, 1);

    daysCnt = firstDayNextMonth.difference(firstDayThisMonth).inDays;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo((selectedDateTime.day - 1) * 30.toWidth);
    });
  }

  void onClickDayItem(int day) {
    final dt = DateTime(selectedDateTime.year, selectedDateTime.month, day);

    // DateTime nowDt = DateTime.now();
    // nowDt = DateTime(nowDt.year, nowDt.month, nowDt.day);

    // bool isBefore = nowDt.isBefore(dt) || nowDt.isAtSameMomentAs(dt);
    // if (isBefore) {

    // }
    setSelectedDateTime(dt);
    setState(() {});
  }
}
