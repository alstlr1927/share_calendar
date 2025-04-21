import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/auth/repository/user_repository.dart';
import 'package:couple_calendar/ui/common/components/bottom_sheet/bottom_sheet_picker.dart';
import 'package:couple_calendar/ui/common/components/bottom_sheet/show_modal_sheet.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/dialog/couple_text_dialog.dart';
import 'package:couple_calendar/ui/common/components/snack_bar/couple_noti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth/provider/user_provider.dart';
import '../../common/components/logger/couple_logger.dart';
import '../../common/provider/schedule_provider.dart';
import '../model/schedule_model.dart';
import '../repository/schedule_repository.dart';

class ScheduleDetailViewModel extends ChangeNotifier {
  State state;

  late ScheduleModel schedule;
  List<UserModel> memberList = [];

  bool _isReady = false;
  bool get isReady => _isReady;
  void setIsReady(bool flag) => _isReady = flag;

  void onClickCopyLocationBtn() {
    Clipboard.setData(ClipboardData(text: schedule.location));
    CoupleNotification().notify(title: '복사되었습니다.');
  }

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
    List<BottomSheetItem> actions = [];
    final uid =
        Provider.of<UserProvider>(state.context, listen: false).getUid();
    if (schedule.ownerUserId == uid) {
      actions = [
        BottomSheetItem(
          title: '수정',
          onPressed: onClickModifyBtn,
        ),
        BottomSheetItem(
          title: '삭제',
          cautionFlag: true,
          onPressed: onClickDeleteBtn,
        ),
      ];
    } else {
      actions = [
        BottomSheetItem(
          title: '일정 나가기',
          cautionFlag: true,
          onPressed: onClickLeaveBtn,
        ),
      ];
    }
    await showModalPopUp(
      context: state.context,
      builder: (context) => BottomSheetPicker(
        actions: actions,
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
              onPressed: () async {
                await ScheduleRepository().deleteMySchedule(id: schedule.id);
                await Provider.of<ScheduleProvider>(state.context,
                        listen: false)
                    .getMySchedule(year: schedule.startDate.year);
                CoupleNotification().notify(title: '일정이 삭제 되었습니다.');
                context.pop();
                context.pop();
              },
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

  Future<void> onClickLeaveBtn() async {
    showDialog(
      context: state.context,
      builder: (context) => CoupleDialog(
        option: CoupleDialogOption.normal(
          header: DialogHeader(text: '일정 나가기'),
          body: DialogBody(text: '이 일정 멤버에서 제외됩니다.\n나가시겠습니까?'),
          actions: [
            DialogAction(
              onPressed: () async {
                await ScheduleRepository().leaveSchedule(id: schedule.id);
                await Provider.of<ScheduleProvider>(state.context,
                        listen: false)
                    .getMySchedule(year: schedule.startDate.year);
                CoupleNotification().notify(title: '일정에서 제외되었습니다.');
                context.pop();
                context.pop();
              },
              buttonOption: CoupleButtonOption.fill(
                text: '나가기',
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
    _getMyScheduleById(scheduleId: scheduleId).then(_initSetting);
  }

  void _initSetting(ScheduleModel? schedule) {
    if (schedule == null) {
      CoupleNotification().notify(title: '일정을 찾을 수 없습니다.');
      state.context.pop();
      return;
    }

    this.schedule = schedule;
    setIsReady(true);
    notifyListeners();

    if (schedule.memberIds.isNotEmpty) {
      getUserList(uids: schedule.memberIds);
    }
  }

  Future<void> getUserList({required List<String> uids}) async {
    final list = await UserRepository().getUserListByQuery(uidList: uids);

    memberList = List<UserModel>.from(list);
    notifyListeners();
  }
}
