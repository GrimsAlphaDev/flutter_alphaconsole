import 'package:alphaconsole/view/app_page.dart';
import 'package:alphaconsole/view/home_page.dart';
import 'package:alphaconsole/view/login_page.dart';
import 'package:alphaconsole/view/not_found_page.dart';
import 'package:alphaconsole/view/profile_page.dart';
import 'package:alphaconsole/view/register_page.dart';
import 'package:flutter/material.dart';

class MyRoute {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );
      case "/app":
        return MaterialPageRoute(
          builder: (context) => const AppPage(),
        );
      case "/register":
        return MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        );
      case "/home":
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case "/profile":
        return MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundPage(),
        );
    }
  }
}
