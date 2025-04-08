part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.authed() = _Authed;
  const factory LoginState.error(
      {required String message,
      Object? error,
      StackTrace? stackTrace}) = _Error;
}
