import 'package:diamond_generation_app/core.dart';
import 'package:diamond_generation_app/features/forget_password/presentation/forget_password_screen.dart';
import 'package:diamond_generation_app/features/get_started/presentation/get_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  String appVersion = '';

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: MyColor.colorBlackBg.withOpacity(0.1),
            ),
            child: Image.asset(
              'assets/images/bg_new.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 50, bottom: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return GetStarted();
                          },
                        ), (route) => false);
                      },
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    Image.asset(
                      'assets/images/gsja.png',
                      fit: BoxFit.cover,
                      height: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: MyColor.colorBlackBg,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 20,
                  right: 20,
                  bottom: 0,
                ),
                child: Form(
                  key: loginProvider.keyLogin,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center(
                      //   child: Container(
                      //     child: Image.asset(
                      //       'assets/icons/gsja.png',
                      //       height: MediaQuery.of(context).size.height / 8,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 12),
                      Text(
                        'Selamat Datang!',
                        style: MyFonts.customTextStyle(
                          24,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Untuk tetap terhubung bersama kami silahkan daftar dengan akun pribadi anda.',
                        style: MyFonts.customTextStyle(
                          12,
                          FontWeight.w500,
                          MyColor.greyText,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFieldWidget(
                        hintText: 'Email',
                        obscureText: false,
                        controller: TextFieldControllerLogin.emailController,
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
                        validator: (value) {
                          if (value!.isEmpty || value == '') {
                            return 'Email tidak boleh kosong';
                          } else {
                            if (value.contains('@gmail.com')) {
                              return null;
                            } else {
                              return 'Silahkan masukkan email yang valid';
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      Stack(
                        children: [
                          TextFieldWidget(
                            hintText: 'Kata Sandi',
                            controller:
                                TextFieldControllerLogin.passwordController,
                            obscureText: loginProvider.obscure ? false : true,
                            inputDecoration: InputDecoration(
                              filled: true,
                              suffixIcon: Icon(Icons.visibility),
                              fillColor: MyColor.greyText.withOpacity(0.1),
                              hintText: 'Kata Sandi',
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
                            validator: (value) {
                              if (value!.isEmpty || value.length == 0) {
                                return 'Kata sandi tidak boleh kosong';
                              } else {
                                return null;
                              }
                            },
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                loginProvider.showPassword();
                              },
                              icon: Icon(
                                (loginProvider.obscure)
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: MyColor.greyText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return ForgetPasswordScreen();
                              }));
                            },
                            child: Text(
                              'Lupa kata sandi?',
                              style: MyFonts.customTextStyle(
                                14,
                                FontWeight.w500,
                                MyColor.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ButtonWidget(
                        title: 'Masuk',
                        onPressed: () {
                          if (loginProvider.keyLogin.currentState!.validate()) {
                            loginProvider.loginUser(
                              {
                                "email": TextFieldControllerLogin
                                    .emailController.text,
                                "password": TextFieldControllerLogin
                                    .passwordController.text,
                                "device_token": "tes",
                              },
                              context,
                            );
                            Future.delayed(Duration(seconds: 2), () {
                              TextFieldControllerLogin.emailController.text =
                                  '';
                              TextFieldControllerLogin.passwordController.text =
                                  '';
                            });
                          }
                        },
                        color: MyColor.primaryColor,
                      ),
                      SizedBox(height: 12),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       'Anda belum memiliki akun? ',
                      //       style: MyFonts.customTextStyle(
                      //         12,
                      //         FontWeight.w500,
                      //         MyColor.whiteColor,
                      //       ),
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {},
                      //       child: Text(
                      //         'Daftar',
                      //         style: MyFonts.customTextStyle(
                      //           14,
                      //           FontWeight.bold,
                      //           MyColor.primaryColor,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      (appVersion != null)
                          ? Center(
                              child: Text(
                                'App Version - ${appVersion} ',
                                style: MyFonts.customTextStyle(
                                  12,
                                  FontWeight.w500,
                                  MyColor.greyText,
                                ),
                              ),
                            )
                          : CoolLoading(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
