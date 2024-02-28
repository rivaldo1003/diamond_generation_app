import 'package:diamond_generation_app/features/login/data/utils/controller_register.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/register/data/providers/register_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: registerProvider.keyRegister,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    child: Image.asset(
                      'assets/icons/gsja.png',
                      height: MediaQuery.of(context).size.height / 5,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Silahkan daftar untuk\n',
                        style: MyFonts.customTextStyle(
                          18,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                      TextSpan(
                        text: 'memulai aplikasi.',
                        style: MyFonts.customTextStyle(
                          18,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextFieldWidget(
                  hintText: 'Nama Lengkap',
                  obscureText: false,
                  controller: TextFieldControllerRegister.fullNameController,
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
                      obscureText: (registerProvider.obscure) ? false : true,
                      controller:
                          TextFieldControllerRegister.passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length == 0) {
                          return 'Kata sandi tidak boleh kosong';
                        } else {
                          if (value.length >= 6) {
                            return null;
                          } else {
                            return 'Password minimal 6 karakter';
                          }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     'Lupa kata sandi?',
                    //     style: MyFonts.customTextStyle(
                    //       14,
                    //       FontWeight.w500,
                    //       MyColor.primaryColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: MyColor.primaryColor,
                    ),
                    onPressed: () {
                      print(DateTime.now().toString());
                      var full_name = capitalizeEachWord(
                          TextFieldControllerRegister.fullNameController.text);
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
                    child: Text(
                      'Daftar',
                      style: MyFonts.customTextStyle(
                        16,
                        FontWeight.bold,
                        MyColor.whiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: MyFonts.customTextStyle(
                        12,
                        FontWeight.w500,
                        MyColor.whiteColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      child: Text(
                        'Masuk',
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
      ),
    );
  }
}
