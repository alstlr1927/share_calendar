import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../util/couple_style.dart';
import '../custom_button/couple_button.dart';

class CoupleTimePicker extends StatefulWidget {
  final DateTime initTime;

  const CoupleTimePicker({
    super.key,
    required this.initTime,
  });

  @override
  State<CoupleTimePicker> createState() => _CoupleTimePickerState();
}

class _CoupleTimePickerState extends State<CoupleTimePicker> {
  int _hour = 1;
  int _min = 1;

  void setHour(int idx) {
    _hour = idx;
    setState(() {});
  }

  void setMin(int idx) {
    _min = idx;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    debugPrint('${widget.initTime.hour}');
    _initSetting();
  }

  void _initSetting() {
    _hour = widget.initTime.hour;
    _min = widget.initTime.minute;
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
                      Flexible(
                        child: NumberPicker(
                          itemHeight: 37.toHeight,
                          minValue: 0,
                          maxValue: 23,
                          value: _hour,
                          haptics: true,
                          infiniteLoop: true,
                          selectedTextStyle: CoupleStyle.h3(
                            weight: FontWeight.w500,
                          ),
                          textStyle: CoupleStyle.h4(
                            color: CoupleStyle.gray080,
                          ),
                          textMapper: (numberText) => '$numberText',
                          onChanged: setHour,
                        ),
                      ),
                      Container(
                        width: 16.toWidth,
                        alignment: Alignment.center,
                        child: Text(
                          ':',
                          style: CoupleStyle.h3(),
                        ),
                      ),
                      Flexible(
                        child: NumberPicker(
                          itemHeight: 37.toHeight,
                          minValue: 0,
                          maxValue: 59,
                          value: _min,
                          haptics: true,
                          infiniteLoop: true,
                          selectedTextStyle: CoupleStyle.h3(
                            weight: FontWeight.w500,
                          ),
                          textStyle: CoupleStyle.h4(
                            color: CoupleStyle.gray080,
                          ),
                          onChanged: setMin,
                        ),
                      ),
                      SizedBox(width: 16.toWidth),
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
                      text: '취소',
                      theme: CoupleButtonFillTheme.gray,
                      style: CoupleButtonFillStyle.fullRegular,
                    ),
                  ),
                ),
                SizedBox(width: 8.toWidth),
                Flexible(
                  child: CoupleButton(
                    onPressed: () => context.pop(
                        widget.initTime.copyWith(hour: _hour, minute: _min)),
                    option: CoupleButtonOption.fill(
                      text: '적용',
                      theme: CoupleButtonFillTheme.magenta,
                      style: CoupleButtonFillStyle.fullRegular,
                    ),
                  ),
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
