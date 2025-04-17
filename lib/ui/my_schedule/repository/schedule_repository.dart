import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_calendar/api/client_service.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:couple_calendar/ui/my_schedule/model/schedule_model.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';
import '../../auth/provider/user_provider.dart';

class ScheduleRepository {
  final userDb = ClientService().getUserDb();
  final scheduleDb = ClientService().getScheduleDb();

  Future<bool> checkDuplicatedTime({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final uid =
        Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();
    QuerySnapshot query = await ClientService()
        .getUserDb()
        .doc(uid)
        .collection('my_schedule')
        .where('start_date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .where('end_date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .get();
    // 존재하면 return true;
    return query.docs.isNotEmpty;
  }

  // Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMyScheduleByDate(
  //     DateTime dt) async {
  //   final uid =
  //       Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();

  //   final startTs = Timestamp.fromDate(DateTime(dt.year, dt.month, dt.day));
  //   final endTs =
  //       Timestamp.fromDate(DateTime(dt.year, dt.month, dt.day, 23, 59, 59));

  //   QuerySnapshot<Map<String, dynamic>> query = await ClientService()
  //       .getUserDb()
  //       .doc(uid)
  //       .collection("my_schedule")
  //       .where("start_date", isLessThanOrEqualTo: endTs)
  //       .where("end_date", isGreaterThanOrEqualTo: startTs)
  //       .get();

  //   return query.docs;
  // }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMyScheduleByYear(
      {required int year}) async {
    final uid =
        Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();
    final startTs = Timestamp.fromDate(DateTime(year, 1, 1, 0, 0, 0));
    final endTs = Timestamp.fromDate(DateTime(year, 12, 31, 23, 59, 59));

    QuerySnapshot<Map<String, dynamic>> query = await ClientService()
        .getScheduleDb()
        .where('is_able', isEqualTo: true)
        .where('start_date', isGreaterThanOrEqualTo: startTs)
        .where('start_date', isLessThanOrEqualTo: endTs)
        .where('member_ids', arrayContains: uid)
        .orderBy('start_date', descending: false)
        .get();

    return query.docs;
  }

  Future<Map<String, dynamic>?> getScheduleDataById({
    required String id,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
          await ClientService().getScheduleDb().doc(id).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e, trace) {
      CoupleLog().e('error : $e');
      CoupleLog().e('$trace');
    }

    return null;
  }

  Future<void> updateMySchedule({
    required String id,
    required String title,
    required String content,
    required DateTime startDate,
    required DateTime endDate,
    required ScheduleTheme theme,
    required String location,
    List<String> memberIds = const [],
  }) async {
    final uid =
        Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();
    await scheduleDb.doc(id).set({
      'id': id,
      'title': title,
      'content': content,
      'theme': theme.name,
      'owner_user_id': uid,
      'type': 'NORMAL',
      'member_ids': [
        uid,
        ...memberIds,
      ],
      'location': location,
      'start_date': Timestamp.fromDate(startDate),
      'end_date': Timestamp.fromDate(endDate),
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'is_able': true,
    });
  }

  Future<void> createMySchedule({
    required String title,
    required String content,
    required DateTime startDate,
    required DateTime endDate,
    required ScheduleTheme theme,
    required String location,
    List<String> memberIds = const [],
  }) async {
    final uid =
        Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();
    final id = uuid.v4();

    await scheduleDb.doc(id).set({
      'id': id,
      'title': title,
      'content': content,
      'theme': theme.name,
      'owner_user_id': uid,
      'type': 'NORMAL',
      'member_ids': [
        uid,
        ...memberIds,
      ],
      'location': location,
      'start_date': Timestamp.fromDate(startDate),
      'end_date': Timestamp.fromDate(endDate),
      'created_at': Timestamp.now(),
      'updated_at': Timestamp.now(),
      'is_able': true,
    });
  }
}
