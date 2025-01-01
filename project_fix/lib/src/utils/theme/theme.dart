import 'package:flutter/material.dart';

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MaterialColor(0xFFFFE200, <int, Color>{
      50: Color(0xFFFFF8E1),
      100: Color(0xFFFFECB3),
      200: Color(0xFFFFE200),
      300: Color(0xFFFFD600),
      400: Color(0xFFFFC400),
      500: Color(0xFFFFB800),
      600: Color(0xFFFFA800),
      700: Color(0xFFFF9800),
      800: Color(0xFFFF8800),
      900: Color(0xFFFF6F00),
    }),
  );
  static ThemeData darkTheme = ThemeData(brightness: Brightness.dark);
}
