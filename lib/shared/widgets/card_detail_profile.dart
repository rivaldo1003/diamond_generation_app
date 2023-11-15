import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class CardDetailProfile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String value;

  const CardDetailProfile({
    super.key,
    required this.iconData,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: (context),
          builder: (context) {
            return AlertDialog(
              content: Text(
                value,
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
              title: Text(
                title,
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.colorLightBlue,
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 48,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: MyColor.colorBlackBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(iconData),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.greyText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: MyFonts.customTextStyle(
                      14,
                      FontWeight.w500,
                      MyColor.greyText,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
