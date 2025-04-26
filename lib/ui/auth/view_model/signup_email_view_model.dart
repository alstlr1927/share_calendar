import 'package:couple_calendar/service/auth_service.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/util/validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SignupEmailViewModel extends ChangeNotifier {
  State state;

  FieldController idController = FieldController();
  FieldController pwController = FieldController();
  FieldController checkController = FieldController();

  void focusout() {
    idController.unfocus();
    pwController.unfocus();
    checkController.unfocus();
  }

  void validateEmail(String text) {
    idController.resetStatus();
    if (text.isEmpty) return;

    if (!Validator.isValidEmail(text)) {
      idController.setErrorText(tr('invalid_email_error_txt'));
      idController.setHasError(true);
      idController.setIsValid(false);
    } else {
      idController.setHasError(false);
      idController.setIsValid(true);
      idController.setIsEnable(true);
    }
  }

  void validatePassword(String text) {
    pwController.resetStatus();
    if (text.isEmpty) return;

    if (!Validator.validPasswordPattern(text)) {
      pwController.setErrorText(tr('invalid_pw_error_txt'));
      pwController.setHasError(true);
      pwController.setIsValid(false);
    } else {
      pwController.setHasError(false);
      pwController.setIsEnable(true);
      pwController.setIsValid(true);
    }

    if (text != checkController.getStatus.text.trim()) {
      checkController.setErrorText(tr('invalid_pw_check_error_txt'));
      checkController.setHasError(true);
      checkController.setIsValid(false);
    } else {
      checkController.setHasError(false);
      checkController.setIsValid(true);
      checkController.setIsEnable(true);
    }
  }

  void validateCheckPassword(String text) {
    checkController.resetStatus();
    if (text.isEmpty) return;

    if (text != pwController.getStatus.text.trim()) {
      checkController.setErrorText(tr('invalid_pw_check_error_txt'));
      checkController.setHasError(true);
      checkController.setIsValid(false);
    } else {
      checkController.setHasError(false);
      checkController.setIsValid(true);
      checkController.setIsEnable(true);
    }
  }

  Future<void> onClickRegistBtn() async {
    final email = idController.getStatus.text.trim();
    final password = pwController.getStatus.text.trim();

    AuthService().emailSignup(email: email, password: password);
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    checkController.dispose();
    super.dispose();
  }

  SignupEmailViewModel(this.state) {
    //
  }
}
