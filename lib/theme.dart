import 'package:flutter/material.dart';

final kDarkTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF000000),
);

final kLightTheme = ThemeData.light().copyWith(
  primaryColor: Color(0xFFFFFFFF),
  errorColor: Color(0xFFFF786F),
  canvasColor: Color(0xFFE5E5E5),
  disabledColor: Color(0xFF7D7D7D),
  dividerColor: Color(0xFFF5F5F5),
  hintColor: Color(0xFFC4C4C4),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  shadowColor: Color(0x19073E71),
  backgroundColor: Color(0xFFF7F9FB),
  cardColor: Color(0xFF64AEEA),
  hoverColor: Color(0xFFD7EBFF),
  splashColor: Color(0xFF70BBF6),
  buttonColor: Color(0xFFF9F9F9),
  secondaryHeaderColor: Color(0xFF97CFFC),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
      foregroundColor: MaterialStateProperty.all(Color(0xFF000000)),
    ),
  ),
  textTheme: ThemeData.light().textTheme.copyWith(
        button: TextStyle(
          color: Color(0xFF77BFFB),
        ),
        overline: TextStyle(
          color: Color(0xFFC4C4C4),
        ),
        headline6: TextStyle(
          color: Color(0xFF555555),
        ),
        headline5: TextStyle(
          color: Color(0xFF70BBF6),
        ),
        subtitle1: TextStyle(
          color: Color(0xFFE0E0E0),
        ),
        headline4: TextStyle(
          color: Color(0xFF5A5A5A),
        ),
      ),
);
