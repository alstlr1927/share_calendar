import 'package:couple_calendar/router/couple_router.dart';
import 'package:flutter/material.dart';

class LandingViewModel extends ChangeNotifier {
  State state;

  Future<void> navigateToLogin() async {
    CoupleRouter().loadLogin(state.context);
  }

  Future<void> navigateToSignupEmail() async {
    CoupleRouter().loadSignupEmail(state.context);
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

  LandingViewModel(this.state) {}
}
