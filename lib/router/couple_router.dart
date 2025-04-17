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
