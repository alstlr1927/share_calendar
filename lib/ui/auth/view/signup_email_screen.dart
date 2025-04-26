import 'package:couple_calendar/ui/auth/view_model/signup_email_view_model.dart';
import 'package:couple_calendar/ui/auth/widget/social_login_button.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/couple_text_field.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../util/validator.dart';

class SignupEmailScreen extends StatefulWidget {
  static String get routeName => 'signup_email';
  const SignupEmailScreen({super.key});

  @override
  State<SignupEmailScreen> createState() => _SignupEmailScreenState();
}

class _SignupEmailScreenState extends State<SignupEmailScreen> {
  late SignupEmailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SignupEmailViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignupEmailViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DefaultLayout(
          title: tr('signup_title'),
          onPressed: viewModel.focusout,
          resizeToAvoidBottomInset: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
            child: Column(
              children: [
                _buildInputFieldArea(),
                SizedBox(height: 16.toHeight),
                _buildRegistButton(),
                const Spacer(),
                OtherLoginWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 4.toWidth, top: 2.toHeight),
      child: Text(
        tr('invalid_email_notice_txt'),
        style: CoupleStyle.overline(
          weight: FontWeight.w500,
          color: CoupleStyle.gray060,
        ),
      ),
    );
  }

  Widget _buildRegistButton() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: Rx.combineLatest3(
        viewModel.idController.statusStream!,
        viewModel.pwController.statusStream!,
        viewModel.checkController.statusStream!,
        (id, pw, check) => id.isValid && pw.isValid && check.isValid,
      ),
      builder: (context, snapshot) {
        final isReady = snapshot.data!;
        return CoupleButton(
          onPressed: isReady ? viewModel.onClickRegistBtn : null,
          option: CoupleButtonOption.fill(
            text: tr('signup_btn_txt'),
            theme: CoupleButtonFillTheme.lightMagenta,
            style: CoupleButtonFillStyle.fullRegular,
          ),
        );
      },
    );
  }

  Widget _buildInputFieldArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoupleTextField(
          controller: viewModel.idController,
          hintText: tr('input_email_hint_txt'),
          title: 'email',
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [
            FilteringTextInputFormatter.deny(Validator().kWhiteSpaceRegex),
          ],
          autoFocus: true,
          autofillHints: const [AutofillHints.email],
          onChanged: viewModel.validateEmail,
        ),
        _buildTitle(),
        CoupleTextField(
          controller: viewModel.pwController,
          hintText: tr('input_pw_hint_txt'),
          isObscure: true,
          title: 'password',
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.deny(Validator().kWhiteSpaceRegex),
          ],
          autofillHints: const [AutofillHints.newPassword],
          onChanged: viewModel.validatePassword,
        ),
        CoupleTextField(
          controller: viewModel.checkController,
          hintText: tr('input_pw_check_hint_txt'),
          isObscure: true,
          title: 'password',
          keyboardType: TextInputType.text,
          inputFormatters: [
            FilteringTextInputFormatter.deny(Validator().kWhiteSpaceRegex),
          ],
          autofillHints: const [AutofillHints.newPassword],
          onChanged: viewModel.validateCheckPassword,
        ),
      ],
    );
  }
}
