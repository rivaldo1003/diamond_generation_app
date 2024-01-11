import 'dart:io';
import 'package:diamond_generation_app/core/models/history_wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/prayer_abbreviation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardHistoryWpda extends StatefulWidget {
  final HistoryWpda historyWpda;
  final String profilePictures;

  const CardHistoryWpda({
    super.key,
    required this.historyWpda,
    required this.profilePictures,
  });

  @override
  State<CardHistoryWpda> createState() => _CardHistoryWpdaState();
}

class _CardHistoryWpdaState extends State<CardHistoryWpda> {
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

  File? _image;
  final keyImageProfile = "image_profile";

  Future<void> loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString(keyImageProfile);
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  late String imgUrl;
  String buildImageUrlWithStaticTimestamp(String? profilePicture) {
    if (profilePicture != null &&
        profilePicture.isNotEmpty &&
        profilePicture != 'null') {
      // Tambahkan timestamp sebagai parameter query string
      return Uri.https(
              'gsjasungaikehidupan.com',
              '/storage/profile_pictures/$profilePicture',
              {'timestamp': DateTime.now().millisecondsSinceEpoch.toString()})
          .toString();
    } else {
      return "${ApiConstants.baseUrlImage}/profile_pictures/profile_pictures/dummy.jpg";
    }
  }

  @override
  void initState() {
    imgUrl = buildImageUrlWithStaticTimestamp(widget.profilePictures);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String time = widget.historyWpda.createdAt.split(' ').last;

    String timeOnly = convertTimeFormat(time);
    String formatDate = DateFormat('dd MMMM yyyy', 'id')
        .format(DateTime.parse(widget.historyWpda.createdAt));

    String currentDate = DateTime.now().toString();
    var currentDateFormat =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(currentDate));
    String dateResult = DateFormat('dd MMM yy')
        .format(DateTime.parse(widget.historyWpda.createdAt));

    String selectedPrayers = widget.historyWpda.doaTabernakel;

    List<String> abbreviations = [];

    if (selectedPrayers.isEmpty || selectedPrayers == null) {
      abbreviations.add('Tidak Berdoa');
    } else {
      List<String> prayersList = selectedPrayers.split(',');
      abbreviations =
          prayersList.map((prayer) => getAbbreviation(prayer)).toList();
    }

    String selectedItemsString = abbreviations.join(', ');
    String filePath = widget.profilePictures;
    FileImage fileImage = FileImage(File(filePath));

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
                                widget.historyWpda.writer.fullName,
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
                        (widget.profilePictures == null ||
                                widget.profilePictures.isEmpty)
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white, // Warna border putih
                                    width: 2.0, // Lebar border
                                  ),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    'assets/images/profile_empty.jpg',
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white, // Warna border putih
                                    width: 2.0, // Lebar border
                                  ),
                                ),
                                child: (widget.profilePictures.startsWith(
                                        '/data/user/0/com.example.diamond_generation_app/'))
                                    ? CircleAvatar(
                                        backgroundImage: fileImage,
                                      )
                                    : CircleAvatar(
                                        backgroundImage: NetworkImage(imgUrl),
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
                        widget.historyWpda.verseContent,
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
                              widget.historyWpda.messageOfGod,
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
                              widget.historyWpda.applicationInLife,
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
              width: MediaQuery.of(context).size.width,
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
                      (widget.profilePictures == null ||
                              widget.profilePictures.isEmpty)
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white, // Warna border putih
                                  width: 2.0, // Lebar border
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/profile_empty.jpg',
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white, // Warna border putih
                                  width: 2.0, // Lebar border
                                ),
                              ),
                              child: (widget.profilePictures.startsWith(
                                      '/data/user/0/com.example.diamond_generation_app/'))
                                  ? CircleAvatar(
                                      backgroundImage: fileImage,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(imgUrl),
                                    ),
                            ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<LoginProvider>(
                              builder: (context, value, _) {
                                if (value.fullName == null) {
                                  value.loadFullName();
                                  return CircularProgressIndicator();
                                } else {
                                  return Text(
                                    widget.historyWpda.writer.fullName,
                                    overflow: TextOverflow.ellipsis,
                                    style: MyFonts.customTextStyle(
                                      14,
                                      FontWeight.bold,
                                      MyColor.whiteColor,
                                    ),
                                  );
                                }
                              },
                            ),
                            Text(
                              widget.historyWpda.writer.email,
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.greyText,
                              ),
                            ),
                          ],
                        ),
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
                            'Anda',
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
                          widget.historyWpda.readingBook,
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
                      Expanded(
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
                        flex: 2,
                        child: Text(
                          selectedItemsString,
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
                  Text(
                    widget.historyWpda.verseContent,
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
