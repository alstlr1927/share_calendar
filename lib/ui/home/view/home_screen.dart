import 'package:couple_calendar/ui/home/view_model/home_view_model.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/couple_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(this);
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: viewModel,
      builder: (context, _) {
        return SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 22.toWidth),
      child: Text(
        '오늘 일정',
        style: CoupleStyle.h3(
          color: CoupleStyle.gray090,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}
