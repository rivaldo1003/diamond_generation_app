import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class CardHeaderCommunity extends StatelessWidget {
  final String dataUser;
  final String title;
  final Color color;
  void Function()? onTap;

  CardHeaderCommunity({
    super.key,
    required this.dataUser,
    required this.title,
    required this.color,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            splashColor: MyColor.primaryColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${dataUser}',
                    style: MyFonts.customTextStyle(
                      24,
                      FontWeight.bold,
                      MyColor.whiteColor,
                    ),
                  ),
                  Text(
                    title,
                    style: MyFonts.customTextStyle(
                      9,
                      FontWeight.bold,
                      MyColor.whiteColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
