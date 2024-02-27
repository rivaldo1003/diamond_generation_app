import 'package:diamond_generation_app/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_banner.dart';

class BannerItem extends StatelessWidget {
  final AppBanner appBanner;
  BannerItem({
    required this.appBanner,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 140,
          child: SvgPicture.asset(
            appBanner.img,
          ),
        ),
        SizedBox(height: 48),
        Text(
          '${appBanner.title}',
          textAlign: TextAlign.center,
          style: MyFonts.customTextStyle(
            20,
            FontWeight.bold,
            MyColor.whiteColor,
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${appBanner.description}',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
