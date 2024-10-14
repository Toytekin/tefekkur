import 'package:flutter/material.dart';
import 'package:tefekkurr/constant/colors.dart';

class TrTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    iconTheme: const IconThemeData(
      color: SbtColors.writeColor,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: SbtColors.secondaryColor,
      elevation: 0,
    ),
    brightness: Brightness.light,
    primaryColor: SbtColors.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: SbtColors.primaryColor,
      primaryContainer: Color(0xFFBBDEFB), // Daha soluk mavi
      onPrimary: Colors.white,
      secondary: SbtColors.secondaryColor,
      secondaryContainer: Color(0xFFE3F2FD), // Çok soluk mavi
      onSecondary: Colors.black,
      surface: Colors.white,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: SbtColors.secondaryColor, // Açık mavi arka plan
    appBarTheme: const AppBarTheme(
      backgroundColor: SbtColors.primaryColor,
      foregroundColor: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: SbtColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    iconTheme: const IconThemeData(
      color: SbtColors.writeColor,
    ),
    brightness: Brightness.dark,
    primaryColor: SbtColors.writeColor,
    colorScheme: const ColorScheme.dark(
      primary: SbtColors.white,
      primaryContainer: Color(0xFF64B5F6), // Soluk mavi
      onPrimary: Colors.black,
      secondary: SbtColors.secondaryColor,
      secondaryContainer: Color(0xFF1565C0), // Daha koyu mavi
      onSecondary: Colors.white,
      surface: Color(0xFF303030),
      error: Color(0xFFCF6679),
      onError: Colors.black,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: SbtColors.secondaryColor, // Koyu gri arka plan
    appBarTheme: const AppBarTheme(
      backgroundColor: SbtColors.writeColor,
      foregroundColor: Colors.white,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: SbtColors.primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
