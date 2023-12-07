import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/presentation/edit_wpda.screen.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/custom_dialog.dart';
import 'package:diamond_generation_app/shared/widgets/prayer_abbreviation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CardWpda extends StatelessWidget {
  final WPDA wpda;

  CardWpda({
    super.key,
    required this.wpda,
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
    String time = wpda.createdAt.split(' ').last;

    String timeOnly = convertTimeFormat(time);

    String formatDate =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(wpda.createdAt));

    String currentDate = DateTime.now().toString();
    var currentDateFormat =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(currentDate));

    String dateResult =
        DateFormat('dd MMM yy').format(DateTime.parse(wpda.createdAt));
    final wpdaProvider = Provider.of<WpdaProvider>(context);

    String selectedPrayers = wpda.selectedPrayers;

    List<String> abbreviations = [];

    if (selectedPrayers.isEmpty || selectedPrayers == null) {
      abbreviations.add('Tidak Berdoa');
    } else {
      List<String> prayersList = selectedPrayers.split(',');
      abbreviations =
          prayersList.map((prayer) => getAbbreviation(prayer)).toList();
    }

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
                    child: SingleChildScrollView(
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
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return EditWpdaScreen(
                                      wpda: wpda,
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
                                                  wpdaProvider.deleteWpda({
                                                    "user_id": value.userId,
                                                    "wpda_id": wpda.id,
                                                  }, context);
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
                        color: (value.userId == wpda.userId &&
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
