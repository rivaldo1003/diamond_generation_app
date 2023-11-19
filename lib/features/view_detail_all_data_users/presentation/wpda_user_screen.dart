// ignore_for_file: unnecessary_null_comparison

import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/features/history_wpda/presentation/history_screen.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WpdaUserScreen extends StatelessWidget {
  final AllUsers allUsers;
  final String totalWpda;

  WpdaUserScreen({
    super.key,
    required this.allUsers,
    required this.totalWpda,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'WPDA User'),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: CardHeaderHistoryWpda(
                    totalWpda: totalWpda,
                    title: 'TOTAL WPDA',
                    color: MyColor.colorGreen,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CardHeaderHistoryWpda(
                    totalWpda: (allUsers.grade == null) ? '0' : allUsers.grade,
                    title: 'GRADE',
                    color: MyColor.colorLightBlue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CardHeaderHistoryWpda(
                    totalWpda: (allUsers.missedDaysTotal == null)
                        ? '-'
                        : allUsers.missedDaysTotal,
                    title: 'MISSED DAY',
                    color: MyColor.colorRed,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: (allUsers.dataWpda.isNotEmpty)
                ? ListView.builder(
                    itemCount: allUsers.dataWpda.length,
                    itemBuilder: (context, index) {
                      var history = allUsers.dataWpda[index];
                      String timeOnly = history.createdAt.split(' ').last;
                      String formatDate = DateFormat('dd MMMM yyyy', 'id')
                          .format(DateTime.parse(history.createdAt));

                      String currentDate = DateTime.now().toString();
                      var currentDateFormat = DateFormat('dd MMMM yyyy', 'id')
                          .format(DateTime.parse(currentDate));

                      String dateResult = DateFormat('dd MMM yy')
                          .format(DateTime.parse(history.createdAt));
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      allUsers.fullName,
                                                      textAlign: TextAlign.end,
                                                      style: MyFonts
                                                          .customTextStyle(
                                                        14,
                                                        FontWeight.bold,
                                                        MyColor.whiteColor,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    (currentDateFormat ==
                                                            formatDate)
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'Hari ini',
                                                                style: MyFonts
                                                                    .customTextStyle(
                                                                  12,
                                                                  FontWeight
                                                                      .w500,
                                                                  MyColor
                                                                      .greyText,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                timeOnly,
                                                                style: MyFonts
                                                                    .customTextStyle(
                                                                  12,
                                                                  FontWeight
                                                                      .w500,
                                                                  MyColor
                                                                      .greyText,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Text(
                                                            currentDateFormat,
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: MyFonts
                                                                .customTextStyle(
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
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          history.isiKitab,
                                          style: MyFonts.customTextStyle(
                                            14,
                                            FontWeight.w500,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Divider(),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                history.pesanTuhan,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                history.aplikasiKehidupan,
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
                                    actions: [
                                      Consumer<LoginProvider>(
                                          builder: (context, value, _) {
                                        if (value.userId == null) {
                                          value.loadFullName();
                                          return CircularProgressIndicator();
                                        } else {
                                          if (value.userId == allUsers.id) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons
                                                      .favorite_border_outlined),
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color:
                                                        MyColor.colorLightBlue,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Card(
                                color: MyColor.colorBlackBg,
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/profile_empty.jpg'),
                                            backgroundColor: Colors.white,
                                            radius: 20,
                                          ),
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                              allUsers.fullName,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: MyFonts
                                                                  .customTextStyle(
                                                                14,
                                                                FontWeight.bold,
                                                                MyColor
                                                                    .whiteColor,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 12),
                                                          (allUsers.id ==
                                                                  value.userId)
                                                              ? Container(
                                                                  height: 20,
                                                                  width: 60,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: MyColor
                                                                        .colorGreen,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'You',
                                                                      style: MyFonts
                                                                          .customTextStyle(
                                                                        14,
                                                                        FontWeight
                                                                            .bold,
                                                                        MyColor
                                                                            .whiteColor,
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
                                                  allUsers.email,
                                                  style:
                                                      MyFonts.customTextStyle(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              history.kitabBacaan,
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
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  (currentDateFormat ==
                                                          formatDate)
                                                      ? Text(
                                                          'Hari ini',
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            12,
                                                            FontWeight.bold,
                                                            MyColor
                                                                .colorLightBlue,
                                                          ),
                                                        )
                                                      : Text(
                                                          dateResult,
                                                          style: MyFonts
                                                              .customTextStyle(
                                                            12,
                                                            FontWeight.bold,
                                                            MyColor.whiteColor,
                                                          ),
                                                        ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    '| ' + timeOnly,
                                                    style:
                                                        MyFonts.customTextStyle(
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          history.isiKitab,
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
                    },
                  )
                : Center(
                    child: Consumer<LoginProvider>(
                      builder: (context, value, _) {
                        if (value.userId == null) {
                          value.userId;
                          return CircularProgressIndicator();
                        } else {
                          return Text(
                            (value.userId == allUsers.id)
                                ? 'Anda belum pernah wpda'
                                : '${allUsers.fullName} belum pernah wpda',
                            textAlign: TextAlign.center,
                            style: MyFonts.customTextStyle(
                              14,
                              FontWeight.w500,
                              MyColor.whiteColor,
                            ),
                          );
                        }
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
