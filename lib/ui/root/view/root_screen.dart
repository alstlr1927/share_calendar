import 'package:couple_calendar/service/auth_service.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/ui/common/components/lazy_indexed_stack/lazy_indexed_stack.dart';
import 'package:couple_calendar/ui/friends/view/friend_list_screen.dart';
import 'package:couple_calendar/ui/home/view/home_screen.dart';
import 'package:couple_calendar/ui/schedule/view/schedule_screen.dart';
import 'package:couple_calendar/ui/root/view_,model/root_view_model.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

enum RootType {
  HOME(homeIcon, 'home_tab_txt'),
  FRIENDS(friendListIcon, 'friends_tab_txt'),
  CALENDAR(calendarIcon, 'calendar_tab_txt'),
  SETTING(settingIcon, 'settings_tab_txt');

  const RootType(this.icon, this.title);

  final String icon;
  final String title;
}

class RootScreen extends StatefulWidget {
  static String get routeName => 'root';

  final int? initTab;
  const RootScreen({
    super.key,
    this.initTab = 2,
  });

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
  void didChangeDependencies() {
    timeDilation = 1;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RootViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DefaultLayout(
          resizeToAvoidBottomInset: false,
          child: Selector<RootViewModel, int>(
            selector: (_, vm) => vm.curTabIdx,
            builder: (_, curIdx, __) {
              return Stack(
                children: [
                  LazyIndexedStack(
                    index: curIdx,
                    children: [
                      const HomeScreen(),
                      const FriendListScreen(),
                      const ScheduleScreen(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                        child: Center(
                          child: CoupleButton(
                            onPressed: () {
                              AuthService().userSignout();
                            },
                            option: CoupleButtonOption.fill(
                              text: tr('signout_btn_txt'),
                              theme: CoupleButtonFillTheme.lightMagenta,
                              style: CoupleButtonFillStyle.fullRegular,
                            ),
                          ),
                        ),
                      ),
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
                height: CoupleStyle.bottomActionHeight,
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      color, BlendMode.srcATop),
                                  child: Builder(
                                    builder: (context) {
                                      return SvgPicture.asset(
                                        e.icon,
                                        width: 26.toWidth,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 4.toHeight),
                                Text(
                                  tr(e.title),
                                  style: CoupleStyle.overline(
                                    color: color,
                                  ),
                                ),
                              ],
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
