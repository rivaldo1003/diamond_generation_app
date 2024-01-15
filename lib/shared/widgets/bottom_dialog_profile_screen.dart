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
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 16),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // color: Colors.amber,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
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
        ),
      ),
    );
  }
}
