import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/auth/screens/login.dart';
import 'package:smart_content_recommendation_application/auth/screens/register.dart';


Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  SignUpScreen(),
      );
     case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  LoginScreen(),
      );
    
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
  }
}
