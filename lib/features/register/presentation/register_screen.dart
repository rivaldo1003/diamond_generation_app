import 'package:diamond_generation_app/features/login/data/utils/controller_register.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/register/data/providers/register_provider.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 40,
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Form(
            key: registerProvider.keyRegister,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 150,
                    width: 300,
                    child: Image.asset('assets/images/title.png'),
                  ),
                ),
                Divider(),
                SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello Dgers, Register\n',
                        style: MyFonts.customTextStyle(
                          24,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                      TextSpan(
                        text: 'here to get started',
                        style: MyFonts.customTextStyle(
                          24,
                          FontWeight.bold,
                          MyColor.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextFieldWidget(
                  hintText: 'Full Name',
                  obscureText: false,
                  controller: TextFieldControllerRegister.fullNameController,
                  validator: (value) {
                    if (value!.isEmpty || value.length == 0) {
                      return 'Full Name Required';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 12),
                TextFieldWidget(
                  hintText: 'Email Address',
                  obscureText: false,
                  controller: TextFieldControllerRegister.emailController,
                  validator: (value) {
                    if (value!.isEmpty || value == '') {
                      return 'Email Required';
                    } else {
                      if (value.contains('@gmail.com')) {
                        return null;
                      } else {
                        return 'Please use a valid email address';
                      }
                    }
                  },
                ),
                SizedBox(height: 12),
                Stack(
                  children: [
                    TextFieldWidget(
                      hintText: 'Password',
                      obscureText: (registerProvider.obscure) ? false : true,
                      controller:
                          TextFieldControllerRegister.passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length == 0) {
                          return 'Password Required';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: MyFonts.customTextStyle(
                          14,
                          FontWeight.w500,
                          MyColor.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
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
                      if (registerProvider.keyRegister.currentState!
                          .validate()) {
                        registerProvider.registerUser(
                          {
                            'full_name': TextFieldControllerRegister
                                .fullNameController.text,
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
                      'Register',
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
                      'Already have an account? ',
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
                        'Login',
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
