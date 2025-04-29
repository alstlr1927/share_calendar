import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:couple_calendar/ui/schedule/model/schedule_model.dart';
import 'package:couple_calendar/ui/schedule/repository/schedule_repository.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  Map<String, Map<String, List<ScheduleModel>>> scheduleDataV2 = {};

  Future<void> getMySchedule({
    required int year,
    bool isRefresh = true,
  }) async {
    CoupleLog().d('Get $year Schedule Data');
    // refresh일때만 데이터 clear
    if (isRefresh) {
      scheduleDataV2 = Map.from({});
    }

    if (scheduleDataV2.containsKey('$year')) {
      CoupleLog().d('$year data is already exist');
      return;
    }

    final docs = await ScheduleRepository().getMyScheduleByYear(year: year);

    if (docs.isNotEmpty) {
      final list = docs.map((e) => ScheduleModel.fromJson(e.data())).toList();

      for (var item in list) {
        final yearKey = item.startDate.year.toString();
        final monthKey = item.startDate.month.toString().padLeft(2, '0');

        if (!scheduleDataV2.containsKey(yearKey)) {
          scheduleDataV2[yearKey] = {};
        }
        final oldV2 = scheduleDataV2[yearKey]![monthKey] ?? <ScheduleModel>[];
        scheduleDataV2[yearKey]![monthKey] = [...oldV2, item];
      }

      CoupleLog().d('scheduleDataV2 : ${scheduleDataV2}');
    }
    notifyListeners();
  }
}
