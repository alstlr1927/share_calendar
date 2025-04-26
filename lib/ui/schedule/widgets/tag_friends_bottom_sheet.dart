import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/couple_text_field.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/ui/common/components/drag_to_dispose/drag_to_dispose.dart';
import 'package:couple_calendar/ui/common/widgets/profile_container.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_style.dart';

class TagFriendsBottomSheet extends StatefulWidget {
  final List<UserModel> selectedList;
  final Function(List<UserModel>) onAdd;

  const TagFriendsBottomSheet({
    super.key,
    required this.selectedList,
    required this.onAdd,
  });

  @override
  State<TagFriendsBottomSheet> createState() => _TagFriendsBottomSheetState();
}

class _TagFriendsBottomSheetState extends State<TagFriendsBottomSheet> {
  List<UserModel> friendList = [];
  FieldController fieldController = FieldController();

  @override
  void initState() {
    super.initState();
    friendList = List<UserModel>.from(widget.selectedList);
  }

  @override
  void dispose() {
    fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DragToDispose(
      onPageClosed: () => context.pop(),
      maxHeight: ScreenUtil().screenHeight * .55 +
          MediaQuery.of(context).viewInsets.bottom,
      dragEnable: true,
      backdropTapClosesPanel: true,
      panelBuilder: (scrollController, ac) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => fieldController.unfocus(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: CoupleStyle.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22.toWidth),
                child: Column(
                  children: [
                    SizedBox(height: 8.toHeight),
                    Container(
                      width: 80.toWidth,
                      height: 6,
                      decoration: BoxDecoration(
                        color: CoupleStyle.gray050,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(
                      height: 10.toHeight,
                    ),
                    _buildInputFieldArea(),
                    SizedBox(
                      height: 10.toHeight,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: _buildFriendListView(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputFieldArea() {
    return Row(
      children: [
        Expanded(
          child: CoupleTextField(
            controller: fieldController,
          ),
        ),
        SizedBox(width: 10.toWidth),
        CoupleButton(
          onPressed: () {
            if (friendList.length > 10) return;
            widget.onAdd.call(friendList);
            context.pop();
          },
          option: CoupleButtonOption.line(
            text: '완료' + (friendList.isNotEmpty ? ' ${friendList.length}' : ''),
            theme: CoupleButtonLineTheme.deepGray,
            style: CoupleButtonLineStyle.regular,
          ),
        ),
      ],
    );
  }

  Widget _buildFriendListView() {
    return Selector<UserProvider, List<UserModel>>(
      selector: (_, prov) => prov.friendList,
      builder: (_, list, __) {
        return StreamBuilder<FieldStatus>(
          initialData: FieldStatus(),
          stream: fieldController.statusStream,
          builder: (context, snapshot) {
            final text = snapshot.data!.text;

            final viewList =
                list.where((e) => e.username.contains(text)).toList();
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...viewList
                      .map((e) => _friendItem(friend: e))
                      .superJoin(SizedBox(height: 12.toHeight))
                      .toList(),
                  SizedBox(height: 40.toHeight),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _friendItem({required UserModel friend}) {
    final idx = friendList.indexWhere((e) => e.uid == friend.uid);
    final isSelected = idx != -1;

    return BaseButton(
      onPressed: () {
        if (isSelected) {
          friendList.removeAt(idx);
        } else {
          if (friendList.length > 10) {
            return;
          }
          friendList.add(friend);
        }
        setState(() {});
      },
      child: Row(
        children: [
          ProfileContainer.size40(url: friend.profileImg),
          SizedBox(width: 10.toWidth),
          Text(
            friend.username,
            style: CoupleStyle.body2(
              weight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          _checkWidget(isSelected),
          // SizedBox(width: 10.toWidth),
        ],
      ),
    );
  }

  Widget _checkWidget(bool flag) {
    final fillColor = flag ? CoupleStyle.coral050 : CoupleStyle.white;
    return Container(
      width: 20.toWidth,
      height: 20.toWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: fillColor,
        border: Border.all(
          width: 1.toWidth,
          color: CoupleStyle.coral050,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.check,
          size: 16.toWidth,
          color: CoupleStyle.white,
        ),
      ),
    );
  }
}
