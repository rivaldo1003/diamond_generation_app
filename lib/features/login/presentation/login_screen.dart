import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/register/data/providers/register_provider.dart';
import 'package:diamond_generation_app/features/register/presentation/register_screen.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/app_bar.dart';
import 'package:diamond_generation_app/shared/widgets/button.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

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
                      'assets/icons/gsja_foreground.png',
                      height: 200,
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
                // SizedBox(height: 12),
                // ButtonWidget(
                //   logo: 'assets/images/google.png',
                //   title: 'Login with Google',
                //   color: MyColor.colorBlackBg,
                //   onPressed: () => signIn(context),
                // ),
                SizedBox(height: 12),
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

  Future signIn(BuildContext context) async {
    final registerProvider =
        Provider.of<RegisterProvider>(context, listen: false);

    final user = await GoogleSignInApi.login();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: MyColor.colorRed,
          content: Text(
            'Sign in failed',
            style: MyFonts.customTextStyle(
              14,
              FontWeight.w500,
              MyColor.whiteColor,
            ),
          )));
    } else {
      registerProvider.registerUser(
        {
          'full_name': user.displayName,
          'email': user.email,
          'password': 'sir123',
          'registration_date': DateTime.now().toString(),
        },
        context,
      );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return LoggedInPage(user: user);
      }));
    }
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> logout() => _googleSignIn.disconnect();
}

class LoggedInPage extends StatelessWidget {
  final GoogleSignInAccount? user;

  const LoggedInPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Login with Google',
        action: [
          TextButton(
            onPressed: () async {
              await GoogleSignInApi.logout();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return LoginScreen();
              }));
            },
            child: Text('Logout'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile'),
            (user != null)
                ? ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user!.photoUrl ?? ''),
                    ),
                    title: Text(user!.displayName ?? 'No Display Name'),
                    subtitle: Text(user!.email ?? 'No Email'),
                  )
                : Text('User data is null.'),
          ],
        ),
      ),
    );
  }
}
