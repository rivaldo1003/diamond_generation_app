import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? action;

  AppBarWidget({
    super.key,
    required this.title,
    this.action,
  });
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: MyFonts.customTextStyle(
          18,
          FontWeight.bold,
          MyColor.whiteColor,
        ),
      ),
      actions: action,
    );
  }
}
