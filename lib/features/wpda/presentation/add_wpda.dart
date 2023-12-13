import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    return Scaffold(
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
                        hintText: 'Kitab bacaan',
                        obscureText: false,
                        controller: wpdaProvider.readingBookController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.readingBookFocusNode,
                        errorText: wpdaProvider.showRequiredMessageReadingBook
                            ? 'Data Required'
                            : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageReadingBook = false;
                          wpdaProvider.notifyListeners();
                        },
                        suffixIcon: Icon(
                          Icons.book,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFieldWidget(
                        hintText: 'Isi kitab',
                        obscureText: false,
                        controller: wpdaProvider.verseContentController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.verseContentFocusNode,
                        errorText: wpdaProvider.showRequiredMessageVerseContent
                            ? 'Data Required'
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
                            ? 'Data Required'
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
                        hintText: 'Aplikasi dalam kehidupan',
                        obscureText: false,
                        controller: wpdaProvider.applicationInLifeController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.applicationInLifeFocusNode,
                        errorText:
                            wpdaProvider.showRequiredMessageApplicationInLife
                                ? 'Data Required'
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
                    title: 'Send WPDA',
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
                          // 'selected_prayers': checkBoxState.selectedItems,
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
