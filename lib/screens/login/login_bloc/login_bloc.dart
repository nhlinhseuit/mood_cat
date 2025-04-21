import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginWithEmailPassword>(_onLoginWithEmailPassword);
    on<LoginWithFacebook>(_onLoginWithFacebook);
  }

  Future<void> _onLoginWithEmailPassword(
    LoginWithEmailPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(error: e.message ?? 'Đăng nhập thất bại'));
    }
  }

  Future<void> _onLoginWithFacebook(
    LoginWithFacebook event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      // Bắt đầu quá trình đăng nhập bằng Facebook
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Tạo credential từ accessToken để dùng với Firebase
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Đăng nhập vào Firebase
        await FirebaseAuth.instance.signInWithCredential(credential);

        emit(LoginSuccess());
      } else if (result.status == LoginStatus.cancelled) {
        emit(const LoginFailure(error: "Đăng nhập bị huỷ."));
      } else {
        emit(LoginFailure(error: result.message ?? "Đăng nhập thất bại."));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
