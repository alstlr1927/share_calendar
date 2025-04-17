import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:couple_calendar/ui/common/widgets/hero_app_logo.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/images.dart';
import '../../common/components/layout/default_layout.dart';

class SplashScreen extends StatefulWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.wait([
      Future.delayed(const Duration(milliseconds: 1200)),
    ]).then((_) {
      Provider.of<UserProvider>(context, listen: false)
          .checkTokenSubscription();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Stack(
        children: [
          Image.asset(
            splashBgImg,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.center,
            child: HeroAppLogo.white(
              textColor: CoupleStyle.white,
            ),
          ),
        ],
      ),
    );
  }
}
