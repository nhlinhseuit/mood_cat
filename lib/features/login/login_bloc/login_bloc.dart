import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  LoginBloc() : super(LoginInitial()) {
    on<LoginWithEmailPassword>(_onLoginWithEmailPassword);
    on<LoginWithFacebook>(_onLoginWithFacebook);
    on<LoginWithGoogle>(_onLoginWithGoogle);
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

  Future<void> _onLoginWithGoogle(
    LoginWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      // Bước 1: Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(const LoginFailure(error: 'Hủy đăng nhập Google'));
        return;
      }

      // Bước 2: Lấy thông tin xác thực từ Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Bước 3: Tạo credential cho Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Bước 4: Đăng nhập với Firebase
      await _firebaseAuth.signInWithCredential(credential);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(error: e.message ?? 'Đăng nhập Google thất bại'));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
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
