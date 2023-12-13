import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
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
                      hintText: 'Kitab bacaan',
                      obscureText: false,
                      controller: editWpdaProvider.readingBookController,
                      focusNode: editWpdaProvider.readingBookFocusNode,
                      errorText: editWpdaProvider.showRequiredMessageReadingBook
                          ? 'Data Required'
                          : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageReadingBook = false;
                      },
                      suffixIcon: Icon(
                        Icons.book,
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
                      // 'selected_prayers':
                      //     editWpdaProvider.newSelectedItems.join(','),
                    }, context, (token == null) ? '' : token!, widget.wpda.id);
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
