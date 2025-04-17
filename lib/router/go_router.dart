import 'package:couple_calendar/main.dart';
import 'package:couple_calendar/ui/auth/view/add_user_info_screen.dart';
import 'package:couple_calendar/ui/auth/view/landing_screen.dart';
import 'package:couple_calendar/ui/auth/view/login_screen.dart';
import 'package:couple_calendar/ui/auth/view/signup_email_screen.dart';
import 'package:couple_calendar/ui/my_schedule/view/schedule_form_screen.dart';
import 'package:couple_calendar/ui/root/view/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/my_schedule/view/search_address_screen.dart';
import '../ui/splash/view/splash_screen.dart';
import 'router_observer.dart';

final router = GoRouter(
  initialLocation: '/splash',
  navigatorKey: nav,
  observers: [CoupleRouterObserver()],
  routes: [
    GoRoute(
      path: '/splash',
      name: SplashScreen.routeName,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/landing',
      name: LandingScreen.routeName,
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          name: LandingScreen.routeName,
          child: const LandingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'login',
          name: LoginScreen.routeName,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: 'signup_email',
          name: SignupEmailScreen.routeName,
          builder: (_, __) => const SignupEmailScreen(),
        ),
        GoRoute(
          path: 'add_user_info',
          name: AddUserInfoScreen.routeName,
          builder: (_, __) => const AddUserInfoScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/root',
      name: RootScreen.routeName,
      builder: (_, __) => const RootScreen(),
      routes: [
        GoRoute(
          path: '/schedule_form',
          name: ScheduleFormScreen.routeName,
          builder: (_, state) {
            final data = state.extra as Map<String, dynamic>;
            final id = data['id'] as String;
            final date = data['date'] as DateTime;
            return ScheduleFormScreen(
              scheduleId: id,
              selectDate: date,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/search_address',
      name: SearchAddressScreen.routeName,
      builder: (_, __) => const SearchAddressScreen(),
    ),
  ],
);
