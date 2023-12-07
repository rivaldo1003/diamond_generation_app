import 'dart:convert';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/user.dart';
import 'package:diamond_generation_app/features/bottom_nav_bar/bottom_navigation_page.dart';
import 'package:diamond_generation_app/features/detail_community/data/providers/search_user_provider.dart';
import 'package:diamond_generation_app/features/login/data/providers/login_provider.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_login.dart';
import 'package:diamond_generation_app/features/login/data/utils/controller_register.dart';
import 'package:diamond_generation_app/features/login/presentation/login_screen.dart';
import 'package:diamond_generation_app/features/register_form/data/providers/register_form_provider.dart';
import 'package:diamond_generation_app/features/register_form/presentation/register_form.dart';
import 'package:diamond_generation_app/shared/constants/constants.dart';
import 'package:diamond_generation_app/shared/utils/color.dart';
import 'package:diamond_generation_app/shared/utils/fonts.dart';
import 'package:diamond_generation_app/shared/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserApi {
  final String urlApi;

  UserApi({
    required this.urlApi,
  });

  Future<List<User>> getUser(String urlApi) async {
    final url = Uri.parse(urlApi);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      final users = jsonResponse.map((json) {
        return User.fromJson(json);
      }).toList();
      return users;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> loginUser(
      Map<String, dynamic> body, BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final url = Uri.parse(ApiConstants.loginUrl);
    final response = await http.post(
      url,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success'] == true) {
        loginProvider.saveFullName(data['full_name']);
        loginProvider.saveToken(data['token']);
        loginProvider.saveRole(data['role']);
        loginProvider.saveAccountNumber(data['account_number']);
        loginProvider.saveUserId(data['user_id']);
        loginProvider.saveProfileCompleted(data['profile_completed']);
        print(data);
        if (data['role'] == 'admin') {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) {
                return BottomNavigationPage();
              }),
              (route) => false,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: MyColor.colorGreen,
                content: Text(
                  '${data['message']}',
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.w500,
                    MyColor.whiteColor,
                  ),
                ),
              ),
            );
            TextFieldControllerLogin.emailController.text = '';
            TextFieldControllerLogin.passwordController.text = '';
          });
        } else {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
          Future.delayed(Duration(seconds: 2), () {
            if (data['profile_completed'] == "0") {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return RegisterForm(
                    token: data['token'],
                  );
                }),
                (route) => false,
              );
              SnackBarWidget.showSnackBar(
                context: context,
                message: 'Profil Anda tidak lengkap. Lengkapi profil Anda.',
                textColor: MyColor.whiteColor,
                bgColor: MyColor.colorLightBlue,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return BottomNavigationPage();
                }),
                (route) => false,
              );
              SnackBarWidget.showSnackBar(
                context: context,
                message: 'Anda telah berhasil masuk ke akun Anda.',
                textColor: MyColor.whiteColor,
                bgColor: MyColor.colorGreen,
              );
            }
          });

          TextFieldControllerLogin.emailController.text = '';
          TextFieldControllerLogin.passwordController.text = '';
        }
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorRed,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
      }
    } else {
      throw Exception('Gagal masuk');
    }
  }

  Future<void> registerUser(
      Map<String, dynamic> body, BuildContext context) async {
    final headers = {"Content-Type": "application/json"};
    final response = await http.post(
      Uri.parse(ApiConstants.registerUrl),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
        TextFieldControllerRegister.fullNameController.text = '';
        TextFieldControllerRegister.emailController.text = '';
        TextFieldControllerRegister.passwordController.text = '';
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorRed,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                    14, FontWeight.w500, MyColor.whiteColor),
              ),
            ),
          );
        });
      }
    } else {
      throw Exception('Gagal mendaftarkan pengguna!');
    }
  }

  Future<void> submitDataUser(
      Map<String, dynamic> body, BuildContext context) async {
    final registerFormProvider =
        Provider.of<RegisterFormProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
    };
    final response = await http.post(
      Uri.parse(ApiConstants.submitDataUserUrl),
      body: json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        loginProvider.saveProfileCompleted(data['profile_completed']);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return BottomNavigationPage();
            }),
            (route) => false,
          );
          registerFormProvider.fullNameController.text = '';
          registerFormProvider.addressController.text = '';
          registerFormProvider.phoneNumberController.text = '';
          registerFormProvider.placeOfBirthController.text = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
        });
      } else {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${data['message']}',
              style: MyFonts.customTextStyle(
                14,
                FontWeight.w500,
                MyColor.greyText,
              ),
            ),
          ),
        );
      }
      print('Update profile API success');
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final headers = {"Content-Type": "application/json"};
    final response = await http.get(
      Uri.parse(ApiConstants.readUserProfileByIdUrl + '?user_id=${userId}'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result;
    } else {
      throw Exception('Failed to load data user profile');
    }
  }

  Future<List<AllUsers>> getAllUsers() async {
    final headers = {"Content-Type": "application/json"};
    final response = await http.get(
      Uri.parse(ApiConstants.getAllUser),
      headers: headers,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> jsonResponse = data['users_data'];
      var result = jsonResponse.map((json) {
        return AllUsers.fromJson(json);
      }).toList();
      return result;
    }
    throw Exception('Failed to load all users');
  }

  Future<void> approveUser(
      Map<String, dynamic> body, BuildContext context) async {
    try {
      final viewAllDataUserProvider =
          Provider.of<SearchUserProvider>(context, listen: false);

      final headers = {"Content-Type": "application/json"};
      final response = await http.post(
        Uri.parse(ApiConstants.approveUserUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: MyColor.colorGreen,
                content: Text(
                  '${data['message']}',
                  style: MyFonts.customTextStyle(
                    14,
                    FontWeight.w500,
                    MyColor.whiteColor,
                  ),
                ),
              ),
            );
            Navigator.pop(context);
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to approve user');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> deleteUser(String userId, BuildContext context) async {
    final response = await http
        .delete(Uri.parse(ApiConstants.deleteUserUrl + '?id=${userId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: MyColor.colorGreen,
              content: Text(
                '${data['message']}',
                style: MyFonts.customTextStyle(
                  14,
                  FontWeight.w500,
                  MyColor.whiteColor,
                ),
              ),
            ),
          );
          Navigator.pop(context);
        });
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to approve user');
    }
  }
}
