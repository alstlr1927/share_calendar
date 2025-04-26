import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RootViewModel extends ChangeNotifier {
  State state;

  int _curTabIdx = 2;
  int get curTabIdx => _curTabIdx;

  void setCurTabIdx(int idx) {
    _curTabIdx = idx;
  }

  void onClickTabItem(int idx) {
    setCurTabIdx(idx);
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
    super.dispose();
  }

  RootViewModel(this.state) {
    Provider.of<UserProvider>(state.context, listen: false).refreshProfile();
  }
}
