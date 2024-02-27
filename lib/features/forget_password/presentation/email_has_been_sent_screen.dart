import 'package:diamond_generation_app/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmailHasBeenSentScreen extends StatelessWidget {
  final String email;

  EmailHasBeenSentScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    final getUserusecase = Provider.of<GetUserUsecase>(context);
    return Scaffold(
      appBar: AppBarWidget(
        automaticallyImplyLeading: false,
        title: '',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: MyColor.colorGreen,
                    size: 48,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Email \ntelah dikirim!',
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: MyColor.whiteColor,
                          height: 1,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Silakan periksa email Anda dan klik tautan yang diterima untuk mengatur ulang kata sandi.',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/vectors/received_email.png',
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
              ),
              SizedBox(height: 32),
              ButtonWidget(
                title: 'Masuk',
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                color: MyColor.primaryColor,
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the link?",
                    style: MyFonts.customTextStyle(
                      14,
                      FontWeight.w500,
                      MyColor.greyText,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getUserusecase.forgetPassword(context, {
                        'email': email,
                      }).then((value) {
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      });
                    },
                    child: Text(
                      " Resend",
                      style: MyFonts.customTextStyle(
                        14,
                        FontWeight.bold,
                        MyColor.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
