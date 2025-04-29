import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_calendar/api/client_service.dart';
import 'package:couple_calendar/ui/comment/model/comment_model.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../auth/provider/user_provider.dart';

class CommentRepository {
  final commentDb = ClientService().getCommentDb();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getCommentListByScheduleId({
    required String scheduleId,
    int limit = 10,
    bool isDescending = false,
    DocumentSnapshot? lastDoc,
  }) async {
    Query<Map<String, dynamic>> query = commentDb
        .where('is_able', isEqualTo: true)
        .where('schedule_id', isEqualTo: scheduleId)
        .orderBy('created_at', descending: isDescending)
        .limit(limit);

    if (lastDoc != null) {
      // debugPrint('last doc : ${lastDoc.data()}');
      query = query.startAfterDocument(lastDoc);
    }

    // debugPrint('query : ${query.parameters}');

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

    return querySnapshot.docs;
  }

  Future<int> getTotalCommentCnt({
    required String scheduleId,
  }) async {
    final countSnapshot = await commentDb
        .where('is_able', isEqualTo: true)
        .where('schedule_id', isEqualTo: scheduleId)
        .count()
        .get();

    return countSnapshot.count ?? 0;
  }

  Future<CommentModel?> createComment({
    required String scheduleId,
    required String comment,
  }) async {
    try {
      final user =
          Provider.of<UserProvider>(nav.currentContext!, listen: false).user;
      final id = uuid.v4();
      var data = {
        'id': id,
        'uid': user.uid,
        'user_image': user.profileImg,
        'user_name': user.username,
        'schedule_id': scheduleId,
        'comment': comment,
        'is_able': true,
        'created_at': Timestamp.now(),
        'updated_at': Timestamp.now(),
      };

      await commentDb.doc(id).set(data);

      return CommentModel.fromJson(data);
    } catch (e, trace) {
      CoupleLog().e('error: $e');
      CoupleLog().e('$trace');
    }
    return null;
  }

  Future<void> updateComment({
    required String id,
    required String comment,
  }) async {
    var data = {
      'comment': comment,
      'updated_at': Timestamp.now(),
    };

    await commentDb.doc(id).update(data);
  }

  Future<void> deleteComment({
    required String id,
  }) async {
    await commentDb.doc(id).delete();
  }
}
