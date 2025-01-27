import 'package:flutter/material.dart';
import 'package:smart_content_recommendation_application/auth/screens/login.dart';
import 'package:smart_content_recommendation_application/auth/screens/register.dart';
import 'package:smart_content_recommendation_application/content/screens/home_screen.dart';
import 'package:smart_content_recommendation_application/splash_screen.dart';


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
      case SplashScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  SplashScreen(),
      );
      case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>  HomeScreen(),
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
