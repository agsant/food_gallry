
import 'package:flutter/cupertino.dart';
import 'package:foodsan/views/screens/home_screen.dart';

class Navigation {
  static Map<String, Widget Function(BuildContext)> routes =   {
    '/' : (context) => HomeScreen(),
  };
}