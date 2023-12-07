import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Filter WPDA'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tahun 2023',
              style: MyFonts.customTextStyle(
                  14, FontWeight.bold, MyColor.whiteColor),
            ),
            SizedBox(height: 4),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: MyColor.colorBlackBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nilai',
                          style: MyFonts.customTextStyle(
                              18, FontWeight.bold, MyColor.whiteColor),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColor.colorGreen,
                          ),
                          child: Center(
                            child: Text(
                              'A',
                              style: MyFonts.customTextStyle(
                                  18, FontWeight.bold, MyColor.whiteColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    FilterDetailWPDAPerMonth(
                        title: 'Bulan', output: 'November'),
                    SizedBox(height: 2),
                    FilterDetailWPDAPerMonth(title: 'Total WPDA', output: '27'),
                    SizedBox(height: 2),
                    FilterDetailWPDAPerMonth(
                        title: 'Total Hari Terlewat', output: '3'),
                    SizedBox(height: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterDetailWPDAPerMonth extends StatelessWidget {
  final String title;
  final String output;

  const FilterDetailWPDAPerMonth({
    super.key,
    required this.title,
    required this.output,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: MyFonts.customTextStyle(14, FontWeight.w500, MyColor.greyText),
        ),
        Text(
          output,
          style:
              MyFonts.customTextStyle(14, FontWeight.bold, MyColor.whiteColor),
        ),
      ],
    );
  }
}
