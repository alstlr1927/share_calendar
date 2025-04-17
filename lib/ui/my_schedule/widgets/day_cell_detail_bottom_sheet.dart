import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/drag_to_dispose/drag_to_dispose.dart';
import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DayCellDetailBottomSheet extends StatefulWidget {
  final DateTime date;
  final List<ScheduleModel> scheduleList;

  const DayCellDetailBottomSheet({
    super.key,
    required this.date,
    this.scheduleList = const [],
  });

  @override
  State<DayCellDetailBottomSheet> createState() =>
      _DayCellDetailBottomSheetState();
}

class _DayCellDetailBottomSheetState extends State<DayCellDetailBottomSheet> {
  @override
  void initState() {
    super.initState();
    debugPrint('scheduleList : ${widget.scheduleList}');
    debugPrint('date : ${widget.date}');
  }

  @override
  Widget build(BuildContext context) {
    return DragToDispose(
      onPageClosed: () {
        debugPrint('onPageClosed');
        context.pop();
      },
      maxHeight: ScreenUtil().screenHeight * .85,
      dragEnable: true,
      backdropTapClosesPanel: true,
      panelBuilder: (scrollController, ac) {
        return Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: CoupleStyle.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                SizedBox(height: 8.toHeight),
                Container(
                  width: 80.toWidth,
                  height: 6,
                  decoration: BoxDecoration(
                    color: CoupleStyle.gray050,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                _buildTitle(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        ...widget.scheduleList
                            .map((e) => _buildScheduleItem(e))
                            .superJoin(SizedBox(height: 8.toHeight))
                            .toList(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                  child: CoupleButton(
                    onPressed: () => CoupleRouter().loadScheduleForm(
                      context,
                      date: widget.date,
                    ),
                    option: CoupleButtonOption.fill(
                      text: '+ 할일을 추가 해보세요.',
                      theme: CoupleButtonFillTheme.lightMagenta,
                      style: CoupleButtonFillStyle.fullSmall,
                    ),
                  ),
                ),
                SizedBox(height: CoupleStyle.defaultBottomPadding()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleItem(ScheduleModel schedule) {
    return GestureDetector(
      onTap: () => CoupleRouter().loadScheduleForm(
        context,
        scheduleId: schedule.id,
        date: widget.date,
      ),
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 6.toWidth,
                    color: schedule.theme.textColor,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.toWidth, vertical: 8.toHeight),
                      decoration: BoxDecoration(
                        color: schedule.theme.backColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        border: Border(
                          right: BorderSide(color: schedule.theme.textColor),
                          top: BorderSide(color: schedule.theme.textColor),
                          bottom: BorderSide(color: schedule.theme.textColor),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            schedule.title,
                            style: CoupleStyle.body2(
                              color: schedule.theme.textColor,
                              weight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.toHeight),
                          Text(
                            schedule.type,
                            style: CoupleStyle.caption(
                              color: schedule.theme.textColor,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final dateText = DateFormat('M월 d일').format(widget.date);
    final dayKor = DateFormat.E('ko').format(widget.date);
    final nowDt =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final diff = nowDt.difference(widget.date).inDays;

    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: 16.toWidth, vertical: 16.toWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateText + ' ($dayKor)',
            style: CoupleStyle.body1(
              weight: FontWeight.w600,
            ),
          ),
          Text(
            getDdayText(diff),
            style: CoupleStyle.caption(),
          ),
        ],
      ),
    );
  }

  String getDdayText(int diff) {
    if (diff == 0) {
      return '오늘';
    } else if (diff > 0) {
      return 'D + $diff';
    }
    return 'D - ${diff.abs()}';
  }
}
