import 'package:flutter/material.dart';
import 'colors.dart';

class WhatsAppThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: WhatsAppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: WhatsAppColors.lightPrimary,
      secondary: WhatsAppColors.lightSecondary,
      background: WhatsAppColors.lightBackground,
    ),
    scaffoldBackgroundColor: WhatsAppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: WhatsAppColors.lightAppBar,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: WhatsAppColors.lightText),
      bodyMedium: TextStyle(color: WhatsAppColors.lightText),
      titleMedium: TextStyle(color: WhatsAppColors.lightText),
      titleSmall: TextStyle(color: WhatsAppColors.lightTextSecondary),
    ),
    dividerColor: WhatsAppColors.lightDivider,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: WhatsAppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: WhatsAppColors.darkPrimary,
      secondary: WhatsAppColors.darkSecondary,
      background: WhatsAppColors.darkBackground,
    ),
    scaffoldBackgroundColor: WhatsAppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: WhatsAppColors.darkAppBar,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: WhatsAppColors.darkText),
      bodyMedium: TextStyle(color: WhatsAppColors.darkText),
      titleMedium: TextStyle(color: WhatsAppColors.darkText),
      titleSmall: TextStyle(color: WhatsAppColors.darkTextSecondary),
    ),
    dividerColor: WhatsAppColors.darkDivider,
  );
}
