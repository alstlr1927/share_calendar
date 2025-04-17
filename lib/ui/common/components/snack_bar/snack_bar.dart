import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

import '../overlay_notification/notification/notification.dart';
import 'snack_bar_theme/snack_bar_theme.dart';

class DefaultSnackBar extends StatelessWidget {
  final String? message;
  final double padding;

  DefaultSnackBar({this.message, this.padding = 0});

  @override
  Widget build(BuildContext context) {
    return SlideDismissible(
      enable: true,
      key: UniqueKey(),
      child: SafeArea(
        minimum: EdgeInsets.fromLTRB(16, 16, 16, 16 + padding),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          elevation: 8,
          color: SnackBarColor.snackbar_base_gray,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.toWidth, vertical: 14.toWidth),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$message',
                  style: CoupleStyle.body2(
                      color: SnackBarColor.snackbar_text_white),
                )),
          ),
        ),
      ),
    );
  }
}

class CustomSnackBar extends StatelessWidget {
  final String? message;
  final double padding;
  final Color? color;

  CustomSnackBar({this.message, this.padding = 0, this.color});

  @override
  Widget build(BuildContext context) {
    return SlideDismissible(
      enable: true,
      key: UniqueKey(),
      child: SafeArea(
        minimum: EdgeInsets.fromLTRB(16, 16, 16, 16 + padding),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          elevation: 8,
          color: SnackBarColor.snackbar_base_gray,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16.toWidth, vertical: 14.toWidth),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$message',
                  style: CoupleStyle.body2(color: color),
                )),
          ),
        ),
      ),
    );
  }
}
