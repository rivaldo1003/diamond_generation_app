import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardWpda extends StatelessWidget {
  final WPDA wpda;

  const CardWpda({
    super.key,
    required this.wpda,
  });

  @override
  Widget build(BuildContext context) {
    String timeOnly = wpda.createdAt.split(' ').last;
    String formatDate =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(wpda.createdAt));

    String currentDate = DateTime.now().toString();
    var currentDateFormat =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(currentDate));

    String dateResult =
        DateFormat('dd MMM yy').format(DateTime.parse(wpda.createdAt));

    return Column(
      children: [
        GestureDetector(
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
                                    wpda.fullName,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                          wpda.createdAt,
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
                          wpda.isiKitab,
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
                                '${wpda.pesanTuhan}',
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
                                '${wpda.aplikasiKehidupan}',
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
                        if (value.userId == wpda.userId) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Card(
              color: MyColor.colorBlackBg,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile_empty.jpg'),
                          backgroundColor: Colors.white,
                          radius: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Consumer<LoginProvider>(
                                builder: (context, value, _) {
                                  if (value.userId == null) {
                                    value.loadUserId();
                                    return CircularProgressIndicator();
                                  } else {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            wpda.fullName,
                                            overflow: TextOverflow.ellipsis,
                                            style: MyFonts.customTextStyle(
                                              14,
                                              FontWeight.bold,
                                              MyColor.whiteColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        (wpda.userId == value.userId)
                                            ? Container(
                                                height: 20,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  color: MyColor.colorGreen,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'You',
                                                    style:
                                                        MyFonts.customTextStyle(
                                                      14,
                                                      FontWeight.bold,
                                                      MyColor.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    );
                                  }
                                },
                              ),
                              Text(
                                wpda.email,
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.w500,
                                  MyColor.greyText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            wpda.kitabBacaan,
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        wpda.isiKitab,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
        ),
      ],
    );
  }
}
