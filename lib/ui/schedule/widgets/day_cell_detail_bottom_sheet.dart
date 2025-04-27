import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/drag_to_dispose/drag_to_dispose.dart';
import 'package:couple_calendar/ui/schedule/model/schedule_model.dart';
import 'package:couple_calendar/ui/schedule/widgets/schedule_list_item.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
  }

  @override
  void didUpdateWidget(covariant DayCellDetailBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return DragToDispose(
      onPageClosed: () => context.pop(),
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
                      children: widget.scheduleList
                          .map((e) => ScheduleListItem(schedule: e) as Widget)
                          .superJoin(SizedBox(height: 8.toHeight))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10.toWidth),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                  child: CoupleButton(
                    onPressed: () {
                      CoupleRouter().loadScheduleForm(
                        context,
                        date: widget.date,
                      );
                    },
                    option: CoupleButtonOption.fill(
                      text: tr('add_schedule_btn_txt'),
                      theme: CoupleButtonFillTheme.lightMagenta,
                      style: CoupleButtonFillStyle.fullRegular,
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
      return tr('today_txt');
    } else if (diff > 0) {
      return 'D + $diff';
    }
    return 'D - ${diff.abs()}';
  }
}
