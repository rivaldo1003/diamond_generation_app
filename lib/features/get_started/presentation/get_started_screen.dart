import 'package:diamond_generation_app/core.dart';
import 'package:diamond_generation_app/features/login/presentation/login.dart';
import 'package:diamond_generation_app/features/register/presentation/register.dart';
import 'package:diamond_generation_app/features/sign_in/app%20banner/app_banner.dart';
import 'package:diamond_generation_app/features/sign_in/app%20banner/banner_item.dart';
import 'package:diamond_generation_app/features/sign_in/app%20banner/indicator.dart';
import 'package:diamond_generation_app/state_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            top: 30,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      'assets/icons/gsja.png',
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      child: PageView.builder(
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        itemCount: appBannerList.length,
                        itemBuilder: (context, index) {
                          var banner = appBannerList[index];
                          var _scale = _selectedIndex == index ? 1.0 : 0.8;
                          return TweenAnimationBuilder(
                            tween: Tween(
                              begin: _scale,
                              end: _scale,
                            ),
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 350),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: BannerItem(
                              appBanner: banner,
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(appBannerList.length, (index) {
                          return Indicator(
                            isActive: _selectedIndex == index ? true : false,
                          );
                        })
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              ButtonWidget(
                title: 'Masuk',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Login();
                  }));
                },
                color: MyColor.primaryColor,
              ),
              SizedBox(height: 12),
              ButtonWidget(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Register();
                  }));
                },
                title: 'Belum ada akun? Daftar dulu',
                textStyle: MyFonts.customTextStyle(
                  14,
                  FontWeight.bold,
                  MyColor.primaryColor,
                ),
                color: MyColor.colorBlackBg,
                borderSide: BorderSide(
                  color: MyColor.primaryColor,
                  width: 0.8,
                ),
              ),
              SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Dengan masuk atau mendaftar, kamu menyetujui',
                        style: MyFonts.customTextStyle(
                          13,
                          FontWeight.w400,
                          MyColor.whiteColor,
                        )),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TermAndConditionsScreen();
                            }));
                          },
                        text: ' Ketentuan layanan',
                        style: MyFonts.customTextStyle(
                          13,
                          FontWeight.w400,
                          MyColor.primaryColor,
                        )),
                    TextSpan(
                        text: ' dan',
                        style: MyFonts.customTextStyle(
                          13,
                          FontWeight.w400,
                          MyColor.whiteColor,
                        )),
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PrivacyPolicyScreen();
                            }));
                          },
                        text: ' Kebijakan privasi.',
                        style: MyFonts.customTextStyle(
                          13,
                          FontWeight.w400,
                          MyColor.primaryColor,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
