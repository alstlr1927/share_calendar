import 'package:couple_calendar/ui/comment/model/comment_model.dart';
import 'package:flutter/material.dart';

import '../../common/components/couple_text_field/field_controller.dart';

class CommentSheetViewModel extends ChangeNotifier {
  State state;

  List<CommentModel> friendList = [];
  FieldController fieldController = FieldController();

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    fieldController.dispose();
    super.dispose();
  }

  CommentSheetViewModel(this.state) {
    //
  }
}
