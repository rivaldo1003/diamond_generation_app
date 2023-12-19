import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class BottomDialogProfileScreen extends StatelessWidget {
  final String title;
  final Icon icon;
  void Function()? onTap;

  BottomDialogProfileScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: MyColor.primaryColor,
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Row(
        children: [
          icon,
          SizedBox(width: 8),
          Text(
            title,
            style: MyFonts.customTextStyle(
              14,
              FontWeight.w500,
              MyColor.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
