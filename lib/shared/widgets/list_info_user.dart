import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class ListInfoUser extends StatelessWidget {
  final String title;
  final Widget widget;

  const ListInfoUser({
    super.key,
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: MyFonts.customTextStyle(
              14,
              FontWeight.w500,
              MyColor.greyText,
            ),
          ),
        ),
        widget,
      ],
    );
  }
}
