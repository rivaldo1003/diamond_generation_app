import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class CardBeranda extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String description;
  Color? textColorSub2;

  CardBeranda({
    Key? key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.description,
    this.textColorSub2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: MyColor.colorLightBlue.withOpacity(0.9),
          // color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            splashColor: MyColor.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: MyFonts.customTextStyle(
                      12,
                      FontWeight.bold,
                      MyColor.whiteColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        subtitle1,
                        style: MyFonts.customTextStyle(
                          20,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          subtitle2,
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.bold,
                            textColorSub2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: MyFonts.customTextStyle(
                      12,
                      FontWeight.w500,
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
