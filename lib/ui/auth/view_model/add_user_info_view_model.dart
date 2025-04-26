import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/auth/repository/user_repository.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/dialog/couple_text_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddUserInfoViewModel extends ChangeNotifier {
  State state;

  FieldController nameController = FieldController();
  FieldController idController = FieldController();

  UserGender _gender = UserGender.NONE;
  UserGender get gender => _gender;

  void focusout() {
    nameController.unfocus();
    idController.unfocus();
  }

  void setGender(UserGender gender) {
    _gender = gender;
  }

  // true => 사용가능
  Future<bool> checkDuplicatedId({required String userId}) async {
    final res = await UserRepository().getUserProfileByUserId(userId: userId);
    return res == null;
  }

  Future<void> onClickAddInfoBtn() async {
    final name = nameController.getStatus.text.trim();
    final id = idController.getStatus.text.trim();

    if (await checkDuplicatedId(userId: id)) {
      final res = await UserRepository().setUserInfoData(
        name: name,
        gender: gender,
        userId: id,
      );

      if (res) {
        CoupleRouter().replaceRoot(state.context);
      } else {
        _showErrorDialog();
      }
    } else {
      showAlertDialog();
    }
  }

  void showAlertDialog() {
    showDialog(
      context: state.context,
      builder: (context) => CoupleDialog(
        option: CoupleDialogOption.normal(
          header: DialogHeader(text: tr('dialog_common_title')),
          body: DialogBody(text: tr('already_exist_id_error_txt')),
          actions: [
            DialogAction(
              onPressed: context.pop,
              buttonOption: CoupleButtonOption.fill(
                text: tr('confirm_btn_txt'),
                theme: CoupleButtonFillTheme.gray,
                style: CoupleButtonFillStyle.fullSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateName(String text) {
    nameController.resetStatus();
    if (text.isEmpty) return;

    if (text.trim().length > 1) {
      nameController.setHasError(false);
      nameController.setIsValid(true);
      nameController.setIsEnable(true);
    } else {
      nameController.setErrorText(tr(
        'min_length_error_txt',
        namedArgs: {'length': '2'},
      ));
      nameController.setHasError(true);
      nameController.setIsValid(false);
    }
  }

  void validateId(String text) {
    idController.resetStatus();
    if (text.isEmpty) return;

    if (text.trim().length > 5) {
      idController.setHasError(false);
      idController.setIsValid(true);
      idController.setIsEnable(true);
    } else {
      idController.setErrorText(tr(
        'min_length_error_txt',
        namedArgs: {'length': '5'},
      ));
      idController.setHasError(true);
      idController.setIsValid(false);
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: state.context,
      builder: (context) => CoupleDialog(
        option: CoupleDialogOption.normal(
          header: DialogHeader(text: tr('error_txt')),
          body: DialogBody(text: tr('default_error_txt')),
          actions: [
            DialogAction(
              onPressed: context.pop,
              buttonOption: CoupleButtonOption.fill(
                text: tr('confirm_btn_txt'),
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
    idController.dispose();
    super.dispose();
  }

  AddUserInfoViewModel(this.state) {
    //
  }
}
