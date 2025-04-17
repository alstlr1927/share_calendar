import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'text_field_theme.dart/text_field_theme.dart';

class FieldStatus {
  bool hasError;
  String errorText;
  bool isFieldEnable;
  bool isValid;
  bool? isConfirmed;
  bool isInProgress;
  Color errorColor;
  bool isObscure;
  bool hasFocus;
  String text;

  FieldStatus({
    this.hasError = false,
    this.isValid = false,
    this.errorText = '',
    this.errorColor = TextFieldColor.textField_error_line,
    this.isFieldEnable = true,
    this.hasFocus = false,
    this.isInProgress = false,
    this.isObscure = true,
    this.text = '',
  });
}

class FieldController {
  FocusNode? focusNode;
  TextEditingController? textController;
  BehaviorSubject<FieldStatus>? statusStream;

  BehaviorSubject<bool> progressStream = BehaviorSubject();

  FieldStatus status = FieldStatus();

  FieldStatus get getStatus => statusStream?.value ?? FieldStatus();

  FieldController({String initText = ''}) {
    focusNode = FocusNode();
    textController = TextEditingController(text: initText);
    statusStream = BehaviorSubject.seeded(status..text = initText);
    focusNode!.addListener(focusListener);
  }

  void dispose() {
    statusStream?.close();
    progressStream.close();
    if (focusNode?.hasFocus ?? false) {
      focusNode!.unfocus();
      Future.delayed(Duration(milliseconds: 300), () {
        focusNode!.removeListener(focusListener);
        focusNode?.dispose();
      });
    }
    textController?.dispose();
  }

  void addData(FieldStatus status) {
    if (!statusStream!.isClosed) {
      statusStream!.add(status);
    }
  }

  focusListener() {
    setFocusStatus(focusNode!.hasFocus);
  }

  setFocusStatus(bool value) {
    status.hasFocus = value;
    addData(status);
  }

  requestFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    textController!.selection =
        TextSelection.fromPosition(TextPosition(offset: status.text.length));
  }

  setErrorText(String value) {
    status.errorText = value;
    addData(status);
  }

  setHasError(bool value) {
    status.hasError = value;
    addData(status);
  }

  setText(String text) {
    status.text = text;
    addData(status);
  }

  setIsEnable(bool value) {
    status.isFieldEnable = value;
    addData(status);
  }

  setIsConfirmed(bool value) {
    status.isConfirmed = value;
    addData(status);
  }

  setIsValid(bool value) {
    status.isValid = value;
    addData(status);
  }

  setIsInProgress(bool value) {
    status.isInProgress = value;
    addData(status);
  }

  setErrorColor(Color value) {
    status.errorColor = value;
    addData(status);
  }

  setIsObscure(bool value) {
    status.isObscure = value;
    addData(status);
  }

  setInitText(String text) {
    status.text = text;
    textController?.text = text;
    addData(status);
  }

  void clear() {
    textController?.clear();
    focusNode?.unfocus();
    status = FieldStatus();
    addData(status);
  }

  void resetStatus() {
    status = FieldStatus()
      ..text = status.text
      ..isObscure = status.isObscure
      ..hasFocus = status.hasFocus;
    addData(status);
  }

  void unfocus() {
    focusNode?.unfocus();
    addData(status);
  }
}
