import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  void setIsLoading(bool flag) {
    if (_isLoading == flag) return;

    Future.microtask(() {
      _isLoading = flag;
      notifyListeners();
    });
  }

  LoadingProvider();
}
