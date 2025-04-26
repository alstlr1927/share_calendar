import 'dart:io';

import 'package:couple_calendar/ui/auth/type/auth_type.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../util/couple_style.dart';
import '../../common/components/custom_button/base_button.dart';
import '../../common/components/divider/defaultDivider.dart';

class OtherLoginWidget extends StatelessWidget {
  const OtherLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Platform.isIOS) ...{
          SocialLoginButton.square(type: SocialLoginButtonType.APPLE),
          SizedBox(height: 8.toHeight),
        },
        SocialLoginButton.square(type: SocialLoginButtonType.GOOGLE),
        _orDivider(),
        SocialLoginButton.circle(type: SocialLoginButtonType.KAKAO),
        SizedBox(
          height: CoupleStyle.defaultBottomPadding() + 10.toHeight,
        ),
      ],
    );
  }

  Widget _orDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.toHeight),
      child: Row(
        children: [
          Expanded(child: DefaultDivider()),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                tr('or_txt'),
                style: CoupleStyle.body2(color: CoupleStyle.gray080),
              )),
          Expanded(child: DefaultDivider()),
        ],
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final SocialLoginButtonType type;
  final bool isSquare;

  const SocialLoginButton.square({
    super.key,
    required this.type,
  }) : isSquare = true;

  const SocialLoginButton.circle({
    super.key,
    required this.type,
  }) : isSquare = false;

  @override
  Widget build(BuildContext context) {
    final textColor =
        type.color == CoupleStyle.black ? CoupleStyle.white : CoupleStyle.black;
    final borderColor =
        type.color == CoupleStyle.white ? CoupleStyle.black : type.color;
    if (!isSquare) {
      return BaseButton(
        onPressed: () {},
        child: Container(
          width: 42.toWidth,
          height: 42.toWidth,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: type.color,
            border: Border.all(
              width: .5,
              color: borderColor,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              type.icon,
              width: 16.toWidth,
            ),
          ),
        ),
      );
    }
    return BaseButton(
      onPressed: () {},
      child: Container(
        height: 48.toWidth,
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: .5,
            color: borderColor,
          ),
        ),
        child: Row(
          children: [
            const Spacer(),
            SvgPicture.asset(type.icon),
            SizedBox(width: 6.toWidth),
            Text(
              tr(type.title),
              style: CoupleStyle.body2(
                color: textColor,
                weight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
