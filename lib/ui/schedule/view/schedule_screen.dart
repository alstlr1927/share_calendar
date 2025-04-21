import 'package:couple_calendar/ui/common/provider/schedule_provider.dart';
import 'package:couple_calendar/ui/schedule/view_model/schedule_view_model.dart';
import 'package:couple_calendar/ui/schedule/widgets/calendar_month_widget.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late ScheduleViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ScheduleViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScheduleViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return Consumer<ScheduleProvider>(
          builder: (_, prov, __) {
            return Container(
              color: CoupleStyle.gray030,
              child: SafeArea(
                top: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    Expanded(
                      child: PageView.builder(
                        controller: viewModel.pageController,
                        itemBuilder: (context, index) {
                          int year = 1970 + (index ~/ 12); // 1970년을 기준으로 연도 계산
                          int month = (index % 12) + 1; // 1월 ~ 12월 반복
                          final key = '$year' + ('$month').padLeft(2, '0');
                          final scheduleList = prov.scheduleData[key] ?? [];

                          return CalendarMonthWidget(
                            year: year,
                            month: month,
                            scheduleList: scheduleList,
                            onPressedDay: ({
                              required date,
                              required type,
                            }) =>
                                viewModel.onClickDayCell(
                              date: date,
                              index: index,
                              type: type,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTitle() {
    return Selector<ScheduleViewModel, Tuple2<int, int>>(
      selector: (_, vm) => Tuple2(vm.curYear, vm.curMonth),
      builder: (_, tuple, __) {
        final year = tuple.item1;
        final month = tuple.item2;

        final isThisYear = year == DateTime.now().year;
        final text = isThisYear ? '$month월' : '$year년 $month월';
        return Padding(
          padding: EdgeInsets.only(left: 22.toWidth),
          child: Text(
            text,
            style: CoupleStyle.h3(
              color: CoupleStyle.gray090,
              weight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }
}
