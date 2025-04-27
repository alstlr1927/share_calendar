import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/provider/schedule_provider.dart';
import 'package:couple_calendar/ui/home/view_model/home_view_model.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_style.dart';
import '../widget/home_schedule_list_item.dart';

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
        if (!list.isEmpty) {
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
                  onPressed: () {
                    CoupleRouter().loadScheduleForm(context);
                  },
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
        return Expanded(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(
                parent: const BouncingScrollPhysics()),
            child: Column(
              children: list
                  .map((e) => HomeScheduleListItem(schedule: e) as Widget)
                  .superJoin(SizedBox(height: 10.toHeight))
                  .toList(),
            ),
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
        ],
      ),
    );
  }
}
