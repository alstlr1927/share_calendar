import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:couple_calendar/ui/auth/repository/user_repository.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/couple_text_field.dart';
import 'package:couple_calendar/ui/common/components/couple_text_field/field_controller.dart';
import 'package:couple_calendar/ui/common/components/custom_button/couple_button.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddFriendDialog extends StatefulWidget {
  const AddFriendDialog({super.key});

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  FieldController controller = FieldController();

  UserModel? findUser;
  bool isSearched = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.toWidth),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: controller.unfocus,
          behavior: HitTestBehavior.translucent,
          child: Container(
            width: double.infinity,
            height: 260.toHeight,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: 12.toWidth, vertical: 12.toHeight),
            child: Column(
              children: [
                CoupleTextField(
                  hintText: '친구의 ID를 검색하세요.',
                  controller: controller,
                ),
                const Spacer(),
                if (findUser != null) ...{
                  _friendWidget(),
                } else ...{
                  _emptyWidget(),
                },
                const Spacer(),
                CoupleButton(
                  onPressed: () async {
                    final id = controller.getStatus.text.trim();
                    final data = await UserRepository()
                        .getUserProfileByUserId(userId: id);

                    if (data != null) {
                      findUser = UserModel.fromJson(data);
                    }

                    isSearched = true;
                    setState(() {});
                  },
                  option: CoupleButtonOption.fill(
                    text: '검색',
                    theme: CoupleButtonFillTheme.magenta,
                    style: CoupleButtonFillStyle.fullRegular,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _friendWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80.toWidth,
          height: 80.toWidth,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: CachedNetworkImageProvider(findUser!.profileImg),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 4.toHeight),
        Text(
          findUser!.username,
          style: CoupleStyle.body1(weight: FontWeight.w500),
        ),
        Builder(
          builder: (context) {
            final friendList = Provider.of<UserProvider>(context, listen: false)
                .user
                .friendList;
            if (friendList.contains(findUser!.uid)) {
              return const SizedBox();
            }
            return Column(
              children: [
                SizedBox(height: 6.toHeight),
                CoupleButton(
                  onPressed: () async {
                    await UserRepository()
                        .addUserFriend(friendUid: findUser!.uid);
                    await Provider.of<UserProvider>(context, listen: false)
                        .refreshProfile();
                    context.pop();
                  },
                  option: CoupleButtonOption.line(
                    text: '친구추가',
                    theme: CoupleButtonLineTheme.deepGray,
                    style: CoupleButtonLineStyle.small,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _emptyWidget() {
    if (isSearched) {
      return Text(
        '해당 아이디의 유저가\n존재하지 않아요 😥',
        style: CoupleStyle.body1(
          weight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    }
    return Container();
  }
}
