import 'package:diamond_generation_app/core/models/wpda.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/edit_wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
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

    editWpdaProvider.kitabBacaanController.text = wpda.kitabBacaan;
    editWpdaProvider.isiKitabController.text = wpda.isiKitab;
    editWpdaProvider.pesanTuhanController.text = wpda.pesanTuhan;
    editWpdaProvider.aplikasiKehidupanController.text = wpda.aplikasiKehidupan;

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
