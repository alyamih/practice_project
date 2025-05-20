import 'dart:ui';

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practice_project/features/login/domain/bloc/login_bloc.dart';
import 'package:practice_project/features/login/presentation/login_page.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late LoginBloc loginBloc;
  TestWidgetsFlutterBinding.ensureInitialized();
  final user = MockUser(
    isAnonymous: false,
    uid: 'test_uid',
    email: 'test@example.com',
    displayName: 'Test User',
  );
  mockAuth = MockFirebaseAuth(mockUser: user);
  loginBloc = LoginBloc(mockAuth);

  group(
    '$LoginPage',
    () {
      _goldenTestSized(const Size(360, 360 * (16 / 9)), loginBloc);
      _goldenTestSized(const Size(768, 768 * (16 / 9)), loginBloc);
      _goldenTestSized(const Size(1024, 1024 * (16 / 9)), loginBloc);
    },
  );
}

void _goldenTestSized(Size size, LoginBloc loginBloc) {
  goldenTest(
    'Render Login page',
    fileName: '$LoginPage $size',
    constraints: BoxConstraints(maxWidth: size.width, maxHeight: size.height),
    pumpBeforeTest: (WidgetTester tester) async {
      await precacheImages(tester);
      await tester.pumpAndSettle();
    },
    whilePerforming: (WidgetTester tester) async {
      return () async => tester.pump(const Duration(milliseconds: 1600));
    },
    builder: () {
      return GoldenTestGroup(children: [
        SizedBox(
          width: size.width,
          height: size.height,
          child: BlocProvider.value(
            value: loginBloc,
            child: const MaterialApp(
              home: LoginPage(),
              debugShowCheckedModeBanner: false,
            ),
          ),
        )
      ]);
    },
  );
}
