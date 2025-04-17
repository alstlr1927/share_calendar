import 'package:couple_calendar/ui/my_schedule/widgets/day_cell_detail_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_util.dart';
import '../../common/provider/schedule_provider.dart';
import '../widgets/calendar_month_widget.dart';

class ScheduleViewModel extends ChangeNotifier {
  static const int _baseYear = 1970;
  State state;

  final PageController pageController = PageController();

  int _curYear = DateTime.now().year;
  int get curYear => _curYear;
  void setCurYear(int year) => _curYear = year;

  int _curMonth = DateTime.now().month;
  int get curMonth => _curMonth;
  void setCurMonth(int month) => _curMonth = month;

  ScheduleViewModel(this.state) {
    _initState();
    Provider.of<ScheduleProvider>(state.context, listen: false)
        .getMySchedule(year: curYear);
  }

  Future<void> onClickDayCell({
    required DateTime date,
    required int index,
    required MonthType type,
  }) async {
    switch (type) {
      case MonthType.CURRENT:
        _showDayCellBottomSheet(date, index);
        break;
      case MonthType.PREV:
        await pageController.previousPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
        break;
      case MonthType.NEXT:
        await pageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
        break;
    }
  }

  Future<void> _showDayCellBottomSheet(DateTime date, int index) async {
    final int year = _baseYear + (index ~/ 12);
    final int month = (index % 12) + 1;
    final String key = '$year${month.toString().padLeft(2, '0')}';
    final targetDateStr =
        CoupleUtil().dateTimeToString(DateTime(year, month, date.day));

    await showModalBottomSheet(
      context: state.context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer<ScheduleProvider>(
          builder: (_, prov, __) {
            final scheduleList = prov.scheduleData[key] ?? [];

            final list = scheduleList.where((e) {
              return CoupleUtil().dateTimeToString(e.startDate) ==
                  targetDateStr;
            }).toList();

            return DayCellDetailBottomSheet(
              date: date,
              scheduleList: list,
            );
          },
        );
      },
    );
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    if (pageController.hasListeners) {
      pageController.removeListener(pageListener);
    }
    pageController.dispose();
    super.dispose();
  }

  void _initState() {
    final now = DateTime.now();

    final initPage =
        (now.year - _baseYear) * DateTime.monthsPerYear + (now.month - 1);

    setCurYear(now.year);
    setCurMonth(now.month);
    pageController.addListener(pageListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(initPage);
    });
  }

  void pageListener() {
    final int page = pageController.page!.toInt();
    final int year = _baseYear + (page ~/ 12);
    final int month = (page % 12) + 1;

    final bool shouldFetch = year != _curYear;

    setCurYear(year);
    setCurMonth(month);
    notifyListeners();

    if (shouldFetch) {
      Provider.of<ScheduleProvider>(state.context, listen: false)
          .getMySchedule(year: _curYear);
    }
  }
}
