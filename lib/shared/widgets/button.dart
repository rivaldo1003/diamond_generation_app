import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/profile/data/providers/profile_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  ProfileProvider? profileProvider;
  final String title;
  void Function()? onPressed;
  IconData? icon;
  Color? color;

  ButtonWidget({
    this.profileProvider,
    this.onPressed,
    this.icon,
    this.color,
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
              borderRadius: BorderRadius.circular(10),
            )),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (icon != null) ? Icon(icon) : Container(),
            SizedBox(width: 8),
            Text(
              title,
              style: MyFonts.customTextStyle(
                16,
                FontWeight.bold,
                MyColor.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
