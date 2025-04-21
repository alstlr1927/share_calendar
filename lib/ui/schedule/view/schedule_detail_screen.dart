import 'package:cached_network_image/cached_network_image.dart';
import 'package:couple_calendar/ui/common/components/custom_button/base_button.dart';
import 'package:couple_calendar/ui/common/components/inset_shadow_box/inset_shadow_box.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/ui/schedule/view_model/schedule_detail_view_model.dart';
import 'package:couple_calendar/ui/schedule/widgets/friends_circle_widget.dart';
import 'package:couple_calendar/ui/schedule/widgets/map_widget.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../model/schedule_model.dart';

class ScheduleDetailScreen extends StatefulWidget {
  static String get routeName => 'schedule_detail';
  final String scheduleId;

  const ScheduleDetailScreen({
    super.key,
    required this.scheduleId,
  });

  @override
  State<ScheduleDetailScreen> createState() => _ScheduleDetailScreenState();
}

class _ScheduleDetailScreenState extends State<ScheduleDetailScreen> {
  late ScheduleDetailViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ScheduleDetailViewModel(this, scheduleId: widget.scheduleId);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScheduleDetailViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return Consumer<ScheduleDetailViewModel>(
          builder: (_, vm, __) {
            if (!vm.isReady) {
              return _loadView();
            }
            final title = vm.schedule.title;
            final theme = vm.schedule.theme;
            return DefaultLayout(
              title: title,
              titleColor: theme.textColor,
              appbarBackgroundColor: theme.backColor,
              actions: [_moreActions(theme.textColor)],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.toWidth),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _buildContentArea(),
                      _buildDateArea(),
                      _buildMemberArea(),
                      _buildMapArea(),
                      SizedBox(height: CoupleStyle.defaultBottomPadding()),
                    ].superJoin(SizedBox(height: 10.toHeight)).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMapArea() {
    return Builder(
      builder: (context) {
        final vm = Provider.of<ScheduleDetailViewModel>(context, listen: false);
        if (vm.schedule.latitude == 0.0) {
          return const SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.toHeight),
            _titleText(title: '장소'),
            SizedBox(height: 4.toHeight),
            Row(
              children: [
                Text(
                  vm.schedule.location,
                  style: CoupleStyle.body2(
                    color: vm.schedule.theme.textColor,
                  ),
                ),
                SizedBox(width: 10.toWidth),
                BaseButton(
                  onPressed: viewModel.onClickCopyLocationBtn,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.toWidth, vertical: 4.toHeight),
                    decoration: BoxDecoration(
                      color: vm.schedule.theme.backColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          vm.schedule.theme.textColor, BlendMode.srcATop),
                      child: SvgPicture.asset(
                        copyIcon,
                        width: 16.toWidth,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.toHeight),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: MapWidget(
                    latitude: vm.schedule.latitude,
                    longitude: vm.schedule.longitude,
                    theme: vm.schedule.theme,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMemberArea() {
    return Builder(
      builder: (context) {
        final vm = Provider.of<ScheduleDetailViewModel>(context, listen: false);
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.toHeight),
              _titleText(title: '참여 인원'),
              SizedBox(height: 6.toHeight),
              Wrap(
                children: vm.memberList
                    .map((e) => FriendsCircleWidget(friend: e))
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateArea() {
    return Builder(
      builder: (context) {
        final schedule =
            Provider.of<ScheduleDetailViewModel>(context, listen: false)
                .schedule;
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.toHeight),
              _titleText(title: '시간'),
              SizedBox(height: 4.toHeight),
              Row(
                children: [
                  Text(
                    CoupleUtil().dateTimeToString(schedule.startDate),
                    style: CoupleStyle.body2(
                      color: schedule.theme.textColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 10.toWidth),
                  _timeBox(time: schedule.startDate, theme: schedule.theme),
                  Text(
                    ' ~ ',
                    style: CoupleStyle.body2(
                      color: schedule.theme.textColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  _timeBox(time: schedule.endDate, theme: schedule.theme),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentArea() {
    return Builder(
      builder: (context) {
        final schedule =
            Provider.of<ScheduleDetailViewModel>(context, listen: false)
                .schedule;

        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 10.toHeight),
              // ShaderMask(
              //   shaderCallback: (bounds) {
              //     return LinearGradient(
              //       colors: [Colors.red, Colors.blue],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ).createShader(bounds);
              //   },
              //   blendMode: BlendMode.srcATop,
              //   child: SvgPicture.asset(
              //     editIcon,
              //     width: 100.toWidth,
              //   ),
              // ),
              SizedBox(height: 10.toHeight),
              _titleText(title: '내용'),
              SizedBox(height: 6.toHeight),
              InsetShadowBox(
                color: schedule.theme.backColor,
                child: Text(
                  schedule.content,
                  style: CoupleStyle.body2(weight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _titleText({required String title}) {
    return Text(
      title,
      style: CoupleStyle.body1(
        color: CoupleStyle.gray090,
        weight: FontWeight.w600,
      ),
    );
  }

  Widget _moreActions(Color color) {
    return CupertinoButton(
      onPressed: viewModel.onClickMoreBtn,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
        child: SvgPicture.asset(
          moreIcon,
        ),
      ),
    );
  }

  Widget _loadView() {
    return DefaultLayout(child: const SizedBox.shrink());
  }

  Widget _timeBox({
    required DateTime time,
    required ScheduleTheme theme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.toWidth, vertical: 4.toWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.backColor,
      ),
      child: Center(
        child: Text(
          CoupleUtil().hourToString(
            time,
          ),
          style: CoupleStyle.body2(
            color: theme.textColor,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
