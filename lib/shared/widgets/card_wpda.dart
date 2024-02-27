import 'package:cached_network_image/cached_network_image.dart';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/core/usecases/get_wpda_usecase.dart';
import 'package:diamond_generation_app/features/comment/presentation/comment_wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/presentation/edit_wpda.screen.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/build_image_url_with_timestamp.dart';
import 'package:diamond_generation_app/shared/widgets/custom_dialog.dart';
import 'package:diamond_generation_app/shared/widgets/prayer_abbreviation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';

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
  String? imgUrl;

  Future<void> fetchData() async {
    // await retryLogic(() async {
    imgUrl =
        buildImageUrlWithStaticTimestamp(widget.wpda.writer.profile_picture);
    print('IMG URL : ${imgUrl}');
    // });
  }

  Future<void> retryLogic(Function action, {int maxRetries = 3}) async {
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        await action();
        // If the action succeeds, break out of the loop
        break;
      } catch (e) {
        print('Error: $e');
        // Increment retry count and wait for a short duration before retrying
        retryCount++;
        await Future.delayed(Duration(seconds: 2));
      }
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
    });
  }

  @override
  void initState() {
    imgUrl =
        buildImageUrlWithStaticTimestamp(widget.wpda.writer.profile_picture);
    // fetchData().then((value) => print('image dijalankan'));
    getToken();
    super.initState();
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty || text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  String? capitalizeEachWord(String? text) {
    if (text!.isEmpty || text.isEmpty) {
      return text;
    }

    List<String> words = text.split(" ");
    for (int i = 0; i < words.length; i++) {
      words[i] = capitalizeFirstLetter(words[i]);
    }

    return words.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    String time = widget.wpda.created_at.split(' ').last;

    String timeOnly = convertTimeFormat(time);

    String formatDate = DateFormat('dd MMMM yyyy', 'id')
        .format(DateTime.parse(widget.wpda.created_at));

    String currentDate = DateTime.now().toString();
    var currentDateFormat =
        DateFormat('dd MMMM yyyy', 'id').format(DateTime.parse(currentDate));

    String dateResult =
        DateFormat('dd MMM yy').format(DateTime.parse(widget.wpda.created_at));
    final wpdaProvider = Provider.of<WpdaProvider>(context, listen: false);

    String selectedPrayers = widget.wpda.doaTabernakel;

    List<String> abbreviations = [];

    if (selectedPrayers.isEmpty || selectedPrayers.isEmpty) {
      abbreviations.add('Tidak Berdoa');
    } else {
      List<String> prayersList = selectedPrayers.split(',');
      abbreviations =
          prayersList.map((prayer) => getAbbreviation(prayer)).toList();
    }

    String selectedItemsString = abbreviations.join(', ');

    String capitalizeFirstLetter(String text) {
      if (text.isEmpty || text.isEmpty) {
        return text;
      }
      return text[0].toUpperCase() + text.substring(1);
    }

    String capitalizeEachWord(String text) {
      if (text.isEmpty || text.isEmpty) {
        return text;
      }

      List<String> words = text.split(" ");
      for (int i = 0; i < words.length; i++) {
        words[i] = capitalizeFirstLetter(words[i]);
      }

      return words.join(" ");
    }

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
                                    capitalizeEachWord(
                                        widget.wpda.writer.full_name),
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
                            (widget.wpda.writer.profile_picture.isEmpty ||
                                    widget.wpda.writer.profile_picture.isEmpty)
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Colors.white, // Warna border putih
                                        width: 2.0, // Lebar border
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/profile_empty.jpg',
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: Colors.transparent,
                                            content: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 300,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          imgUrl!),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // border: Border.all(
                                        //   color:
                                        //       Colors.white, // Warna border putih
                                        //   width: 2.0, // Lebar border
                                        // ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            CachedNetworkImageProvider(imgUrl!),
                                      ),
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
                                  '${capitalizeFirstLetter(widget.wpda.message_of_god)}',
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
                                  '${capitalizeFirstLetter(widget.wpda.application_in_life)}',
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
                      if (value.userId!.isEmpty) {
                        value.loadFullName();
                        return CircularProgressIndicator();
                      } else {
                        if (value.userId == widget.wpda.user_id) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                                  if (value.userId!.isEmpty) {
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
                                                    (token!.isEmpty)
                                                        ? ''
                                                        : token!,
                                                    widget.wpda.id,
                                                  );
                                                },
                                                title: 'Konfirmasi Hapus WPDA',
                                                content:
                                                    'Apakah Anda yakin ingin menghapus WPDA ini?',
                                                textColorYes: 'Hapus',
                                                buttonYesColor:
                                                    MyColor.colorRed,
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
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Row(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {
                              //         wpdaProvider.likeWpda();
                              //         // getWpdausecase.likeWpda(
                              //         //     int.parse(widget.wpda.id), token!);
                              //       },
                              //       icon: (wpdaProvider.click)
                              //           ? Icon(Icons.favorite_border_outlined)
                              //           : Icon(
                              //               Icons.favorite,
                              //               color: MyColor.colorRed,
                              //             ),
                              //     ),
                              //     Text(
                              //       widget.wpda.id,
                              //       style: MyFonts.customTextStyle(
                              //         14,
                              //         FontWeight.w500,
                              //         MyColor.whiteColor,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(width: 8),
                              // Row(
                              //   children: [
                              //     IconButton(
                              //       onPressed: () {},
                              //       icon: Icon(Icons.comment),
                              //     ),
                              //     Text('1'),
                              //   ],
                              // ),
                            ],
                          );
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
              if (value.userId!.isEmpty) {
                value.loadUserId();
                return CircularProgressIndicator();
              } else {
                return Card(
                  color: MyColor.colorBlackBg,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            (widget.wpda.writer.profile_picture.isEmpty ||
                                    widget.wpda.writer.profile_picture.isEmpty)
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Colors.white, // Warna border putih
                                        width: 2.0, // Lebar border
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/profile_empty.jpg',
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        CachedNetworkImageProvider(imgUrl!),
                                  ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Consumer<LoginProvider>(
                                    builder: (context, value, _) {
                                      if (value.userId!.isEmpty) {
                                        value.loadUserId();
                                        return CircularProgressIndicator();
                                      } else {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                capitalizeEachWord(widget
                                                    .wpda.writer.full_name),
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
                                                          13,
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
                                      12,
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
                              flex: 2,
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
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: MyFonts.customTextStyle(
                              14,
                              FontWeight.w500,
                              MyColor.whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Consumer<LikeProvider>(
                        //   builder: (context, likeProvider, child) {
                        //     return GestureDetector(
                        //       onTap: () {
                        //         if (!likeProvider
                        //             .isLiked(int.parse(widget.wpda.id))) {
                        //           getWpdausecase
                        //               .likeWpda(int.parse(value.userId!),
                        //                   int.parse(widget.wpda.id), token!)
                        //               .then((value) {
                        //             likeProvider
                        //                 .toggleLike(int.parse(widget.wpda.id));
                        //           });
                        //         } else {
                        //           getWpdausecase
                        //               .unlikeWpda(int.parse(value.userId!),
                        //                   int.parse(widget.wpda.id), token!)
                        //               .then((value) {
                        //             likeProvider
                        //                 .toggleLike(int.parse(widget.wpda.id));
                        //           });
                        //         }
                        //       },
                        //       child: AnimatedSwitcher(
                        //         duration: Duration(milliseconds: 300),
                        //         child: Icon(
                        //           likeProvider
                        //                   .isLiked(int.parse(widget.wpda.id))
                        //               ? Icons.favorite
                        //               : Icons.favorite_border,
                        //           key: Key(likeProvider
                        //               .isLiked(int.parse(widget.wpda.id))
                        //               .toString()),
                        //           color: likeProvider
                        //                   .isLiked(int.parse(widget.wpda.id))
                        //               ? Colors.red
                        //               : null,
                        //         ),
                        //         transitionBuilder: (child, animation) {
                        //           return FadeTransition(
                        //             opacity: animation,
                        //             child: child,
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   },
                        // )
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                var today = DateTime.now();
                                var formatDateResult =
                                    DateFormat('EEEE, d MMMM y', 'id')
                                        .format(today);
                                final dataReadingBook =
                                    widget.wpda.reading_book;
                                final dataVerseContent =
                                    widget.wpda.verse_content;
                                final dataPT = widget.wpda.message_of_god;
                                final dataAP = widget.wpda.application_in_life;
                                final doaTabernakel = widget.wpda.doaTabernakel;
                                // Teks yang ingin disalin ke clipboard
                                String textToCopy =
                                    ('*WPDA ${widget.wpda.writer.full_name}*\n\n${formatDateResult}\n\n*Kitab Bacaan:* ${dataReadingBook}\n\n*Isi Ayat:* ${dataVerseContent}\n\n*Pesan Tuhan:* ${dataPT}\n\n*Aplikasi dalam kehidupan:* ${dataAP}\n\n*DT:* ${doaTabernakel}');

                                // Salin teks ke clipboard
                                Clipboard.setData(
                                    ClipboardData(text: textToCopy));

                                // Tampilkan pesan toast
                                Fluttertoast.showToast(
                                  msg: "Teks disalin ke clipboard",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/copy_icon.svg',
                                color: MyColor.colorLightBlue,
                              ),
                            ),
                            SizedBox(width: 24),
                            GestureDetector(
                              onTap: () {
                                var today = DateTime.now();
                                var formatDateResult =
                                    DateFormat('EEEE, d MMMM y', 'id')
                                        .format(today);
                                final dataReadingBook =
                                    widget.wpda.reading_book;
                                final dataVerseContent =
                                    widget.wpda.verse_content;
                                final dataPT = widget.wpda.message_of_god;
                                final dataAP = widget.wpda.application_in_life;
                                final doaTabernakel = widget.wpda.doaTabernakel;

                                shareContent(
                                    '*WPDA ${widget.wpda.writer.full_name}*\n\n${formatDateResult}\n\n*Kitab Bacaan:* ${dataReadingBook}\n\n*Isi Ayat:* ${dataVerseContent}\n\n*Pesan Tuhan:* ${dataPT}\n\n*Aplikasi dalam kehidupan:* ${dataAP}\n\n*DT:* ${doaTabernakel}');
                              },
                              child: SvgPicture.asset(
                                'assets/icons/share.svg',
                                color: MyColor.colorLightBlue,
                              ),
                            ),
                            SizedBox(width: 8),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (context) {
                                        return PartialCommentWpda(
                                          wpda: widget.wpda,
                                          deviceToken:
                                              widget.wpda.writer.deviceToken,
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    widget.wpda.comments.length.toString() +
                                        ' komentar',
                                    style: MyFonts.customTextStyle(
                                      12,
                                      FontWeight.w600,
                                      MyColor.greyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  void shareContent(String textToShare) {
    Share.share(textToShare);
  }
}
