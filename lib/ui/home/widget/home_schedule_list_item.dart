import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/schedule/model/schedule_model.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

import '../../../util/couple_style.dart';

class HomeScheduleListItem extends StatelessWidget {
  final ScheduleModel schedule;
  final double height;

  const HomeScheduleListItem({
    super.key,
    required this.schedule,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final scheduleState = CoupleUtil().getScheduleState(
        startDate: schedule.startDate, endDate: schedule.endDate);
    return GestureDetector(
      onTap: () =>
          CoupleRouter().loadScheduleDetail(context, scheduleId: schedule.id),
      child: Padding(
        padding: EdgeInsets.only(right: 16.toWidth, left: 24.toWidth),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: CoupleStyle.elevation_03dp(),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Container(
                  width: 6.toWidth,
                  color: schedule.theme.textColor,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.toWidth, vertical: 0.toHeight),
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
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.toHeight),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: SizedBox(
                                height: height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule.title,
                                      style: CoupleStyle.body2(
                                        color: schedule.theme.textColor,
                                        weight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                            ),
                          ),
                          if (scheduleState == ScheduleState.UP_COMING) ...{
                            Text(
                              '일정까지\n${CoupleUtil().getTimeStatus(startDate: schedule.startDate, endDate: schedule.endDate)}',
                              style: CoupleStyle.caption(
                                color: schedule.theme.textColor,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          } else ...{
                            Text(
                              '${scheduleState.title}',
                              style: CoupleStyle.caption(
                                color: schedule.theme.textColor,
                              ),
                            ),
                          },
                        ],
                      ),
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
}
