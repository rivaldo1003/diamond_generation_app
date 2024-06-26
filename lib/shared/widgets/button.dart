import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  ProfileProvider? profileProvider;
  final String title;
  void Function()? onPressed;
  IconData? icon;
  String? logo;
  Color? color;
  TextStyle? textStyle;
  BorderSide? borderSide;

  ButtonWidget({
    this.profileProvider,
    this.onPressed,
    this.icon,
    this.logo,
    this.color,
    this.textStyle,
    this.borderSide,
    required this.title,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            side: (borderSide == null)
                ? BorderSide.none
                : BorderSide(
                    color: MyColor.primaryColor,
                    width: 0.5,
                  ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (icon != null) ? Icon(icon) : Container(),
            SizedBox(width: 8),
            (logo != null)
                ? Container(
                    height: 20,
                    width: 20,
                    child: Image.asset(logo!),
                  )
                : Container(),
            SizedBox(width: 8),
            Text(
              title,
              style: (textStyle == null)
                  ? MyFonts.customTextStyle(
                      14,
                      FontWeight.bold,
                      MyColor.whiteColor,
                    )
                  : textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
