import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeOwn {
  ThemeOwn._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 226, 137),
    drawerTheme: DrawerThemeData(
      backgroundColor: const Color.fromARGB(255, 255, 232, 163),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: const Color.fromARGB(255, 246, 221, 149),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    cardTheme: CardTheme(
      color: Color.fromARGB(255, 249, 206, 78),
      shadowColor: Colors.black,
      elevation: 5,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.amber,
      centerTitle: true,
      titleTextStyle: GoogleFonts.ubuntu(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 22,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        side: BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: GoogleFonts.ubuntu(fontSize: 16),
        elevation: 5,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.ubuntu(fontSize: 16, color: Colors.black),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
    ),
    dialogBackgroundColor: Colors.amber,
    textTheme: TextTheme(
      titleSmall: GoogleFonts.ubuntu(
        fontSize: 16,
        color: Colors.black,
      ),
      titleMedium: GoogleFonts.ubuntu(
        fontSize: 35,
        color: Colors.black,
      ),
      titleLarge: GoogleFonts.ubuntu(
        fontSize: 50,
        color: Colors.black,
      ),
    ),
    listTileTheme: ListTileThemeData(iconColor: Colors.black),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    dialogTheme: DialogTheme(
      backgroundColor: Color.fromARGB(255, 50, 50, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.black,
    ),
    listTileTheme: ListTileThemeData(iconColor: Colors.white),
    cardTheme: CardTheme(
      color: Color.fromARGB(255, 50, 50, 50),
      shadowColor: Colors.black,
      elevation: 5,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.ubuntu(fontSize: 16, color: Colors.white),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
    ),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.black,
      centerTitle: true,
      titleTextStyle: GoogleFonts.ubuntu(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 22,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
    ),
    textTheme: TextTheme(
      titleSmall: GoogleFonts.ubuntu(
        fontSize: 16,
        color: Colors.white,
      ),
      titleMedium: GoogleFonts.ubuntu(
        fontSize: 35,
        color: Colors.white,
      ),
      titleLarge: GoogleFonts.ubuntu(
        fontSize: 50,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
