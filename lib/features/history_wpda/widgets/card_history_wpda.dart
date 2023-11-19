import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardHistoryWpda extends StatelessWidget {
  final HistoryWpda historyWpda;

  const CardHistoryWpda({
    super.key,
    required this.historyWpda,
  });

  String convertTimeFormat(String originalTime) {
    // Membuat formatter untuk waktu dengan format HH.mm.ss
    DateFormat originalFormat = DateFormat('HH:mm:ss');

    // Parsing waktu dari string ke objek DateTime
    DateTime dateTime = originalFormat.parseStrict(originalTime);

    // Membuat formatter baru untuk waktu dengan format HH.mm
    DateFormat newFormat = DateFormat('HH:mm');

    // Mengonversi waktu ke format yang diinginkan
    return newFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    String time = historyWpda.createdAt.split(' ').last;

    String timeOnly = convertTimeFormat(time);
    String formatDate = DateFormat('dd MMMM yyyy', 'id')
        .format(DateTime.parse(historyWpda.createdAt));

    String currentDate = DateTime.now().toString();
    var currentDateFormat =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(currentDate));
    String dateResult =
        DateFormat('dd MMM yy').format(DateTime.parse(historyWpda.createdAt));

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Dikirim \nOleh',
                    style: MyFonts.customTextStyle(
                      14,
                      FontWeight.bold,
                      MyColor.colorLightBlue,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                historyWpda.fullName,
                                textAlign: TextAlign.end,
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.bold,
                                  MyColor.whiteColor,
                                ),
                              ),
                              SizedBox(height: 2),
                              (currentDateFormat == formatDate)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Hari ini',
                                          style: MyFonts.customTextStyle(
                                            12,
                                            FontWeight.w500,
                                            MyColor.greyText,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          timeOnly,
                                          style: MyFonts.customTextStyle(
                                            12,
                                            FontWeight.w500,
                                            MyColor.greyText,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      dateResult + ' | ${timeOnly}',
                                      textAlign: TextAlign.end,
                                      style: MyFonts.customTextStyle(
                                        12,
                                        FontWeight.w500,
                                        MyColor.greyText,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          height: 48,
                          width: 48,
                          child: Image.asset(
                            'assets/images/profile.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      historyWpda.isiKitab,
                      style: MyFonts.customTextStyle(
                        14,
                        FontWeight.w500,
                        MyColor.whiteColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PT : ',
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.bold,
                            MyColor.colorLightBlue,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            historyWpda.pesanTuhan,
                            style: MyFonts.customTextStyle(
                              14,
                              FontWeight.w500,
                              MyColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AP : ',
                          style: MyFonts.customTextStyle(
                            14,
                            FontWeight.bold,
                            MyColor.colorLightBlue,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            historyWpda.aplikasiKehidupan,
                            style: MyFonts.customTextStyle(
                              14,
                              FontWeight.w500,
                              MyColor.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                Consumer<LoginProvider>(builder: (context, value, _) {
                  if (value.userId == null) {
                    value.loadFullName();
                    return CircularProgressIndicator();
                  } else {
                    if (value.userId == 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.favorite_border_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              color: MyColor.colorLightBlue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.delete,
                              color: MyColor.colorRed,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  }
                }),
              ],
            );
          },
        );
      },
      child: Column(
        children: [
          Card(
            color: MyColor.colorBlackBg,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Consumer<LoginProvider>(
                                builder: (context, value, _) {
                                  if (value.fullName == null) {
                                    value.loadFullName();
                                    return CircularProgressIndicator();
                                  } else {
                                    return Text(
                                      historyWpda.fullName,
                                      style: MyFonts.customTextStyle(
                                        16,
                                        FontWeight.bold,
                                        MyColor.whiteColor,
                                      ),
                                    );
                                  }
                                },
                              ),
                              Text(
                                historyWpda.email,
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.w500,
                                  MyColor.greyText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 20,
                        width: 60,
                        decoration: BoxDecoration(
                          color: MyColor.colorGreen,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'You',
                            style: MyFonts.customTextStyle(
                              14,
                              FontWeight.bold,
                              MyColor.whiteColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          historyWpda.kitabBacaan,
                          style: MyFonts.customTextStyle(
                            16,
                            FontWeight.bold,
                            MyColor.colorLightBlue,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 30,
                          // width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            // color: MyColor.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              (currentDateFormat == formatDate)
                                  ? Text(
                                      'Hari ini',
                                      style: MyFonts.customTextStyle(
                                        12,
                                        FontWeight.bold,
                                        MyColor.colorLightBlue,
                                      ),
                                    )
                                  : Text(
                                      dateResult,
                                      style: MyFonts.customTextStyle(
                                        12,
                                        FontWeight.bold,
                                        MyColor.whiteColor,
                                      ),
                                    ),
                              SizedBox(width: 4),
                              Text(
                                '| ' + timeOnly,
                                style: MyFonts.customTextStyle(
                                  12,
                                  FontWeight.bold,
                                  MyColor.colorLightBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    historyWpda.isiKitab,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
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
          Divider(),
        ],
      ),
    );
  }
}
