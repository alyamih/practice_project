import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_project/features/login/domain/bloc/login_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FilledButton(
            child: const Text('Exit'),
            onPressed: () {
              context.read<LoginBloc>().add(const LoginEvent.signOut());
            },
          )
        ],
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
