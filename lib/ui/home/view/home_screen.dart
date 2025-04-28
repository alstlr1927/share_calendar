import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/provider/schedule_provider.dart';
import 'package:couple_calendar/ui/home/provider/time_line_provider.dart';
import 'package:couple_calendar/ui/home/view_model/home_view_model.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_style.dart';
import '../widget/home_schedule_list_item.dart';

final double HOUR_CELL_HEIGHT = 100.toHeight;
final double HOUR_TITLE_WIDTH = 34.toWidth;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build method');
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return SafeArea(
          top: true,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                _buildScheduleListView(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScheduleListView() {
    return Consumer2<ScheduleProvider, HomeViewModel>(
      builder: (_, prov, vm, __) {
        final today = DateTime(vm.today.year, vm.today.month, vm.today.day);
        final key = '${today.year}' + ('${today.month}').padLeft(2, '0');
        final curMonthList = prov.scheduleData[key] ?? [];
        final list = curMonthList.where((e) {
          final data = CoupleUtil().dateTimeToString(e.startDate);
          final target = CoupleUtil().dateTimeToString(today);
          return data == target;
        }).toList();
        if (list.isEmpty) {
          return _buildEmptyWidget();
        }
        return Expanded(
          child: SingleChildScrollView(
            controller: viewModel.scrollController,
            physics: AlwaysScrollableScrollPhysics(
                parent: const BouncingScrollPhysics()),
            child: SizedBox(
              width: ScreenUtil().screenWidth,
              height: 24 * HOUR_CELL_HEIGHT + CoupleStyle.bottomActionHeight,
              child: Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(
                            24,
                            (int idx) => Container(
                                  width: double.infinity,
                                  height: HOUR_CELL_HEIGHT,
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 6.toWidth),
                                  decoration: BoxDecoration(
                                    color: [
                                      CoupleStyle.gray030,
                                      CoupleStyle.white,
                                    ][idx % 2],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: HOUR_TITLE_WIDTH,
                                        alignment: Alignment.topRight,
                                        child: Text('${idx}시'),
                                      ),
                                    ],
                                  ),
                                )),
                        SizedBox(height: CoupleStyle.bottomActionHeight),
                      ],
                    ),
                  ),
                  ...list.map((e) {
                    final startHour =
                        e.startDate.hour + (e.startDate.minute / 60);
                    final endHour = e.endDate.hour + (e.endDate.minute / 60);

                    final top = startHour * HOUR_CELL_HEIGHT;
                    final height = (endHour - startHour) * HOUR_CELL_HEIGHT;

                    return Positioned(
                      top: top,
                      left: HOUR_TITLE_WIDTH,
                      child: Container(
                        width: ScreenUtil().screenWidth - HOUR_TITLE_WIDTH,
                        height: height,
                        padding: EdgeInsets.symmetric(vertical: 4.toHeight),
                        child:
                            HomeScheduleListItem(schedule: e, height: height),
                      ),
                    );
                  }).toList(),
                  _curTimeLine(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _curTimeLine() {
    return Selector<TimeLineProvider, double>(
      selector: (_, vm) => vm.curTimeLineTop,
      builder: (_, top, __) {
        return Positioned(
          top: top,
          left: HOUR_TITLE_WIDTH + 12.toWidth,
          child: Row(
            children: [
              Container(
                width: 6.toWidth,
                height: 6.toWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CoupleStyle.coral050,
                ),
              ),
              Container(
                width:
                    ScreenUtil().screenWidth - (HOUR_TITLE_WIDTH + 24.toWidth),
                height: 1.toHeight,
                color: CoupleStyle.coral050.withOpacity(.5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 22.toWidth, bottom: 10.toHeight),
      child: Row(
        children: [
          Text(
            tr('home_title'),
            style: CoupleStyle.h3(
              color: CoupleStyle.gray090,
              weight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          BaseButton(
            onPressed: () => CoupleRouter().loadScheduleForm(context),
            child: SvgPicture.asset(
              addScheduleIcon,
              width: 26.toWidth,
            ),
          ),
          SizedBox(width: 12.toWidth),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 180.toHeight),
          Text(
            '오늘 일정이 없어요.\n새로운 일정을 만들어보세요!',
            style: CoupleStyle.body1(
              weight: FontWeight.w600,
              color: CoupleStyle.gray070,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.toHeight),
          CoupleButton(
            onPressed: () => CoupleRouter().loadScheduleForm(context),
            option: CoupleButtonOption.fill(
              text: '일정 만들기',
              theme: CoupleButtonFillTheme.lightMagenta,
              style: CoupleButtonFillStyle.regular,
            ),
          ),
        ],
      ),
    );
  }
}
