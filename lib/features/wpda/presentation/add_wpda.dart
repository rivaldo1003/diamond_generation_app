import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddWPDAForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wpdaProvider = Provider.of<WpdaProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(title: 'Buat WPDA'),
      body: WillPopScope(
        onWillPop: () async {
          wpdaProvider.kitabBacaanController.clear();
          wpdaProvider.isiKitabController.clear();
          wpdaProvider.pesanTuhanController.clear();
          wpdaProvider.aplikasiKehidupanController.clear();
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
                        controller: wpdaProvider.kitabBacaanController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.kitabBacaanFocusNode,
                        errorText: wpdaProvider.showRequiredMessageKitabBacaan
                            ? 'Data Required'
                            : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageKitabBacaan = false;
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
                        controller: wpdaProvider.isiKitabController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.isiKitabFocusNode,
                        errorText: wpdaProvider.showRequiredMessageIsiKitab
                            ? 'Data Required'
                            : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageIsiKitab = false;
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
                        controller: wpdaProvider.pesanTuhanController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.pesanTuhanFocusNode,
                        errorText: wpdaProvider.showRequiredMessagePesanTuhan
                            ? 'Data Required'
                            : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessagePesanTuhan = false;
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
                        controller: wpdaProvider.aplikasiKehidupanController,
                        textColor: MyColor.greyText,
                        focusNode: wpdaProvider.aplikasiKehidupanFocusNode,
                        errorText:
                            wpdaProvider.showRequiredMessageAplikasiKehidupan
                                ? 'Data Required'
                                : null,
                        onChanged: (value) {
                          wpdaProvider.showRequiredMessageAplikasiKehidupan =
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
                          'user_id': value.userId,
                          'kitab_bacaan':
                              wpdaProvider.kitabBacaanController.text,
                          'isi_kitab': wpdaProvider.isiKitabController.text,
                          'pesan_tuhan': wpdaProvider.pesanTuhanController.text,
                          'aplikasi_kehidupan':
                              wpdaProvider.aplikasiKehidupanController.text,
                          'selected_prayers': checkBoxState.selectedItems,
                        }, context);
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
