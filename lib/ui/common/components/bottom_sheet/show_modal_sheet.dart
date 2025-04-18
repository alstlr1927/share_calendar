import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_modal_route.dart';

Future<dynamic>? showModalPopUp(
    {BuildContext? context, WidgetBuilder? builder}) {
  if (context?.findRootAncestorStateOfType() == null) {
    return null;
  }
  return Navigator.of(context!, rootNavigator: true).push(
    CupertinoModalRoute(
      barrierColor:
          CupertinoDynamicColor.resolve(Colors.black.withOpacity(.32), context),
      barrierLabel: 'Dismiss',
      builder: builder,
    ),
  );
}

class CupertinoModalRoute<T> extends CustomPopupRoute<T> {
  CupertinoModalRoute({
    this.barrierColor,
    this.barrierLabel,
    this.builder,
    bool? semanticsDismissible,
    ImageFilter? filter,
    RouteSettings? settings,
  }) : super(
          filter: filter,
          settings: settings,
        ) {
    _semanticsDismissible = semanticsDismissible;
  }

  final WidgetBuilder? builder;
  bool? _semanticsDismissible;

  @override
  final String? barrierLabel;

  @override
  final Color? barrierColor;

  @override
  bool get barrierDismissible => true;

  @override
  bool get semanticsDismissible => _semanticsDismissible ?? false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 330);

  Animation<double>? _animation;

  late Tween<Offset> _offsetTween;

  @override
  Animation<double> createAnimation() {
    assert(_animation == null);
    _animation = CurvedAnimation(
      parent: super.createAnimation(),

      // These curves were initially measured from native iOS horizontal page
      // route animations and seemed to be a good match here as well.
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.linearToEaseOut.flipped,
    );
    _offsetTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    );
    return _animation!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double>? animation,
      Animation<double>? secondaryAnimation) {
    return CupertinoUserInterfaceLevel(
      data: CupertinoUserInterfaceLevelData.elevated,
      child: Builder(builder: builder!),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double>? animation,
      Animation<double>? secondaryAnimation, Widget child) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionalTranslation(
        translation: _offsetTween.evaluate(_animation!),
        child: child,
      ),
    );
  }

  @override
  // TODO: implement popGestureEnabled
  bool get popGestureEnabled => throw UnimplementedError();
}
