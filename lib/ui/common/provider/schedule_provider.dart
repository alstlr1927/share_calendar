import 'package:couple_calendar/ui/schedule/model/schedule_model.dart';
import 'package:couple_calendar/ui/schedule/repository/schedule_repository.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  //
  Map<String, List<ScheduleModel>> scheduleData = {};

  Future<void> getMySchedule({
    required int year,
  }) async {
    debugPrint('get data : $year');

    final docs = await ScheduleRepository().getMyScheduleByYear(year: year);
    scheduleData = {};
    if (docs.isNotEmpty) {
      final list = docs.map((e) => ScheduleModel.fromJson(e.data())).toList();

      for (var item in list) {
        final key = CoupleUtil()
            .dateTimeToString(item.startDate, division: '', dayExclude: true);

        final old = scheduleData[key] ?? <ScheduleModel>[];
        scheduleData[key] = [...old, item];
      }

      debugPrint('scheduleData : ${scheduleData}');
    }
    notifyListeners();
  }
}
