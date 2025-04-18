import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
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
      onTap: () => CoupleRouter().loadScheduleForm(
        context,
        scheduleId: schedule.id,
        date: schedule.startDate,
      ),
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
                          schedule.content,
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
    );
  }
}
