import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/loading_diamond/loading_diamond.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/bible_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/presentation/bible_app.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddWPDAForm extends StatefulWidget {
  @override
  State<AddWPDAForm> createState() => _AddWPDAFormState();
}

class _AddWPDAFormState extends State<AddWPDAForm> {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController startVerseController = TextEditingController();
  TextEditingController endVerseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    final bibleProvider = Provider.of<BibleProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBarWidget(title: 'Buat WPDA'),
      body: WillPopScope(
        onWillPop: () async {
          wpdaProvider.readingBookController.clear();
          wpdaProvider.verseContentController.clear();
          wpdaProvider.messageOfGodController.clear();
          wpdaProvider.applicationInLifeController.clear();
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldWidget(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'Kitab Bacaan',
                                    style: MyFonts.customTextStyle(
                                      14,
                                      FontWeight.bold,
                                      MyColor.whiteColor,
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Consumer<BibleProvider>(
                                        builder:
                                            (context, bibleProvider, child) {
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12),
                                            decoration: BoxDecoration(
                                              color: MyColor.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              underline: SizedBox(),
                                              icon: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: MyColor.greyText,
                                              ),
                                              value: bibleProvider.selectedBook,
                                              items: bibleProvider.allBooks
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style:
                                                        MyFonts.customTextStyle(
                                                      14,
                                                      FontWeight.bold,
                                                      MyColor.greyText,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                bibleProvider
                                                    .updateSelectedBook(
                                                        newValue!);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          labelText: 'Pasal',
                                          labelStyle: MyFonts.customTextStyle(
                                            14,
                                            FontWeight.bold,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          Provider.of<BibleProvider>(context,
                                                  listen: false)
                                              .updateSelectedChapter(value);
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller:
                                            bibleProvider.startVerseController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          labelText: 'Ayat Awal',
                                          labelStyle: MyFonts.customTextStyle(
                                            14,
                                            FontWeight.bold,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          Provider.of<BibleProvider>(context,
                                                  listen: false)
                                              .updateSelectedVerse(value);
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller:
                                            bibleProvider.endVerseController,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          labelText: 'Ayat Akhir',
                                          labelStyle: MyFonts.customTextStyle(
                                            14,
                                            FontWeight.bold,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          Provider.of<BibleProvider>(context,
                                                  listen: false)
                                              .updateSelectedVerse(value);
                                        },
                                      ),
                                      SizedBox(height: 16),
                                      Consumer<BibleProvider>(
                                        builder: (context, bibleProvider, _) {
                                          return ButtonWidget(
                                            title: 'Pilih Ayat',
                                            color: MyColor.primaryColor,
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Center(
                                                    child: CoolLoading(),
                                                  );
                                                },
                                              );
                                              Future.delayed(
                                                  Duration(milliseconds: 300),
                                                  () async {
                                                await Provider.of<
                                                    BibleProvider>(
                                                  context,
                                                  listen: false,
                                                ).fetchVerse(
                                                  context,
                                                  bibleProvider
                                                      .startVerseController
                                                      .text,
                                                  bibleProvider
                                                      .endVerseController.text,
                                                );
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              });
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        },
                        hintText: 'Kitab Bacaan',
                        obscureText: false,
                        readOnly: true,
                        controller: wpdaProvider.readingBookController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.readingBookFocusNode,
                        errorText: wpdaProvider.showRequiredMessageReadingBook
                            ? 'Kitab Bacaan wajib diisi'
                            : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageReadingBook = false;
                          wpdaProvider.notifyListeners();
                        },
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.book),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFieldWidget(
                        hintText: 'Isi Ayat',
                        obscureText: false,
                        controller: wpdaProvider.verseContentController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.verseContentFocusNode,
                        errorText: wpdaProvider.showRequiredMessageVerseContent
                            ? 'Isi Ayat wajib diisi'
                            : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageVerseContent = false;
                          wpdaProvider.notifyListeners();
                        },
                        suffixIcon: Icon(
                          Icons.book,
                        ),
                        maxLines: 6,
                      ),
                      SizedBox(height: 12),
                      TextFieldWidget(
                        hintText: 'Pesan Tuhan',
                        obscureText: false,
                        controller: wpdaProvider.messageOfGodController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.messageOfGodFocusNode,
                        errorText: wpdaProvider.showRequiredMessageMessageOfGod
                            ? 'Pesan Tuhan wajib diisi'
                            : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageMessageOfGod = false;
                          wpdaProvider.notifyListeners();
                        },
                        suffixIcon: Icon(
                          Icons.book,
                        ),
                        maxLines: 4,
                      ),
                      SizedBox(height: 12),
                      TextFieldWidget(
                        hintText: 'Aplikasi Dalam Kehidupan',
                        obscureText: false,
                        controller: wpdaProvider.applicationInLifeController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.applicationInLifeFocusNode,
                        errorText:
                            wpdaProvider.showRequiredMessageApplicationInLife
                                ? 'Aplikasi dalam Kehidupan wajib diisi'
                                : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageApplicationInLife =
                              false;
                          wpdaProvider.notifyListeners();
                        },
                        suffixIcon: Icon(
                          Icons.book,
                        ),
                        maxLines: 4,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Doa Tabernakel',
                        style: MyFonts.customTextStyle(
                          15,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                      Consumer<AddWpdaWProvider>(
                          builder: (context, checkBoxState, _) {
                        return Container(
                          height: 200,
                          // color: Colors.white,
                          child: ListView(
                            padding: EdgeInsets.only(
                              top: 0,
                              bottom: 20,
                            ),
                            shrinkWrap: true,
                            children: [
                              CheckboxListTile(
                                dense: true,
                                title: Text('Mesbah Bakaran',
                                    style: MyFonts.customTextStyle(
                                      15,
                                      FontWeight.w500,
                                      MyColor.whiteColor,
                                    )),
                                value: !checkBoxState.selectedItems
                                        .contains('Tidak Berdoa') &&
                                    checkBoxState.selectedItems
                                        .contains('Mesbah Bakaran'),
                                onChanged: checkBoxState.selectedItems
                                        .contains('Tidak Berdoa')
                                    ? null
                                    : (value) {
                                        checkBoxState.editSelectedItems(
                                            value!, 'Mesbah Bakaran');
                                      },
                              ),
                              CheckboxListTile(
                                  dense: true,
                                  title: Text('Bejana Pembasuhan',
                                      style: MyFonts.customTextStyle(
                                        15,
                                        FontWeight.w500,
                                        MyColor.whiteColor,
                                      )),
                                  value: !checkBoxState.selectedItems
                                          .contains('Tidak Berdoa') &&
                                      checkBoxState.selectedItems
                                          .contains('Bejana Pembasuhan'),
                                  onChanged: checkBoxState.selectedItems
                                          .contains('Tidak Berdoa')
                                      ? null
                                      : (value) {
                                          checkBoxState.editSelectedItems(
                                              value!, 'Bejana Pembasuhan');
                                        }),
                              CheckboxListTile(
                                  dense: true,
                                  title: Text('Ruang Kudus',
                                      style: MyFonts.customTextStyle(
                                        15,
                                        FontWeight.w500,
                                        MyColor.whiteColor,
                                      )),
                                  value: !checkBoxState.selectedItems
                                          .contains('Tidak Berdoa') &&
                                      checkBoxState.selectedItems
                                          .contains('Ruang Kudus'),
                                  onChanged: checkBoxState.selectedItems
                                          .contains('Tidak Berdoa')
                                      ? null
                                      : (value) {
                                          checkBoxState.editSelectedItems(
                                              value!, 'Ruang Kudus');
                                        }),
                              CheckboxListTile(
                                  dense: true,
                                  title: Text('Ruang Maha Kudus',
                                      style: MyFonts.customTextStyle(
                                        15,
                                        FontWeight.w500,
                                        MyColor.whiteColor,
                                      )),
                                  value: !checkBoxState.selectedItems
                                          .contains('Tidak Berdoa') &&
                                      checkBoxState.selectedItems
                                          .contains('Ruang Maha Kudus'),
                                  onChanged: checkBoxState.selectedItems
                                          .contains('Tidak Berdoa')
                                      ? null
                                      : (value) {
                                          checkBoxState.editSelectedItems(
                                              value!, 'Ruang Maha Kudus');
                                        }),
                              CheckboxListTile(
                                  dense: true,
                                  title: Text('Nila-Nilai GSJA SK',
                                      style: MyFonts.customTextStyle(
                                        15,
                                        FontWeight.w500,
                                        MyColor.whiteColor,
                                      )),
                                  value: !checkBoxState.selectedItems
                                          .contains('Tidak Berdoa') &&
                                      checkBoxState.selectedItems
                                          .contains('Nilai-Nilai GSJA SK'),
                                  onChanged: checkBoxState.selectedItems
                                          .contains('Tidak Berdoa')
                                      ? null
                                      : (value) {
                                          checkBoxState.editSelectedItems(
                                              value!, 'Nilai-Nilai GSJA SK');
                                        }),
                              CheckboxListTile(
                                  dense: true,
                                  title: Text('Tidak Berdoa',
                                      style: MyFonts.customTextStyle(
                                        15,
                                        FontWeight.w500,
                                        MyColor.whiteColor,
                                      )),
                                  value: checkBoxState.selectedItems
                                      .contains('Tidak Berdoa'),
                                  onChanged: (value) {
                                    if (value!) {
                                      checkBoxState.selectedItems.clear();
                                      checkBoxState.selectedItems
                                          .add('Tidak Berdoa');
                                    } else {
                                      checkBoxState.selectedItems
                                          .remove('Tidak Berdoa');
                                    }
                                    checkBoxState.notifyListeners();
                                  }),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Consumer<LoginProvider>(builder: (context, value, _) {
                if (value.userId == null) {
                  value.loadUserId();
                  return CircularProgressIndicator();
                } else {
                  return ButtonWidget(
                    title: 'Kirim WPDA',
                    color: MyColor.primaryColor,
                    onPressed: () {
                      var checkBoxState =
                          Provider.of<AddWpdaWProvider>(context, listen: false);

                      if (checkBoxState.selectedItems.isNotEmpty) {
                        wpdaProvider.onSubmit({
                          'reading_book':
                              wpdaProvider.readingBookController.text,
                          'verse_content':
                              wpdaProvider.verseContentController.text,
                          'message_of_god':
                              wpdaProvider.messageOfGodController.text,
                          'application_in_life':
                              wpdaProvider.applicationInLifeController.text,
                          'doa_tabernakel':
                              checkBoxState.selectedItems.toString()
                        }, context, (token == null) ? '' : token!);
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Peringatan',
                                style: MyFonts.customTextStyle(
                                    14, FontWeight.bold, MyColor.whiteColor),
                              ),
                              content: Text(
                                'Minimal satu item harus dipilih!',
                                style: MyFonts.customTextStyle(
                                    14, FontWeight.w500, MyColor.whiteColor),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK',
                                      style: MyFonts.customTextStyle(14,
                                          FontWeight.bold, MyColor.whiteColor)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
