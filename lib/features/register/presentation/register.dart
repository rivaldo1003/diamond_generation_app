import 'package:diamond_generation_app/core.dart';
import 'package:diamond_generation_app/features/get_started/presentation/get_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  String? capitalizeEachWord(String? text) {
    if (text == null || text.isEmpty) {
      return text;
    }

    List<String> words = text.split(" ");
    for (int i = 0; i < words.length; i++) {
      words[i] = capitalizeFirstLetter(words[i]);
    }

    return words.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

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
            padding: const EdgeInsets.only(left: 20, top: 40, bottom: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return GetStarted();
                          }),
                          (route) => false,
                        );
                      },
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    Image.asset(
                      'assets/icons/gsja.png',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 15,
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
                  key: registerProvider.keyRegister,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        hintText: 'Nama Lengkap',
                        obscureText: false,
                        controller:
                            TextFieldControllerRegister.fullNameController,
                        inputDecoration: InputDecoration(
                          filled: true,
                          fillColor: MyColor.greyText.withOpacity(0.1),
                          hintText: 'Nama Lengkap',
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
                            return 'Nama lengkap tidak boleh kosong';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      TextFieldWidget(
                        hintText: 'Email',
                        obscureText: false,
                        controller: TextFieldControllerRegister.emailController,
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
                                TextFieldControllerRegister.passwordController,
                            obscureText:
                                registerProvider.obscure ? false : true,
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
                                registerProvider.showPassword();
                              },
                              icon: Icon(
                                (registerProvider.obscure)
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: MyColor.greyText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      ButtonWidget(
                        title: 'Daftar',
                        onPressed: () {
                          print(DateTime.now().toString());
                          var full_name = capitalizeEachWord(
                              TextFieldControllerRegister
                                  .fullNameController.text);
                          print('Full Name : $full_name');
                          if (registerProvider.keyRegister.currentState!
                              .validate()) {
                            registerProvider.registerUser(
                              {
                                'full_name': full_name,
                                'email': TextFieldControllerRegister
                                    .emailController.text,
                                'password': TextFieldControllerRegister
                                    .passwordController.text,
                                'registration_date': DateTime.now().toString(),
                              },
                              context,
                            );
                          }
                        },
                        color: MyColor.primaryColor,
                      ),
                      SizedBox(height: 12),
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
