import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/common/components/bottom_sheet/bottom_sheet_picker.dart';
import 'package:couple_calendar/ui/common/components/bottom_sheet/show_modal_sheet.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/dialog/couple_text_dialog.dart';
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

  Future<void> onClickMoreBtn() async {
    await showModalPopUp(
      context: state.context,
      builder: (context) => BottomSheetPicker(
        actions: [
          BottomSheetItem(
            title: '수정',
            onPressed: onClickModifyBtn,
          ),
          BottomSheetItem(
            title: '삭제',
            cautionFlag: true,
            onPressed: onClickDeleteBtn,
          ),
        ],
        cancelItem: BottomSheetItem(title: '취소'),
      ),
    );
  }

  Future<void> onClickModifyBtn() async {
    await CoupleRouter().loadScheduleForm(
      state.context,
      scheduleId: schedule.id,
      date: schedule.startDate,
    );
  }

  Future<void> onClickDeleteBtn() async {
    showDialog(
      context: state.context,
      builder: (context) => CoupleDialog(
        option: CoupleDialogOption.normal(
          header: DialogHeader(text: '일정 삭제'),
          body: DialogBody(text: '복구되지 않습니다.\n삭제하시겠습니까?'),
          actions: [
            DialogAction(
              onPressed: () {},
              buttonOption: CoupleButtonOption.fill(
                text: '삭제',
                theme: CoupleButtonFillTheme.lightMagenta,
                style: CoupleButtonFillStyle.fullRegular,
              ),
            ),
            DialogAction(
              onPressed: context.pop,
              buttonOption: CoupleButtonOption.fill(
                text: '취소',
                theme: CoupleButtonFillTheme.gray,
                style: CoupleButtonFillStyle.fullRegular,
              ),
            ),
          ],
        ),
      ),
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
