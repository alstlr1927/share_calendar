// import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
// import 'package:couple_calendar/ui/common/widgets/scroll_calendar_widget.dart';
// import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
// import 'package:couple_calendar/ui/my_schedule/view_model/my_schedule_view_model.dart';
// import 'package:couple_calendar/util/couple_style.dart';
// import 'package:couple_calendar/util/couple_util.dart';
// import 'package:couple_calendar/util/images.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';

// class MyScheduleScreen extends StatefulWidget {
//   static String get routeName => 'my_schedule';
//   const MyScheduleScreen({super.key});

//   @override
//   State<MyScheduleScreen> createState() => _MyScheduleScreenState();
// }

// class _MyScheduleScreenState extends State<MyScheduleScreen> {
//   late MyScheduleViewModel viewModel;

//   final CELL_HEIGHT = 120.toWidth;
//   final TIME_CELL_WIDTH = 46.toWidth;

//   @override
//   void initState() {
//     super.initState();
//     viewModel = MyScheduleViewModel(this);
//   }

//   @override
//   void dispose() {
//     viewModel.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<MyScheduleViewModel>.value(
//       value: viewModel,
//       builder: (context, _) {
//         return DefaultLayout(
//           title: '내 일정',
//           actions: [_buildAddButton()],
//           child: Column(
//             children: [
//               ScrollCalendarWidget(
//                 onChanged: viewModel.setSelectDt,
//               ),
//               SizedBox(height: 8.toHeight),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
//                     child: Column(
//                       children: [
//                         SizedBox(height: 8.toHeight),
//                         Row(
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: List.generate(
//                                 24,
//                                 (index) => Container(
//                                   width: TIME_CELL_WIDTH,
//                                   height: CELL_HEIGHT,
//                                   child: Text(
//                                     '$index시',
//                                     style: CoupleStyle.body2(
//                                       weight: FontWeight.w700,
//                                       color: CoupleStyle.gray060,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: SizedBox(
//                                 width: double.infinity,
//                                 height: CELL_HEIGHT * 24,
//                                 child: Selector<MyScheduleViewModel,
//                                     List<ScheduleModel>>(
//                                   selector: (_, vm) => vm.scheduleList,
//                                   builder: (_, list, __) {
//                                     return Stack(
//                                       fit: StackFit.expand,
//                                       children:
//                                           list.map((e) => _item(e)).toList(),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _item(ScheduleModel schedule) {
//     final startDate = schedule.startDate;
//     final endDate = schedule.endDate;
//     final startHour = startDate.hour + (startDate.minute / 60);
//     final endHour = endDate.hour + (endDate.minute / 60);
//     final startPosition = startHour * CELL_HEIGHT;
//     final height = (endHour - startHour) * CELL_HEIGHT;

//     return Positioned(
//       top: startPosition,
//       child: Container(
//         width: ScreenUtil().screenWidth - (32.toWidth + TIME_CELL_WIDTH),
//         height: height,
//         padding: EdgeInsets.all(12.toWidth),
//         decoration: BoxDecoration(
//           // color: Color(schedule.backColor),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: CoupleStyle.elevation_04dp(),
//         ),
//         child: Text(
//           schedule.title,
//           style: CoupleStyle.body2(
//             weight: FontWeight.w600,
//             // color: Color(schedule.textColor),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAddButton() {
//     return Selector<MyScheduleViewModel, DateTime>(
//       selector: (_, vm) => vm.selectDt,
//       builder: (_, selectDt, __) {
//         DateTime nowDt = DateTime.now();
//         nowDt = DateTime(nowDt.year, nowDt.month, nowDt.day);

//         bool isBefore =
//             nowDt.isBefore(selectDt) || nowDt.isAtSameMomentAs(selectDt);
//         if (!isBefore) return const SizedBox();
//         return CupertinoButton(
//           onPressed: viewModel.onClickAddBtn,
//           child: SvgPicture.asset(
//             editIcon,
//           ),
//         );
//       },
//     );
//   }
// }
