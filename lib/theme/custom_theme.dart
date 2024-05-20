import 'package:flutter/material.dart';
import 'package:leben_in_deutschland/constants/style_constants.dart';

class CustomTheme {
  get darkTheme => ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
            elevation: 0,
            color: darkThemeBackgroundColor, //lightThemeAppBarColor,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        primaryTextTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(16, 16, 16, 1)),
        ),
      );

  get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: lightThemeBackgroundColor,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: lightThemeFABColor,
        ),
        appBarTheme: const AppBarTheme(
            elevation: 0,
            color: lightThemeBackgroundColor, //lightThemeAppBarColor,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        bottomAppBarTheme: const BottomAppBarTheme(
            color: lightThemeSecondColor, elevation: 20),
        primaryTextTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: lightThemeSecondColor,
          ),
        ),
      );
}
