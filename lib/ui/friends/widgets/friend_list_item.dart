import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/widgets/profile_container.dart';
import 'package:couple_calendar/ui/friends/view/friend_sheet.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

class FriendListItem extends StatelessWidget {
  final UserModel user;

  const FriendListItem({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: () async {
        await Navigator.push(
          context,
          SheetRoute(
            builder: (context) {
              return FriendSheet(friend: user);
            },
          ),
        );
      },
      child: Container(
        child: Row(
          children: [
            ProfileContainer.size40(url: user.profileImg),
            SizedBox(width: 10.toWidth),
            Text(
              user.username,
              style: CoupleStyle.body1(weight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
