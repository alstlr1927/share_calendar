import 'package:couple_calendar/ui/auth/view/add_user_info_screen.dart';
import 'package:couple_calendar/ui/auth/view/landing_screen.dart';
import 'package:couple_calendar/ui/auth/view/login_screen.dart';
import 'package:couple_calendar/ui/auth/view/signup_email_screen.dart';
import 'package:couple_calendar/ui/my_schedule/view/schedule_form_screen.dart';
import 'package:couple_calendar/ui/my_schedule/view/search_address_screen.dart';
import 'package:couple_calendar/ui/root/view/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kpostal/kpostal.dart';

const pageTransitionDuration = Duration(milliseconds: 400);

class CoupleRouter {
  void replaceLanding(BuildContext context) {
    context.goNamed(LandingScreen.routeName);
  }

  void replaceRoot(BuildContext context) {
    context.goNamed(RootScreen.routeName);
  }

  void replaceAddUserInfo(BuildContext context) async {
    context.goNamed(
      AddUserInfoScreen.routeName,
    );
  }

  loadLogin(BuildContext context) async {
    return await context.pushNamed(
      LoginScreen.routeName,
    );
  }

  loadSignupEmail(BuildContext context) async {
    return await context.pushNamed(
      SignupEmailScreen.routeName,
    );
  }

  // loadMySchedule(BuildContext context) async {
  //   return await context.pushNamed(
  //     MyScheduleScreen.routeName,
  //   );
  // }

  loadScheduleForm(
    BuildContext context, {
    String scheduleId = '',
    required DateTime date,
  }) async {
    return await context.pushNamed(
      ScheduleFormScreen.routeName,
      extra: {'id': scheduleId, 'date': date},
    );
  }

  Future<Kpostal?> loadSearchAddress(BuildContext context) async {
    return await context.pushNamed(
      SearchAddressScreen.routeName,
    );
  }
}

class SheetRoute<T> extends PageRoute<T> {
  /// Construct a DubPageRoute whose contents are defined by [builder].
  ///
  /// The values of [builder], [maintainState], and [fullScreenDialog] must not
  /// be null.
  SheetRoute({
    required this.builder,
    RouteSettings? settings,
    Color? barrierColor,
    this.maintainState = true,
  })  : barrierColors = barrierColor ?? Colors.black38,
        assert(builder != null),
        assert(maintainState != null),
        super(settings: settings, fullscreenDialog: true);

  final Color barrierColors;

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => pageTransitionDuration;

  @override
  Color get barrierColor => barrierColors;

  @override
  String? get barrierLabel => null;

  // @override
  // bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
  //   return previousRoute is DubPageRoute || previousRoute is CupertinoPageRoute;
  // }

  // @override
  // bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
  //   // Don't perform outgoing animation if the next route is a fullscreen dialog.
  //   return (nextRoute is DubPageRoute && !nextRoute.fullscreenDialog) ||
  //       (nextRoute is CupertinoPageRoute && !nextRoute.fullscreenDialog);
  // }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Duration get reverseTransitionDuration => pageTransitionDuration;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;

    final PageTransitionsTheme newTheme = const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        });

    return newTheme.buildTransitions<T>(
        this, context, animation, secondaryAnimation, child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
