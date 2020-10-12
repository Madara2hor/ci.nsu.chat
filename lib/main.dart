import 'package:ci.nsu.chat/Helpers/app_colors.dart';
import 'package:ci.nsu.chat/Services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/Sidebar/sidebar_layout.dart';
import 'Pages/signIn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.mainColor,
            primaryColor: AppColors.secondColor,
          ),
          title: 'ci.nsu.chat',
          initialRoute: '/authWrapper',
          routes: {'/authWrapper': (context) => AuthenticationWrapper()}),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
        builder: (context, user, child) =>
            user == null ? SignInPage() : SideBarLayout());
  }
}
