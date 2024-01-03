import 'dart:convert';
import 'package:diamond_generation_app/core/models/all_users.dart';
import 'package:diamond_generation_app/core/models/monthly_data_wpda.dart';
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
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      if (data['success']) {
        Map<String, dynamic> userData = json.decode(response.body)['user'];
        if (userData['profile'] != null) {
          Map<String, dynamic> profile = userData['profile'];
          loginProvider.saveBirthDate(profile['birth_date']);
        }

        loginProvider.saveFullName(userData['full_name']);
        loginProvider.saveToken(data['token']);
        loginProvider.saveRole(userData['role']);
        loginProvider.saveUserId(userData['id'].toString());
        loginProvider
            .saveProfileCompleted(userData['profile_completed'].toString());
        print('DATA : $data');
        print('Token : ${data['token']}');
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
          });
          TextFieldControllerLogin.emailController.text = '';
          TextFieldControllerLogin.passwordController.text = '';
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
            if (userData['profile_completed'] == 0) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return RegisterForm();
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
      final data = json.decode(response.body);
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
  }

  Future<void> registerUser(
      Map<String, dynamic> body, BuildContext context) async {
    final headers = {
      "Content-Type": "application/json",
    };
    final response = await http.post(
      Uri.parse(ApiConstants.registerUrl),
      headers: headers,
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('DATA REGISTER :${data}');
      if (data['success']) {
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
    }
  }

  Future<void> submitDataUser(
    Map<String, dynamic> body,
    BuildContext context,
    String token,
    String id,
  ) async {
    final registerFormProvider =
        Provider.of<RegisterFormProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final headers = {
      "Content-Type": "application/json",
      'Authorization': "Bearer $token",
    };
    final response = await http.post(
      Uri.parse(ApiConstants.submitDataUserUrl + '/$id'),
      body: json.encode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        loginProvider
            .saveProfileCompleted(data['profile_completed'].toString());
        loginProvider.saveGender(data['gender'].toString());

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

  Future<Map<String, dynamic>> getUserProfile(int userId, String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + '/users/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result;
      } else {
        throw Exception(
            'Failed to load data user profile. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<AllUsers>> getAllUsers(String token) async {
    final headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };
    final response = await http.get(
      Uri.parse(ApiConstants.getAllUser),
      headers: headers,
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body)['users_data'];
      List<AllUsers> usersList =
          jsonData.map((data) => AllUsers.fromJson(data)).toList();
      return usersList;
    } else {
      throw Exception('Failed to load users data');
    }
  }

  Future<void> approveUser(
      BuildContext context, String token, String id) async {
    try {
      final viewAllDataUserProvider =
          Provider.of<SearchUserProvider>(context, listen: false);

      final headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      };
      final response = await http.put(
        Uri.parse(ApiConstants.approveUserUrl + '/$id'),
        headers: headers,
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

  Future<void> deleteUser(
    String userId,
    BuildContext context,
    String token,
  ) async {
    final response = await http.delete(
      Uri.parse(ApiConstants.deleteUserUrl + '/$userId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
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
      }
    } else {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> updateProfile(
    BuildContext context,
    String userId,
    String token,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse(ApiConstants.updateProfile + '/$userId'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        print(response.body);
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
      }
    } else {
      throw Exception('Gagal update user profile');
    }
  }

  Future<Map<String, dynamic>> getTotalNewUsers(String token) async {
    final url = Uri.parse(ApiConstants.getTotalNewUsers);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data new users');
    }
  }

  Future<ApiResponse> getMonthlyDataForAllUsers(String token) async {
    final url = Uri.parse(ApiConstants.getMonthlyDataForAllUsers);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      print('Get data success');
      final Map<String, dynamic> data = json.decode(response.body);
      return ApiResponse.fromJson(data);
    } else {
      throw Exception('Failed get data');
    }
  }
}
