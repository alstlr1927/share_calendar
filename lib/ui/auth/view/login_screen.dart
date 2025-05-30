import 'package:couple_calendar/ui/auth/view_model/login_view_model.dart';
import 'package:couple_calendar/ui/auth/widget/social_login_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../util/validator.dart';
import '../../common/components/couple_text_field/couple_text_field.dart';
import '../../common/components/custom_button/couple_button.dart';

class LoginScreen extends StatefulWidget {
  static String get routeName => 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LoginViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DefaultLayout(
          title: tr('login_title'),
          resizeToAvoidBottomInset: false,
          onPressed: viewModel.focusout,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
            child: Column(
              children: [
                _buildInputField(),
                SizedBox(height: 8.toHeight),
                _buildFindPwButton(),
                SizedBox(height: 16.toHeight),
                _buildLoginButton(),
                const Spacer(),
                OtherLoginWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFindPwButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CoupleButton(
        onPressed: () {},
        option: CoupleButtonOption.text(
          text: tr('find_pw_btn_txt'),
          theme: CoupleButtonTextTheme.gray,
          style: CoupleButtonTextStyle.small,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: Rx.combineLatest2(
        viewModel.idController.statusStream!,
        viewModel.pwController.statusStream!,
        (id, pw) => id.isValid && pw.isValid,
      ),
      builder: (context, snapshot) {
        final isReady = snapshot.data!;
        return CoupleButton(
          onPressed: isReady ? viewModel.onClickLoginBtn : null,
          option: CoupleButtonOption.fill(
            text: tr('login_btn_txt'),
            theme: CoupleButtonFillTheme.magenta,
            style: CoupleButtonFillStyle.fullRegular,
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Column(
      children: [
        CoupleTextField(
          controller: viewModel.idController,
          hintText: tr('input_email_hint_txt'),
          onChanged: viewModel.validateEmail,
          title: 'email',
          inputFormatters: [
            FilteringTextInputFormatter.deny(Validator().kWhiteSpaceRegex),
          ],
        ),
        SizedBox(height: 4.toHeight),
        CoupleTextField(
          controller: viewModel.pwController,
          hintText: tr('input_pw_hint_txt'),
          isObscure: true,
          onChanged: viewModel.validatePassword,
          title: 'password',
          inputFormatters: [
            FilteringTextInputFormatter.deny(Validator().kWhiteSpaceRegex),
          ],
        ),
      ],
    );
  }
}
