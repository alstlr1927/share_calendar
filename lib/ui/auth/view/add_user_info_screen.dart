import 'package:couple_calendar/service/auth_service.dart';
import 'package:couple_calendar/ui/auth/view_model/add_user_info_view_model.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/couple_text_field.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../util/couple_style.dart';
import '../../../util/validator.dart';
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
  void didChangeDependencies() {
    timeDilation = 1;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddUserInfoViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return DefaultLayout(
          title: tr('additional_info_title'),
          leading: _leading(),
          onPressed: viewModel.focusout,
          resizeToAvoidBottomInset: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
            child: Column(
              children: [
                _buildNameField(),
                SizedBox(height: 4.toHeight),
                _buildIdField(),
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
    return StreamBuilder<bool>(
      initialData: false,
      stream: Rx.combineLatest2(
        viewModel.nameController.statusStream!,
        viewModel.idController.statusStream!,
        (name, id) => name.isValid && id.isValid,
      ),
      builder: (context, snapshot) {
        final isReady = snapshot.data!;
        return CoupleButton(
          onPressed: isReady ? viewModel.onClickAddInfoBtn : null,
          option: CoupleButtonOption.fill(
            text: tr('regist_btn_txt'),
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
      hintText: tr('input_name_hint_txt'),
      title: 'name',
      onChanged: viewModel.validateName,
    );
  }

  Widget _buildIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoupleTextField(
          controller: viewModel.idController,
          hintText: tr('input_id_hint_txt'),
          title: 'ID',
          inputFormatters: [
            FilteringTextInputFormatter.deny(Validator().kWhiteSpaceRegex),
          ],
          onChanged: viewModel.validateId,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.toWidth),
          child: Text(
            tr('id_notice_txt'),
            style: CoupleStyle.caption(color: CoupleStyle.coral050),
          ),
        ),
      ],
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
