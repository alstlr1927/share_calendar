import 'package:couple_calendar/service/auth_service.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/util/validator.dart';
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
      idController.setErrorText('올바른 이메일 주소를 입력해주세요.');
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
      pwController.setErrorText('영문 대/소문자, 숫자, 특수문자를 조합하여 8자 이상 입력해주세요.');
      pwController.setHasError(true);
      pwController.setIsValid(false);
    } else {
      pwController.setHasError(false);
      pwController.setIsEnable(true);
      pwController.setIsValid(true);
    }

    if (text != checkController.getStatus.text.trim()) {
      checkController.setErrorText('비밀번호가 일치하지 않습니다.');
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
      checkController.setErrorText('비밀번호가 일치하지 않습니다.');
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
