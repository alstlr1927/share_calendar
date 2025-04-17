library dialog_button;

import 'package:couple_calendar/util/couple_util.dart';
import 'package:flutter/material.dart';

import '../../../../util/couple_style.dart';
import '../custom_button/couple_button.dart';

part 'dialog_button_type.dart';

class CoupleDialog extends StatelessWidget {
  final CoupleDialogOption option;

  CoupleDialog({required this.option});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0.0, 0.1),
      child: Dialog(
        backgroundColor: CoupleStyle.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Container(
          width: 311.toWidth,
          child: Padding(
            padding: EdgeInsets.only(left: 18, right: 18, top: 24, bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (option.header != null) ...{
                        Align(
                          alignment:
                              option.header?.align ?? Alignment.centerLeft,
                          child: Text(
                            '${option.header?.text ?? ''}',
                            textAlign: option.header?.align != null
                                ? TextAlign.center
                                : TextAlign.left,
                            style: CoupleStyle.h5(
                                color: CoupleDialogColors.dialog_text_deepGray,
                                weight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 6),
                      },
                      if (option.body != null) ...{
                        Align(
                          alignment: option.body?.align ?? Alignment.centerLeft,
                          child: Text(
                            '${option.body?.text ?? ''}',
                            textAlign: option.body?.align != null
                                ? TextAlign.center
                                : TextAlign.left,
                            style: CoupleStyle.body2(
                              color: CoupleDialogColors.dialog_text_deepGray,
                            ),
                          ),
                        ),
                      },
                      if (option.customBody != null) ...{
                        if (option.header != null || option.body != null) ...{
                          SizedBox(height: 12),
                        },
                        option.customBody!.child,
                      },
                    ],
                  ),
                ),
                buildActions(actions: option.actions),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActions({required List<DialogAction>? actions}) {
    if (actions == null) {
      return SizedBox();
    }

    List<Widget> actionWidgets = actions.map((action) {
      return Expanded(
        child: CoupleButton(
          option: action.buttonOption,
          onPressed: action.onPressed,
        ),
      );
    }).toList();

    actionWidgets = actionWidgets.superJoin(SizedBox(width: 8)).toList();

    return Padding(
        padding: EdgeInsets.only(top: 20), child: Row(children: actionWidgets));
  }
}
