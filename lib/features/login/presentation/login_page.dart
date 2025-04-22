import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_project/features/login/domain/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _email;
  late TextEditingController _password;

  void _init() {
    _email = TextEditingController(text: '');
    _password = TextEditingController(text: '');
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoTextField(
                    controller: _email,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CupertinoTextField(
                    controller: _password,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  state.whenOrNull(
                        error: (message, error, stackTrace) => Text(
                          message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ) ??
                      const SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(
                              LoginEvent.signIn(_email.text, _password.text));
                        },
                        child: const Text('Login'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
