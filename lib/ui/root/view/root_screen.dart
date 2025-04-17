import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/ui/common/components/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:couple_calendar/ui/my_schedule/view/schedule_screen.dart';
import 'package:couple_calendar/ui/root/view_,model/root_view_model.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

enum RootType {
  HOME(homeIcon),
  CALENDAR(calendarIcon),
  SETTING(settingIcon);

  const RootType(this.icon);

  final String icon;
}

class RootScreen extends StatefulWidget {
  static String get routeName => 'root';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late RootViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = RootViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RootViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DefaultLayout(
          child: Selector<RootViewModel, int>(
            selector: (_, vm) => vm.curTabIdx,
            builder: (_, curIdx, __) {
              return Stack(
                children: [
                  LazyIndexedStack(
                    index: curIdx,
                    children: [
                      Container(
                        color: Colors.amber,
                      ),
                      ScheduleScreen(),
                      Container(),
                    ],
                  ),
                  _buildBottomNav(),
                ],
              );
            },
          ),
          // bottomNavigation: _buildBottomNav(),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Selector<RootViewModel, int>(
        selector: (_, vm) => vm.curTabIdx,
        builder: (_, curIdx, __) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                height: 50.toHeight,
                padding: EdgeInsets.only(top: 10.toHeight),
                decoration: BoxDecoration(
                  color: CoupleStyle.gray080,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Row(
                  children: RootType.values.map((e) {
                    final color = e.index == curIdx
                        ? CoupleStyle.primary060
                        : CoupleStyle.white;
                    return Flexible(
                      child: BaseButton(
                        onPressed: () => viewModel.onClickTabItem(e.index),
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: ColorFiltered(
                              colorFilter:
                                  ColorFilter.mode(color, BlendMode.srcATop),
                              child: SvgPicture.asset(
                                e.icon,
                                width: 26.toWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                height: CoupleStyle.defaultBottomPadding(),
                color: CoupleStyle.gray080,
              ),
            ],
          );
        },
      ),
    );
  }
}
