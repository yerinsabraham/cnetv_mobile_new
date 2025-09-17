import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class Routes {
  static const String home = '/home';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
  };
}
