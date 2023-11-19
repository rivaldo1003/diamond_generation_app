import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
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
      appBar: AppBarWidget(title: 'Add WPDA'),
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
                    wpdaProvider.onSubmit({
                      'user_id': value.userId,
                      'kitab_bacaan': wpdaProvider.kitabBacaanController.text,
                      'isi_kitab': wpdaProvider.isiKitabController.text,
                      'pesan_tuhan': wpdaProvider.pesanTuhanController.text,
                      'aplikasi_kehidupan':
                          wpdaProvider.aplikasiKehidupanController.text,
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
