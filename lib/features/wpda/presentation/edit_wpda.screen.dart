import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/bible_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/edit_wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditWpdaScreen extends StatefulWidget {
  final WPDA wpda;

  EditWpdaScreen({super.key, required this.wpda});

  @override
  State<EditWpdaScreen> createState() => _EditWpdaScreenState();
}

class _EditWpdaScreenState extends State<EditWpdaScreen> {
  String? token;

  Future getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString(SharedPreferencesManager.keyToken);
      print(token);
    });
  }

  late EditWpdaProvider editWpdaProvider;
  late AddWpdaProvider addWpdaProvider;

  @override
  void initState() {
    editWpdaProvider = Provider.of<EditWpdaProvider>(context, listen: false);
    addWpdaProvider = Provider.of<AddWpdaProvider>(context, listen: false);

    editWpdaProvider.readingBookController.text = widget.wpda.reading_book;
    editWpdaProvider.verseContentController.text = widget.wpda.verse_content;
    editWpdaProvider.messageOfGodController.text = widget.wpda.message_of_god;
    editWpdaProvider.applicationInLifeController.text =
        widget.wpda.application_in_life;

    editWpdaProvider.newSelectedItems = addWpdaProvider.selectedItems;
    print(editWpdaProvider.newSelectedItems);
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bibleProvider = Provider.of<BibleProvider>(context);

    return Scaffold(
      appBar: AppBarWidget(title: 'Edit WPDA'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFieldWidget(
                      textStyle: MyFonts.customTextStyle(
                        14,
                        FontWeight.w500,
                        MyColor.blackColor,
                      ),
                      onTap: () {
                        // String getBook(String verseReference, int index) {
                        //   // Pisahkan string menggunakan tanda spasi
                        //   List<String> parts = verseReference.split(' ');
                        //   // Ambil bagian pertama dari array hasil pemisahan
                        //   String book = parts[index];

                        //   return book;
                        // }

                        // String getStartVerse(String verseRef) {
                        //   List<String> parts = verseRef.split(' : ');
                        //   String verse = parts[1].substring(0, 2);
                        //   return verse;
                        // }

                        // String getEndVerse(String verseRef) {
                        //   List<String> parts = verseRef.split(' : ');
                        //   String verseNumber =
                        //       parts.length > 1 && parts[1].length >= 5
                        //           ? parts[1].substring(3, 5)
                        //           : '';
                        //   return verseNumber;
                        // }

                        // String result = getStartVerse(widget.wpda.reading_book);
                        // print('Verse Result : $result ');

                        // bibleProvider.selectedBook =
                        //     getBook(widget.wpda.reading_book, 0);
                        // setState(() {
                        //   bibleProvider.selectedChapter =
                        //       int.parse(getBook(widget.wpda.reading_book, 1));
                        //   bibleProvider.chapterController.text =
                        //       getBook(widget.wpda.reading_book, 1);
                        // bibleProvider.startVerseControllerEdit.text =
                        //     getStartVerse(widget.wpda.reading_book);
                        // bibleProvider.endVerseControllerEdit.text =
                        //     getEndVerse(widget.wpda.reading_book);
                        // });

                        print('Chapter : ${bibleProvider.selectedChapter}');
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
                                      builder: (context, bibleProvider, child) {
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
                                              bibleProvider.updateSelectedBook(
                                                  newValue!);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 16),
                                    TextFormField(
                                      controller:
                                          bibleProvider.chapterController,
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
                                      controller: bibleProvider
                                          .startVerseControllerEdit,
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
                                          bibleProvider.endVerseControllerEdit,
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
                                          onPressed: () {
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
                                              await bibleProvider
                                                  .fetchVerseEdit(
                                                context,
                                                bibleProvider
                                                    .startVerseControllerEdit
                                                    .text,
                                                bibleProvider
                                                    .endVerseControllerEdit
                                                    .text,
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
                      controller: editWpdaProvider.readingBookController,
                      textColor: MyColor.greyText,
                      focusNode: editWpdaProvider.readingBookFocusNode,
                      errorText: editWpdaProvider.showRequiredMessageReadingBook
                          ? 'Kitab Bacaan wajib diisi'
                          : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageReadingBook = false;
                        editWpdaProvider.notifyListeners();
                      },
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.book),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFieldWidget(
                      textStyle: MyFonts.customTextStyle(
                        14,
                        FontWeight.w500,
                        MyColor.blackColor,
                      ),
                      hintText: 'Isi Ayat',
                      obscureText: false,
                      controller: editWpdaProvider.verseContentController,
                      textColor: MyColor.greyText,
                      focusNode: editWpdaProvider.verseContentFocusNode,
                      errorText:
                          editWpdaProvider.showRequiredMessageVerseContent
                              ? 'Data Required'
                              : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageVerseContent =
                            false;
                      },
                      suffixIcon: Icon(
                        Icons.book,
                      ),
                      maxLines: 6,
                    ),
                    SizedBox(height: 12),
                    TextFieldWidget(
                      textStyle: MyFonts.customTextStyle(
                        14,
                        FontWeight.w500,
                        MyColor.blackColor,
                      ),
                      hintText: 'Pesan Tuhan',
                      obscureText: false,
                      controller: editWpdaProvider.messageOfGodController,
                      textColor: MyColor.greyText,
                      focusNode: editWpdaProvider.messageOfGodFocusNode,
                      errorText:
                          editWpdaProvider.showRequiredMessageMessageOfGod
                              ? 'Data Required'
                              : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageMessageOfGod =
                            false;
                      },
                      suffixIcon: Icon(
                        Icons.book,
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 12),
                    TextFieldWidget(
                      textStyle: MyFonts.customTextStyle(
                        14,
                        FontWeight.w500,
                        MyColor.blackColor,
                      ),
                      hintText: 'Aplikasi dalam kehidupan',
                      obscureText: false,
                      controller: editWpdaProvider.applicationInLifeController,
                      textColor: MyColor.greyText,
                      focusNode: editWpdaProvider.applicationInLifeFocusNode,
                      errorText:
                          editWpdaProvider.showRequiredMessageApplicationInLife
                              ? 'Data Required'
                              : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageApplicationInLife =
                            false;
                      },
                      suffixIcon: Icon(
                        Icons.book,
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 12),
                    TextButton(
                        style: ButtonStyle(
                          // backgroundColor: MaterialStatePropertyAll(
                          //   MyColor.colorLightBlue,
                          // ),
                          side: MaterialStatePropertyAll(BorderSide(
                              color: MyColor.greyText.withOpacity(
                            0.4,
                          ))),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(12),
                                      height: 5,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: MyColor.greyText,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(height: 32),
                                        Text(
                                          'Doa Tabernakel',
                                          style: MyFonts.customTextStyle(
                                            15,
                                            FontWeight.bold,
                                            MyColor.whiteColor,
                                          ),
                                        ),
                                        SizedBox(height: 24),
                                        Consumer<AddWpdaProvider>(builder:
                                            (context, checkBoxState, _) {
                                          return Container(
                                            // height: 400,
                                            // color: Colors.white,
                                            child: ListView(
                                              padding: EdgeInsets.only(
                                                top: 0,
                                                bottom: 20,
                                              ),
                                              shrinkWrap: true,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Expanded(
                                                      child: CheckboxListTile(
                                                        activeColor: MyColor
                                                            .primaryColor,
                                                        dense: true,
                                                        title: Text(
                                                            'Mesbah Bakaran',
                                                            style: MyFonts
                                                                .customTextStyle(
                                                              12,
                                                              FontWeight.w500,
                                                              MyColor
                                                                  .whiteColor,
                                                            )),
                                                        value: !checkBoxState
                                                                .selectedItems
                                                                .contains(
                                                                    'Tidak Berdoa') &&
                                                            checkBoxState
                                                                .selectedItems
                                                                .contains(
                                                                    'Mesbah Bakaran'),
                                                        onChanged: checkBoxState
                                                                .selectedItems
                                                                .contains(
                                                                    'Tidak Berdoa')
                                                            ? null
                                                            : (value) {
                                                                checkBoxState
                                                                    .editSelectedItems(
                                                                        value!,
                                                                        'Mesbah Bakaran');
                                                              },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: CheckboxListTile(
                                                          activeColor: MyColor
                                                              .primaryColor,
                                                          dense: true,
                                                          title: Text(
                                                              'Bejana Pembasuhan',
                                                              style: MyFonts
                                                                  .customTextStyle(
                                                                12,
                                                                FontWeight.w500,
                                                                MyColor
                                                                    .whiteColor,
                                                              )),
                                                          value: !checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa') &&
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Bejana Pembasuhan'),
                                                          onChanged: checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa')
                                                              ? null
                                                              : (value) {
                                                                  checkBoxState
                                                                      .editSelectedItems(
                                                                          value!,
                                                                          'Bejana Pembasuhan');
                                                                }),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: CheckboxListTile(
                                                          activeColor: MyColor
                                                              .primaryColor,
                                                          dense: true,
                                                          title: Text(
                                                              'Ruang Maha Kudus',
                                                              style: MyFonts
                                                                  .customTextStyle(
                                                                12,
                                                                FontWeight.w500,
                                                                MyColor
                                                                    .whiteColor,
                                                              )),
                                                          value: !checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa') &&
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Ruang Maha Kudus'),
                                                          onChanged: checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa')
                                                              ? null
                                                              : (value) {
                                                                  checkBoxState
                                                                      .editSelectedItems(
                                                                          value!,
                                                                          'Ruang Maha Kudus');
                                                                }),
                                                    ),
                                                    Expanded(
                                                      child: CheckboxListTile(
                                                          activeColor: MyColor
                                                              .primaryColor,
                                                          dense: true,
                                                          title: Text(
                                                              'Ruang Kudus',
                                                              style: MyFonts
                                                                  .customTextStyle(
                                                                12,
                                                                FontWeight.w500,
                                                                MyColor
                                                                    .whiteColor,
                                                              )),
                                                          value: !checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa') &&
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Ruang Kudus'),
                                                          onChanged: checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa')
                                                              ? null
                                                              : (value) {
                                                                  checkBoxState
                                                                      .editSelectedItems(
                                                                          value!,
                                                                          'Ruang Kudus');
                                                                }),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: CheckboxListTile(
                                                          activeColor: MyColor
                                                              .primaryColor,
                                                          dense: true,
                                                          title: Text(
                                                              'Doa Rantai',
                                                              style: MyFonts
                                                                  .customTextStyle(
                                                                12,
                                                                FontWeight.w500,
                                                                MyColor
                                                                    .whiteColor,
                                                              )),
                                                          value: !checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa') &&
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Doa Rantai'),
                                                          onChanged: checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa')
                                                              ? null
                                                              : (value) {
                                                                  checkBoxState
                                                                      .editSelectedItems(
                                                                          value!,
                                                                          'Doa Rantai');
                                                                }),
                                                    ),
                                                    Expanded(
                                                      child: CheckboxListTile(
                                                          activeColor: MyColor
                                                              .primaryColor,
                                                          dense: true,
                                                          title: Text(
                                                              'Nila-Nilai GSJA SK',
                                                              style: MyFonts
                                                                  .customTextStyle(
                                                                12,
                                                                FontWeight.w500,
                                                                MyColor
                                                                    .whiteColor,
                                                              )),
                                                          value: !checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa') &&
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Nilai-Nilai GSJA SK'),
                                                          onChanged: checkBoxState
                                                                  .selectedItems
                                                                  .contains(
                                                                      'Tidak Berdoa')
                                                              ? null
                                                              : (value) {
                                                                  checkBoxState
                                                                      .editSelectedItems(
                                                                          value!,
                                                                          'Nilai-Nilai GSJA SK');
                                                                }),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: CheckboxListTile(
                                                          activeColor: MyColor
                                                              .primaryColor,
                                                          dense: true,
                                                          title: Text(
                                                              'Tidak Berdoa',
                                                              style: MyFonts
                                                                  .customTextStyle(
                                                                12,
                                                                FontWeight.w500,
                                                                MyColor
                                                                    .whiteColor,
                                                              )),
                                                          value: checkBoxState
                                                              .selectedItems
                                                              .contains(
                                                                  'Tidak Berdoa'),
                                                          onChanged: (value) {
                                                            if (value!) {
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .clear();
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .add(
                                                                      'Tidak Berdoa');
                                                            } else {
                                                              checkBoxState
                                                                  .selectedItems
                                                                  .remove(
                                                                      'Tidak Berdoa');
                                                            }
                                                            checkBoxState
                                                                .notifyListeners();
                                                          }),
                                                    ),
                                                    Expanded(
                                                      child: Text(''),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pilih Doa Tabernakel',
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.bold,
                                MyColor.whiteColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: MyColor.whiteColor,
                            )
                          ],
                        )),
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
                  title: 'Edit WPDA',
                  color: MyColor.primaryColor,
                  onPressed: () {
                    var checkBoxState =
                        Provider.of<AddWpdaProvider>(context, listen: false);
                    if (checkBoxState.selectedItems.isNotEmpty) {
                      editWpdaProvider.onSubmit({
                        // 'user_id': value.userId,
                        'reading_book':
                            editWpdaProvider.readingBookController.text,
                        'verse_content':
                            editWpdaProvider.verseContentController.text,
                        'message_of_god':
                            editWpdaProvider.messageOfGodController.text,
                        'application_in_life':
                            editWpdaProvider.applicationInLifeController.text,
                        'doa_tabernakel':
                            editWpdaProvider.newSelectedItems.toString(),
                        'created_at': DateTime.now().toString(),
                      }, context, (token == null) ? '' : token!,
                          widget.wpda.id);
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
    );
  }
}
