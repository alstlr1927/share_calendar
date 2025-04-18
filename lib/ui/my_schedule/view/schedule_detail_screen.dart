import 'package:couple_calendar/ui/common/components/inset_shadow_box/inset_shadow_box.dart';
import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/ui/my_schedule/view_model/schedule_detail_view_model.dart';
import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

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
                    children: [
                      _buildContentArea(),
                      _buildDateArea(),
                      _buildMapArea(),
                      SizedBox(height: CoupleStyle.defaultBottomPadding()),
                    ],
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
    return Container();
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
              _titleText(title: '일정 시간'),
              SizedBox(height: 6.toHeight),
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
                  _timeBox(
                      time: schedule.startDate,
                      backColor: schedule.theme.backColor,
                      textColor: schedule.theme.textColor),
                  Text(
                    ' ~ ',
                    style: CoupleStyle.body2(
                      color: schedule.theme.textColor,
                      weight: FontWeight.w700,
                    ),
                  ),
                  _timeBox(
                      time: schedule.endDate,
                      backColor: schedule.theme.backColor,
                      textColor: schedule.theme.textColor),
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
              SizedBox(height: 10.toHeight),
              _titleText(title: '일정 내용'),
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
    required Color backColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.toWidth, vertical: 4.toWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: backColor,
      ),
      child: Center(
        child: Text(
          CoupleUtil().hourToString(
            time,
          ),
          style: CoupleStyle.body2(
            color: textColor,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
