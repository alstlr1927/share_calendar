import 'package:couple_calendar/util/couple_style.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../util/images.dart';
import '../../../../util/strings.dart';
import 'field_controller.dart';
import 'text_field_theme.dart/text_field_theme.dart';

class CoupleTextField extends StatefulWidget {
  final FieldController? controller;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final String title;
  final bool autoFocus;
  final bool usingMaxLengthValidator;
  final int? maxLength;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final List<TextInputFormatter> inputFormatters;
  final int? maxLines;
  final int? minLines;
  final bool isCollapse;
  final bool isObscure;
  final bool emojiEnable;
  final Iterable<String>? autofillHints;
  final EdgeInsets scrollPadding;

  CoupleTextField({
    Key? key,
    this.controller,
    this.onSubmitted,
    this.onTap,
    this.onChanged,
    this.prefixIcon,
    this.hintText = '',
    this.title = '',
    this.autoFocus = false,
    this.usingMaxLengthValidator = false,
    this.scrollPadding = const EdgeInsets.all(45),
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.maxLines = 1,
    this.minLines,
    this.isCollapse = false,
    this.isObscure = false,
    this.emojiEnable = false,
    this.autofillHints = const <String>[],
  }) : super(key: key);

  @override
  _CoupleTextFieldState createState() => _CoupleTextFieldState();
}

class _CoupleTextFieldState extends State<CoupleTextField> {
  FieldController? _controller;
  BorderRadius borderRadius = BorderRadius.all(Radius.circular(8.0));

  @override
  void initState() {
    if (widget.controller != null) {
      _controller = widget.controller;
    } else {
      _controller = FieldController();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _controller!.statusStream,
        initialData: FieldStatus(),
        builder: (context, snapshot) {
          bool isCollapse = false;
          if (widget.isCollapse &&
              (_controller?.focusNode?.hasFocus ?? false)) {
            isCollapse = true;
          } else {
            isCollapse = false;
          }
          FieldStatus status = (snapshot.data as FieldStatus);

          var suffixWidget;
          if (widget.isObscure) {
            suffixWidget = CupertinoButton(
              padding: EdgeInsets.zero,
              pressedOpacity: .9,
              minSize: 0,
              onPressed: () {
                widget.controller!.setIsObscure(!status.isObscure);
              },
              child: !status.isObscure
                  ? SvgPicture.asset(
                      showPw,
                      width: 20.toWidth,
                    )
                  : SvgPicture.asset(
                      hidePw,
                      width: 20.toWidth,
                    ),
            );
          }
          int textLength = _controller?.status.text.characters.length ?? 0;
          var maxLengthWidget = Padding(
            padding: EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '$textLength',
                  style: CoupleStyle.caption(
                      color: TextFieldColor.textField_default_label),
                ),
                Text(
                  '/${widget.maxLength}',
                  style: CoupleStyle.caption(
                      color: TextFieldColor.textField_default_label),
                ),
              ],
            ),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: widget.title.isEmpty ? 0 : 8.toWidth),
                    child: TextField(
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      inputFormatters: [
                        if (!widget.emojiEnable) ...{
                          FilteringTextInputFormatter.deny(
                              Strings().blockEmojiRegex),
                        },
                        ...widget.inputFormatters,
                      ],
                      autofillHints: widget.autofillHints,
                      obscureText: widget.isObscure ? status.isObscure : false,
                      autofocus: widget.autoFocus,
                      enabled: (status.isFieldEnable),
                      focusNode: _controller!.focusNode,
                      controller: _controller!.textController,
                      keyboardType: widget.keyboardType,
                      cursorColor: TextFieldColor.textField_text,
                      cursorWidth: 1,
                      onAppPrivateCommand: (_, __) {},
                      onSubmitted: (value) {
                        _controller!.unfocus();
                        if (widget.onSubmitted != null) {
                          widget.onSubmitted!(value);
                        }
                      },
                      onTap: widget.onTap,
                      onChanged: (value) {
                        _controller!.setText(value);
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                      },
                      style: CoupleStyle.body2(
                          color: status.isFieldEnable
                              ? TextFieldColor.textField_text
                              : TextFieldColor.textField_disable_text),
                      scrollPadding: widget.scrollPadding,
                      maxLength: widget.maxLength,
                      decoration: InputDecoration(
                        counterText: '',
                        prefixIcon: widget.prefixIcon,
                        suffixIcon: suffixWidget,
                        contentPadding: isCollapse
                            ? EdgeInsets.only(
                                left: 16, right: 16, top: 17, bottom: 36)
                            : EdgeInsets.symmetric(
                                vertical: 12.toHeight, horizontal: 16.toWidth),
                        hintText: (status.hasFocus && widget.title.isNotEmpty)
                            ? ''
                            : '${widget.hintText}',
                        hintStyle: CoupleStyle.body2(
                            color: TextFieldColor.textField_hint_text),
                        isCollapsed: isCollapse,
                        filled: true,
                        fillColor: Colors.white,
                        hintMaxLines: 2,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide:
                              BorderSide(color: CoupleStyle.gray040, width: 1),
                        ),
                        enabledBorder: status.hasError
                            ? OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: BorderSide(
                                    color: TextFieldColor.textField_error_line,
                                    width: 1),
                              )
                            : OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: BorderSide(
                                    color:
                                        TextFieldColor.textField_default_line,
                                    width: 1),
                              ),
                        focusedBorder: status.hasError
                            ? OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: BorderSide(
                                    color: TextFieldColor.textField_error_line,
                                    width: 2),
                              )
                            : OutlineInputBorder(
                                borderRadius: borderRadius,
                                borderSide: BorderSide(
                                    color: TextFieldColor.textField_focus_line,
                                    width: 2),
                              ),
                      ),
                    ),
                  ),
                  if (widget.title.isNotEmpty) ...{
                    Positioned(
                        top: 0,
                        left: 16,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 250),
                          opacity: (widget.title.trim() != '' &&
                                      status.text.trim() != '' ||
                                  status.hasFocus)
                              ? 1.0
                              : 0.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            color: CoupleStyle.white,
                            child: Text(
                              '${widget.title}',
                              style: status.hasFocus
                                  ? CoupleStyle.caption(
                                      color: status.hasError
                                          ? TextFieldColor.textField_error_label
                                          : TextFieldColor
                                              .textField_focus_label)
                                  : CoupleStyle.caption(
                                      color: status.hasError
                                          ? TextFieldColor.textField_error_label
                                          : TextFieldColor
                                              .textField_default_label),
                            ),
                          ),
                        )),
                  }
                ],
              )),
              Container(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  child: Container(child: Builder(builder: (ctx) {
                    if (widget.usingMaxLengthValidator == false &&
                        !status.hasError) {
                      return SizedBox();
                    }
                    if (!status.hasError) {
                      return Padding(
                        padding: EdgeInsets.only(top: 3.toWidth, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text('', style: CoupleStyle.caption()),
                            ),
                            if (widget.usingMaxLengthValidator) ...{
                              maxLengthWidget
                            }
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 14.toWidth, top: 3.toWidth, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text('${status.errorText}',
                                  style: CoupleStyle.caption(
                                      color: TextFieldColor
                                          .textField_error_label)),
                            ),
                            if (widget.usingMaxLengthValidator) ...{
                              maxLengthWidget
                            }
                          ],
                        ),
                      );
                    }
                  })),
                ),
              ),
            ],
          );
        });
  }
}
