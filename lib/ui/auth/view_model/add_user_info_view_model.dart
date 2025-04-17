import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/auth/repository/user_repository.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/dialog/couple_text_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddUserInfoViewModel extends ChangeNotifier {
  State state;

  FieldController nameController = FieldController();

  UserGender _gender = UserGender.NONE;
  UserGender get gender => _gender;

  void focusout() {
    nameController.unfocus();
  }

  void setGender(UserGender gender) {
    _gender = gender;
  }

  Future<void> onClickAddInfoBtn() async {
    final name = nameController.getStatus.text.trim();

    final res =
        await UserRepository().setUserInfoData(name: name, gender: gender);

    if (res) {
      CoupleRouter().replaceRoot(state.context);
    } else {
      _showErrorDialog();
    }
  }

  void validateName(String text) {
    nameController.resetStatus();
    if (text.isEmpty) return;

    if (text.trim().length > 1) {
      nameController.setHasError(false);
      nameController.setIsValid(true);
      nameController.setIsEnable(true);
    } else {
      nameController.setErrorText('최소 2자 이상 입력해주세요.');
      nameController.setHasError(true);
      nameController.setIsValid(false);
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: state.context,
      builder: (context) => CoupleDialog(
        option: CoupleDialogOption.normal(
          header: DialogHeader(text: '에러'),
          body: DialogBody(text: '문제가 발생했습니다.'),
          actions: [
            DialogAction(
              onPressed: context.pop,
              buttonOption: CoupleButtonOption.fill(
                text: '확인',
                theme: CoupleButtonFillTheme.gray,
                style: CoupleButtonFillStyle.fullSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  AddUserInfoViewModel(this.state) {
    //
  }
}
