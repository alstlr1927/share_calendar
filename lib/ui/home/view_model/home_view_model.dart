import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view/home_screen.dart';

class HomeViewModel extends ChangeNotifier {
  State state;

  ScrollController scrollController = ScrollController();

  DateTime today = DateTime.now();

  double _curTimeLineTop = 0.0;
  double get curTimeLineTop => _curTimeLineTop;
  void setCurTimeLineTop(double value) => _curTimeLineTop = value;

  void calCurTimeLine() {
    final now = DateTime.now();
    final top = (now.hour + (now.minute / 60)) * HOUR_CELL_HEIGHT;
    setCurTimeLineTop(top);
    notifyListeners();
  }

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
    calCurTimeLine();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double offset = _curTimeLineTop;
      if (_curTimeLineTop > ScreenUtil().screenHeight * .3) {
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
