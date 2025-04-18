import 'package:couple_calendar/ui/common/components/snack_bar/couple_noti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/components/logger/couple_logger.dart';
import '../model/schedule_model.dart';
import '../repository/schedule_repository.dart';

class ScheduleDetailViewModel extends ChangeNotifier {
  State state;

  late ScheduleModel schedule;

  bool _isReady = false;
  bool get isReady => _isReady;
  void setIsReady(bool flag) => _isReady = flag;

  Future<ScheduleModel?> _getMyScheduleById({
    required String scheduleId,
  }) async {
    final rawData =
        await ScheduleRepository().getScheduleDataById(id: scheduleId);

    if (rawData != null) {
      try {
        return ScheduleModel.fromJson(rawData);
      } catch (e, trace) {
        CoupleLog().e('error : $e');
        CoupleLog().e('$trace');
      }
    }
    return null;
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScheduleDetailViewModel(this.state, {required String scheduleId}) {
    _getMyScheduleById(scheduleId: scheduleId).then((schedule) {
      if (schedule == null) {
        CoupleNotification().notify(title: '일정을 찾을 수 없습니다.');
        state.context.pop();
        return;
      }

      this.schedule = schedule;
      setIsReady(true);
      notifyListeners();
    });
  }
}
