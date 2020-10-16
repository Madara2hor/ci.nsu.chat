import 'package:ci.nsu.chat/ui/views/sidebar/sidebar_layout.dart';
import 'package:ci.nsu.chat/ui/views/signIn_view.dart';

import 'package:flutter/material.dart';

const String initialRoute = "signIn";

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'signIn':
        return MaterialPageRoute(builder: (_) => SignInView());
      // case 'authWrapper':
      //   return MaterialPageRoute(builder: (_) => AuthenticationWrapper());
      case 'sidebar':
        return MaterialPageRoute(builder: (_) => SideBarLayout());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
