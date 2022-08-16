import 'package:craneapp/screens/CategoryScreen.dart';
import 'package:craneapp/screens/HomeScreen.dart';
import 'package:craneapp/screens/LoginScreen.dart';
import 'package:craneapp/screens/RegisterScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => LoginScreen(),
      );
    case RegisterScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => RegisterScreen(),
      );
    // case CategoryScreen.routeName:
    //   final args = routeSettings.arguments;
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => CategoryScreen(category: args.category),
    //   );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Scaffold(
          body: Center(
            child: Text("$routeSettings screen not found"),
          ),
        ),
      );
  }
}
