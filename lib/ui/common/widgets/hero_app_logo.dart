import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HeroAppLogo extends StatelessWidget {
  const HeroAppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app_logo',
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              appLogo,
              width: 200.toWidth,
            ),
            Text(
              tr('app_splash_title'),
              style: CoupleStyle.h3(
                color: CoupleStyle.primary050,
                weight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
