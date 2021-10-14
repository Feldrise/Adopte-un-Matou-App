import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AUMTheme {
  static ThemeData theme(BuildContext context) {
    return ThemeData(
      colorScheme:  ColorScheme.fromSwatch(
        primarySwatch: colorSwatch(Palette.colorPrimary.value),
        accentColor: Palette.colorPrimary,
        backgroundColor: Palette.colorWhite,
      ),
      primaryColor: Palette.colorPrimary,
      backgroundColor: Palette.colorWhite,
      cardColor: Palette.colorWhite,
      scaffoldBackgroundColor: Palette.colorScaffold,
      dividerColor: Colors.black12,

      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        color: Palette.colorScaffold,
        elevation: 0,
        iconTheme: IconThemeData(color: Palette.colorBlack),
        titleTextStyle: TextStyle(color: Palette.colorBlack, fontSize: 24)
      ),

      textTheme: GoogleFonts.ralewayTextTheme().copyWith(
        headline1: GoogleFonts.raleway(fontSize: 35, color: Palette.colorBlack),
        headline2: GoogleFonts.raleway(fontSize: 28, color: Palette.colorBlack),
        headline3: GoogleFonts.raleway(fontSize: 26, color: Palette.colorBlack),
        button: GoogleFonts.raleway(fontSize: 13, fontWeight: FontWeight.w600, color: Palette.colorWhite)
      ),
            
      visualDensity: VisualDensity.standard
    );
  }

  static ThemeData themeDark(BuildContext context) {
    return ThemeData(
      colorScheme:  ColorScheme.fromSwatch(
        primarySwatch: colorSwatch(Palette.colorPrimary.value),
        accentColor: Palette.colorPrimary,
        backgroundColor: Palette.colorBlack,
      ),
      primaryColor: Palette.colorPrimary,
      backgroundColor: Palette.colorBlack,
      cardColor: Palette.colorBlack,
      scaffoldBackgroundColor: Palette.colorDarkScaffold,
      dividerColor: Colors.white30,

      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        color: Palette.colorDarkScaffold,
        elevation: 0,
        iconTheme: IconThemeData(color: Palette.colorWhite),
        titleTextStyle: TextStyle(color: Palette.colorWhite, fontSize: 24)
      ),

      textTheme: GoogleFonts.ralewayTextTheme().copyWith(
        button: GoogleFonts.raleway(fontSize: 10, fontWeight: FontWeight.w600, color: Palette.colorWhite)
      ).apply(
        decorationColor: Palette.colorWhite,
        displayColor: Palette.colorWhite,
        bodyColor: Palette.colorWhite
      ),

      iconTheme: const IconThemeData(
        color: Palette.colorWhite
      ),
            
      visualDensity: VisualDensity.standard
    );
  }

  static MaterialColor colorSwatch(int value) {
    final color50 = Color(value).withOpacity(0.1);
    final color100 = Color(value).withOpacity(0.2);
    final color200 = Color(value).withOpacity(0.3);
    final color300 = Color(value).withOpacity(0.4);
    final color400 = Color(value).withOpacity(0.5);
    final color500 = Color(value).withOpacity(0.6);
    final color600 = Color(value).withOpacity(0.7);
    final color700 = Color(value).withOpacity(0.8);
    final color800 = Color(value).withOpacity(0.8);
    final color900 = Color(value).withOpacity(1);

    return MaterialColor(value, <int, Color>{
      50:color50,
      100:color100,
      200:color200,
      300:color300,
      400:color400,
      500:color500,
      600:color600,
      700:color700,
      800:color800,
      900:color900,
    });
  }

}