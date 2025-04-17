import 'dart:async';

import 'package:flutter/material.dart';

import '../ui/common/components/logger/couple_logger.dart';

class CoupleRouterObserver extends NavigatorObserver {
  final List<Route<dynamic>?> _history = <Route<dynamic>?>[];

  String getHistoryToString() {
    return _history
        .map((element) => element!.settings.name)
        .toList()
        .toString();
  }

  List<Route<dynamic>> classHistories = [];

  List<String?> getHistories() {
    return _history.map((element) => element!.settings.name).toList();
  }

  Route? get top => _history.last;

  final List<Route<dynamic>?> _poppedRoutes = <Route<dynamic>?>[];

  final StreamController _historyChangeStreamController =
      StreamController.broadcast();

  Stream get historyChangeStream => _historyChangeStreamController.stream;

  static final CoupleRouterObserver _singleton =
      CoupleRouterObserver._internal();

  CoupleRouterObserver._internal();

  factory CoupleRouterObserver() {
    return _singleton;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _history.add(route);
    _poppedRoutes.remove(route);

    try {
      classHistories.add(route);
    } catch (e) {}

    _historyChangeStreamController.add(HistoryChange(
      action: NavigationStackAction.PUSH,
      newRoute: route,
      oldRoute: previousRoute,
    ));
    CoupleLog().i('History Observer : didPush \n${getHistoryToString()}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _poppedRoutes.add(_history.last);

    try {
      classHistories.removeLast();
    } catch (e) {}

    _history.removeLast();
    _historyChangeStreamController.add(HistoryChange(
      action: NavigationStackAction.POP,
      newRoute: route,
      oldRoute: previousRoute,
    ));
    CoupleLog().i('History Observer : didPop \n${getHistoryToString()}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _history.remove(route);

    try {
      classHistories.remove(route);
    } catch (e) {}

    _historyChangeStreamController.add(HistoryChange(
      action: NavigationStackAction.REMOVE,
      newRoute: route,
      oldRoute: previousRoute,
    ));
    CoupleLog().i('History Observer : didRemove \n${getHistoryToString()}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    try {
      if (newRoute is MaterialPageRoute) {
        classHistories.removeLast();
        classHistories.add(newRoute);
      }
    } catch (e) {}

    int oldRouteIndex = _history.indexOf(oldRoute);
    _history.replaceRange(oldRouteIndex, oldRouteIndex + 1, [newRoute]);
    _historyChangeStreamController.add(HistoryChange(
      action: NavigationStackAction.REPLACE,
      newRoute: newRoute,
      oldRoute: oldRoute,
    ));
    CoupleLog().i('History Observer : didReplace \n${getHistoryToString()}');
  }
}

class HistoryChange {
  HistoryChange({this.action, this.newRoute, this.oldRoute});

  final NavigationStackAction? action;
  final Route<dynamic>? newRoute;
  final Route<dynamic>? oldRoute;
}

enum NavigationStackAction { PUSH, POP, REMOVE, REPLACE }
