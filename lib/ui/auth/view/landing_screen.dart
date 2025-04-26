import 'dart:io';

import 'package:couple_calendar/ui/auth/type/auth_type.dart';
import 'package:couple_calendar/ui/auth/view_model/landing_view_model.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/ui/common/widgets/hero_app_logo.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../widget/social_login_button.dart';

class LandingScreen extends StatefulWidget {
  static String get routeName => 'landing';
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  late LandingViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LandingViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    timeDilation = 1;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LandingViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DefaultLayout(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
            child: Column(
              children: [
                SizedBox(height: 120.toHeight),
                const HeroAppLogo(),
                const Spacer(),
                SocialLoginButton.square(type: SocialLoginButtonType.KAKAO),
                SizedBox(height: 8.toHeight),
                if (Platform.isIOS) ...{
                  SocialLoginButton.square(type: SocialLoginButtonType.APPLE),
                  SizedBox(height: 8.toHeight),
                },
                SocialLoginButton.square(type: SocialLoginButtonType.GOOGLE),
                SizedBox(height: 20.toHeight),
                _buildTextButtonRow(),
                SizedBox(
                  height: CoupleStyle.defaultBottomPadding() + 10.toHeight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextButtonRow() {
    return Row(
      children: [
        Expanded(
          child: CoupleButton(
            onPressed: viewModel.navigateToLogin,
            option: CoupleButtonOption.text(
              text: tr('signin_email'),
              theme: CoupleButtonTextTheme.gray,
              style: CoupleButtonTextStyle.regular,
            ),
          ),
        ),
        Container(
          width: 1.toWidth,
          height: 20.toWidth,
          color: CoupleStyle.gray050,
        ),
        Expanded(
          child: CoupleButton(
            onPressed: viewModel.navigateToSignupEmail,
            option: CoupleButtonOption.text(
              text: tr('signup_email'),
              theme: CoupleButtonTextTheme.gray,
              style: CoupleButtonTextStyle.regular,
            ),
          ),
        ),
      ],
    );
  }
}
