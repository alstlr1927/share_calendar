import 'package:couple_calendar/util/images.dart';
import 'package:flutter/material.dart';

import '../../../util/couple_style.dart';

enum SocialLoginButtonType {
  APPLE(
    title: 'signup_apple',
    color: CoupleStyle.black,
    icon: appleLogoIcon,
  ),
  GOOGLE(
    title: 'signup_google',
    color: CoupleStyle.white,
    icon: googleLogoIcon,
  ),
  KAKAO(
    title: 'signup_kakao',
    color: Color(0xFFFEE500),
    icon: kakaoLogoIcon,
  );

  const SocialLoginButtonType(
      {required this.title, required this.color, required this.icon});

  final String title;
  final Color color;
  final String icon;
}
