import 'package:diamond_generation_app/core.dart';
import 'package:diamond_generation_app/features/login/presentation/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final int verified;

  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.verified,
  });
  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  TextEditingController _emailVerifikasiController = TextEditingController();
  String? token;
  Future getToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      token = _prefs.getString(SharedPreferencesManager.keyToken);
    });
  }

  @override
  void initState() {
    getToken();
    _emailVerifikasiController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getUserUsecase = Provider.of<GetUserUsecase>(context);
    return Scaffold(
      appBar: AppBarWidget(title: 'Verifikasi Email'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/banner/undraw_verified.svg',
                height: MediaQuery.of(context).size.height / 5,
              ),
              SizedBox(height: 12),
              TextFieldWidget(
                readOnly: true,
                hintText: 'Email',
                obscureText: false,
                controller: _emailVerifikasiController,
                inputDecoration: InputDecoration(
                  filled: true,
                  fillColor: MyColor.greyText.withOpacity(0.1),
                  hintText: 'Email',
                  hintStyle: MyFonts.customTextStyle(
                    14,
                    FontWeight.w500,
                    MyColor.greyText,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ButtonWidget(
                color: MyColor.primaryColor,
                title: 'Verifikasi Email',
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return Center(
                          child: CoolLoading(),
                        );
                      });
                  print('Email : ${_emailVerifikasiController.text}');
                  getUserUsecase
                      .verifyEmail(
                    context,
                    (token != null) ? token! : '',
                    _emailVerifikasiController.text,
                  )
                      .then((value) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Verifikasi Email',
                              style: MyFonts.customTextStyle(
                                16,
                                FontWeight.bold,
                                MyColor.whiteColor,
                              ),
                            ),
                            content: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'Periksa email',
                                  style: MyFonts.customTextStyle(
                                    14,
                                    FontWeight.w500,
                                    MyColor.whiteColor,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${widget.email} ',
                                  style: MyFonts.customTextStyle(
                                    14,
                                    FontWeight.bold,
                                    MyColor.colorLightBlue,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'sekarang. Setelah melakukan verifikasi, silahkan login kembali.',
                                  style: MyFonts.customTextStyle(
                                    14,
                                    FontWeight.w500,
                                    MyColor.whiteColor,
                                  ),
                                ),
                              ]),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return Login();
                                    }),
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Login sekarang',
                                  style: MyFonts.customTextStyle(
                                    15,
                                    FontWeight.bold,
                                    Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    });
                  });
                },
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Login();
                    }),
                    (route) => false,
                  );
                },
                child: Text(
                  'Kembali',
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.bold,
                    MyColor.blueContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
