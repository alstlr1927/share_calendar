import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_calendar/main.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../ui/my_schedule/model/schedule_model.dart';

class DataUtils {
  // JsonSerializable로 생성된 모델에서 fromJson 을 할떄 변환 할 데이터 메서드 클래스

  static DateTime parseDateTime(Object? value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    return DateTime.now();
  }

  static UserGender parseUserGender(
    Object? value, {
    UserGender defaultValue = UserGender.NONE,
  }) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return defaultValue;
      if (value is double) return defaultValue;
      if (value is bool) return defaultValue;
      if (value is String) {
        int idx = UserGender.values.indexWhere((e) => e.name == value);
        if (idx != -1) {
          return UserGender.values[idx];
        }
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static ScheduleTheme parseScheduleTheme(
    Object? value, {
    ScheduleTheme defaultValue = ScheduleTheme.WHITE,
  }) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return defaultValue;
      if (value is double) return defaultValue;
      if (value is bool) return defaultValue;
      if (value is String) {
        int idx = ScheduleTheme.values.indexWhere((e) => e.name == value);
        if (idx != -1) {
          return ScheduleTheme.values[idx];
        }
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static List<String> parseMembersString(
    Object? value, {
    List<String> defaultValue = const [],
  }) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return defaultValue;
      if (value is double) return defaultValue;
      if (value is bool) return defaultValue;
      if (value is String) return defaultValue;
      if (value is List) {
        List<String> temp = [];
        for (var e in value) {
          temp.add(e.toString());
        }
        final uid =
            Provider.of<UserProvider>(nav.currentContext!, listen: false)
                .getUid();
        temp.remove(uid);
        return temp;
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static List<String> parseListString(
    Object? value, {
    List<String> defaultValue = const [],
  }) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return defaultValue;
      if (value is double) return defaultValue;
      if (value is bool) return defaultValue;
      if (value is String) return defaultValue;
      if (value is List) {
        List<String> temp = [];
        for (var e in value) {
          temp.add(e.toString());
        }
        return temp;
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  static int parseInt(Object? value, {int defaultValue = 0}) {
    try {
      if (value == null || value == "null") return defaultValue;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is bool) return value ? 1 : 0;
      if (value is String) {
        var temp = int.tryParse(value);
        if (temp == null) return defaultValue;
        return temp;
      }
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  static double parseDouble(Object? value, {double defaultValue = 0.0}) {
    try {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is bool) return value ? 1.0 : 0.0;
      if (value is String) {
        var temp = double.tryParse(value);
        if (temp == null) return defaultValue;
        return temp;
      }
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  static String parseString(Object? value, {String defaultValue = ""}) {
    try {
      if (value == null) return defaultValue;
      if (value is String) return value;
      if (value is int) return value.toString();
      if (value is bool) return value ? "true" : "false";
      if (value is double) return value.toString();
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  static bool parseBoolean(Object? value, {bool defaultValue = false}) {
    try {
      if (value == null) return defaultValue;
      if (value is bool) return value;
      if (value is int) {
        if (value == 1) return true;
        if (value == 0) return false;
        return false;
      }
      if (value is double) {
        if (value == 1.0) return true;
        if (value == 0.0) return false;
        return false;
      }
      if (value is String) {
        if (value.toLowerCase() == 'true') return true;
        if (value.toLowerCase() == '1') return true;
        if (value.toLowerCase() == 'false') return false;
        if (value.toLowerCase() == '0') return true;
        return defaultValue;
      }
      return defaultValue;
    } catch (error) {
      return defaultValue;
    }
  }

  // static List<String> parseListString(Object? value) {
  //   try {
  //     if (value == null) return [];
  //     if (value is List<String>) return value;
  //     return [];
  //   } catch (error) {
  //     return [];
  //   }
  // }
}
