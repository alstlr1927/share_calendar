import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoupleStyle {
  static double appbarHeight = 60.toHeight;

  static List<BoxShadow> elevation_01dp() {
    return [
      BoxShadow(
          color: const Color(0x14000000),
          offset: Offset(0, 3),
          blurRadius: 3,
          spreadRadius: 0),
      BoxShadow(
          color: const Color(0x26000000),
          offset: Offset(0, 0),
          blurRadius: 1,
          spreadRadius: 0)
    ];
  }

  static List<BoxShadow> elevation_03dp() {
    return [
      BoxShadow(
          color: const Color(0x14000000),
          offset: Offset(0, 3),
          blurRadius: 8,
          spreadRadius: 0),
      BoxShadow(
          color: const Color(0x08000000),
          offset: Offset(0, 2),
          blurRadius: 5,
          spreadRadius: 0),
      BoxShadow(
          color: const Color(0x26000000),
          offset: Offset(0, 0),
          blurRadius: 1,
          spreadRadius: 0)
    ];
  }

  static List<BoxShadow> elevation_04dp() {
    return [
      BoxShadow(
          color: const Color(0x1a000000),
          offset: Offset(0, 6),
          blurRadius: 8,
          spreadRadius: 0),
      BoxShadow(
          color: const Color(0x0d000000),
          offset: Offset(0, 1),
          blurRadius: 5,
          spreadRadius: 0),
      BoxShadow(
          color: const Color(0x26000000),
          offset: Offset(0, 0),
          blurRadius: 1,
          spreadRadius: 0)
    ];
  }

  static List<BoxShadow> elevation_06dp() {
    return [
      BoxShadow(
          color: const Color(0x33000000),
          offset: Offset(0, 3),
          blurRadius: 5,
          spreadRadius: -1),
      BoxShadow(
          color: const Color(0x1f000000),
          offset: Offset(0, 1),
          blurRadius: 18,
          spreadRadius: 0),
      BoxShadow(
          color: const Color(0x24000000),
          offset: Offset(0, 6),
          blurRadius: 10,
          spreadRadius: 0)
    ];
  }

  static List<BoxShadow> elevation_8dp() {
    return [
      BoxShadow(
          color: const Color(0x33000000),
          offset: Offset(0, 3),
          blurRadius: 5,
          spreadRadius: -1),
      BoxShadow(
          color: const Color(0x1f000000),
          offset: Offset(0, 1),
          blurRadius: 18,
          spreadRadius: 0),
      BoxShadow(
          color: const Color(0x24000000),
          offset: Offset(0, 6),
          blurRadius: 10,
          spreadRadius: 0)
    ];
  }

  static List<BoxShadow> elevation_24dp() {
    return [
      BoxShadow(
          color: const Color(0x33000000),
          offset: Offset(0, 11),
          blurRadius: 15,
          spreadRadius: -7),
      BoxShadow(
          color: const Color(0x1f000000),
          offset: Offset(0, 9),
          blurRadius: 46,
          spreadRadius: 8),
      BoxShadow(
          color: const Color(0x24000000),
          offset: Offset(0, 24),
          blurRadius: 38,
          spreadRadius: 3)
    ];
  }

  static double defaultBottomPadding() {
    if (ScreenUtil().bottomBarHeight == 0) {
      return 16.0;
    } else {
      return ScreenUtil().bottomBarHeight;
    }
  }

  static double get bottomActionHeight => defaultBottomPadding() + 50.toHeight;

  static double safeAreaPadding() {
    if (ScreenUtil().bottomBarHeight == 0) {
      return 0.0;
    } else {
      return ScreenUtil().bottomBarHeight;
    }
  }

  static TextStyle title({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(28),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 41 / 28,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle h1({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(48),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle h2({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(34),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 50 / 34,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle h3({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(24),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 36 / 24,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle h4({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(20),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 29 / 20,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle h5({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(18),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 27 / 18,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle body1({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(16),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 24 / 16,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle body2({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(14),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 20 / 14,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle caption({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(12),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 18 / 12,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static TextStyle overline({Color? color, FontWeight? weight}) {
    return TextStyle(
        fontSize: ScreenUtil().setSp(10),
        color: color ?? const Color(0xff333333),
        fontWeight: weight ?? FontWeight.normal,
        height: 15 / 10,
        leadingDistribution: TextLeadingDistribution.even,
        fontFamily: 'pretendard');
  }

  static const white = Color(0xffffffff);
  static const black = Color(0xff000000);

  static const primary010 = Color(0xFFFFF9FA);
  static const primary020 = Color(0xFFFFEDEF);
  static const primary030 = Color(0xFFFFCDD7);
  static const primary040 = Color(0xFFFF7E8A);
  static const primary050 = Color(0xFFFF475D);
  static const primary060 = Color(0xFFFF334B);
  static const primary070 = Color(0xFFF31237);
  static const primary080 = Color(0xFFD80039);
  static const primary090 = Color(0xFFA8002C);

  static const gray010 = Color(0xFFFCFCFC);
  static const gray020 = Color(0xFFFAFAFA);
  static const gray030 = Color(0xFFF5F5F5);
  static const gray040 = Color(0xFFEEEEEE);
  static const gray050 = Color(0xFFE0E0E0);
  static const gray060 = Color(0xFF9E9E9E);
  static const gray070 = Color(0xFF616161);
  static const gray080 = Color(0xFF424242);
  static const gray090 = Color(0xFF212121);

  static const coral005 = const Color(0xfffff9fa);
  static const coral010 = const Color(0xffffebee);
  static const coral020 = const Color(0xffffccd1);
  static const coral030 = const Color(0xfffa9797);
  static const coral040 = const Color(0xfff46d6d);
  static const coral045 = const Color(0xffFF5F5F);
  static const coral050 = const Color(0xffff4747);
  static const coral055 = const Color(0xffEE4A4A);
  static const coral060 = const Color(0xffff2f27);
  static const coral070 = const Color(0xfff62229);
  static const coral080 = const Color(0xffe41023);
  static const coral090 = const Color(0xffd7001b);
  static const coral100 = const Color(0xffc7000d);

  static const violet010 = const Color(0xffece5ff);
  static const violet020 = const Color(0xffccc0fd);
  static const violet030 = const Color(0xffa796fd);
  static const violet040 = const Color(0xFF7C6BFF);
  static const violet050 = const Color(0xFF514AFF);
  static const violet060 = const Color(0xff082bf3);
  static const violet070 = const Color(0xff0028ed);
  static const violet080 = const Color(0xff0021e4);
  static const violet090 = const Color(0xff001ddc);

  static const subGreen = Color(0xFF4FCB6B);
  static const subYellow = Color(0xFFF8C030);
  static const subYellow24 = Color(0xFFFDF0CD);
  static const subYellow40 = Color(0xFFFCE6AC);
  static const subBlue = Color(0xFF1873FF);
  static const subBlue10 = Color(0xFFE8F1FF);
  static const negationRed = Color(0xFFC7000D);

  static ThemeData coupleTheme = ThemeData(
    fontFamily: 'pretendard',
    scaffoldBackgroundColor: white,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      titleTextStyle: body1(
        weight: FontWeight.w600,
        color: gray090,
      ),
      toolbarHeight: appbarHeight,
      iconTheme: const IconThemeData(color: gray090),
      backgroundColor: white,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
  );
}
