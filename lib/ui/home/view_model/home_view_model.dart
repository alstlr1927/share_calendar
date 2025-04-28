import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../provider/time_line_provider.dart';

class HomeViewModel extends ChangeNotifier {
  State state;

  ScrollController scrollController = ScrollController();

  DateTime today = DateTime.now();

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  HomeViewModel(this.state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final top = Provider.of<TimeLineProvider>(state.context, listen: false)
          .curTimeLineTop;
      double offset = top;
      if (top > ScreenUtil().screenHeight * .3) {
        offset -= (ScreenUtil().screenHeight * .3);
      }
      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    });
  }
}
