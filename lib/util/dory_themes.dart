import 'package:alyak/util/dory_colors.dart';
import 'package:flutter/material.dart';

class DoryThemes {
  static ThemeData get lightTheme => ThemeData(
      primarySwatch: DoryColors.primaryMeterialColor,
      fontFamily: 'GmarketSansTTF',
      textTheme: _textTheme,
      splashColor: Colors.white,
      appBarTheme: _appbarTheme,
      scaffoldBackgroundColor: Colors.white,
      brightness: Brightness.light);

      static ThemeData get darkTheme => ThemeData(
      primarySwatch: DoryColors.primaryMeterialColor,
      fontFamily: 'GmarketSansTTF',
      textTheme: _textTheme,
      splashColor: Colors.white,
      appBarTheme: _appbarTheme,
      brightness: Brightness.dark);


  static const AppBarTheme _appbarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: DoryColors.primaryColor),
    elevation: 0,
  );

  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );
}
