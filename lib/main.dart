import 'package:flutter/material.dart';
import 'package:new_project_flutter/view/dashboard.dart';
import 'package:new_project_flutter/view/login.dart';
import 'package:new_project_flutter/view/signup.dart';
import 'package:new_project_flutter/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/dashboard': (context) => Dashboard(),
      },
    );
  }
}
