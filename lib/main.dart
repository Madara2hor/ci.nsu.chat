import 'package:ci.nsu.chat/ui/router.dart';
import 'package:ci.nsu.chat/ui/shared/app_colors.dart';
import 'package:ci.nsu.chat/core/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
        create: (BuildContext context) =>
            locator<AuthenticationService>().authStateChanges,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.mainColor,
            primaryColor: AppColors.secondColor,
          ),
          title: 'ci.nsu.chat',
          initialRoute: locator<AuthenticationService>().currentUser == null
              ? 'signIn'
              : 'sidebar',
          onGenerateRoute: Router.generateRoute,
        ));
  }
}
