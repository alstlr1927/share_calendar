import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/ui/common/components/date_picker_dialog/date_picker_dialog.dart';
import 'package:couple_calendar/ui/common/components/date_picker_dialog/time_picker_dialog.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:couple_calendar/ui/common/components/snack_bar/couple_noti.dart';
import 'package:couple_calendar/ui/common/provider/loading_provider.dart';
import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
import 'package:couple_calendar/ui/my_schedule/repository/schedule_repository.dart';
import 'package:couple_calendar/ui/my_schedule/widgets/tag_friends_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/provider/schedule_provider.dart';

enum ScheduleFormType {
  CREATE,
  UPDATE;
}

class ScheduleFormViewModel extends ChangeNotifier {
  State state;
  DateTime selectDate;

  ScheduleFormType curForm = ScheduleFormType.CREATE;

  late FieldController titleController;
  late FieldController contentController;
  late FieldController locationController;

  ScheduleTheme _curTheme = ScheduleTheme.WHITE;
  ScheduleTheme get curTheme => _curTheme;
  void setCurTheme(ScheduleTheme theme) => _curTheme = theme;

  late DateTime startDate;
  late DateTime endDate;

  bool _isReady = false;
  bool get isReady => _isReady;
  void setIsReady(bool flag) => _isReady = flag;

  List<UserModel> _memberUserList = [];
  List<UserModel> get memberUserList => _memberUserList;
  void setMemberUserList(List<UserModel> list) =>
      _memberUserList = List<UserModel>.from(list);

  void focusout() {
    titleController.unfocus();
    contentController.unfocus();
    locationController.unfocus();
  }

  Future<void> onClickConfirmBtn() async {
    String completeText = '';
    Provider.of<LoadingProvider>(state.context, listen: false)
        .setIsLoading(true);

    // 이미 등록된 시간 체크 존재하면 return true
    if (await ScheduleRepository()
        .checkDuplicatedTime(startDate: startDate, endDate: endDate)) {
      return;
    }

    if (curForm == ScheduleFormType.CREATE) {
      completeText = '일정이 등록되었습니다.';
      await createSchedule();
    } else {
      completeText = '일정이 수정되었습니다.';
    }

    Provider.of<ScheduleProvider>(state.context, listen: false)
        .getMySchedule(year: selectDate.year);

    Provider.of<LoadingProvider>(state.context, listen: false)
        .setIsLoading(false);

    state.context.pop();
    CoupleNotification().notify(title: completeText);
  }

  Future<void> createSchedule() async {
    final memberIdList = memberUserList.map((e) => e.uid).toList();
    await ScheduleRepository().createMySchedule(
      title: titleController.getStatus.text,
      content: contentController.getStatus.text,
      theme: curTheme,
      location: locationController.getStatus.text,
      startDate: startDate,
      endDate: endDate,
      memberIds: memberIdList,
    );
  }

  Future<void> updateSchedule() async {
    //
  }

  Future<void> onClickTagFriend() async {
    showModalBottomSheet(
      context: state.context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TagFriendsBottomSheet(
          selectedList: memberUserList,
          onAdd: (list) {
            setMemberUserList(list);
            notifyListeners();
          },
        );
      },
    );
  }

  void onClickRemoveFriend(String uid) {
    final temp = List<UserModel>.from(memberUserList);
    int idx = temp.indexWhere((e) => e.uid == uid);

    temp.removeAt(idx);

    setMemberUserList(temp);

    notifyListeners();
  }

  Future<void> onClickSearchAddressBtn() async {
    final res = await CoupleRouter().loadSearchAddress(state.context);

    if (res == null) return;

    debugPrint('');

    locationController.textController?.text = res.address;
    locationController.setText(res.address);
    notifyListeners();
  }

  Future<void> onClickStartDateBtn() async {
    final res = await showTimePicker(
      initDt: startDate,
    );

    if (res == null) return;

    if (!res.isBefore(endDate)) {
      if (res.hour >= 23) {
        CoupleNotification().notify(title: '시작 날짜는 종료 날짜 이전이어야 합니다.');
        return;
      }
      endDate = DateTime(res.year, res.month, res.day, res.hour + 1);
    }

    startDate = res;
    debugPrint('res : $res');

    debugPrint('isBefore : ${startDate.isBefore(endDate)}');
    notifyListeners();
  }

  Future<void> onClickEndDateBtn() async {
    final res = await showTimePicker(
      initDt: endDate,
    );

    if (res == null) return;

    debugPrint('res :$res');

    if (!res.isAfter(startDate)) {
      CoupleNotification().notify(title: '시작 날짜는 종료 날짜 이전이어야 합니다.');
      return;
    }

    endDate = res;
    debugPrint('res :$res');

    debugPrint('isAfter : ${res.isAfter(startDate)}');
    notifyListeners();
  }

  Future<void> onClickDateBtn() async {
    final res = await showDatePicker(initDt: startDate);

    if (res == null) return;

    debugPrint('res : ${res}');

    startDate =
        startDate.copyWith(year: res.year, month: res.month, day: res.day);
    endDate = endDate.copyWith(year: res.year, month: res.month, day: res.day);
    notifyListeners();
  }

  void onClickTheme(ScheduleTheme theme) {
    setCurTheme(theme);
    notifyListeners();
  }

  Future<DateTime?> showTimePicker({required DateTime initDt}) async {
    return await showDialog<DateTime>(
      context: state.context,
      builder: (_) => CoupleTimePicker(initTime: initDt),
    );
  }

  Future<DateTime?> showDatePicker({required DateTime initDt}) async {
    return await showDialog<DateTime>(
      context: state.context,
      builder: (_) => CoupleDatePicker(
        title: '날짜 선택',
        initDateTime: initDt,
        contents: DateDialogContent.values,
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
    titleController.dispose();
    contentController.dispose();
    locationController.dispose();
    super.dispose();
  }

  ScheduleFormViewModel(this.state, this.selectDate,
      {required String scheduleId}) {
    if (scheduleId.isNotEmpty) {
      curForm = ScheduleFormType.UPDATE;
      _updateInitSetting(scheduleId: scheduleId);
    } else {
      _createInitSetting();
    }
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

  void _updateInitSetting({required String scheduleId}) async {
    final model = await _getMyScheduleById(scheduleId: scheduleId);
    if (model == null) {
      return;
    }
    debugPrint('model : ${model.toJson()}');
    titleController = FieldController(initText: model.title);
    contentController = FieldController(initText: model.content);
    locationController = FieldController(initText: model.location);
    _curTheme = model.theme;
    startDate = model.startDate;
    endDate = model.endDate;

    setIsReady(true);
    notifyListeners();
  }

  void _createInitSetting() {
    DateTime now = DateTime.now();
    titleController = FieldController();
    contentController = FieldController();
    locationController = FieldController();
    startDate =
        DateTime(selectDate.year, selectDate.month, selectDate.day, now.hour);
    endDate = startDate.add(const Duration(hours: 1));

    setIsReady(true);
    notifyListeners();
  }

  List<int> colorList = [
    0xFFFFe6e7,
    0xffece5ff,
    0xFFd8f9f5,
    0xFFfeecde,
    0xff000000,
  ];

  List<int> textColorList = [
    0xFFdc6982,
    0xFF7C6BFF,
    0xFF6bc6c7,
    0xFF98713e,
    0xffffffff,
  ];
}
