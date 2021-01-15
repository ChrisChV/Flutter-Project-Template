import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData themeData = ThemeData(
      primarySwatch: Colors.blueGrey,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Color(0xff002E68),
      accentColor: Color(0xffFECF00),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xff002E68),
      ),
      textButtonTheme: TextButtonThemeData(style: ButtonStyle()));
}
