import 'package:flutter/material.dart';

import '../overlay_notification/notification/overlay_notification.dart';
import '../overlay_notification/overlay.dart';
import 'snack_bar.dart';
import 'snack_bar_theme/snack_bar_theme.dart';

class CoupleNotification {
  CoupleNotification();

  OverlaySupportEntry notify(
      {String? title = '',
      double padding = 0.0,
      MainAxisAlignment align = MainAxisAlignment.end}) {
    final entry = showSnackBar(
      (context) {
        return DefaultSnackBar(message: '$title', padding: padding);
      },
      duration: const Duration(seconds: 1),
      align: align,
    );

    return entry;
  }

  OverlaySupportEntry notifyCustom(
      {String? title = '',
      double padding = 0,
      Color? color = SnackBarColor.snackbar_text_white}) {
    final entry = showSnackBar((context) {
      return CustomSnackBar(message: '$title', padding: padding, color: color);
    });
    return entry;
  }
}
