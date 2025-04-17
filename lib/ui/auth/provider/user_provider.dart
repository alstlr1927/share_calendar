import 'dart:async';

import 'package:couple_calendar/main.dart';
import 'package:couple_calendar/router/couple_router.dart';
import 'package:couple_calendar/ui/auth/model/user_model.dart';
import 'package:couple_calendar/ui/auth/repository/user_repository.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/components/custom_button/couple_button.dart';
import '../../common/components/dialog/couple_text_dialog.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel();
  UserModel get user => _user;

  List<UserModel> _friendList = [];
  List<UserModel> get friendList => _friendList;
  void setFriendList(List<UserModel> list) =>
      _friendList = List<UserModel>.from(list);

  StreamSubscription? _tokenSubs;

  String getUid() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  void updateProfileInfo(UserModel model) {
    _user = model;
    notifyListeners();
  }

  Future<UserModel?> refreshProfile() async {
    try {
      final res = await UserRepository().getMyProfile();
      if (res == null) return null;

      final user = UserModel.fromJson(res);
      updateProfileInfo(user);
      final list =
          await UserRepository().getUserByUidList(uidList: user.friendList);
      setFriendList(list);
      notifyListeners();
      return user;
    } catch (e, trace) {
      CoupleLog().e('error: $e');
      CoupleLog().e('$trace');
    }
    return null;
  }

  Future<void> checkTokenSubscription() async {
    _tokenSubs =
        FirebaseAuth.instance.idTokenChanges().listen((User? authUser) async {
      if (authUser == null) {
        CoupleRouter().replaceLanding(nav.currentContext!);
      } else {
        final isExist =
            await UserRepository().checkUserExist(uid: authUser.uid);

        if (isExist) {
          CoupleRouter().replaceRoot(nav.currentContext!);
        } else {
          CoupleRouter().replaceAddUserInfo(nav.currentContext!);
        }
      }
    });
  }

  Future verifyDialog() async {
    return await showDialog(
      context: nav.currentContext!,
      builder: (context) => CoupleDialog(
        option: CoupleDialogOption.normal(
          header: DialogHeader(text: '인증'),
          body: DialogBody(text: '가입한 이메일로 인증메일을 발송했습니다.\n인증후 다시 로그인 해주세요.'),
          actions: [
            DialogAction(
              onPressed: context.pop,
              buttonOption: CoupleButtonOption.fill(
                text: '확인',
                theme: CoupleButtonFillTheme.gray,
                style: CoupleButtonFillStyle.fullSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tokenSubs?.cancel();
    super.dispose();
  }
}
