part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.signIn(String email, String password) = _SignIn;
  const factory LoginEvent.signOut() = _SignOut;
}
