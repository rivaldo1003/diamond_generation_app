import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/add_wpda_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/edit_wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditWpdaScreen extends StatelessWidget {
  final WPDA wpda;

  EditWpdaScreen({super.key, required this.wpda});

  @override
  Widget build(BuildContext context) {
    final editWpdaProvider =
        Provider.of<EditWpdaProvider>(context, listen: false);
    final addWpdaProvider =
        Provider.of<AddWpdaWProvider>(context, listen: false);

    editWpdaProvider.kitabBacaanController.text = wpda.kitabBacaan;
    editWpdaProvider.isiKitabController.text = wpda.isiKitab;
    editWpdaProvider.pesanTuhanController.text = wpda.pesanTuhan;
    editWpdaProvider.aplikasiKehidupanController.text = wpda.aplikasiKehidupan;

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
                      controller: editWpdaProvider.kitabBacaanController,
                      focusNode: editWpdaProvider.kitabBacaanFocusNode,
                      errorText: editWpdaProvider.showRequiredMessageKitabBacaan
                          ? 'Data Required'
                          : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageKitabBacaan = false;
                      },
                      suffixIcon: Icon(
                        Icons.book,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFieldWidget(
                      hintText: 'Isi kitab',
                      obscureText: false,
                      controller: editWpdaProvider.isiKitabController,
                      textColor: MyColor.greyText,
                      focusNode: editWpdaProvider.isiKitabFocusNode,
                      errorText: editWpdaProvider.showRequiredMessageIsiKitab
                          ? 'Data Required'
                          : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageIsiKitab = false;
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
                      controller: editWpdaProvider.pesanTuhanController,
                      textColor: MyColor.greyText,
                      focusNode: editWpdaProvider.pesanTuhanFocusNode,
                      errorText: editWpdaProvider.showRequiredMessagePesanTuhan
                          ? 'Data Required'
                          : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessagePesanTuhan = false;
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
                      controller: editWpdaProvider.aplikasiKehidupanController,
                      textColor: MyColor.greyText,
                      focusNode: editWpdaProvider.aplikasiKehidupanFocusNode,
                      errorText:
                          editWpdaProvider.showRequiredMessageAplikasiKehidupan
                              ? 'Data Required'
                              : null,
                      onChanged: (value) {
                        editWpdaProvider.showRequiredMessageAplikasiKehidupan =
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
                      'user_id': value.userId,
                      'wpda_id': wpda.id,
                      'kitab_bacaan':
                          editWpdaProvider.kitabBacaanController.text,
                      'isi_kitab': editWpdaProvider.isiKitabController.text,
                      'pesan_tuhan': editWpdaProvider.pesanTuhanController.text,
                      'aplikasi_kehidupan':
                          editWpdaProvider.aplikasiKehidupanController.text,
                      'selected_prayers':
                          editWpdaProvider.newSelectedItems.join(','),
                    }, context);
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
