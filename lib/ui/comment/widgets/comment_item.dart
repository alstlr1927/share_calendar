import 'package:couple_calendar/ui/comment/model/comment_model.dart';
import 'package:couple_calendar/ui/common/widgets/profile_container.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;

  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: null,
      builder: (context, snapshot) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileContainer.size40(url: comment.userImage),
            SizedBox(width: 10.toWidth),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${comment.userName}',
                        style: CoupleStyle.caption(weight: FontWeight.w600),
                      ),
                      SizedBox(width: 4.toWidth),
                      Text(
                        CoupleUtil().getLeaveTime(date: comment.createdAt) +
                            '전',
                        style: CoupleStyle.overline(
                          weight: FontWeight.w500,
                          color: CoupleStyle.gray060,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.toHeight),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.toWidth, vertical: 8.toHeight),
                    decoration: BoxDecoration(
                      color: CoupleStyle.primary020,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      comment.comment,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
