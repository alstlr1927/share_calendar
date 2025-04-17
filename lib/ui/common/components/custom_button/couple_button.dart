library couple_button;

import 'package:couple_calendar/util/couple_util.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../util/couple_style.dart';
import '../indicator/couple_indicator.dart';
import 'base_button.dart';

part 'button_type.dart';

class CoupleButton extends StatefulWidget {
  final Function? onPressed;
  final CoupleButtonOption option;

  CoupleButton({
    required this.option,
    this.onPressed,
  });

  @override
  CoupleButtonState createState() => CoupleButtonState();
}

class CoupleButtonState extends State<CoupleButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    CoupleButtonTheme theme = widget.option.theme;
    if (theme is CoupleButtonFillTheme) {
      return _Fill(option: widget.option, onPressed: widget.onPressed);
    } else if (theme is CoupleButtonLineTheme) {
      return _Line(option: widget.option, onPressed: widget.onPressed);
    } else if (theme is CoupleButtonTextTheme) {
      return _Text(option: widget.option, onPressed: widget.onPressed);
    } else {
      return _Icon(option: widget.option, onPressed: widget.onPressed);
    }
  }
}

class CoupleDropdownButton extends StatelessWidget {
  final bool isOpen;
  final String hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;

  const CoupleDropdownButton({
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.isOpen = false,
    this.selectedItemBuilder,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = const Offset(0, 0),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        //To avoid long text overflowing.
        isExpanded: true,
        hint: Container(
          alignment: hintAlignment,
          child: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: CoupleStyle.body2(
                color: isOpen ? CoupleStyle.gray070 : CoupleStyle.gray090),
          ),
        ),
        value: value,
        items: dropdownItems
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    alignment: valueAlignment,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: CoupleStyle.body1(color: CoupleStyle.gray090),
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
        buttonStyleData: ButtonStyleData(
          height: buttonHeight ?? 40,
          width: buttonWidth ?? 130,
          padding: buttonPadding ?? const EdgeInsets.only(left: 16, right: 16),
          decoration: buttonDecoration ??
              BoxDecoration(
                color: isOpen ? CoupleStyle.gray040 : CoupleStyle.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: CoupleStyle.gray050,
                ),
              ),
          elevation: buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: icon ?? const Icon(Icons.abc),
          iconSize: iconSize ?? 12,
          iconEnabledColor: iconEnabledColor,
          iconDisabledColor: iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          //Max height for the dropdown menu & becoming scrollable if there are more items. If you pass Null it will take max height possible for the items.
          maxHeight: dropdownHeight ?? 200,
          width: dropdownWidth ?? 130,
          padding: dropdownPadding ??
              EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
          decoration: dropdownDecoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
          elevation: dropdownElevation ?? 8,
          //Null or Offset(0, 0) will open just under the button. You can edit as you want.
          offset: offset,
          //Default is false to show menu below button
          isOverButton: false,
          scrollbarTheme: ScrollbarThemeData(
            radius: scrollbarRadius ?? const Radius.circular(40),
            thickness: scrollbarThickness != null
                ? MaterialStateProperty.all<double>(scrollbarThickness!)
                : null,
            thumbVisibility: scrollbarAlwaysShow != null
                ? MaterialStateProperty.all<bool>(scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: itemHeight ?? 40,
          padding: itemPadding ?? const EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}

class _Fill extends StatefulWidget {
  final Function? onPressed;
  final CoupleButtonOption option;

  _Fill({
    required this.option,
    this.onPressed,
  });

  @override
  _FillState createState() => _FillState();
}

class _FillState extends State<_Fill> with SingleTickerProviderStateMixin {
  bool inProgress = false;

  void setProgress({required bool inProgress}) {
    if (mounted) {
      setState(() {
        this.inProgress = inProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoupleButtonFillTheme theme = widget.option.theme as CoupleButtonFillTheme;
    CoupleButtonFillStyle style = widget.option.style as CoupleButtonFillStyle;

    bool enabled = widget.onPressed != null && !inProgress;

    Color backgroundColor = enabled ? theme.baseColor : theme.disabledBaseColor;
    double borderRadius = style.borderRadius;
    double? minWidth = style.minWidth;
    double height = style.height;
    EdgeInsets padding = style.padding;
    String? text = widget.option.text;
    TextStyle textStyle = style.textStyle
        .copyWith(color: enabled ? theme.textColor : theme.disabledTextColor);

    return BaseButton(
        onPressed: enabled
            ? () async {
                setProgress(inProgress: true);
                await widget.onPressed?.call();
                setProgress(inProgress: false);
              }
            : null,
        child: Container(
          constraints: minWidth == null
              ? BoxConstraints.expand(height: height)
              : BoxConstraints(
                  minHeight: height,
                  minWidth: minWidth,
                ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: inProgress
                      ? Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            if (text != null) ...{
                              Text(
                                '$text',
                                style: textStyle.copyWith(
                                    color: Colors.transparent),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            },
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CupertinoTheme(
                                      data: CupertinoThemeData(
                                        brightness: Brightness.light,
                                      ),
                                      child: CoupleIndicator(
                                        animating: true,
                                        radius: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              if (text != null) ...{
                                Text(
                                  '${text.isEmpty ? ' ' : text}',
                                  style: textStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              },
                            ],
                          ),
                        )),
            ),
          ),
        ));
  }
}

class _Line extends StatefulWidget {
  final Function? onPressed;
  final CoupleButtonOption option;

  _Line({
    required this.option,
    this.onPressed,
  });

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<_Line> with SingleTickerProviderStateMixin {
  bool inProgress = false;

  void setProgress({required bool inProgress}) {
    if (mounted) {
      setState(() {
        this.inProgress = inProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoupleButtonLineTheme theme = widget.option.theme as CoupleButtonLineTheme;
    CoupleButtonLineStyle style = widget.option.style as CoupleButtonLineStyle;

    bool enabled = widget.onPressed != null && !inProgress;

    Color backgroundColor = enabled ? theme.baseColor : theme.disabledBaseColor;
    Color borderColor = enabled ? theme.lineColor : theme.disabledLineColor;
    double borderRadius = style.borderRadius;
    double? minWidth = style.minWidth;
    double height = style.height;
    EdgeInsets padding = style.padding;
    String? text = widget.option.text;
    TextStyle textStyle = style.textStyle
        .copyWith(color: enabled ? theme.textColor : theme.disabledTextColor);
    return BaseButton(
        onPressed: enabled
            ? () async {
                setProgress(inProgress: true);
                await widget.onPressed?.call();
                setProgress(inProgress: false);
              }
            : null,
        child: Container(
          constraints: minWidth == null
              ? BoxConstraints.expand(height: height)
              : BoxConstraints(
                  minHeight: height,
                  minWidth: minWidth,
                ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: 1),
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: inProgress
                      ? Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            if (text != null) ...{
                              Text(
                                '$text',
                                style: textStyle.copyWith(
                                    color: Colors.transparent),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            },
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CupertinoTheme(
                                      data: CupertinoThemeData(
                                        brightness: Brightness.light,
                                      ),
                                      child: CoupleIndicator(
                                        animating: true,
                                        radius: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (text != null) ...{
                                Text(
                                  '$text',
                                  style: textStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              },
                            ],
                          ),
                        )),
            ),
          ),
        ));
  }
}

class _Icon extends StatefulWidget {
  final Function? onPressed;
  final CoupleButtonOption option;

  _Icon({
    required this.option,
    this.onPressed,
  });

  @override
  _IconState createState() => _IconState();
}

class _IconState extends State<_Icon> with SingleTickerProviderStateMixin {
  bool inProgress = false;

  void setProgress({required bool inProgress}) {
    if (mounted) {
      setState(() {
        this.inProgress = inProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoupleButtonIconTheme theme = widget.option.theme as CoupleButtonIconTheme;
    CoupleButtonIconStyle style = widget.option.style as CoupleButtonIconStyle;

    bool enabled = widget.onPressed != null && !inProgress;

    double size = style.size;
    Color backgroundColor = enabled ? theme.textColor : theme.disabledTextColor;
    IconData? icon = widget.option.icon;
    return BaseButton(
        onPressed: enabled
            ? () async {
                setProgress(inProgress: true);
                await widget.onPressed?.call();
                setProgress(inProgress: false);
              }
            : null,
        child: AnimatedSwitcher(
            duration: Duration(milliseconds: 100),
            child: inProgress
                ? Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      if (icon != null) ...{
                        Icon(icon, size: size, color: Colors.transparent)
                      },
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CupertinoTheme(
                            data: CupertinoThemeData(
                              brightness: Brightness.light,
                            ),
                            child: CoupleIndicator(
                              animating: true,
                              radius: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : FittedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...{
                          Icon(icon, size: size, color: backgroundColor)
                        },
                      ],
                    ),
                  )));
  }
}

class _Text extends StatefulWidget {
  final Function? onPressed;
  final CoupleButtonOption option;

  _Text({
    required this.option,
    this.onPressed,
  });

  @override
  _TextState createState() => _TextState();
}

class _TextState extends State<_Text> with SingleTickerProviderStateMixin {
  bool inProgress = false;

  void setProgress({required bool inProgress}) {
    if (mounted) {
      setState(() {
        this.inProgress = inProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoupleButtonTextTheme theme = widget.option.theme as CoupleButtonTextTheme;
    CoupleButtonTextStyle style = widget.option.style as CoupleButtonTextStyle;

    bool enabled = widget.onPressed != null && !inProgress;

    Color backgroundColor = Colors.transparent;
    double borderRadius = style.borderRadius;
    double height = style.height;
    double minWidth = style.minWidth;
    EdgeInsets padding = style.padding;
    String? text = widget.option.text;
    TextStyle textStyle = style.textStyle
        .copyWith(color: enabled ? theme.textColor : theme.disabledTextColor);

    return BaseButton(
        onPressed: enabled
            ? () async {
                setProgress(inProgress: true);
                await widget.onPressed?.call();
                setProgress(inProgress: false);
              }
            : null,
        child: Container(
          constraints: BoxConstraints(
            minHeight: height,
            minWidth: minWidth,
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 100),
                  child: inProgress
                      ? Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            if (text != null) ...{
                              Text(
                                '$text',
                                style: textStyle.copyWith(
                                    color: Colors.transparent),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            },
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CupertinoTheme(
                                  data: CupertinoThemeData(
                                    brightness: Brightness.light,
                                  ),
                                  child: CoupleIndicator(
                                    animating: true,
                                    radius: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : FittedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (text != null) ...{
                                Text(
                                  '$text',
                                  style: textStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              },
                            ],
                          ),
                        )),
            ),
          ),
        ));
  }
}
