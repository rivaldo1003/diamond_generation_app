import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFonts {
  static TextStyle brownText(double size, FontWeight weight) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: weight,
      color: MyColor.primaryColor,
    );
  }

  static TextStyle primaryTextStyle(double size) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
  }

  static TextStyle customTextStyle(
      double size, FontWeight fontWeight, Color color) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle secondaryTextStyle(double size) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: Colors.grey[700],
    );
  }
}
