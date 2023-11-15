import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class SnackBarWidget {
  static void showSnackBar({
    required BuildContext context,
    required String message,
    required Color textColor,
    required Color bgColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: bgColor,
        content: Text(
          message,
          style: MyFonts.customTextStyle(
            14,
            FontWeight.w500,
            textColor,
          ),
        ),
      ),
    );
  }
}
