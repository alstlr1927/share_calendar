import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_calendar/ui/comment/model/comment_model.dart';
import 'package:couple_calendar/ui/comment/repository/comment_repository.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:flutter/material.dart';

import '../../common/components/couple_text_field/field_controller.dart';

class CommentSheetViewModel extends ChangeNotifier {
  State state;
  String scheduleId;

  List<CommentModel> commentList = [];
  FieldController fieldController = FieldController();

  final int COMMENT_LIMIT = 10;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool flag) => _isLoading = flag;

  bool _hasMore = true;
  bool get hasMore => _hasMore;
  void setHasMore(bool flag) => _hasMore = flag;

  DocumentSnapshot? lastDoc;

  void scrollListener(ScrollPosition position) {
    if (position.pixels > position.maxScrollExtent - 40) {
      getCommentDatas();
    }
  }

  Future<void> onClickSendComment() async {
    final commentText = fieldController.getStatus.text;
    final res = await CommentRepository().createComment(
      scheduleId: scheduleId,
      comment: commentText,
    );

    if (res != null) {
      commentList = List<CommentModel>.from([res, ...commentList]);
      notifyListeners();
    }
    fieldController.clear();
  }

  Future<void> getCommentDatas() async {
    if (isLoading) return;
    if (!hasMore) return;

    setIsLoading(true);
    debugPrint('==============================');
    debugPrint('getCommentDatas call');
    debugPrint('isLoading : $isLoading');
    debugPrint('hasMore : $hasMore');

    try {
      final datas = await CommentRepository().getCommentListByScheduleId(
        scheduleId: scheduleId,
        lastDoc: lastDoc,
        limit: COMMENT_LIMIT,
        isDescending: true,
      );

      final tempList =
          datas.map((e) => CommentModel.fromJson(e.data())).toList();

      if (tempList.length < COMMENT_LIMIT) {
        setHasMore(false);
      }

      if (datas.isNotEmpty) {
        lastDoc = datas.last;
      }

      commentList = List<CommentModel>.from([...commentList, ...tempList]);

      notifyListeners();
    } catch (e, trace) {
      CoupleLog().e('error: $e');
      CoupleLog().e('$trace');
    } finally {
      setIsLoading(false);
      debugPrint('isLoading : $isLoading');
      debugPrint('==============================');
    }
  }

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

  CommentSheetViewModel(this.state, {required this.scheduleId}) {
    getCommentDatas();
  }
}
