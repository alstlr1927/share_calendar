import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

import '../../../util/couple_style.dart';
import '../../common/components/custom_button/base_button.dart';

class FriendsCircleWidget extends StatelessWidget {
  final UserModel friend;
  final Function()? onPressed;
  final bool isForm;

  const FriendsCircleWidget.forForm({
    super.key,
    required this.friend,
    this.onPressed,
  }) : isForm = true;

  const FriendsCircleWidget({
    super.key,
    required this.friend,
    this.onPressed,
  }) : isForm = false;

  @override
  Widget build(BuildContext context) {
    return BaseButton(
      onPressed: onPressed,
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
                if (isForm)
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
          SizedBox(
            width: 46.toWidth,
            child: Text(
              friend.username,
              style: CoupleStyle.overline(),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
