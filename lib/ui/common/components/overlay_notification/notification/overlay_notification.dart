import 'package:flutter/material.dart';

import '../overlay.dart';
import 'notification.dart';

OverlaySupportEntry showSnackBar(WidgetBuilder builder,
    {Duration? duration, Key? key, MainAxisAlignment? align}) {
  return showOverlay((context, t) {
    MainAxisAlignment alignment = align ?? MainAxisAlignment.end;
    return Column(
      mainAxisAlignment: alignment,
      children: <Widget>[
        if (alignment == MainAxisAlignment.end) ...{
          BottomSlideNotification(builder: builder, progress: t)
        } else if (alignment == MainAxisAlignment.start) ...{
          TopSlideNotification(builder: builder, progress: t)
        } else ...{
          CenterSlideNotification(builder: builder, progress: t)
        },
      ],
    );
  }, duration: duration, key: key, curve: Curves.fastOutSlowIn);
}

class Toast {
  Toast._private();

  ///Show the view or text notification for a short period of time.  This time
  ///could be user-definable.  This is the default.
  static const LENGTH_SHORT = const Duration(milliseconds: 2000);

  ///Show the view or text notification for a long period of time.  This time
  ///could be user-definable.
  static const LENGTH_LONG = const Duration(milliseconds: 3500);
}

///popup a message in front of screen
///
/// [duration] the duration to show a toast,
/// for most situation, you can use [Toast.LENGTH_SHORT] and [Toast.LENGTH_LONG]
///
void toast({Widget? child, Duration duration = Toast.LENGTH_SHORT}) {
  if (duration <= Duration.zero) {
    //fast fail
    return;
  }

  showOverlay((context, t) {
    return Opacity(
        opacity: t,
        child: Stack(
          children: <Widget>[
            child ?? Container(),
          ],
        ));
  },
      curve: Curves.ease,
      key: const ValueKey('overlay_toast'),
      duration: duration);
}
