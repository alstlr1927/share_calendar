import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../util/couple_style.dart';
import '../../provider/loading_provider.dart';
import '../custom_button/base_button.dart';
import '../indicator/couple_indicator.dart';

class DefaultLayout extends StatelessWidget {
  final String? title;
  final Widget child;
  final Color? backgroundColor;
  final Color? appbarBackgroundColor;
  final bool? resizeToAvoidBottomInset;
  final Widget? leading;
  final List<Widget> actions;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? appBar;
  final VoidCallback? onPressed;
  final Widget? bottomNavigation;
  final Widget? floatingBtn;
  final FloatingActionButtonLocation? floatingLocation;

  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor = CoupleStyle.white,
    this.appbarBackgroundColor = CoupleStyle.white,
    this.title,
    this.resizeToAvoidBottomInset,
    this.leading,
    this.actions = const [],
    this.automaticallyImplyLeading = true,
    this.appBar,
    this.onPressed,
    this.bottomNavigation,
    this.floatingBtn,
    this.floatingLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Scaffold(
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            appBar: appBar ?? _appbar(),
            backgroundColor: backgroundColor,
            body: child,
            bottomNavigationBar: bottomNavigation,
            floatingActionButton: floatingBtn,
            floatingActionButtonLocation: floatingLocation,
          ),
        ),
        Selector<LoadingProvider, bool>(
          selector: (_, prov) => prov.isLoading,
          builder: (_, isLoading, __) {
            if (!isLoading) {
              return const SizedBox();
            }
            return Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              color: CoupleStyle.black.withOpacity(.65),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CoupleIndicator(
                    color: CoupleStyle.white,
                    radius: 22.toWidth,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  PreferredSizeWidget? _appbar() {
    if (title != null) {
      return AppBar(
        iconTheme: IconThemeData(
          color: CoupleStyle.gray090,
        ),
        backgroundColor: appbarBackgroundColor,
        title: Text(title!),
        scrolledUnderElevation: 0,
        actions: actions,
        leading: leading ?? _defaultLeading(),
        automaticallyImplyLeading: automaticallyImplyLeading,
      );
    }
    return null;
  }

  Widget _defaultLeading() {
    return Builder(builder: (context) {
      if (!context.canPop()) {
        return SizedBox();
      }
      return BaseButton(
          onPressed: context.pop,
          child: Icon(
            Icons.chevron_left_sharp,
            size: 32.toWidth,
          ));
    });
  }
}
