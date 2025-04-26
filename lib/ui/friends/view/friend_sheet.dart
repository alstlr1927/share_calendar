import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/widgets/profile_container.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../util/couple_style.dart';
import '../../auth/model/user_model.dart';
import '../../common/components/drag_to_dispose/drag_to_dispose.dart';
import '../../schedule/model/schedule_model.dart';

class FriendSheet extends StatefulWidget {
  final UserModel friend;

  const FriendSheet({
    super.key,
    required this.friend,
  });

  @override
  State<FriendSheet> createState() => _FriendSheetState();
}

class _FriendSheetState extends State<FriendSheet> {
  @override
  Widget build(BuildContext context) {
    return DragToDispose(
      onPageClosed: () => context.pop(),
      maxHeight: ScreenUtil().screenHeight,
      dragEnable: true,
      backdropTapClosesPanel: true,
      header: _buildProfileView(),
      panelBuilder: (sc, ac) => SizedBox(),
    );
  }

  Widget _buildProfileView() {
    return Material(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: ScreenUtil().screenHeight,
        child: SafeArea(
          top: true,
          child: Column(
            children: [
              _appbar(),
              const Spacer(),
              ProfileContainer.size100(
                url: widget.friend.profileImg,
              ),
              SizedBox(height: 6.toHeight),
              Text(
                widget.friend.username,
                style: CoupleStyle.h5(
                  weight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 40.toHeight),
              Divider(
                height: 1,
                color: CoupleStyle.gray050,
              ),
              SizedBox(height: 20.toHeight),
              _iconButton(),
              SizedBox(height: 20.toHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
      child: SizedBox(
        width: double.infinity,
        height: CoupleStyle.appbarHeight,
        child: Row(
          children: [
            BaseButton(
              onPressed: context.pop,
              child: Icon(
                Icons.close,
                color: CoupleStyle.black,
                size: 26.toWidth,
              ),
            ),
            const Spacer(),
            BaseButton(
              onPressed: () {},
              child: ColorFiltered(
                colorFilter:
                    ColorFilter.mode(CoupleStyle.black, BlendMode.srcATop),
                child: SvgPicture.asset(moreIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton() {
    return BaseButton(
      onPressed: () {
        final now = DateTime.now();
        DateTime startDt = DateTime(now.year, now.month, now.day, now.hour);
        DateTime endDt = startDt.add(const Duration(hours: 1));
        startDt = startDt.add(const Duration(seconds: 1));

        final schedule = ScheduleModel(
          startDate: startDt,
          endDate: endDt,
          memberIds: [widget.friend.uid],
        );
        CoupleRouter().loadScheduleForm(context, schedule: schedule);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            addScheduleIcon,
            width: 26.toWidth,
          ),
          SizedBox(height: 6.toHeight),
          Text(
            '일정 만들기',
            style: CoupleStyle.caption(weight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
