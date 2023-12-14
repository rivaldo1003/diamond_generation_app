import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? action;
  Widget? leading;

  AppBarWidget({
    super.key,
    required this.title,
    this.action,
    this.leading,
  });
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: leading,
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
