import 'package:assessment/screens/login_page_screen/login_page_screen.dart';
import 'package:assessment/screens/splash_screen/splash_screen.dart';
import 'package:assessment/screens/user_screen/user_screen.dart';
import 'package:assessment/screens/video_screen/video_screen.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen/home_screen.dart';
//import '../screens/login_screen/login_screen.dart';
//import 'package:assessment/presentation/splash_screen/splash_screen.dart';

class AppRoutes {


  static const String splashScreen = '/splash_screen';
  static const String homeScreen = '/home_screen';
  static const String videoScreen = '/video_screen';
  static const String userScreen = '/user_screen';
  static const String loginPageScreen = '/login_pages_screen';
  static const String initialRoute = '/initialRoute';
  // Latest
  static Map<String, WidgetBuilder> get routes => {

    splashScreen: SplashScreen.builder,
    homeScreen: HomeScreen.builder,
    videoScreen: VideoScreen.builder,
    userScreen: UserScreen.builder,
    loginPageScreen: LoginPageScreen.builder,
    initialRoute: SplashScreen.builder,
  };
}
