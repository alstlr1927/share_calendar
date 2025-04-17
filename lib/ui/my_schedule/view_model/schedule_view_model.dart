import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
import 'package:couple_calendar/ui/my_schedule/widgets/day_cell_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/provider/schedule_provider.dart';
import '../widgets/calendar_month_widget.dart';

class ScheduleViewModel extends ChangeNotifier {
  State state;

  final PageController pageController = PageController();

  int _curYear = 2025;
  int get curYear => _curYear;
  void setCurYear(int year) {
    _curYear = year;
  }

  int _curMonth = 3;
  int get curMonth => _curMonth;
  void setCurMonth(int month) {
    _curMonth = month;
  }

  Future<void> onClickDayCell({
    required DateTime date,
    required List<ScheduleModel> scheduleList,
    required MonthType type,
  }) async {
    switch (type) {
      case MonthType.CURRENT:
        showModalBottomSheet(
          context: state.context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return DayCellDetailBottomSheet(
              date: date,
              scheduleList: scheduleList,
            );
          },
        );
        break;
      case MonthType.PREV:
        pageController.previousPage(
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
        break;
      case MonthType.NEXT:
        pageController.nextPage(
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
        break;
    }
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.removeListener(pageListener);
    pageController.dispose();
    super.dispose();
  }

  ScheduleViewModel(this.state) {
    Provider.of<ScheduleProvider>(state.context, listen: false)
        .getMySchedule(year: curYear);
    _initState();
  }

  void _initState() {
    DateTime now = DateTime.now();

    final initYear = now.year;
    final initMonth = now.month;
    final initPage =
        (initYear - 1970) * DateTime.monthsPerYear + (initMonth - 1);

    setCurYear(initYear);
    setCurMonth(initMonth);
    pageController.addListener(pageListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(initPage);
    });
  }

  void pageListener() {
    int page = pageController.page!.toInt();
    int year = 1970 + (page ~/ 12);
    int month = (page % 12) + 1;
    bool getDataFlag = year != curYear;

    setCurYear(year);
    setCurMonth(month);
    notifyListeners();

    if (getDataFlag) {
      Provider.of<ScheduleProvider>(state.context, listen: false)
          .getMySchedule(year: curYear);
    }
  }
}
