import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
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
    return Container(
      child: Row(
        children: [
          Container(
            width: 40.toWidth,
            height: 40.toWidth,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(user.profileImg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 10.toWidth),
          Text(
            user.username,
            style: CoupleStyle.body1(weight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
