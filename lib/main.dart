import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_project/app/deeplink/deeplink_service.dart';
import 'package:practice_project/app/navigation/routes.dart';
import 'package:practice_project/app/notification/notification_service.dart';
import 'package:practice_project/features/favorites/data/repositories/favorite_firebase_repository.dart';
import 'package:practice_project/features/favorites/data/repositories/favorite_repository.dart';
import 'package:practice_project/features/favorites/domain/bloc/favorites_bloc.dart';
import 'package:practice_project/features/login/domain/bloc/login_bloc.dart';
import 'package:practice_project/firebase_options.dart';

bool shouldUseFirebaseEmulator = true;

late final FirebaseApp app;
late final FirebaseAuth auth;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await NotificationService.init();
  }
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  DeepLinkService.handleInit();
  DeepLinkService.handleForeground();
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FavoritesBloc(FavoriteFirebaseRepository())
            ..add(const FavoritesEvent.getData()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(FirebaseAuth.instance),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
      ),
    );
  }
}
