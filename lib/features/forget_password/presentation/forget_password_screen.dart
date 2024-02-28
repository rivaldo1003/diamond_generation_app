import 'package:diamond_generation_app/core.dart';
import 'package:diamond_generation_app/features/forget_password/data/controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final GlobalKey<FormState> _forgetPasswordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final getUserusecase = Provider.of<GetUserUsecase>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: '',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _forgetPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lupa \nKata Sandi',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: MyColor.whiteColor,
                      height: 1,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Masukkan email terdaftar Anda di bawah ini untuk menerima instruksi pengaturan ulang kata sandi',
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.w500,
                    MyColor.whiteColor.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Image.asset(
                    'assets/vectors/forget_password.png',
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                ),
                SizedBox(height: 24),
                TextFieldWidget(
                    suffixIcon: Icon(Icons.email),
                    hintText: 'emailanda@gmail.com',
                    obscureText: false,
                    controller: forgetPasswordEmail,
                    textStyle: MyFonts.customTextStyle(
                      14,
                      FontWeight.w500,
                      MyColor.blackColor,
                    )),
                SizedBox(height: 12),
                ButtonWidget(
                  title: 'Kirim Tautan Reset',
                  onPressed: () {
                    if (forgetPasswordEmail.text.isNotEmpty) {
                      if (forgetPasswordEmail.text.contains('@gmail.com')) {
                        getUserusecase.forgetPassword(context, {
                          'email': forgetPasswordEmail.text,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: MyColor.colorRed,
                            content: Text(
                              'Email tidak valid',
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.whiteColor,
                              ),
                            ),
                          ),
                        );
                      }
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(Icons.info),
                                  SizedBox(width: 8),
                                  Text(
                                    'Informasi',
                                    style: MyFonts.customTextStyle(
                                      16,
                                      FontWeight.bold,
                                      MyColor.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                'Email anda tidak boleh kosong. Tautan akan dikirim ke email yang terdaftar untuk proses reset password.',
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.w500,
                                  MyColor.whiteColor,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Oke',
                                    style: MyFonts.customTextStyle(
                                      14,
                                      FontWeight.bold,
                                      MyColor.colorLightBlue,
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                    }
                  },
                  color: MyColor.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
