import 'package:couple_calendar/ui/friends/widgets/add_friend_dialog.dart';
import 'package:flutter/material.dart';

class FriendListViewModel extends ChangeNotifier {
  State state;

  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void focusout() {
    focusNode.unfocus();
  }

  Future<void> onClickAddFrindBtn() async {
    showDialog(
      context: state.context,
      builder: (context) => AddFriendDialog(),
    );
  }

  @override
  void notifyListeners() {
    if (state.mounted) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  FriendListViewModel(this.state) {
    //
  }
}
