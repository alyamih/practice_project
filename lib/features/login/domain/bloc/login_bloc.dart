import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const _Initial()) {
    on<_SignIn>(_onSignIn);
    on<_SignOut>(_onSignOut);
    on<_HandleFirebaseAuthStateChanges>(_handleFirebaseAuthStateChanges);
    firebaseAuth = FirebaseAuth.instance.authStateChanges().listen(
          (event) => add(LoginEvent.handleFirebaseAuthStateChanges(event)),
        );
  }
  late StreamSubscription firebaseAuth;

  FutureOr<void> _onSignOut(_SignOut event, Emitter<LoginState> emit) async {
    await FirebaseAuth.instance.signOut();
    emit(const _Initial());
  }

  FutureOr<void> _onSignIn(
    _SignIn event,
    Emitter<LoginState> emit,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } on FirebaseAuthException catch (e, st) {
      if (e.code == 'email-already-in-use') {
        try {
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
      } else {
        emit(LoginState.error(message: e.code, error: e, stackTrace: st));
      }
    } catch (e, st) {
      log(e.toString(), name: 'b:login', stackTrace: st, error: e);
    }
  }

  @override
  Future<void> close() {
    firebaseAuth.cancel();
    return super.close();
  }

  FutureOr<void> _handleFirebaseAuthStateChanges(
      _HandleFirebaseAuthStateChanges event, Emitter<LoginState> emit) {
    event.user != null
        ? emit(const LoginState.authed())
        : emit(const LoginState.initial());
  }
}
