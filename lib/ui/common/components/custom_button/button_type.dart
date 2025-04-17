part of couple_button;

abstract class CoupleButtonStyle {
  CoupleButtonStyle();
}

abstract class CoupleButtonTheme {
  CoupleButtonTheme();
}

/* STYLE===================================================*/

class CoupleButtonFillStyle extends CoupleButtonStyle {
  final double height;
  final double? minWidth;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double borderRadius;

  static CoupleButtonFillStyle get fullLarge => CoupleButtonFillStyle(
        height: 56.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 18),
        borderRadius: 8,
        textStyle: CoupleStyle.body1(weight: FontWeight.w600),
      );

  static CoupleButtonFillStyle get large => CoupleButtonFillStyle(
        height: 56.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 18),
        minWidth: 88.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.body1(weight: FontWeight.w600),
      );

  static CoupleButtonFillStyle get xsmall => CoupleButtonFillStyle(
        height: 28.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 8),
        minWidth: 73.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.caption(weight: FontWeight.w600),
      );

  static CoupleButtonFillStyle get small => CoupleButtonFillStyle(
        height: 36.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 16),
        minWidth: 52.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.body2(weight: FontWeight.w600),
      );

  static CoupleButtonFillStyle get fullSmall => CoupleButtonFillStyle(
        height: 36.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 16),
        borderRadius: 8,
        textStyle: CoupleStyle.body2(weight: FontWeight.w600),
      );

  static CoupleButtonFillStyle get regular => CoupleButtonFillStyle(
        height: 48.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 16),
        minWidth: 88.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.body1(weight: FontWeight.w600),
      );

  static CoupleButtonFillStyle get fullRegular => CoupleButtonFillStyle(
        height: 48.toWidth,
        padding: EdgeInsets.zero,
        borderRadius: 8,
        textStyle: CoupleStyle.body1(weight: FontWeight.w600),
      );

  CoupleButtonFillStyle({
    required this.height,
    this.minWidth,
    required this.padding,
    required this.textStyle,
    required this.borderRadius,
  });

  CoupleButtonFillStyle copyWith({
    double? height,
    double? minWidth,
    EdgeInsets? padding,
    TextStyle? textStyle,
    double? borderRadius,
  }) {
    return CoupleButtonFillStyle(
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

class CoupleButtonLineStyle extends CoupleButtonStyle {
  final double height;
  final double? minWidth;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double borderRadius;

  static CoupleButtonLineStyle get large => CoupleButtonLineStyle(
        height: 56.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 18),
        minWidth: 88.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.body1(weight: FontWeight.w600),
      );

  static CoupleButtonLineStyle get regular => CoupleButtonLineStyle(
        height: 48.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 16),
        minWidth: 88.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.body1(weight: FontWeight.w600),
      );

  static CoupleButtonLineStyle get xsmall => CoupleButtonLineStyle(
        height: 28.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 8),
        minWidth: 73.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.caption(weight: FontWeight.w600),
      );

  static CoupleButtonLineStyle get small => CoupleButtonLineStyle(
        height: 36.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 16),
        minWidth: 52.toWidth,
        borderRadius: 8,
        textStyle: CoupleStyle.body2(weight: FontWeight.w600),
      );

  static CoupleButtonLineStyle get fullSmall => CoupleButtonLineStyle(
        height: 36.toWidth,
        padding: EdgeInsets.symmetric(horizontal: 16),
        borderRadius: 8,
        textStyle: CoupleStyle.body2(weight: FontWeight.w600),
      );

  static CoupleButtonLineStyle get fullRegular => CoupleButtonLineStyle(
        height: 48.toWidth,
        padding: EdgeInsets.zero,
        borderRadius: 8,
        textStyle: CoupleStyle.body1(weight: FontWeight.w600),
      );

  CoupleButtonLineStyle(
      {required this.height,
      this.minWidth,
      required this.padding,
      required this.textStyle,
      required this.borderRadius});

  CoupleButtonLineStyle copyWith({
    double? height,
    double? minWidth,
    EdgeInsets? padding,
    TextStyle? textStyle,
    double? borderRadius,
  }) {
    return CoupleButtonLineStyle(
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      padding: padding ?? this.padding,
      textStyle: textStyle ?? this.textStyle,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}

class CoupleButtonIconStyle extends CoupleButtonStyle {
  double size;

  static CoupleButtonIconStyle get small => CoupleButtonIconStyle(
        size: 16.toWidth,
      );

  static CoupleButtonIconStyle get regular => CoupleButtonIconStyle(
        size: 24.toWidth,
      );

  CoupleButtonIconStyle({required this.size});
}

class CoupleButtonTextStyle extends CoupleButtonStyle {
  final double height;
  final double minWidth;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final double borderRadius;

  static CoupleButtonTextStyle get small => CoupleButtonTextStyle(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: 8,
        minWidth: 48.toWidth,
        height: 26.toWidth,
        textStyle: CoupleStyle.caption(weight: FontWeight.w600),
      );

  static CoupleButtonTextStyle get regular => CoupleButtonTextStyle(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: 8,
        minWidth: 52.toWidth,
        height: 28.toWidth,
        textStyle: CoupleStyle.body2(weight: FontWeight.w600),
      );

  CoupleButtonTextStyle(
      {required this.padding,
      required this.height,
      required this.minWidth,
      required this.textStyle,
      required this.borderRadius});
}

/* THEME===================================================*/

class CoupleButtonColors {
  static const button_base_white = CoupleStyle.white;
  static const button_base_gray = CoupleStyle.gray040;
  static const button_base_magenta = CoupleStyle.primary050;
  static const button_base_lightMagenta = CoupleStyle.primary020;

  static const button_text_white = CoupleStyle.white;
  static const button_text_gray = CoupleStyle.gray070;
  static const button_text_deepGray = CoupleStyle.gray090;
  static const button_text_magenta = CoupleStyle.primary050;
  static const button_text_blue = CoupleStyle.subBlue;
  static const button_text_negationRed = CoupleStyle.negationRed;

  static const button_disabled_text_gray = CoupleStyle.gray060;
  static const button_disabled_base_gray = CoupleStyle.gray040;
  static const button_disabled_line_gray = CoupleStyle.gray050;

  static const button_line_negationRed = CoupleStyle.negationRed;

  static const button_loading_base_gray = CoupleStyle.gray040;
  static const button_loading_line_gray = CoupleStyle.gray050;
}

class CoupleButtonFillTheme extends CoupleButtonTheme {
  final Color baseColor;
  final Color textColor;
  final Color disabledBaseColor;
  final Color disabledTextColor;
  final Color loadingColor;

  static CoupleButtonFillTheme get lightMagenta => CoupleButtonFillTheme(
        baseColor: CoupleButtonColors.button_base_lightMagenta,
        textColor: CoupleButtonColors.button_text_magenta,
        disabledBaseColor: CoupleButtonColors.button_disabled_base_gray,
        disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
        loadingColor: CoupleButtonColors.button_loading_base_gray,
      );

  static CoupleButtonFillTheme get magenta => CoupleButtonFillTheme(
        baseColor: CoupleButtonColors.button_base_magenta,
        textColor: CoupleButtonColors.button_text_white,
        disabledBaseColor: CoupleButtonColors.button_disabled_base_gray,
        disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
        loadingColor: CoupleButtonColors.button_loading_base_gray,
      );

  static CoupleButtonFillTheme get gray => CoupleButtonFillTheme(
        baseColor: CoupleButtonColors.button_base_gray,
        textColor: CoupleButtonColors.button_text_gray,
        disabledBaseColor: CoupleButtonColors.button_disabled_base_gray,
        disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
        loadingColor: CoupleButtonColors.button_loading_base_gray,
      );

  static CoupleButtonFillTheme get orange => CoupleButtonFillTheme(
        baseColor: Color(0xFFFF7742),
        textColor: CoupleButtonColors.button_text_white,
        disabledBaseColor: CoupleButtonColors.button_disabled_base_gray,
        disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
        loadingColor: CoupleButtonColors.button_loading_base_gray,
      );

  static CoupleButtonFillTheme get blue => CoupleButtonFillTheme(
        baseColor: CoupleStyle.subBlue,
        textColor: CoupleButtonColors.button_text_white,
        disabledBaseColor: CoupleButtonColors.button_disabled_base_gray,
        disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
        loadingColor: CoupleButtonColors.button_loading_base_gray,
      );

  static CoupleButtonFillTheme get lightBlue => CoupleButtonFillTheme(
        baseColor: CoupleStyle.subBlue10,
        textColor: CoupleStyle.subBlue,
        disabledBaseColor: CoupleButtonColors.button_disabled_base_gray,
        disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
        loadingColor: CoupleButtonColors.button_loading_base_gray,
      );

  static CoupleButtonFillTheme custom({
    required Color baseColor,
    required Color textColor,
  }) =>
      CoupleButtonFillTheme(
        baseColor: baseColor,
        textColor: textColor,
        disabledBaseColor: CoupleButtonColors.button_disabled_base_gray,
        disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
        loadingColor: CoupleButtonColors.button_loading_base_gray,
      );

  CoupleButtonFillTheme(
      {required this.baseColor,
      required this.textColor,
      required this.disabledBaseColor,
      required this.disabledTextColor,
      required this.loadingColor});
}

class CoupleButtonLineTheme extends CoupleButtonTheme {
  final Color baseColor;
  final Color textColor;
  final Color lineColor;
  final Color disabledBaseColor;
  final Color disabledTextColor;
  final Color disabledLineColor;
  final Color loadingColor;

  static CoupleButtonLineTheme get negationRed => CoupleButtonLineTheme(
      baseColor: CoupleButtonColors.button_base_white,
      textColor: CoupleButtonColors.button_text_negationRed,
      lineColor: CoupleButtonColors.button_line_negationRed,
      disabledBaseColor: CoupleButtonColors.button_base_white,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray,
      disabledLineColor: CoupleButtonColors.button_disabled_line_gray,
      loadingColor: CoupleButtonColors.button_loading_line_gray);

  static CoupleButtonLineTheme get deepGray => CoupleButtonLineTheme(
      baseColor: CoupleStyle.white,
      textColor: CoupleStyle.gray090,
      lineColor: CoupleStyle.gray050,
      disabledBaseColor: CoupleStyle.white,
      disabledTextColor: CoupleStyle.gray060,
      disabledLineColor: CoupleStyle.gray050,
      loadingColor: CoupleStyle.gray050);

  CoupleButtonLineTheme(
      {required this.baseColor,
      required this.textColor,
      required this.lineColor,
      required this.disabledBaseColor,
      required this.disabledTextColor,
      required this.disabledLineColor,
      required this.loadingColor});
}

class CoupleButtonIconTheme extends CoupleButtonTheme {
  final Color textColor;
  final Color disabledTextColor;

  static CoupleButtonIconTheme get deepGray => CoupleButtonIconTheme(
      textColor: CoupleButtonColors.button_text_deepGray,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray);

  static CoupleButtonIconTheme get white => CoupleButtonIconTheme(
      textColor: CoupleButtonColors.button_text_white,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray);

  static CoupleButtonIconTheme get subBlue => CoupleButtonIconTheme(
      textColor: CoupleButtonColors.button_text_blue,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray);

  CoupleButtonIconTheme(
      {required this.textColor, required this.disabledTextColor});

  CoupleButtonIconTheme copyWith({
    Color? textColor,
    Color? disabledTextColor,
  }) {
    return CoupleButtonIconTheme(
      textColor: textColor ?? this.textColor,
      disabledTextColor: disabledTextColor ?? this.disabledTextColor,
    );
  }
}

class CoupleButtonTextTheme extends CoupleButtonTheme {
  final Color textColor;
  final Color disabledTextColor;

  static CoupleButtonTextTheme get gray => CoupleButtonTextTheme(
      textColor: CoupleButtonColors.button_text_gray,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray);

  static CoupleButtonTextTheme get magenta => CoupleButtonTextTheme(
      textColor: CoupleButtonColors.button_text_magenta,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray);
  static CoupleButtonTextTheme get subBlue => CoupleButtonTextTheme(
      textColor: CoupleStyle.subBlue,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray);

  static CoupleButtonTextTheme get negationRed => CoupleButtonTextTheme(
      textColor: CoupleButtonColors.button_text_negationRed,
      disabledTextColor: CoupleButtonColors.button_disabled_text_gray);

  CoupleButtonTextTheme(
      {required this.textColor, required this.disabledTextColor});
}

class CoupleButtonOption {
  final String? text;
  final IconData? icon;
  final CoupleButtonTheme theme;
  final CoupleButtonStyle style;

  CoupleButtonOption.fill(
      {required this.text,
      required CoupleButtonFillTheme theme,
      required CoupleButtonFillStyle style})
      : theme = theme,
        style = style,
        icon = null;

  CoupleButtonOption.line(
      {required this.text,
      required CoupleButtonLineTheme theme,
      required CoupleButtonLineStyle style})
      : theme = theme,
        style = style,
        icon = null;

  CoupleButtonOption.icon(
      {required this.icon,
      required CoupleButtonIconTheme theme,
      required CoupleButtonIconStyle style})
      : theme = theme,
        style = style,
        text = '';

  CoupleButtonOption.text(
      {required this.text,
      required CoupleButtonTextTheme theme,
      required CoupleButtonTextStyle style})
      : theme = theme,
        style = style,
        icon = null;
}
