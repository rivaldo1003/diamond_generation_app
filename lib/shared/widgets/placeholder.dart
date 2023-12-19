import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';

import 'package:flutter/material.dart';

class PlaceholderErrorConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Koneksi internetmu terganggu!',
            textAlign: TextAlign.center,
            style: MyFonts.customTextStyle(
              16,
              FontWeight.bold,
              MyColor.whiteColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Yuk, pastikan internetmu lancar dengan ulang paket data, WiFi, atau jaringan di tempatmu.',
            textAlign: TextAlign.center,
            style: MyFonts.customTextStyle(
              12,
              FontWeight.w500,
              MyColor.greyText,
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
