import 'package:couple_calendar/service/auth_service.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/util/validator.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  State state;

  late FieldController idController;
  late FieldController pwController;

  void focusout() {
    idController.unfocus();
    pwController.unfocus();
  }

  Future<void> onClickLoginBtn() async {
    final email = idController.getStatus.text.trim();
    final password = pwController.getStatus.text.trim();

    AuthService().emailLogin(email: email, password: password);
  }

  Future<void> onClickFindPwBtn() async {
    //
  }

  void validatePassword(String text) {
    pwController.resetStatus();
    if (text.isEmpty) return;

    if (text.length < 6) {
      pwController.setErrorText('최소 6자 이상 입력해주세요.');
      pwController.setHasError(true);
      pwController.setIsValid(false);
    } else {
      pwController.setHasError(false);
      pwController.setIsValid(true);
      pwController.setIsEnable(true);
    }
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
    super.dispose();
  }

  LoginViewModel(this.state) {
    idController = FieldController();
    pwController = FieldController();
  }
}
