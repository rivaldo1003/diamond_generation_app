import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Function(BuildContext context) onApprovePressed;
  final String title;
  final String content;
  final String textColorYes;
  Color? buttonYesColor;

  CustomDialog({
    super.key,
    required this.onApprovePressed,
    required this.title,
    required this.content,
    required this.textColorYes,
    this.buttonYesColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: MyFonts.customTextStyle(
          16,
          FontWeight.bold,
          MyColor.whiteColor,
        ),
      ),
      content: Text(
        content,
        style: MyFonts.customTextStyle(
          14,
          FontWeight.w500,
          MyColor.whiteColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: MyFonts.customTextStyle(
              15,
              FontWeight.w500,
              Colors.lightBlue,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            onApprovePressed(context);
          },
          child: Text(
            textColorYes,
            style: MyFonts.customTextStyle(
              15,
              FontWeight.bold,
              (buttonYesColor == null)
                  ? (textColorYes == 'Setujui')
                      ? MyColor.colorLightBlue
                      : Colors.red
                  : buttonYesColor,
            ),
          ),
        ),
      ],
    );
  }
}
