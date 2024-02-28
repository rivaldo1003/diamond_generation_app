import 'dart:convert';

import 'package:diamond_generation_app/features/bottom_nav_bar/bottom_navigation_page.dart';
import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/loading_diamond/loading_diamond.dart';
import 'package:diamond_generation_app/features/register_form/presentation/register_form.dart';
import 'package:diamond_generation_app/features/verified_email/data/providers/verified_email_provider.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/shared_pref_manager.dart';
import 'package:diamond_generation_app/shared/utils/snackbar.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatelessWidget {
  const Otp({
    Key? key,
    required this.otpController,
  }) : super(key: key);
  final TextEditingController otpController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: otpController,
        keyboardType: TextInputType.number,
        style: MyFonts.customTextStyle(24, FontWeight.bold, MyColor.whiteColor),
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.only(bottom: 20),
        ),
        onSaved: (value) {},
      ),
    );
  }
}

class OtpScreen extends StatefulWidget {
  OtpScreen({
    Key? key,
    required this.myauth,
    required this.email,
  }) : super(key: key);
  final EmailOTP myauth;
  final String email;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();

  String otpController = "1234";

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
    final verifiedEmailProvider = Provider.of<VerifiedEmailProvider>(context);
    print('EMAIL : ${widget.email}');
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Verifikasi',
        action: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Perhatian!',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                      content: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info,
                            color: MyColor.colorLightBlue,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pastikan email yang anda masukkan adalah email yang benar.',
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Icon(
            Icons.dialpad_rounded,
            size: 50,
            color: MyColor.colorLightBlue,
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Masukkan kode verifikasi yang dikirim ke email Anda. Cek email Anda sekarang!",
              textAlign: TextAlign.center,
              style: MyFonts.customTextStyle(
                  14, FontWeight.w500, MyColor.whiteColor),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Otp(
                otpController: otp1Controller,
              ),
              Otp(
                otpController: otp2Controller,
              ),
              Otp(
                otpController: otp3Controller,
              ),
              Otp(
                otpController: otp4Controller,
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          // Text(
          //   "Cek email Anda sekarang!",
          //   textAlign: TextAlign.center,
          //   style: MyFonts.customTextStyle(
          //       14, FontWeight.w500, MyColor.whiteColor),
          // ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ButtonWidget(
              title: 'Konfirmasi',
              color: MyColor.primaryColor,
              onPressed: () async {
                if (await widget.myauth.verifyOTP(
                        otp: otp1Controller.text +
                            otp2Controller.text +
                            otp3Controller.text +
                            otp4Controller.text) ==
                    true) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return Center(
                          child: CoolLoading(),
                        );
                      });
                  Future.delayed(Duration(seconds: 2), () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: MyColor.colorGreen,
                      content: Text(
                        "OTP berhasil diverifikasi",
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.whiteColor,
                        ),
                      ),
                    ));
                    verifiedEmailProvider.verifyUser(
                      {"email": widget.email},
                      context,
                      (token == null) ? '' : token!,
                    );

                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return RegisterForm();
                    })).then((value) {
                      SnackBarWidget.showSnackBar(
                        context: context,
                        message:
                            'Profil Anda tidak lengkap. Lengkapi profil Anda.',
                        textColor: MyColor.whiteColor,
                        bgColor: MyColor.colorLightBlue,
                      );
                    });
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: MyColor.colorRed,
                    content: Text(
                      "OTP tidak valid",
                      style: MyFonts.customTextStyle(
                        14,
                        FontWeight.w500,
                        MyColor.whiteColor,
                      ),
                    ),
                  ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
