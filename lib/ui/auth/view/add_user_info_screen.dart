import 'package:couple_calendar/service/auth_service.dart';
import 'package:couple_calendar/ui/auth/view_model/add_user_info_view_model.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/couple_text_field.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_style.dart';
import '../../common/components/custom_button/base_button.dart';
import '../widget/select_gender_widget.dart';

class AddUserInfoScreen extends StatefulWidget {
  static String get routeName => 'add_user_info';
  const AddUserInfoScreen({super.key});

  @override
  State<AddUserInfoScreen> createState() => _AddUserInfoScreenState();
}

class _AddUserInfoScreenState extends State<AddUserInfoScreen> {
  late AddUserInfoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = AddUserInfoViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddUserInfoViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DefaultLayout(
          title: '추가정보 입력',
          leading: _leading(),
          onPressed: viewModel.focusout,
          resizeToAvoidBottomInset: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
            child: Column(
              children: [
                _buildNameField(),
                SizedBox(height: 16.toHeight),
                SelectGenderWidget(onChanged: viewModel.setGender),
                const Spacer(),
                _buildAddInfoButton(),
                SizedBox(height: CoupleStyle.defaultBottomPadding()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddInfoButton() {
    return StreamBuilder<FieldStatus>(
      initialData: FieldStatus(),
      stream: viewModel.nameController.statusStream!,
      builder: (context, snapshot) {
        final isReady = snapshot.data!.isValid;
        return CoupleButton(
          onPressed: isReady ? viewModel.onClickAddInfoBtn : null,
          option: CoupleButtonOption.fill(
            text: '등록',
            theme: CoupleButtonFillTheme.magenta,
            style: CoupleButtonFillStyle.fullRegular,
          ),
        );
      },
    );
  }

  Widget _buildNameField() {
    return CoupleTextField(
      controller: viewModel.nameController,
      hintText: '이름을 입력하세요.',
      title: 'name',
      onChanged: viewModel.validateName,
    );
  }

  Widget _leading() {
    return BaseButton(
      onPressed: () {
        AuthService().userSignout();
      },
      child: Icon(
        Icons.chevron_left_sharp,
        size: 32.toWidth,
      ),
    );
  }
}
