import 'package:diamond_generation_app/features/loading_diamond/cool_loading.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/verified_email/presentation/otp_screen.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, required this.email});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  TextEditingController email = TextEditingController();
  EmailOTP myauth = EmailOTP();

  @override
  Widget build(BuildContext context) {
    email.text = widget.email;
    return Scaffold(
      appBar: AppBarWidget(title: 'Verifikasi Email'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/verify.png",
              height: 350,
            ),
            Text(
              "Verifikasi email anda!",
              style: MyFonts.customTextStyle(
                18,
                FontWeight.bold,
                MyColor.whiteColor,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFieldWidget(
                hintText: 'Alamat Email',
                obscureText: false,
                controller: email,
                readOnly: true,
                suffixIcon: IconButton(
                    onPressed: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Center(
                              child: CoolLoading(),
                            );
                          });
                      Future.delayed(Duration(seconds: 2), () async {
                        Navigator.pop(context);
                        myauth.setConfig(
                            appEmail: "me@rohitchouhan.com",
                            appName: "Email OTP",
                            userEmail: email.text,
                            otpLength: 4,
                            otpType: OTPType.digitsOnly);
                        if (await myauth.sendOTP() == true) {
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: MyColor.colorGreen,
                              content: Text(
                                "OTP sudah dikirim. Cek email Anda!",
                                style: MyFonts.customTextStyle(
                                  14,
                                  FontWeight.w500,
                                  MyColor.whiteColor,
                                ),
                              ),
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpScreen(
                                          myauth: myauth,
                                          email: widget.email,
                                        )));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: MyColor.colorRed,
                            content: Text(
                              "Oops, OTP send failed",
                              style: MyFonts.customTextStyle(
                                  14, FontWeight.w500, MyColor.whiteColor),
                            ),
                          ));
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.send_rounded,
                      color: MyColor.primaryColor,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }), (route) => false);
                },
                child: Text(
                  'Kembali ke halaman login',
                  style: MyFonts.customTextStyle(
                      12, FontWeight.w500, MyColor.colorLightBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
