import 'package:couple_calendar/ui/comment/model/comment_model.dart';
import 'package:couple_calendar/ui/common/widgets/profile_container.dart';
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
          children: [
            ProfileContainer.size40(url: comment.userImage),
            SizedBox(width: 12.toWidth),
            Text('${comment.userName}')
          ],
        );
      },
    );
  }
}
