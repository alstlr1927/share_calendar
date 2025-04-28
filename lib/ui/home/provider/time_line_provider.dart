import 'dart:async';

import 'package:flutter/material.dart';

import '../view/home_screen.dart';

class TimeLineProvider extends ChangeNotifier {
  double _curTimeLineTop = 0.0;
  double get curTimeLineTop => _curTimeLineTop;
  void setCurTimeLineTop(double value) => _curTimeLineTop = value;

  Timer? timer;

  void calCurTimeLine() {
    final now = DateTime.now();
    final top = (now.hour + (now.minute / 60)) * HOUR_CELL_HEIGHT;
    setCurTimeLineTop(top);
    notifyListeners();
    debugPrint('cal time line');
  }

  void startTimeLineRefresh() async {
    timer = Timer.periodic(const Duration(minutes: 20), (_) {
      debugPrint('refresh');
      calCurTimeLine();
    });
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
