import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../util/couple_style.dart';
import '../custom_button/couple_button.dart';

enum DateDialogContent {
  YEAR,
  MONTH,
  DAY;
}

class CoupleDatePicker extends StatefulWidget {
  final DateTime initDateTime;
  final List<DateDialogContent> contents;

  /// 미래 날짜는 허용하지 않기위함. 년도는 고르지 않을떄에만 유효함.
  // final bool denyLastYearDateWhenSelectWithOutYear;

  const CoupleDatePicker({
    super.key,
    required this.initDateTime,
    this.contents = const [DateDialogContent.YEAR, DateDialogContent.MONTH],
    // this.denyLastYearDateWhenSelectWithOutYear = true,
  });

  @override
  State<CoupleDatePicker> createState() => _CoupleDatePickerState();
}

class _CoupleDatePickerState extends State<CoupleDatePicker> {
  int year = 2022;
  int month = 1;
  int day = 1;

  int maxDay = 30;

  int getMaxDay() {
    DateTime firstDayOfNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }

  void setYear(int year) {
    this.year = year;
    setState(() {});
  }

  void setMonth(int month) {
    this.month = month;
  }

  void setDay(int day) {
    this.day = day;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initSetting();
  }

  void _initSetting() {
    year = widget.initDateTime.year;
    month = widget.initDateTime.month;
    day = widget.initDateTime.day;

    maxDay = getMaxDay();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CoupleStyle.white,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 2.toHeight,
            ),
            Container(
              height: 127.toHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.contents.contains(DateDialogContent.YEAR)) ...{
                        Flexible(
                          child: NumberPicker(
                            itemHeight: 37.toHeight,
                            minValue: 2000,
                            maxValue: 2099,
                            value: year,
                            haptics: true,
                            selectedTextStyle: CoupleStyle.h3(
                              weight: FontWeight.w500,
                            ),
                            textStyle: CoupleStyle.h4(
                              color: CoupleStyle.gray080,
                            ),
                            onChanged: setYear,
                            textMapper: (numberText) => '$numberText',
                          ),
                        ),
                        SizedBox(width: 16.toWidth),
                      },
                      if (widget.contents
                          .contains(DateDialogContent.MONTH)) ...{
                        Flexible(
                          child: NumberPicker(
                            itemHeight: 37.toHeight,
                            minValue: 1,
                            maxValue: 12,
                            value: month,
                            haptics: true,
                            infiniteLoop: true,
                            selectedTextStyle: CoupleStyle.h3(
                              weight: FontWeight.w500,
                            ),
                            textStyle: CoupleStyle.h4(
                              color: CoupleStyle.gray080,
                            ),
                            onChanged: (val) async {
                              // TODO 어색 하지 않으려면
                              // TODO throttle 같은걸 사용해서 마지막으로 호출되는 함수 만 실행되게 해야할듯

                              setMonth(val);
                              maxDay = getMaxDay();
                              if (day > maxDay) {
                                setDay(maxDay);
                              }
                              setState(() {});
                            },
                            textMapper: (numberText) => '$numberText월',
                          ),
                        ),
                        SizedBox(width: 16.toWidth),
                      },
                      if (widget.contents.contains(DateDialogContent.DAY)) ...{
                        Flexible(
                          child: NumberPicker(
                            itemHeight: 37.toHeight,
                            minValue: 1,
                            maxValue: maxDay,
                            value: day,
                            haptics: true,
                            infiniteLoop: true,
                            selectedTextStyle: CoupleStyle.h3(
                              weight: FontWeight.w500,
                            ),
                            textStyle: CoupleStyle.h4(
                              color: CoupleStyle.gray080,
                            ),
                            onChanged: setDay,
                            textMapper: (numberText) => '$numberText일',
                          ),
                        ),
                      },
                    ],
                  ),
                  IgnorePointer(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.infinity,
                        height: 50.toHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              CoupleStyle.white,
                              CoupleStyle.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 50.toHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              CoupleStyle.white.withOpacity(0),
                              CoupleStyle.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.toHeight),
            Row(
              children: [
                Flexible(
                  child: CoupleButton(
                    onPressed: context.pop,
                    option: CoupleButtonOption.fill(
                      text: tr('cancel_btn_txt'),
                      theme: CoupleButtonFillTheme.gray,
                      style: CoupleButtonFillStyle.fullRegular,
                    ),
                  ),
                ),
                SizedBox(width: 8.toWidth),
                Builder(
                  builder: (context) {
                    late DateTime selectDt;
                    if (widget.contents.contains(DateDialogContent.DAY)) {
                      selectDt = DateTime(year, month, day);
                    } else {
                      selectDt = DateTime(year, month, 1);
                    }
                    return Flexible(
                      child: CoupleButton(
                        onPressed: () => context.pop<DateTime>(selectDt),
                        option: CoupleButtonOption.fill(
                          text: tr('apply_btn_txt'),
                          theme: CoupleButtonFillTheme.magenta,
                          style: CoupleButtonFillStyle.fullRegular,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16.toHeight),
          ],
        ),
      ),
    );
  }
}
