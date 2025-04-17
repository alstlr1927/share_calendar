import 'package:couple_calendar/util/images.dart';
import 'package:flutter/material.dart';

import '../../../util/couple_style.dart';

enum SocialLoginButtonType {
  APPLE(
    title: 'Apple로 등록',
    color: CoupleStyle.black,
    icon: appleLogoIcon,
  ),
  GOOGLE(
    title: 'Google로 가입하기',
    color: CoupleStyle.white,
    icon: googleLogoIcon,
  ),
  KAKAO(
    title: '카카오 1초 회원가입',
    color: Color(0xFFFEE500),
    icon: kakaoLogoIcon,
  );

  const SocialLoginButtonType(
      {required this.title, required this.color, required this.icon});

  final String title;
  final Color color;
  final String icon;
}
