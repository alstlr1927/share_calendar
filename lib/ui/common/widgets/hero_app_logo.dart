import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:flutter/material.dart';

class HeroAppLogo extends StatelessWidget {
  final bool isWhite;
  final Color textColor;

  const HeroAppLogo.white({
    super.key,
    required this.textColor,
  }) : isWhite = true;

  const HeroAppLogo.filled({
    super.key,
    required this.textColor,
  }) : isWhite = false;

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
              whiteAppLogoImg,
              width: 130.toWidth,
              color: isWhite ? null : Color(0xffff705e),
            ),
            Text(
              '상대방의 일정을\n확인해요',
              style: CoupleStyle.h3(
                color: textColor,
                weight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
