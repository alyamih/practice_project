import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const _Initial()) {
    on<_SignIn>(_onSignIn);
    on<_SignOut>(_onSignOut);
  }

  FutureOr<void> _onSignOut(_SignOut event, Emitter<LoginState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(const _Initial());
  }

  FutureOr<void> _onSignIn(
    _SignIn event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(LoginState.error(
            message: e.code, error: e, stackTrace: e.stackTrace));
      } else if (e.code == 'email-already-in-use') {
        try {
          final credential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            emit(LoginState.error(
                message: e.code, error: e, stackTrace: e.stackTrace));
          } else if (e.code == 'wrong-password') {
            emit(LoginState.error(
                message: e.code, error: e, stackTrace: e.stackTrace));
          }
        }
      }
    } catch (e, st) {
      log(e.toString(), name: 'b:login', stackTrace: st, error: e);
    }
  }
}
