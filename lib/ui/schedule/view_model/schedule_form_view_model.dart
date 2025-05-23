import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/ui/common/components/date_picker_dialog/date_picker_dialog.dart';
import 'package:couple_calendar/ui/common/components/date_picker_dialog/time_picker_dialog.dart';
import 'package:couple_calendar/ui/common/components/snack_bar/couple_noti.dart';
import 'package:couple_calendar/ui/common/provider/loading_provider.dart';
import 'package:couple_calendar/ui/schedule/model/schedule_model.dart';
import 'package:couple_calendar/ui/schedule/repository/schedule_repository.dart';
import 'package:couple_calendar/ui/schedule/view/schedule_form_screen.dart';
import 'package:couple_calendar/ui/schedule/widgets/tag_friends_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../auth/repository/user_repository.dart';
import '../../common/provider/schedule_provider.dart';

enum ScheduleFormType {
  CREATE,
  UPDATE;
}

class ScheduleFormViewModel extends ChangeNotifier {
  State<ScheduleFormScreen> state;
  ScheduleModel schedule;

  ScheduleFormType curForm = ScheduleFormType.CREATE;

  late FieldController titleController;
  late FieldController contentController;
  late FieldController locationController;

  double? latitude;
  double? longitude;

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

    // 이미 등록된 시간 체크 존재하면 return true
    if (await checkDuplicatedValidate()) {
      Provider.of<LoadingProvider>(state.context, listen: false)
          .setIsLoading(true);
      if (curForm == ScheduleFormType.CREATE) {
        completeText = tr('schedule_registered_notice_txt');
        await createSchedule();
      } else {
        completeText = tr('schedule_updated_notice_txt');
        await updateSchedule();
      }

      Provider.of<ScheduleProvider>(state.context, listen: false)
          .getMySchedule(year: schedule.startDate.year);

      Provider.of<LoadingProvider>(state.context, listen: false)
          .setIsLoading(false);

      state.context.pop();
    } else {
      completeText = tr('schedule_conflict_notice_txt');
    }

    CoupleNotification().notify(
      title: completeText,
      padding: MediaQuery.of(state.context).viewInsets.bottom,
    );
  }

  Future<bool> checkDuplicatedValidate() async {
    final existList = await ScheduleRepository()
        .checkDuplicatedTime(startDate: startDate, endDate: endDate);

    if (curForm == ScheduleFormType.CREATE) {
      // 같은 시간대 일정 존재하면 불가
      return existList.isEmpty;
    } else {
      // 같은 시간대 일정이 존재하지만 같은 id라면(수정일때) 허용
      final ids = existList.map((e) => e.id).toList();
      return ids.contains(schedule.id);
    }
  }

  Future<void> createSchedule() async {
    final memberIdList = memberUserList.map((e) => e.uid).toList();
    await ScheduleRepository().createMySchedule(
      title: titleController.getStatus.text,
      content: contentController.getStatus.text,
      theme: curTheme,
      location: locationController.getStatus.text,
      latitude: latitude,
      longitude: longitude,
      startDate: startDate,
      endDate: endDate,
      memberIds: memberIdList,
    );
  }

  Future<void> updateSchedule() async {
    final memberIdList = memberUserList.map((e) => e.uid).toList();
    await ScheduleRepository().updateMySchedule(
      id: schedule.id,
      title: titleController.getStatus.text,
      content: contentController.getStatus.text,
      theme: curTheme,
      location: locationController.getStatus.text,
      latitude: latitude,
      longitude: longitude,
      startDate: startDate,
      endDate: endDate,
      memberIds: memberIdList,
    );
  }

  Future<void> onClickTagFriend() async {
    await Navigator.push(
      state.context,
      SheetRoute(
        builder: (context) {
          return TagFriendsBottomSheet(
            selectedList: memberUserList,
            onAdd: (list) {
              setMemberUserList(list);
              notifyListeners();
            },
          );
        },
      ),
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

    debugPrint('latitude :${res.latitude}');
    debugPrint('longitude :${res.longitude}');

    locationController.textController?.text = res.address;
    locationController.setText(res.address);

    latitude = res.latitude;
    longitude = res.longitude;

    notifyListeners();
  }

  Future<void> onClickStartDateBtn() async {
    final res = await showTimePicker(
      initDt: startDate,
    );

    if (res == null) return;

    if (!res.isBefore(endDate)) {
      if (res.hour >= 23) {
        CoupleNotification().notify(title: tr('schedule_error_txt'));
        return;
      }
      endDate = DateTime(res.year, res.month, res.day, res.hour + 1);
    }

    startDate = DateTime(res.year, res.month, res.day, res.hour, res.minute, 1);
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
      CoupleNotification().notify(title: tr('schedule_error_txt'));
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

  ScheduleFormViewModel(this.state, {required this.schedule}) {
    _initSetting();
  }

  void _initSetting() {
    if (schedule.id.isNotEmpty) {
      curForm = ScheduleFormType.UPDATE;
    }

    titleController = FieldController(initText: schedule.title);
    contentController = FieldController(initText: schedule.content);
    locationController = FieldController(initText: schedule.location);
    locationController.setIsEnable(false);

    _curTheme = schedule.theme;
    startDate = schedule.startDate;
    endDate = schedule.endDate;
    latitude = schedule.latitude;
    longitude = schedule.longitude;

    setIsReady(true);
    notifyListeners();

    if (schedule.memberIds.isNotEmpty) {
      _getUserList(uids: schedule.memberIds);
    }
  }

  Future<void> _getUserList({required List<String> uids}) async {
    final list = await UserRepository().getUserListByQuery(uidList: uids);

    setMemberUserList(list);
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
