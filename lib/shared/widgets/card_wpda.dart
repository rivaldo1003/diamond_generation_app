import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/presentation/edit_wpda.screen.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CardWpda extends StatefulWidget {
  final WPDA wpda;

  CardWpda({
    super.key,
    required this.wpda,
  });

  @override
  State<CardWpda> createState() => _CardWpdaState();
}

class _CardWpdaState extends State<CardWpda> {
  String buildImageUrlWithTimestamp(String? profilePicture) {
    // Periksa apakah profilePicture tidak null dan tidak kosong sebelum membangun URL
    if (profilePicture != null && profilePicture.isNotEmpty) {
      return "${ApiConstants.baseUrlImage}/$profilePicture?timestamp=${DateTime.now().millisecondsSinceEpoch}";
    } else {
      // Handle ketika profilePicture null atau kosong, misalnya mengembalikan URL default atau kosong
      return ""; // Gantilah dengan URL default atau kosong sesuai kebutuhan
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

  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String imgUrl =
        buildImageUrlWithTimestamp(widget.wpda.writer.profile_picture);

    String time = widget.wpda.created_at.split(' ').last;

    String timeOnly = convertTimeFormat(time);

    String formatDate = DateFormat('dd MMMM yyyy', 'id')
        .format(DateTime.parse(widget.wpda.created_at));

    String currentDate = DateTime.now().toString();
    var currentDateFormat =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(currentDate));

    String dateResult =
        DateFormat('dd MMM yy').format(DateTime.parse(widget.wpda.created_at));
    final wpdaProvider = Provider.of<WpdaProvider>(context);

    // String selectedPrayers = wpda.selectedPrayers;

    List<String> abbreviations = [];

    // if (selectedPrayers.isEmpty || selectedPrayers == null) {
    //   abbreviations.add('Tidak Berdoa');
    // } else {
    //   List<String> prayersList = selectedPrayers.split(',');
    //   abbreviations =
    //       prayersList.map((prayer) => getAbbreviation(prayer)).toList();
    // }

    String selectedItemsString = abbreviations.join(', ');

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
                                    widget.wpda.writer.full_name,
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
                                          widget.wpda.created_at,
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.wpda.verse_content,
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
                                  '${widget.wpda.message_of_god}',
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
                                  '${widget.wpda.application_in_life}',
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
                  ),
                  actions: [
                    Consumer<LoginProvider>(builder: (context, value, _) {
                      if (value.userId == null) {
                        value.loadFullName();
                        return CircularProgressIndicator();
                      } else {
                        if (value.userId == widget.wpda.user_id) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_border_outlined),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return EditWpdaScreen(
                                      wpda: widget.wpda,
                                    );
                                  }));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: MyColor.colorLightBlue,
                                ),
                              ),
                              Consumer<LoginProvider>(
                                builder: (context, _value, _) {
                                  if (value.userId == null) {
                                    value.loadUserId();
                                    return CircularProgressIndicator();
                                  } else {
                                    return IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomDialog(
                                                onApprovePressed: (context) {
                                                  wpdaProvider.deleteWpda(
                                                    context,
                                                    (token == null)
                                                        ? ''
                                                        : token!,
                                                    widget.wpda.id,
                                                  );
                                                },
                                                title:
                                                    'Delete WPDA confirmation',
                                                content:
                                                    'Are you sure you want to delete this WPDA?',
                                                textColorYes: 'Delete',
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: MyColor.colorRed,
                                      ),
                                    );
                                  }
                                },
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
            child: Consumer<LoginProvider>(builder: (context, value, _) {
              if (value.userId == null) {
                value.loadUserId();
                return CircularProgressIndicator();
              } else {
                return Card(
                  color: MyColor.colorBlackBg,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (value.userId == widget.wpda.user_id &&
                                currentDateFormat == formatDate)
                            ? MyColor.greyText
                            : MyColor.colorBlackBg,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            (imgUrl.isEmpty)
                                ? CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/profile_empty.jpg'),
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        CachedNetworkImageProvider(imgUrl),
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
                                                widget.wpda.writer.full_name,
                                                overflow: TextOverflow.ellipsis,
                                                style: MyFonts.customTextStyle(
                                                  14,
                                                  FontWeight.bold,
                                                  MyColor.whiteColor,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            (widget.wpda.user_id ==
                                                    value.userId)
                                                ? Container(
                                                    height: 20,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                      color: MyColor.colorGreen,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Anda',
                                                        style: MyFonts
                                                            .customTextStyle(
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
                                    widget.wpda.writer.email,
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
                                widget.wpda.reading_book,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                '${selectedItemsString}',
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
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.wpda.verse_content,
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
                );
              }
            }),
          ),
        ),
        Divider(
          thickness: 0.5,
        ),
      ],
    );
  }
}
