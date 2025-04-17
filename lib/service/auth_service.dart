import 'package:couple_calendar/main.dart';
import 'package:couple_calendar/ui/common/components/logger/couple_logger.dart';
import 'package:couple_calendar/ui/common/provider/loading_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/common/components/custom_button/couple_button.dart';
import '../ui/common/components/dialog/couple_text_dialog.dart';

class AuthService {
  Future<void> emailSignup({
    required String email,
    required String password,
  }) async {
    try {
      Provider.of<LoadingProvider>(nav.currentContext!, listen: false)
          .setIsLoading(true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String body = '서버 오류가 발생했습니다. (${e.code})';
      if (e.code == 'email-already-in-use') {
        body = '이미 등록된 이메일입니다.';
      }
      _showDialog(header: '회원가입', body: body);
    } catch (e, trace) {
      CoupleLog().e('error : $e');
      CoupleLog().e('$trace');
    } finally {
      Provider.of<LoadingProvider>(nav.currentContext!, listen: false)
          .setIsLoading(false);
    }
  }

  Future<void> googleLogin() async {
    //
  }

  Future<void> appleLogin() async {
    //
  }

  Future<void> kakaoLogin() async {
    //
  }

  Future<void> emailLogin({
    required String email,
    required String password,
  }) async {
    try {
      Provider.of<LoadingProvider>(nav.currentContext!, listen: false)
          .setIsLoading(true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String body = '서버에 오류가 발생했습니다. (${e.code})';
      switch (e.code.toLowerCase()) {
        case 'invalid_login_credential':
        case 'invalid-credential':
          body = '비밀번호 또는 이메일을 다시 입력해주세요.';
          return;
        case 'user-disabled':
          body = '제한된 유저입니다.';
          break;
        case 'user-not-found':
          body = '유저를 찾을 수가 없습니다.';
          break;
        case 'wrong-password':
          body = '비밀번호를 다시 입력해주세요.';
          break;
        default:
      }
      _showDialog(header: '로그인', body: body);
    } catch (e, trace) {
      CoupleLog().e('error: $e');
      CoupleLog().e('$trace');
    } finally {
      Provider.of<LoadingProvider>(nav.currentContext!, listen: false)
          .setIsLoading(false);
    }
  }

  Future<void> userSignout() async {
    FirebaseAuth.instance.signOut();
  }

  Future _showDialog({required String header, required String body}) {
    return showDialog(
      context: nav.currentContext!,
      builder: (context) => CoupleDialog(
        option: CoupleDialogOption.normal(
          header: DialogHeader(text: header),
          body: DialogBody(text: body),
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
}
