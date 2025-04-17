part of dialog_button;

class CoupleDialogColors {
  static const dialog_text_deepGray = CoupleStyle.gray090;
  static const dialog_text_white = CoupleStyle.white;
}

class DialogHeader {
  final String text;
  final AlignmentGeometry? align;

  DialogHeader({required this.text, this.align});
}

class DialogBody {
  final String text;
  final AlignmentGeometry? align;

  DialogBody({required this.text, this.align});
}

class DialogCustomBody {
  final Widget child;

  DialogCustomBody({required this.child});
}

class DialogAction {
  final Function? onPressed;
  final CoupleButtonOption buttonOption;

  DialogAction({required this.buttonOption, this.onPressed});
}

class CoupleDialogOption {
  final DialogHeader? header;
  final DialogBody? body;
  final DialogCustomBody? customBody;
  final List<DialogAction>? actions;

  CoupleDialogOption.normal({this.header, this.body, this.actions})
      : customBody = null;
  CoupleDialogOption.custom(
      {this.header, this.body, required this.customBody, this.actions});
}
