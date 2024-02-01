import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class TermAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Syarat dan Kondisi'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Syarat dan Kondisi River App',
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
                'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to GSJA Sungai Kehidupan. \n\nGSJA Sungai Kehidupan is committed to ensuring that the app is as useful and efficient as possible. \n\nFor that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for. The River App app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the River App app won’t work properly or at all. \n\nThe app does use third-party services that declare their Terms and Conditions. \n\nLink to Terms and Conditions of third-party service providers used by the app',
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
