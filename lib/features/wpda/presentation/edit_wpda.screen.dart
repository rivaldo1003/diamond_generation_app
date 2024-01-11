import 'package:diamond_generation_app/core/models/wpda.dart';
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

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final editWpdaProvider =
        Provider.of<EditWpdaProvider>(context, listen: false);
    final addWpdaProvider =
        Provider.of<AddWpdaWProvider>(context, listen: false);

    editWpdaProvider.readingBookController.text = widget.wpda.reading_book;
    editWpdaProvider.verseContentController.text = widget.wpda.verse_content;
    editWpdaProvider.messageOfGodController.text = widget.wpda.message_of_god;
    editWpdaProvider.applicationInLifeController.text =
        widget.wpda.application_in_life;

    editWpdaProvider.newSelectedItems = addWpdaProvider.selectedItems;
    print(editWpdaProvider.newSelectedItems);

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
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        labelText: 'Ayat',
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
                                            await Provider.of<BibleProvider>(
                                                    context,
                                                    listen: false)
                                                .fetchVerse(context, '2', '6');

                                            if (Provider.of<BibleProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedVerseData
                                                    .isNotEmpty &&
                                                Provider.of<BibleProvider>(
                                                                context,
                                                                listen: false)
                                                            .selectedVerseData[
                                                        "verse"] >
                                                    0) {
                                              // Kode yang sudah ada ketika ayat ditemukan...
                                              editWpdaProvider
                                                      .verseContentController
                                                      .text =
                                                  '(${bibleProvider.selectedVerseData["verse"]})  ${bibleProvider.selectedVerseData["content"]}';
                                              editWpdaProvider
                                                      .readingBookController
                                                      .text =
                                                  '${bibleProvider.selectedBook} ${bibleProvider.selectedChapter} : ${bibleProvider.selectedVerseData["verse"]}';
                                              Navigator.pop(context);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      MyColor.colorRed,
                                                  content: Text(
                                                    'Pasal atau ayat tidak valid!',
                                                    style:
                                                        MyFonts.customTextStyle(
                                                      14,
                                                      FontWeight.w500,
                                                      MyColor.whiteColor,
                                                    ),
                                                  ),
                                                  duration:
                                                      Duration(seconds: 3),
                                                ),
                                              );
                                            }
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
                      },
                    ),
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
                        Provider.of<AddWpdaWProvider>(context, listen: false);
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
