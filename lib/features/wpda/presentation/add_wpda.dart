import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/wpda/data/providers/wpda_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddWPDAForm extends StatelessWidget {
  TextEditingController _kitabBacaanController = TextEditingController();
  TextEditingController _isiKitabController = TextEditingController();
  TextEditingController _pesanTuhanController = TextEditingController();
  TextEditingController _aplikasiKehidupanController = TextEditingController();
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
                      controller: _kitabBacaanController,
                      textColor: MyColor.greyText,
                      suffixIcon: Icon(
                        Icons.book,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFieldWidget(
                      hintText: 'Isi kitab',
                      obscureText: false,
                      controller: _isiKitabController,
                      textColor: MyColor.greyText,
                      suffixIcon: Icon(
                        Icons.book,
                      ),
                      maxLines: 6,
                    ),
                    SizedBox(height: 12),
                    TextFieldWidget(
                      hintText: 'Pesan Tuhan',
                      obscureText: false,
                      controller: _pesanTuhanController,
                      textColor: MyColor.greyText,
                      suffixIcon: Icon(
                        Icons.book,
                      ),
                      maxLines: 4,
                    ),
                    SizedBox(height: 12),
                    TextFieldWidget(
                      hintText: 'Aplikasi dalam kehidupan',
                      obscureText: false,
                      controller: _aplikasiKehidupanController,
                      textColor: MyColor.greyText,
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
                    wpdaProvider.createWpda(
                      {
                        'user_id': value.userId,
                        'kitab_bacaan': _kitabBacaanController.text,
                        'isi_kitab': _isiKitabController.text,
                        'pesan_tuhan': _pesanTuhanController.text,
                        'aplikasi_kehidupan': _aplikasiKehidupanController.text,
                      },
                      context,
                    );
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
