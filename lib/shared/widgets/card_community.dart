import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';

class CardCommunity extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const CardCommunity({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/images/diamond.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              margin: EdgeInsets.all(12),
              alignment: Alignment.center,
              width: 140,
              height: 30,
              decoration: BoxDecoration(
                color: MyColor.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 0,
                ),
                child: Text(
                  title,
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.bold,
                    MyColor.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
