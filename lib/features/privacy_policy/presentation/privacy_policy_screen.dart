import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Kebijakan Privasi'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kebijakan Privasi River App',
                style: MyFonts.customTextStyle(
                  24,
                  FontWeight.bold,
                  MyColor.whiteColor,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'GSJA Sungai Kehidupan built the River App app as a Free app. This SERVICE is provided by GSJA Sungai Kehidupan at no cost and is intended for use as is. \n\nThis page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service. \n\nIf you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy. \n\nThe terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at River App unless otherwise defined in this Privacy Policy.',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
