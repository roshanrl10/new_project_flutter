// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    useMaterial3: false,
    fontFamily: 'OpenSans Regular',
    primarySwatch: Colors.pink,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
