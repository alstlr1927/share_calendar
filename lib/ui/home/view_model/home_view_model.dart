import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  State state;

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

  HomeViewModel(this.state) {
    //
  }
}
