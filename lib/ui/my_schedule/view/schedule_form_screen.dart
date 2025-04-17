import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/couple_text_field.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/ui/my_schedule/view_model/schedule_form_view_model.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../model/schedule_model.dart';

class ScheduleFormScreen extends StatefulWidget {
  static String get routeName => 'schedule_form';

  final String scheduleId;
  final DateTime selectDate;

  const ScheduleFormScreen({
    super.key,
    this.scheduleId = '',
    required this.selectDate,
  });

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  late ScheduleFormViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ScheduleFormViewModel(
      this,
      widget.selectDate,
      scheduleId: widget.scheduleId,
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScheduleFormViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return Selector<ScheduleFormViewModel, bool>(
          selector: (_, vm) => vm.isReady,
          builder: (_, isReady, __) {
            if (!isReady) {
              return _loading();
            }
            return DefaultLayout(
              title: '일정 작성',
              onPressed: viewModel.focusout,
              actions: [_buildConfirmBtn()],
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(
                    parent: const BouncingScrollPhysics()),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                  child: Column(
                    children: [
                      _buildTitleInputArea(),
                      _buildSelectTime(),
                      _buildTagFriendArea(),
                      _buildSelectBackColor(),
                      _buildInputLocation(),
                    ].superJoin(SizedBox(height: 20.toHeight)).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildConfirmBtn() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: Rx.combineLatest2(
        viewModel.titleController.statusStream!,
        viewModel.contentController.statusStream!,
        (title, content) =>
            title.text.trim().isNotEmpty && content.text.trim().isNotEmpty,
      ),
      builder: (context, snapshot) {
        final isReady = snapshot.data!;
        return Padding(
          padding: EdgeInsets.only(right: 16.toWidth),
          child: CoupleButton(
            onPressed: isReady ? viewModel.onClickConfirmBtn : null,
            option: CoupleButtonOption.icon(
              icon: Icons.check,
              theme: CoupleButtonIconTheme.subBlue,
              style: CoupleButtonIconStyle.regular,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagFriendArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(title: '멤버', isRequired: false),
        SizedBox(
          width: double.infinity,
          height: 4.toHeight,
        ),
        Selector<ScheduleFormViewModel, List<UserModel>>(
          selector: (_, vm) => vm.memberUserList,
          builder: (_, list, __) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseButton(
                  onPressed: viewModel.onClickTagFriend,
                  child: Container(
                    width: 40.toWidth,
                    height: 40.toWidth,
                    margin: EdgeInsets.all(3.toWidth),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1.toWidth,
                        color: CoupleStyle.gray070,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: CoupleStyle.gray070,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.toWidth),
                Container(
                  width: 1.toWidth,
                  height: 20.toWidth,
                  margin: EdgeInsets.only(top: 13.toWidth),
                  color: CoupleStyle.gray070,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 3.toWidth),
                        ...list
                            .map((e) => _friendCircle(e))
                            .superJoin(
                              SizedBox(width: 0.toWidth),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _friendCircle(UserModel friend) {
    return BaseButton(
      onPressed: () => viewModel.onClickRemoveFriend(friend.uid),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 46.toWidth,
            height: 46.toWidth,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40.toWidth,
                    height: 40.toWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(friend.profileImg),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 16.toWidth,
                    height: 16.toWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CoupleStyle.coral050,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: CoupleStyle.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.toHeight),
        ],
      ),
    );
  }

  Widget _buildInputLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(title: '장소', isRequired: false),
        SizedBox(height: 4.toHeight),
        Row(
          children: [
            Expanded(
              child: CoupleTextField(
                hintText: '장소를 입력하세요.',
                controller: viewModel.locationController,
              ),
            ),
            SizedBox(width: 10.toWidth),
            CoupleButton(
              onPressed: viewModel.onClickSearchAddressBtn,
              option: CoupleButtonOption.fill(
                text: '주소 검색',
                theme: CoupleButtonFillTheme.lightMagenta,
                style: CoupleButtonFillStyle.regular,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectBackColor() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleText(title: '테마', isRequired: false),
          SizedBox(height: 4.toHeight),
          Selector<ScheduleFormViewModel, ScheduleTheme>(
            selector: (_, vm) => vm.curTheme,
            builder: (_, theme, __) {
              return Wrap(
                spacing: 8.toWidth,
                runSpacing: 8.toWidth,
                children: ScheduleTheme.values.map((e) {
                  final isSelect = e == theme;
                  return _themeItem(
                    theme: e,
                    isSelect: isSelect,
                    onPressed: viewModel.onClickTheme,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSelectTime() {
    return Selector<ScheduleFormViewModel, Tuple2<DateTime, DateTime>>(
      selector: (_, vm) => Tuple2(vm.startDate, vm.endDate),
      builder: (_, tuple, __) {
        final start = tuple.item1;
        final end = tuple.item2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _titleText(title: '날짜 시간', isRequired: false),
            SizedBox(height: 4.toHeight),
            BaseButton(
              onPressed: viewModel.onClickDateBtn,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8.toHeight),
                decoration: BoxDecoration(
                  color: CoupleStyle.white,
                  border:
                      Border.all(width: .8.toWidth, color: CoupleStyle.gray060),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  CoupleUtil().dateTimeToString(start),
                  style: CoupleStyle.body2(weight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 8.toHeight),
            Row(
              children: [
                Flexible(
                  child: BaseButton(
                    onPressed: viewModel.onClickStartDateBtn,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8.toHeight),
                      decoration: BoxDecoration(
                        color: CoupleStyle.gray040,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        CoupleUtil().hourToString(start),
                        style: CoupleStyle.body2(weight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 20.toWidth,
                  alignment: Alignment.center,
                  child: Text(
                    '~',
                    style: CoupleStyle.body1(),
                  ),
                ),
                Flexible(
                  child: BaseButton(
                    onPressed: viewModel.onClickEndDateBtn,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 8.toHeight),
                      decoration: BoxDecoration(
                        color: CoupleStyle.gray040,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        CoupleUtil().hourToString(end),
                        style: CoupleStyle.body2(weight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTitleInputArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(title: '제목'),
        SizedBox(height: 4.toHeight),
        CoupleTextField(
          hintText: '제목을 입력하세요.',
          controller: viewModel.titleController,
        ),
        SizedBox(height: 8.toHeight),
        _titleText(title: '내용'),
        SizedBox(height: 4.toHeight),
        CoupleTextField(
          hintText: '내용을 입력하세요.',
          controller: viewModel.contentController,
        ),
      ],
    );
  }

  Widget _titleText({
    bool isRequired = true,
    required String title,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          if (isRequired)
            TextSpan(
              text: '*',
              style: CoupleStyle.body1(color: CoupleStyle.primary050),
            ),
          TextSpan(text: ' ${title}'),
        ],
        style: CoupleStyle.body1(weight: FontWeight.w700),
      ),
    );
  }

  Widget _themeItem({
    required ScheduleTheme theme,
    required bool isSelect,
    required Function(ScheduleTheme) onPressed,
  }) {
    return BaseButton(
      onPressed: () => onPressed.call(theme),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30.toWidth,
            height: 30.toWidth,
            decoration: BoxDecoration(
              border: Border.all(width: .5.toWidth),
              shape: BoxShape.circle,
              color: theme.backColor,
            ),
          ),
          if (isSelect)
            Container(
              width: 30.toWidth,
              height: 30.toWidth,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CoupleStyle.black.withOpacity(.4),
              ),
              child: Icon(Icons.check, color: CoupleStyle.white),
            ),
        ],
      ),
    );
  }

  Widget _loading() {
    return DefaultLayout(child: const SizedBox.shrink());
  }
}
