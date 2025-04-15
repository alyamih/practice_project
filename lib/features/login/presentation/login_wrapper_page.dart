import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_project/features/login/domain/bloc/login_bloc.dart';
import 'package:practice_project/features/login/presentation/login_page.dart';
import 'package:practice_project/features/profile/presentation/profile_page.dart';

class LoginWrapperPage extends StatelessWidget {
  const LoginWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.maybeWhen(
          authed: () => const ProfilePage(),
          orElse: () => const LoginPage(),
        );
      },
    );
  }
}
