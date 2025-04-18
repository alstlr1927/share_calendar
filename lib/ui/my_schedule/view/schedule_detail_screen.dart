import 'package:couple_calendar/ui/common/components/layout/default_layout.dart';
import 'package:couple_calendar/ui/my_schedule/view_model/schedule_detail_view_model.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              child: Container(),
            );
          },
        );
      },
    );
  }

  Widget _moreActions(Color color) {
    return CupertinoButton(
      onPressed: () {},
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
}
