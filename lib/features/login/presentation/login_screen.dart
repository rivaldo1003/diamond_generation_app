import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/register/presentation/register_screen.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: loginProvider.keyLogin,
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
                      'assets/icons/logo_new.png',
                      height: 150,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Selamat Datang,\n',
                        style: MyFonts.customTextStyle(
                          18,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Senang Bertemu Denganmu.',
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
                  hintText: 'Email',
                  controller: TextFieldControllerLogin.emailController,
                  obscureText: false,
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
                      controller: TextFieldControllerLogin.passwordController,
                      obscureText: loginProvider.obscure ? false : true,
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
                      if (loginProvider.keyLogin.currentState!.validate()) {
                        loginProvider.loginUser(
                          {
                            "email":
                                TextFieldControllerLogin.emailController.text,
                            "password": TextFieldControllerLogin
                                .passwordController.text,
                          },
                          context,
                        );
                      }
                    },
                    child: Text(
                      'Masuk',
                      style: MyFonts.customTextStyle(
                        16,
                        FontWeight.bold,
                        MyColor.whiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Anda belum memiliki akun? ',
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
                          return RegisterScreen();
                        }));
                      },
                      child: Text(
                        'Daftar',
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
