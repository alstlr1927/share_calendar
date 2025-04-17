import 'dart:io';

import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:couple_calendar/ui/common/components/overlay_notification/overlay.dart';
import 'package:couple_calendar/ui/common/provider/loading_provider.dart';
import 'package:couple_calendar/ui/common/provider/schedule_provider.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'router/go_router.dart';
import 'util/couple_util.dart';
import 'util/image_cache_delegate.dart';

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();
final uuid = Uuid();

final TABLET_VIEW_SIZE = Size(700, 1232);
final TABLET_VIEW_SIZE_HORIZONTAL = Size(1232, 700);
final MOBILE_VIEW_SIZE = Size(375, 667);
final MOBILE_VIEW_SIZE_HORIZONTAL = Size(667, 375);

class OverFlowGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

void main() async {
  CustomImageCache();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await initializeDateFormatting();

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool usingDeviceSize = Device.get().isTablet && Device.get().isAndroid;

    return OverlaySupport(
      child: OrientationBuilder(
        builder: (context, orientation) {
          Size designSize;

          if (orientation == Orientation.portrait) {
            designSize = usingDeviceSize ? TABLET_VIEW_SIZE : MOBILE_VIEW_SIZE;
          } else {
            designSize = usingDeviceSize
                ? TABLET_VIEW_SIZE_HORIZONTAL
                : MOBILE_VIEW_SIZE_HORIZONTAL;
          }

          ScreenUtil.init(
            context,
            designSize: designSize,
          );

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: CoupleStyle.coupleTheme,
            title: 'Couple calendar',
            showPerformanceOverlay: false,
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            builder: (context, child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<UserProvider>(
                    create: (_) => UserProvider(),
                  ),
                  ChangeNotifierProvider<LoadingProvider>(
                    create: (_) => LoadingProvider(),
                  ),
                  ChangeNotifierProvider<ScheduleProvider>(
                    create: (_) => ScheduleProvider(),
                  ),
                ],
                child: ScrollConfiguration(
                  behavior: OverFlowGlowBehavior(),
                  child: MediaQuery(
                    data: data.copyWith(
                      textScaler:
                          TextScaler.linear(Platform.isAndroid ? .95 : 1.0),
                    ),
                    child: child ?? const SizedBox(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
