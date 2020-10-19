import 'package:ci.nsu.chat/ui/shared/route_name.dart';
import 'package:ci.nsu.chat/ui/views/sidebar/sidebar_layout.dart';
import 'package:ci.nsu.chat/ui/views/signIn_view.dart';

import 'package:flutter/material.dart';

const String initialRoute = RouteName.signInRoute;

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.signInRoute:
        return MaterialPageRoute(builder: (_) => SignInView());
      case RouteName.sideBarRoute:
        return MaterialPageRoute(builder: (_) => SideBarLayout());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                    body: Center(
                  child: Text(
                    'No route defined for ${settings.name}',
                    style: TextStyle(
                        color: Color(0xffd7d7d7),
                        fontWeight: FontWeight.bold,
                        fontSize: 28),
                  ),
                )));
    }
  }
}
