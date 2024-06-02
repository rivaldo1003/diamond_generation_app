import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  List<Widget>? action;
  Widget? leading;
  bool? automaticallyImplyLeading;

  AppBarWidget({
    super.key,
    required this.title,
    this.action,
    this.leading,
    this.automaticallyImplyLeading,
  });
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: Colors.white, // <-- SEE HERE
      //   statusBarIconBrightness:
      //       Brightness.dark, //<-- For Android SEE HERE (dark icons)
      //   statusBarBrightness:
      //       Brightness.light, //<-- For iOS SEE HERE (dark icons)
      // ),

      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: leading,
      automaticallyImplyLeading: (automaticallyImplyLeading == null)
          ? true
          : automaticallyImplyLeading!,
      title: Text(
        title,
        style: MyFonts.customTextStyle(
          16,
          FontWeight.bold,
          MyColor.whiteColor,
        ),
      ),
      actions: action,
    );
  }
}
