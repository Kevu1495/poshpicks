import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poshpicks/core/extensions/app_extensions.dart';
import 'package:poshpicks/features/home/view/home_view.dart';
import 'package:poshpicks/firebase_options.dart';
import 'package:poshpicks/screens/HomepageScreen.dart';
import 'package:poshpicks/screens/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'core/init/navigation/navigation_route.dart';
import 'core/init/navigation/navigation_service.dart';
import 'features/common/splash/view/splash_view.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String path = '/';
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    navigatorKey: NavigationService.navigatorKey,
    onGenerateRoute: NavigationRoute.generateRoute,
    title: 'Shopping App',
    debugShowCheckedModeBanner: false,
    theme: _theme(context),
    home: const Signinscreen(),
  );

  ThemeData _theme(BuildContext context) => ThemeData(
    primaryColor: context.primaryColor,
    scaffoldBackgroundColor: context.background,
    fontFamily: "Avenir",
  );
}

