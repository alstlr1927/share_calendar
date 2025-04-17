// import 'package:couple_calendar/router/couple_router.dart';
// import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
// import 'package:flutter/material.dart';

// import '../../common/components/logger/couple_logger.dart';
// import '../repository/schedule_repository.dart';

// class MyScheduleViewModel extends ChangeNotifier {
//   State state;

//   DateTime selectDt = DateTime.now();
//   List<ScheduleModel> scheduleList = [];

//   Future<void> getTodayMySchedule() async {
//     try {
//       final docs = await ScheduleRepository().getMyScheduleByDate(selectDt);
//       final temp = docs.map((e) => ScheduleModel.fromJson(e.data()));
//       scheduleList = List.from(temp);
//       notifyListeners();
//       debugPrint('list length : ${scheduleList.length}');
//     } catch (e, trace) {
//       CoupleLog().e('error: $e');
//       CoupleLog().e('$trace');
//     }
//   }

//   void setSelectDt(DateTime dt) {
//     selectDt = dt;
//     notifyListeners();
//     getTodayMySchedule();
//   }

//   Future<void> onClickAddBtn() async {
//     CoupleRouter().loadScheduleForm(
//       state.context,
//     );
//   }

//   @override
//   void notifyListeners() {
//     if (state.mounted) {
//       super.notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   MyScheduleViewModel(this.state) {
//     getTodayMySchedule();
//   }
// }
