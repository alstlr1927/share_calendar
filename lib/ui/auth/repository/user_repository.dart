import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_calendar/api/client_service.dart';
import 'package:couple_calendar/main.dart';
import 'package:couple_calendar/ui/auth/provider/user_provider.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';

class UserRepository {
  final userDb = ClientService().getUserDb();

  Future<bool> checkUserExist({
    required String uid,
  }) async {
    final user = await userDb.doc(uid).get();
    return user.exists;
  }

  Future<Map<String, dynamic>?> getMyProfile() async {
    final uid =
        Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();

    final userDoc = await userDb.doc(uid).get();

    return userDoc.data();
  }

  Future<bool> setUserInfoData({
    required String name,
    required String userId,
    required UserGender gender,
  }) async {
    try {
      final uid = Provider.of<UserProvider>(nav.currentContext!, listen: false)
          .getUid();
      if (uid.isEmpty) return false;

      await userDb.doc(uid).set({
        'uid': uid,
        'name': name,
        'gender': gender.name,
        'created_at': DateTime.now(),
        'friend_ids': <String>[],
        'profile_image': '',
        'user_id': userId,
      });

      return true;
    } catch (e, trace) {
      CoupleLog().e('error!: $e');
      CoupleLog().e('$trace');
      return false;
    }
  }

  Future<List<UserModel>> getUserByUidList({
    required List<String> uidList,
  }) async {
    try {
      final futures = uidList.map((uid) {
        return userDb.doc(uid).get();
      }).toList();

      final list = await Future.wait(futures);

      return list.map((e) => UserModel.fromJson(e.data()!)).toList();
    } catch (e, trace) {
      CoupleLog().e('error: $e');
      CoupleLog().e('$trace');
    }
    return <UserModel>[];
  }

  // uid 리스트가 10개 이하일때 사용해야함
  Future<List<UserModel>> getUserListByQuery({
    required List<String> uidList,
  }) async {
    try {
      final query = await userDb.where('uid', whereIn: uidList).get();

      return query.docs.map((e) => UserModel.fromJson(e.data())).toList();
    } catch (e, trace) {
      CoupleLog().e('error: $e');
      CoupleLog().e('$trace');
    }
    return <UserModel>[];
  }

  Future<Map<String, dynamic>?> getUserProfileByUserId({
    required String userId,
  }) async {
    final query = await userDb.where('user_id', isEqualTo: userId).get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }

    return null;
  }

  Future<void> addUserFriend({
    required String friendUid,
  }) async {
    final uid =
        Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();
    await userDb.doc(uid).update({
      'friend_ids': FieldValue.arrayUnion([friendUid])
    });
  }

  Future<void> removeUserFriend({
    required String friendUid,
  }) async {
    final uid =
        Provider.of<UserProvider>(nav.currentContext!, listen: false).getUid();
    await userDb.doc(uid).update({
      'friend_ids': FieldValue.arrayRemove([friendUid]),
    });
  }
}
