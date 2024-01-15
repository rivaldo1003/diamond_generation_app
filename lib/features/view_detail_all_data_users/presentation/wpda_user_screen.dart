// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/features/history_wpda/presentation/history_screen.dart';
import 'package:diamond_generation_app/features/history_wpda/widgets/filter_date_dropdown.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/prayer_abbreviation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WpdaUserScreen extends StatefulWidget {
  final AllUsers allUsers;
  final String totalWpda;

  WpdaUserScreen({
    super.key,
    required this.allUsers,
    required this.totalWpda,
  });

  @override
  State<WpdaUserScreen> createState() => _WpdaUserScreenState();
}

class _WpdaUserScreenState extends State<WpdaUserScreen> {
  String buildImageUrlWithStaticTimestamp(String? profilePicture) {
    if (profilePicture != null &&
        profilePicture.isNotEmpty &&
        profilePicture != 'null') {
      // Tambahkan timestamp sebagai parameter query string
      return "${ApiConstants.baseUrlImage}/profile_pictures/$profilePicture?timestamp=${DateTime.now().millisecondsSinceEpoch}";
    } else {
      return "${ApiConstants.baseUrlImage}/profile_pictures/profile_pictures/dummy.jpg";
    }
  }

  String? imgUrl;

  @override
  void initState() {
    super.initState();
    print('Halo : User ${widget.allUsers.profile!.profile_picture}');

    if (widget.allUsers.profile != null &&
        widget.allUsers.profile!.profile_picture != null &&
        widget.allUsers.profile!.profile_picture.isNotEmpty) {
      imgUrl = buildImageUrlWithStaticTimestamp(
          widget.allUsers.profile!.profile_picture);
    } else {
      imgUrl =
          "${ApiConstants.baseUrlImage}/profile_pictures/profile_pictures/dummy.jpg";
    }
  }

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
    widget.allUsers.dataWpda.sort((a, b) =>
        DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt)));

    return Scaffold(
      appBar: AppBarWidget(
        title: 'WPDA ${widget.allUsers.profile}',
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: CardHeaderHistoryWpda(
                    totalWpda: widget.totalWpda,
                    title: 'TOTAL WPDA',
                    color: MyColor.colorGreen,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CardHeaderHistoryWpda(
                    totalWpda: (widget.allUsers.dataWpda.isEmpty)
                        ? 'C'
                        : widget.allUsers.profile!.grade,
                    title: 'GRADE',
                    color: MyColor.colorLightBlue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CardHeaderHistoryWpda(
                    totalWpda: widget.allUsers.profile!.missed_days_total,
                    title: 'MISSED DAY',
                    color: MyColor.colorRed,
                  ),
                ),
              ],
            ),
          ),
          FilterDateDropdown(),
          Expanded(
            child: (widget.allUsers.dataWpda.isNotEmpty)
                ? ListView.builder(
                    itemCount: widget.allUsers.dataWpda.length,
                    itemBuilder: (context, index) {
                      var history = widget.allUsers.dataWpda[index];

                      DateFormat apiDateFormat =
                          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ");
                      DateFormat desiredDateFormat =
                          DateFormat("yyyy-MM-dd HH:mm:ss");

                      DateTime createdAt =
                          apiDateFormat.parse(history.createdAt);
                      String formattedCreatedAt =
                          desiredDateFormat.format(createdAt);

                      print('formattedCreatedAt : $formattedCreatedAt');

                      String time = formattedCreatedAt.split(' ').last;

                      String timeOnly = convertTimeFormat(time);
                      String formatDate = DateFormat('dd MMMM yyyy', 'id')
                          .format(DateTime.parse(formattedCreatedAt));

                      String currentDate = DateTime.now().toString();
                      var currentDateFormat = DateFormat('dd MMMM yyyy', 'id')
                          .format(DateTime.parse(currentDate));
                      String dateResult = DateFormat('dd MMM yy')
                          .format(DateTime.parse(formattedCreatedAt));

                      String selectedPrayers = history.selectedPrayers;

                      List<String> abbreviations = [];
                      if (selectedPrayers.isEmpty) {
                        abbreviations.add('Tidak Berdoa');
                      } else {
                        List<String> prayersList = selectedPrayers.split(',');
                        abbreviations = prayersList
                            .map((prayer) => getAbbreviation(prayer))
                            .toList();
                      }

                      String selectedItemString = abbreviations.join(',');

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
                                                      widget.allUsers.fullName,
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
                                                            dateResult +
                                                                ' | ${timeOnly}',
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
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors
                                                        .white, // Warna border putih
                                                    width: 2.0, // Lebar border
                                                  ),
                                                ),
                                                child: (widget
                                                            .allUsers
                                                            .profile!
                                                            .profile_picture
                                                            .isEmpty ||
                                                        widget.allUsers.profile!
                                                                .profile_picture ==
                                                            null)
                                                    ? CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            'assets/images/profile_empty.jpg'),
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 20,
                                                      )
                                                    : CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(widget
                                                                .allUsers
                                                                .profile!
                                                                .profile_picture),
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 20,
                                                      ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            history.readingBook,
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
                                                  history.messageOfGod,
                                                  style:
                                                      MyFonts.customTextStyle(
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
                                                  history.applicationInLife,
                                                  style:
                                                      MyFonts.customTextStyle(
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
                                      Consumer<LoginProvider>(
                                          builder: (context, value, _) {
                                        if (value.userId == null) {
                                          value.loadFullName();
                                          return CircularProgressIndicator();
                                        } else {
                                          if (value.userId == 0) {
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
                                          (widget
                                                      .allUsers
                                                      .profile!
                                                      .profile_picture
                                                      .isEmpty ||
                                                  widget.allUsers.profile!
                                                          .profile_picture ==
                                                      null)
                                              ? CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/profile_empty.jpg'),
                                                  backgroundColor: Colors.white,
                                                  radius: 20,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      widget.allUsers.profile!
                                                          .profile_picture),
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
                                                              widget.allUsers
                                                                  .fullName,
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
                                                          (widget.allUsers.id ==
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
                                                  widget.allUsers.email,
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
                                              history.readingBook,
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
                                                    '| ' + time,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'Doa Tabernakel',
                                              style: MyFonts.customTextStyle(
                                                12,
                                                FontWeight.w500,
                                                MyColor.greyText,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              selectedItemString,
                                              textAlign: TextAlign.right,
                                              style: MyFonts.customTextStyle(
                                                12,
                                                FontWeight.bold,
                                                MyColor.whiteColor,
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
                                          history.verseContent,
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
                            (value.userId == widget.allUsers.id)
                                ? 'Anda belum pernah wpda'
                                : '${widget.allUsers.fullName} belum pernah wpda',
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
