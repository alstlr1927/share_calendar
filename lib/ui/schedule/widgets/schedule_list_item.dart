import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/schedule/model/schedule_model.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

import '../../../util/couple_style.dart';

class ScheduleListItem extends StatelessWidget {
  final ScheduleModel schedule;

  const ScheduleListItem({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          CoupleRouter().loadScheduleDetail(context, scheduleId: schedule.id),
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
                    constraints: BoxConstraints(
                      maxHeight: 100.toHeight,
                    ),
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
                    child: Row(
                      children: [
                        Expanded(
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
                              Expanded(
                                child: Text(
                                  schedule.content,
                                  style: CoupleStyle.caption(
                                    color: schedule.theme.textColor,
                                    weight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            _timeBox(time: schedule.startDate),
                            Expanded(
                              child: Container(
                                width: 2.toWidth,
                                color: schedule.theme.textColor.withOpacity(.6),
                              ),
                            ),
                            // Expanded(
                            //   child: Icon(
                            //     Icons.keyboard_arrow_down_outlined,
                            //     color: schedule.theme.textColor,
                            //   ),
                            // ),
                            _timeBox(time: schedule.endDate),
                          ],
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
    );
  }

  Widget _timeBox({
    required DateTime time,
  }) {
    final theme = schedule.theme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.toWidth, vertical: 2.toWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: theme.textColor.withOpacity(.6),
        boxShadow: CoupleStyle.elevation_01dp(),
      ),
      child: Center(
        child: Text(
          CoupleUtil().hourToString(
            time,
          ),
          style: CoupleStyle.overline(
            color: CoupleStyle.white,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
